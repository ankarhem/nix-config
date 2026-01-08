# Migration to Dendritic Pattern with Flake Parts

This document describes the migration of this Nix configuration to the **Dendritic Pattern** using **Flake Parts**. It explains why we're doing this, what we're trying to achieve, and provides a step-by-step migration plan for future developers.

---

## Table of Contents

1. [What is the Dendritic Pattern?](#what-is-the-dendritic-pattern)
2. [Why Migrate?](#why-migrate)
3. [Current State](#current-state)
4. [Target State](#target-state)
5. [Migration Progress](#migration-progress)
6. [Migration Plan](#migration-plan)
7. [References](#references)

---

## What is the Dendritic Pattern?

The Dendritic Pattern is a **bottom-up** approach to Nix configuration that "flips the configuration matrix."

### Traditional (Top-Down) Approach
```
homelab (host)
  ├── has service: syncthing
  ├── has service: tailscale
  └── has user: idealpink
       ├── has neovim preset
       └── has git preset

workstation (host)
  ├── has service: bluetooth
  └── has user: idealpink
       ├── has neovim preset
       └── has git preset
```

### Dendritic (Bottom-Up) Approach
```
syncthing (feature)
  ├── nixos: { services.syncthing.enable = true; }
  ├── darwin: { services.syncthing.enable = true; }
  └── homeManager: { services.syncthing = { ... }; }

neovim (feature)
  ├── nixos: { programs.neovim.enable = true; }
  └── homeManager: { programs.lazyvim = { ... }; }

idealpink (feature) - composes other features
  ├── nixos: { imports = [ syncthing neovim git ]; }
  └── homeManager: { imports = [ syncthing neovim git ]; }

homelab (feature) - composes other features
  └── nixos: { imports = [ idealpink tailscale ]; }
```

**Key Insight:** Instead of defining what a host *has*, we define features that know *where they are used*. A feature defines its configuration across all contexts (NixOS, Darwin, Home Manager) in one place.

---

## Why Migrate?

### Problems with Current Structure

1. **Scattered Configuration:** Settings for a single "concept" (like `neovim`) are spread across multiple directories (`presets/neovim/`, `homeManagerModules/`, host configs)

2. **Hard to Reuse:** To add the same feature to a new host, you need to:
   - Find all related files across the codebase
   - Import them in the right places
   - Hope nothing breaks

3. **Context Mixing:** Some presets are Home Manager only, some are system-level, but they're all in one `presets/` folder

4. **Manual Composition:** Host composition is done manually in each host's `configuration/default.nix`

### Benefits of Dendritic Pattern

1. **Feature Isolation:** Everything related to a feature lives in one directory

2. **Easy Composition:** Adding a feature to a host is one line: `imports = [ syncthing ];`

3. **Cross-Platform Support:** Features define themselves for NixOS, Darwin, and Home Manager separately

4. **Hierarchical Features:** Features can compose other features (e.g., `system-desktop` extends `system-cli`)

5. **No Special Arguments:** No need for `specialArgs` to pass things between modules

---

## Current State

### Directory Structure
```
nix-config/
├── flake.nix                    # Uses flake-parts + import-tree
├── lib/                         # Custom library functions
├── packages/                    # Custom packages
├── presets/                     # Reusable configurations (BEING MIGRATED)
│   ├── neovim/                  # Neovim configuration
│   ├── vscode.nix               # VSCode settings
│   ├── git.nix                  # Git configuration
│   └── ...
├── nixosModules/                # NixOS-specific modules
├── darwinModules/               # Darwin-specific modules
├── homeManagerModules/          # Home Manager modules
├── modules/                     # NEW: Dendritic feature modules
│   ├── fish.nix                 # DONE: Fish shell feature
│   └── hosts/                   # NEW: Host feature modules
│       ├── homelab.nix          # Host feature
│       ├── mbp.nix              # Host feature
│       └── workstation.nix      # Host feature
└── hosts/                       # Traditional host configurations
    ├── homelab/
    │   ├── configuration/       # NixOS system config
    │   └── home/                # Home Manager user config
    ├── mbp/
    │   ├── configuration/       # Darwin system config
    │   └── home/                # Home Manager user config
    └── workstation/
        ├── configuration/       # NixOS system config
        └── home/                # Home Manager user config
```

### What's Already Done

1. **Flake Parts Setup:** ✅ `flake.nix` uses `flake-parts` and `import-tree`
2. **Fish Feature:** ✅ Migrated to `modules/fish.nix` as a dendritic feature
3. **Host Feature Skeletons:** ✅ Basic structure in `modules/hosts/*.nix`

### What Still Uses Old Pattern

1. **Presets:** `presets/` directory contains reusable configs that should become features
2. **Host Configs:** `hosts/*/configuration/` and `hosts/*/home/` still use traditional structure
3. **Separate Module Directories:** `nixosModules/`, `darwinModules/`, `homeManagerModules/` should be consolidated into features

---

## Target State

### Final Directory Structure
```
nix-config/
├── flake.nix
├── lib/
├── packages/
└── modules/
    ├── nix/                     # Nix tools setup
    │   └── flake-parts/         # Helper functions (mkNixos, mkDarwin, mkHomeManager)
    ├── hosts/                   # Host features
    │   ├── homelab/
    │   │   ├── default.nix      # Host feature: imports syncthing, tailscale, etc.
    │   │   ├── hardware.nix     # Hardware-specific config
    │   │   └── filesystem.nix   # Impermanence/btrfs config
    │   ├── mbp/
    │   └── workstation/
    ├── programs/                # Program features
    │   ├── fish/                # DONE: Fish shell
    │   ├── neovim/              # Migrated from presets/neovim/
    │   ├── firefox/             # Migrated from presets/firefox/
    │   └── ...
    ├── services/                # Service features
    │   ├── syncthing/
    │   ├── tailscale/
    │   └── ...
    ├── system/                  # System settings
    │   ├── defaults/            # Base system settings
    │   └── settings/
    │       ├── bluetooth/
    │       └── networking/
    └── users/                   # User features
        ├── ankarhem/
        └── idealpink/
```

### Feature Module Structure

Each feature is a file or directory containing:

```nix
{
  inputs,
  self,
  ...
}:
{
  # NixOS aspect
  flake.modules.nixos.featureName = {
    imports = with inputs.self.modules.nixos; [
      otherFeature  # Compose other features
    ];
    # NixOS configuration
  };

  # Darwin aspect (optional)
  flake.modules.darwin.featureName = {
    # Darwin configuration
  };

  # Home Manager aspect (optional)
  flake.modules.homeManager.featureName = {
    # Home Manager configuration
  };

  # Generic aspect (works in any context)
  flake.modules.generic.featureName = {
    # Shared options/configuration
  };
}
```

---

## Migration Progress

### Completed ✅
- [x] Fish shell migrated to `modules/fish.nix`
- [x] Host feature skeletons created in `modules/hosts/`
- [x] Basic flake-parts setup in `flake.nix`

### In Progress 🚧
- [ ] Migrating `presets/` to `modules/programs/`
- [ ] Creating base system features
- [ ] Migrating host-specific configurations

### Not Started 📋
- [ ] Migrating service configurations
- [ ] Consolidating module directories
- [ ] Creating user features
- [ ] Adding helper functions

---

## Migration Plan

### Phase 1: Infrastructure & Base Features

#### 1.1 Create Helper Functions (NOT STARTED)

Create `modules/nix/flake-parts/lib.nix` with helper functions:

```nix
{
  inputs,
  lib,
  ...
}:
{
  options.flake.lib = lib.mkOption {
    type = lib.types.attrsOf lib.types.unspecified;
    default = { };
  };

  config.flake.lib = {
    mkNixos = system: name: {
      ${name} = inputs.nixpkgs.lib.nixosSystem {
        modules = [
          inputs.self.modules.nixos.${name}
          { nixpkgs.hostPlatform = lib.mkDefault system; }
        ];
      };
    };

    mkDarwin = system: name: {
      ${name} = inputs.darwin.lib.darwinSystem {
        modules = [
          inputs.self.modules.darwin.${name}
          { nixpkgs.hostPlatform = lib.mkDefault system; }
        ];
      };
    };

    mkHomeManager = system: name: {
      ${name} = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = inputs.nixpkgs.legacyPackages.${system};
        modules = [
          inputs.self.modules.homeManager.${name}
        ];
      };
    };
  };
}
```

**Files to create:**
- `modules/nix/flake-parts/lib.nix`
- `modules/nix/flake-parts/default.nix` (imports lib.nix)

---

#### 1.2 Create Base System Features (NOT STARTED)

Create hierarchical system base features in `modules/system/`:

**Structure:**
```
modules/system/
├── defaults/
│   ├── default.nix           # Base defaults (nix settings, locale, etc.)
│   ├── nixos/
│   │   └── default.nix       # NixOS-specific defaults
│   └── darwin/
│       └── default.nix       # Darwin-specific defaults
├── essential/
│   └── default.nix           # Essential tools (ssh, vim, etc.)
├── basic/
│   └── default.nix           # Basic CLI tools
└── desktop/
    └── default.nix           # Desktop environment
```

**Pattern:** Each inherits from the previous using `imports`.

---

### Phase 2: Migrate Presets to Features

#### 2.1 Migrate Program Presets (NOT STARTED)

For each preset in `presets/`, create a feature in `modules/programs/`:

**Example: Neovim**
```nix
# modules/programs/neovim/default.nix
{
  inputs,
  pkgs,
  pkgs-unstable,
  ...
}:
{
  flake.modules.homeManager.neovim = {
    imports = [
      inputs.lazyvim.homeManagerModules.default
    ];
    # Home Manager neovim configuration
  };

  flake.modules.nixos.neovim = {
    programs.neovim.enable = true;
    # NixOS neovim configuration
  };
}
```

**Presets to migrate:**
- [ ] `presets/neovim/` → `modules/programs/neovim/`
- [ ] `presets/firefox/` → `modules/programs/firefox/`
- [ ] `presets/git.nix` → `modules/programs/git/`
- [ ] `presets/gpg.nix` → `modules/programs/gpg/`
- [ ] `presets/gh.nix` → `modules/programs/gh/`
- [ ] `presets/vscode.nix` → `modules/programs/vscode/`
- [ ] `presets/claude.nix` → `modules/programs/claude/`

---

#### 2.2 Create Service Features (NOT STARTED)

Extract service configurations into features:

**Services to create:**
- [ ] Syncthing (from various host configs)
- [ ] Tailscale (from `hosts/homelab/configuration/tailscale.nix`)
- [ ] Docker/Podman (from `nixosModules/docker.nix`)
- [ ] SSH (create unified feature)

**Pattern:**
```nix
# modules/services/syncthing/default.nix
{
  inputs,
  ...
}:
{
  flake.modules.nixos.syncthing = {
    services.syncthing = {
      enable = true;
      # Configuration
    };
  };

  flake.modules.homeManager.syncthing = {
    services.syncthing = {
      # User-level configuration
    };
  };
}
```

---

### Phase 3: Migrate Host Configurations

#### 3.1 Refactor Host Feature Modules (IN PROGRESS)

Currently, `modules/hosts/*.nix` contain both the feature definition AND the flake output. These should be separated.

**Current (mixed):**
```nix
# modules/hosts/homelab.nix
{
  flake.modules.nixos."hosts/${username}" = { ... };
  flake.nixosConfigurations.homelab = inputs.nixpkgs.lib.nixosSystem { ... };
}
```

**Target (separated):**
```nix
# modules/hosts/homelab/default.nix - Feature only
{
  inputs,
  ...
}:
{
  flake.modules.nixos.homelab = {
    imports = with inputs.self.modules.nixos; [
      system-default
      syncthing
      tailscale
    ];
    # Host-specific configuration
  };
}

# modules/hosts/homelab/hardware.nix - Hardware config
{
  # Hardware-specific stuff that shouldn't change
}

# modules/nix/flake-parts/outputs.nix - Flake outputs
{
  flake.nixosConfigurations = inputs.self.lib.mkNixos "x86_64-linux" "homelab";
}
```

**Action needed:**
- [ ] Separate feature definitions from flake outputs in all host files
- [ ] Create `modules/nix/flake-parts/outputs.nix` for flake outputs
- [ ] Move hardware-specific config to `hardware.nix` files

---

#### 3.2 Migrate Host Configuration Files (NOT STARTED)

Move configurations from `hosts/*/configuration/` into the host feature:

**Example for homelab:**
```nix
# modules/hosts/homelab/default.nix
{
  inputs,
  ...
}:
{
  flake.modules.nixos.homelab = {
    imports = with inputs.self.modules.nixos; [
      system-default
      networking
      syncthing
      tailscale
      # Import configurations that were in configuration/
    ];

    # Direct imports from old configuration files
    networking.custom = {
      homelabIp = "192.168.1.221";
      synologyIp = "192.168.1.163";
      lanNetwork = "192.168.1.0/24";
    };
  };
}
```

**Migration strategy:**
1. Read each file in `hosts/*/configuration/`
2. Decide if it should be:
   - A separate feature (reusable) → `modules/services/` or `modules/system/`
   - Host-specific config → merge into host feature
3. Delete old file after migration

---

#### 3.3 Migrate Home Manager Configurations (NOT STARTED)

Similar to system configs, migrate `hosts/*/home/` configurations:

**Options:**
1. Merge into user features (`modules/users/username/`)
2. Keep as host-specific home config within host feature

---

### Phase 4: Create User Features

#### 4.1 Define User Features (NOT STARTED)

Create user features that compose program features:

```nix
# modules/users/idealpink/default.nix
{
  inputs,
  ...
}:
{
  flake.modules.nixos.idealpink = {
    users.users.idealpink = {
      isNormalUser = true;
      # System-level user config
    };

    home-manager.users.idealpink = {
      imports = [ inputs.self.modules.homeManager.idealpink ];
    };
  };

  flake.modules.homeManager.idealpink = {
    imports = with inputs.self.modules.homeManager; [
      fish
      neovim
      git
      gpg
    ];
    # Home Manager user config
  };
}
```

**Users to create:**
- [ ] `idealpink` (homelab, workstation)
- [ ] `ankarhem` (mbp)

---

### Phase 5: Consolidate and Clean Up

#### 5.1 Remove Old Directories (NOT STARTED)

After migration is complete and verified:

- [ ] Delete `presets/` (all migrated to `modules/programs/`)
- [ ] Delete `nixosModules/` (migrated to features)
- [ ] Delete `darwinModules/` (migrated to features)
- [ ] Delete `homeManagerModules/` (migrated to features)
- [ ] Delete `hosts/*/configuration/` (migrated to host features)
- [ ] Delete `hosts/*/home/` (migrated to user/host features)

#### 5.2 Update Documentation (NOT STARTED)

- [ ] Update README.md with new structure
- [ ] Add examples for adding new features
- [ ] Document common patterns

---

## Migration Guidelines

### When to Create a New Feature

Create a feature when:
1. It's a coherent "unit" of functionality (e.g., a program, service, user)
2. It needs to work in multiple contexts (NixOS, Darwin, Home Manager)
3. You want to reuse it across multiple hosts/users

### When NOT to Create a Feature

Keep it inline when:
1. It's truly host-specific (hardware config, unique filesystem setup)
2. It's only used once and unlikely to be reused

### Naming Conventions

- **Features:** Use lowercase, dash-separated: `syncthing`, `neovim`, `git`
- **Directories:** Match feature name: `modules/programs/neovim/`
- **Hosts:** Use hostname: `homelab`, `workstation`, `mbp`
- **Users:** Use username: `idealpink`, `ankarhem`

### File Organization Within Features

```
modules/programs/neovim/
├── default.nix          # Main feature module (exports flake.modules)
├── nixos.nix            # NixOS-specific (optional)
├── darwin.nix           # Darwin-specific (optional)
├── homeManager.nix      # Home Manager-specific (optional)
├── plugins/             # Sub-components for complex features
│   └── default.nix
└── flake-parts.nix      # Extra flake outputs (rare)
```

---

## Design Patterns Reference

### Simple Aspect
A feature used in multiple contexts, no dependencies.

```nix
{
  flake.modules.homeManager.fish = { ... };
  flake.modules.nixos.fish = { ... };
  flake.modules.darwin.fish = { ... };
}
```

### Multi-Context Aspect
A feature that acts on multiple module classes simultaneously.

```nix
{
  # Main module (NixOS)
  flake.modules.nixos.gnome = {
    home-manager.sharedModules = [
      inputs.self.modules.homeManager.gnome
    ];
    # System-level GNOME config
  };

  # Auxiliary module (Home Manager)
  flake.modules.homeManager.gnome = {
    # User-level GNOME config
  };
}
```

### Inheritance Aspect
A feature that extends another feature.

```nix
{
  flake.modules.nixos.system-desktop = {
    imports = with inputs.self.modules.nixos; [
      system-cli    # Parent
      bluetooth
      printing
    ];
  };
}
```

### Collector Aspect
A feature that collects configuration from users.

```nix
{
  # Base feature
  flake.modules.nixos.syncthing = {
    services.syncthing.enable = true;
  };

  # Host contributes its device ID
  flake.modules.nixos.homelab = {
    services.syncthing.settings.devices.homelab.id = "...";
  };
}
```

---

## Testing Strategy

After each migration step:

1. **Evaluate the flake:** `nix flake check`
2. **Build configurations:**
   ```bash
   nix build .#nixosConfigurations.homelab.config.system.build.toplevel
   nix build .#darwinConfigurations.mbp.system
   ```
3. **Test on actual system** (when possible):
   ```bash
   nh os switch .
   ```

---

## References

### Essential Reading

1. **[Dendritic Design with Flake Parts Guide](https://github.com/Doc-Steve/dendritic-design-with-flake-parts)**
   - Comprehensive guide with examples
   - Source of this migration approach

2. **[Vic's Dendritic Nix Summary](https://vic.github.io/dendrix/Dendritic.html)**
   - Excellent overview of benefits

3. **[Flake Parts Framework](https://flake.parts)**
   - Official documentation

4. **[Flipping the Configuration Matrix](https://not-a-number.io/2025/refactoring-my-infrastructure-as-code-configurations/#flipping-the-configuration-matrix)**
   - Original inspiration for the pattern

### Reference Configurations

- [vic/vix](https://github.com/vic/vix) - Vic's personal config
- [drupol/infra](https://github.com/drupol/infra) - Another example
- [Doc-Steve/dendritic-design-with-flake-parts](https://github.com/Doc-Steve/dendritic-design-with-flake-parts) - The example from the guide

### Tools

- [hercules-ci/flake-parts](https://github.com/hercules-ci/flake-parts) - The framework
- [vic/import-tree](https://github.com/vic/import-tree) - Auto-import modules
- [vic/flake-file](https://github.com/vic/flake-file) - Embed flake.nix in modules (optional)

---

## Questions or Issues?

If you're confused about something in this migration:

1. Check the reference links above
2. Look at the example in `/tmp/dendritic-guide/` (if available)
3. Consider: "What context does this belong in?" (NixOS? Darwin? Home Manager?)
4. Remember: Features are just modules that know where they're used

**Key mantra:** *"Define the feature, not the host."*
