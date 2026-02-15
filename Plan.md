# Flake-Parts / Dendritic Migration Plan

## 1. Scope & Constraints

**In scope:** flake.nix wiring, flake-parts modules, NixOS/Darwin host definitions, home-manager integration, overlays, nix settings, secrets/sops, factory functions, legacy cleanup.

**Out of scope / hard constraints:**
- **`apps/` directory under homelab is entirely ignored.** Do not read, analyze, or modify anything in `hosts/homelab/configuration/apps/`. When migrated, homelab's apps will be imported as-is using the underscore (`_apps/`) directory convention (auto-imported by `import-tree` but semantically grouped).
- No changes to `packages/` derivations.
- No changes to `secrets/` encrypted files or `.sops.yaml` key mappings.

---

## 2. Inventory

### 2.1 Hosts

| Host | OS | Arch | Location (old) | Location (new) | Status |
|---|---|---|---|---|---|
| **mbp** | macOS (Darwin) | aarch64-darwin | `hosts/mbp/` | `modules/hosts/mbp/` | Migrated |
| **workstation** | NixOS | x86_64-linux | `hosts/workstation/` | -- | Not migrated |
| **homelab** | NixOS (Proxmox LXC) | x86_64-linux | `hosts/homelab/` | -- | Not migrated |

### 2.2 Legacy Directories (to be removed post-migration)

| Directory | Purpose | Used by |
|---|---|---|
| `darwinModules/` | Custom darwin options (linear-mouse, settings) | Old `hosts/mbp/` only |
| `homeManagerModules/` | `scripts.nix` + `clone_org.sh` | Old `hosts/mbp/` and `hosts/workstation/` |
| `nixosModules/` | `docker.nix` (watchtower auto-updater), `networking.nix` (custom IP options) | Old `hosts/homelab/` |
| `hosts/` | All old-style host configs | **Dead code** -- references deleted `presets/` paths |

### 2.3 Dendritic Modules (already in `modules/`)

| Module | nixos | darwin | homeManager | generic |
|---|---|---|---|---|
| `ai/` | x | x | x (claude, mcp, opencode) | |
| `audio` | x | | | |
| `bluetooth` | x | | | |
| `chat` | x | x | x | |
| `colemak` | x | x | | |
| `comfyui` | x | | | |
| `constants` | | | | x |
| `dev-tools` | x | x | x | |
| `factory/` | (flake-level) | | | |
| `firefox/` | x | x | x | |
| `fish` | x | x | x | |
| `fonts` | x | x | | |
| `general` | x | x | x | |
| `gh` | x | x | x | |
| `git` | | | x | |
| `gpg` | x | x | x | |
| `homebrew` | | x | | |
| `launcher` | x | x | x | |
| `lazyvim/` | x | x | x | |
| `nix` | x | x | | |
| `norcevpn` | x | x | | |
| `npm` | | | x | |
| `ssh` | | | x | |
| `sshd` | x | x | | |
| `terminal/cli` | x | x | x | |
| `terminal/ghostty` | | | x | |
| `tools/home-manager` | x | x | | |
| `tools/secrets` | x | x | x | |
| `users/ankarhem` | x | x | x | |

---

## 3. Migrated Host Audit (`mbp`)

### 3.1 What's Working

- `modules/hosts/mbp/flake-parts.nix` correctly calls `factory.darwin "aarch64-darwin" "mbp"`
- `modules/hosts/mbp/configuration.nix` defines `flake.modules.darwin.mbp` importing 17+ dendritic aspects
- All core modules (nix, fish, git, gh, gpg, ssh, sshd, lazyvim, ai, dev-tools, firefox, homebrew, fonts, general, chat, launcher, colemak, norcevpn, secrets, home-manager, cli, constants) are properly defined with `flake.modules` pattern
- Factory pattern (`factory/systems.nix`, `factory/user.nix`) is correctly implemented
- `import-tree` auto-imports all modules from `./modules`
- Constants aspect uses `generic` module class correctly

### 3.2 Checklist: What's Missing or Needs Attention

| # | Item | Status | File(s) | Fix |
|---|---|---|---|---|
| 1 | **1Password SSH agent** not configured | MISSING | `modules/ssh.nix` vs old `hosts/mbp/home/ssh.nix` | Add `identityAgent` for 1Password to mbp-specific HM config in `modules/hosts/mbp/configuration.nix` or make it conditional in `modules/ssh.nix` |
| 2 | **`workstation` SSH matchBlock** missing | MISSING | `modules/ssh.nix` | Old mbp ssh.nix had `workstation` matchBlock with GPG agent remote forward. Add to `modules/ssh.nix` matchBlocks |
| 3 | **GPG agent remote forward** on homelab matchBlock | MISSING | `modules/ssh.nix` | Old ssh config had `remoteForwards` for gpg-agent on homelab. Current `modules/ssh.nix` has homelab block but no remoteForwards |
| 4 | **Mouse acceleration settings** | MISSING | `modules/general.nix` | Old config had `.GlobalPreferences."com.apple.mouse.scaling" = 1.25` and `"com.apple.mouse.linear" = true`. Not in new general.nix. Add to darwin.general or mbp-specific config |
| 5 | **Siri hotkey disable** | MISSING | `modules/general.nix` | Old config disabled Siri shortcut (key `"176"`). New config only disables spotlight (`"64"`) and language switch (`"60"`). Add `"176".enabled = 0` |
| 6 | **`clone_org` script** | MISSING | `homeManagerModules/scripts.nix` | Not migrated to any dendritic module. Create `modules/scripts.nix` or fold into `modules/terminal/cli.nix` |
| 7 | **`darwinModules/linear-mouse.nix`** custom options | SUPERSEDED | `darwinModules/linear-mouse.nix` | Was a workaround for nix-darwin missing mouse options. Now nix-darwin 25.11 may have these natively. Verify and remove legacy module. If still needed, add option definitions to `modules/general.nix` |
| 8 | **`darwinModules/settings.nix`** option-based approach | SUPERSEDED | `darwinModules/settings.nix` | All settings were inlined into `modules/general.nix` darwin.general. Correctly superseded -- delete after validation |
| 9 | **Duplicate casks in general vs homebrew** | MINOR | `modules/general.nix`, `modules/homebrew.nix` | Both define `homebrew.casks` with overlapping entries (1password, bitwarden, etc.). The module system merges lists, but this creates maintenance confusion. Consolidate cask lists into `modules/homebrew.nix` only |
| 10 | **`flake.homeConfigurations`** not emitted | INFO | `modules/factory/systems.nix` | Factory function `homeManager` exists but is never called. This is fine if standalone HM configs aren't needed, but could be useful for CI |
| 11 | **Old `hosts/mbp/` directory** still exists | CLEANUP | `hosts/mbp/` | Dead code (references deleted `presets/` paths). Delete after migration is validated |
| 12 | **Missing `tailscale-app` in homebrew module** | CHECK | `modules/homebrew.nix` vs `modules/general.nix` | `tailscale-app` cask is in `modules/general.nix` darwin.general but not in `homebrew.nix`. Should be consolidated |
| 13 | **Firefox dock apps reference wrong .app names** | BUG | `modules/firefox/default.nix` | `system.defaults.dock.persistent-apps` references `Element.app` and `Slack.app` inside firefox package, which are likely wrong paths. Should reference the actual firefox apps |

---

## 4. Remaining Hosts Migration Plan

### 4.1 Pre-requisites (shared work before any host migration)

#### 4.1.1 New dendritic modules to extract from old configs

These modules should be created first so they can be shared across hosts:

| New Module | Source | Classes | Notes |
|---|---|---|---|
| `modules/gaming.nix` | `hosts/workstation/configuration/gaming.nix` | nixos, homeManager | Steam, gamemode, gamescope, lutris, mangohud |
| `modules/kde.nix` | `hosts/workstation/configuration/kde.nix` | nixos | SDDM, Plasma 6, KDE packages, kdeconnect |
| `modules/plasma.nix` | `hosts/workstation/home/plasma.nix` | homeManager | plasma-manager config (panels, shortcuts, spectacle) |
| `modules/gpu-nvidia.nix` | `hosts/workstation/configuration/gpu.nix` | nixos | NVIDIA driver config, kernel packages, modesetting |
| `modules/tailscale.nix` | `hosts/homelab/configuration/tailscale.nix` | nixos | Tailscale service with sops secret for auth key |
| `modules/docker.nix` | `nixosModules/docker.nix` | nixos | Watchtower auto-updater option module. Rename to avoid confusion -- consider `modules/services/docker-autoupdate.nix` |
| `modules/networking-custom.nix` | `nixosModules/networking.nix` | nixos | Custom networking options (homelabIp, synologyIp, lanNetwork). Consider folding into homelab host-specific config |
| `modules/konsole.nix` | `hosts/workstation/home/konsole.nix` | homeManager | Konsole with Catppuccin themes |
| `modules/fail2ban.nix` | `hosts/homelab/configuration/fail2ban.nix` | nixos | Fail2ban with Cloudflare integration (host-specific, keep in homelab host dir) |

#### 4.1.2 Extend factory for NixOS

The factory already supports NixOS (`factory.nixos`). Verify it works by building the first NixOS host.

### 4.2 Workstation Migration

**Target:** `modules/hosts/workstation/`

#### Step 1: Create new dendritic modules (shared)

Create these files (they'll be auto-imported by `import-tree`):

**`modules/gaming.nix`** -- Extract from `hosts/workstation/configuration/gaming.nix`:
```
flake.modules.nixos.gaming = { ... }:  # steam, gamemode, gamescope, lutris, protonup-qt
flake.modules.homeManager.gaming = { ... }:  # mangohud config
```

**`modules/kde.nix`** -- Extract from `hosts/workstation/configuration/kde.nix`:
```
flake.modules.nixos.kde = { ... }:  # sddm, plasma6, kdeconnect, kde packages
```

**`modules/plasma.nix`** -- Extract from `hosts/workstation/home/plasma.nix`:
```
flake.modules.homeManager.plasma = { ... }:  # plasma-manager panels, shortcuts, config
```
Note: Must add `inputs.plasma-manager.homeManagerModules.plasma-manager` to imports.

**`modules/gpu-nvidia.nix`** -- Extract from `hosts/workstation/configuration/gpu.nix`:
```
flake.modules.nixos.gpu-nvidia = { ... }:  # nvidia driver, kernel, modesetting
```

**`modules/konsole.nix`** -- Extract from `hosts/workstation/home/konsole.nix`:
```
flake.modules.homeManager.konsole = { ... }:  # konsole + catppuccin themes
```

#### Step 2: Create host files

**`modules/hosts/workstation/flake-parts.nix`**:
```nix
{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.factory.nixos "x86_64-linux" "workstation";
}
```

**`modules/hosts/workstation/configuration.nix`**:
```nix
{ inputs, ... }:
{
  flake.modules.nixos.workstation = {
    imports = with inputs.self.modules.nixos; [
      # Infrastructure
      nix
      home-manager
      secrets
      sshd
      ankarhem

      # Hardware
      gpu-nvidia

      # Desktop
      general
      fonts
      kde
      colemak
      bluetooth
      audio

      # Apps
      ai
      chat
      dev-tools
      firefox
      fish
      gh
      gpg
      lazyvim
      norcevpn
      cli
      launcher
      gaming
      comfyui
    ] ++ [
      inputs.self.modules.generic.constants
      # Hardware config (not a dendritic module)
      ./hardware-configuration.nix
    ];

    # Host-specific config
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;
    hardware.enableAllFirmware = true;
    hardware.cpu.amd.updateMicrocode = true;
    networking.hostName = "workstation";
    system.stateVersion = "25.11";

    home-manager.sharedModules = [
      inputs.self.modules.generic.constants
      inputs.self.modules.homeManager.workstation
    ];
  };

  flake.modules.homeManager.workstation = {
    imports = with inputs.self.modules.homeManager; [
      plasma
      konsole
      gaming
    ];
    home.stateVersion = "25.11";
  };
}
```

**`modules/hosts/workstation/hardware-configuration.nix`**: Copy from `hosts/workstation/configuration/hardware-configuration.nix` as-is.

#### Step 3: Validate

```bash
nix flake check
nix build .#nixosConfigurations.workstation.config.system.build.toplevel --dry-run
# On the actual machine:
# sudo nixos-rebuild build --flake .#workstation
# sudo nixos-rebuild switch --flake .#workstation
```

### 4.3 Homelab Migration

**Target:** `modules/hosts/homelab/`

#### Step 1: Create shared modules needed

**`modules/tailscale.nix`** -- Extract from `hosts/homelab/configuration/tailscale.nix`:
```nix
flake.modules.nixos.tailscale = { config, pkgs, ... }: {
  environment.systemPackages = [ pkgs.tailscale ];
  services.tailscale = {
    enable = true;
    openFirewall = true;
  };
};
```
Note: The auth key, routing features, and exit node flags are homelab-specific and stay in the host config.

**`modules/docker.nix`** -- Move `nixosModules/docker.nix` content:
```nix
flake.modules.nixos.docker = { ... }:  # watchtower auto-updater option module
```

**`modules/networking-custom.nix`** -- Move `nixosModules/networking.nix`:
```nix
flake.modules.nixos.networking-custom = { ... }:  # custom IP options
```
Alternatively, keep this homelab-specific since no other host uses it.

#### Step 2: Create host files

**`modules/hosts/homelab/flake-parts.nix`**:
```nix
{ inputs, ... }:
{
  flake.nixosConfigurations = inputs.self.factory.nixos "x86_64-linux" "homelab";
}
```

**`modules/hosts/homelab/configuration.nix`**:
```nix
{ inputs, ... }:
{
  flake.modules.nixos.homelab = {
    imports = with inputs.self.modules.nixos; [
      # Infrastructure
      nix
      home-manager
      secrets
      sshd
      ankarhem

      # Shared
      general  # i18n, timezone, avahi, printing
      fish
      gh
      gpg
      lazyvim
      cli
      colemak

      # Homelab-specific
      docker
      tailscale
    ] ++ [
      inputs.self.modules.generic.constants
    ];

    # Proxmox LXC
    imports = [
      "${inputs.nixpkgs}/nixos/modules/virtualisation/proxmox-lxc.nix"
    ];
    proxmoxLXC.manageNetwork = true;
    boot.isContainer = true;

    # Host-specific networking
    networking.custom = {
      homelabIp = "192.168.1.221";
      synologyIp = "192.168.1.163";
      lanNetwork = "192.168.1.0/24";
    };

    # Host-specific sops
    sops.defaultSopsFile = "${inputs.self}/secrets/homelab/secrets.yaml";
    sops.age.keyFile = "/home/idealpink/.config/sops/age/keys.txt";

    # Host-specific tailscale
    sops.secrets.tailscale_auth_key = {};
    services.tailscale = {
      authKeyFile = config.sops.secrets.tailscale_auth_key.path;
      useRoutingFeatures = "both";
      extraUpFlags = [
        "--advertise-exit-node"
        "--advertise-routes=${config.networking.custom.lanNetwork}"
      ];
      extraSetFlags = [
        "--advertise-exit-node"
        "--advertise-routes=${config.networking.custom.lanNetwork}"
      ];
    };

    # Apps -- imported as-is using underscore convention
    imports = [ ./_apps ];

    # Fail2ban (host-specific)
    imports = [ ./fail2ban.nix ];

    system.stateVersion = "24.05";

    home-manager.sharedModules = [
      inputs.self.modules.generic.constants
      inputs.self.modules.homeManager.homelab
    ];
  };

  flake.modules.homeManager.homelab = {
    home.stateVersion = "24.05";
  };
}
```

Note: The above is pseudo-code showing intent. In actual Nix, multiple `imports` would be merged into a single list.

**`modules/hosts/homelab/_apps/`**: Copy `hosts/homelab/configuration/apps/` directory here. The `_` prefix means `import-tree` will NOT auto-import it at the flake level -- it's only imported explicitly by the homelab host.

**`modules/hosts/homelab/fail2ban.nix`**: Copy from `hosts/homelab/configuration/fail2ban.nix`.

#### Step 3: Validate

```bash
nix flake check
nix build .#nixosConfigurations.homelab.config.system.build.toplevel --dry-run
# On the actual machine:
# sudo nixos-rebuild build --flake .#homelab
# sudo nixos-rebuild switch --flake .#homelab
```

### 4.4 Migration Order

1. Create shared dendritic modules (gaming, kde, plasma, gpu-nvidia, konsole, tailscale, docker, networking-custom)
2. Migrate **workstation** (simpler, no apps/ complication, more overlap with existing modules)
3. Validate workstation with `nix flake check` + dry-run build
4. Migrate **homelab** (apps/ imported as-is, more host-specific config)
5. Validate homelab
6. Delete legacy directories (`hosts/`, `darwinModules/`, `homeManagerModules/`, `nixosModules/`)
7. Final `nix flake check` -- all three hosts build clean

---

## 5. Validation Commands & Success Criteria

### 5.1 Commands

```bash
# Flake evaluation (all outputs)
nix flake check

# Per-host dry-run builds
nix build .#darwinConfigurations.mbp.system --dry-run
nix build .#nixosConfigurations.workstation.config.system.build.toplevel --dry-run
nix build .#nixosConfigurations.homelab.config.system.build.toplevel --dry-run

# Actual build (no switch) -- on respective machines
darwin-rebuild build --flake .#mbp
sudo nixos-rebuild build --flake .#workstation
sudo nixos-rebuild build --flake .#homelab

# List all flake outputs to confirm
nix flake show

# Verify no references to legacy dirs
grep -r 'hosts/' modules/ --include='*.nix' | grep -v '_apps' | grep -v 'hardware-configuration'
grep -r 'darwinModules/' modules/ --include='*.nix'
grep -r 'homeManagerModules/' modules/ --include='*.nix'
grep -r 'nixosModules/' modules/ --include='*.nix'
grep -r 'presets/' modules/ --include='*.nix'
```

### 5.2 Success Criteria

- [ ] `nix flake check` passes with zero errors
- [ ] `nix flake show` lists `darwinConfigurations.mbp`, `nixosConfigurations.workstation`, `nixosConfigurations.homelab`
- [ ] All three hosts build successfully (at minimum dry-run; full build on target machines)
- [ ] No `.nix` file under `modules/` references paths outside `modules/` (except `secrets/`, `packages/`, flake inputs)
- [ ] Legacy directories (`hosts/`, `darwinModules/`, `homeManagerModules/`, `nixosModules/`) are deleted
- [ ] `grep -r 'presets/' .` returns zero results
- [ ] `nix flake check` still passes after legacy directory deletion

---

## 6. Structural Improvements

### 6.1 Proposed Module Layout

Organize the flat `modules/` into semantic subdirectories matching the dendritic comprehensive example:

```
modules/
  factory/              # Factory functions (unchanged)
    flake-parts.nix
    systems.nix
    user.nix
  hosts/                # Host features
    mbp/
      flake-parts.nix
      configuration.nix
    workstation/
      flake-parts.nix
      configuration.nix
      hardware-configuration.nix
    homelab/
      flake-parts.nix
      configuration.nix
      fail2ban.nix
      _apps/            # Underscore = not auto-imported at flake level
        default.nix
        ...
  lib/                  # Flake-level library (unchanged)
    flake-parts.nix
    getGithubKeys.nix
  nix/                  # Nix tooling
    nix.nix             # was: nix.nix (nix settings, overlays)
    tools/
      home-manager.nix
      secrets.nix
  programs/             # User-facing programs
    ai/
      default.nix
      claude.nix
      mcp.nix
      opencode/
    chat.nix
    dev-tools.nix
    firefox/
    gaming.nix
    lazyvim/
      ...
  services/             # System services
    sshd.nix
    tailscale.nix
    docker.nix
    norcevpn.nix
    comfyui.nix
  system/               # System-level settings
    settings/
      audio.nix
      bluetooth.nix
      colemak.nix
      fonts.nix
      general.nix       # i18n, timezone, dock, finder
      gpu-nvidia.nix
      kde.nix
      networking-custom.nix
    constants.nix
  terminal/             # Terminal & shell (unchanged)
    cli.nix
    ghostty.nix
    fish.nix            # was: fish.nix at root
  users/                # User features (unchanged)
    ankarhem.nix
  desktop/              # Desktop-environment things
    homebrew.nix
    launcher.nix
    konsole.nix
    plasma.nix
  tools/                # Developer tools at HM level
    gh.nix
    git.nix
    gpg.nix
    npm.nix
    ssh.nix
```

**Important:** This reorganization is cosmetic and can be done incrementally. `import-tree` will auto-import regardless of directory depth. No functional changes needed -- just `git mv`.

### 6.2 System Type Hierarchy (optional, aspirational)

Following the dendritic comprehensive example's `system-default` -> `system-cli` -> `system-desktop` pattern:

```nix
# modules/system/types/system-default.nix
flake.modules.nixos.system-default = {
  imports = with inputs.self.modules.nixos; [ nix home-manager secrets ];
};
flake.modules.darwin.system-default = {
  imports = with inputs.self.modules.darwin; [ nix home-manager secrets ];
};

# modules/system/types/system-cli.nix
flake.modules.nixos.system-cli = {
  imports = with inputs.self.modules.nixos; [ system-default sshd fish cli lazyvim gpg gh ];
};

# modules/system/types/system-desktop.nix
flake.modules.nixos.system-desktop = {
  imports = with inputs.self.modules.nixos; [ system-cli general fonts audio bluetooth colemak ];
};
```

Then hosts become very concise:
```nix
flake.modules.nixos.workstation = {
  imports = with inputs.self.modules.nixos; [
    system-desktop
    ankarhem
    kde gaming gpu-nvidia comfyui firefox chat dev-tools norcevpn launcher
  ];
  # host-specific overrides...
};
```

This is a **Phase 2** improvement after the basic migration is complete.

### 6.3 Module Style Consistency

Current modules use two patterns:
```nix
# Pattern A: let/in with inherit
let flake.modules.nixos.foo = { ... }; in { inherit flake; }

# Pattern B: direct
{ flake.modules.nixos.foo = { ... }; }
```

Both work with `import-tree`. Standardize on **Pattern B** (direct) for simplicity. Pattern A is only needed when you want to reuse a local binding across multiple module class definitions.

### 6.4 Consolidate Homebrew Casks

Currently casks are scattered across `modules/homebrew.nix`, `modules/general.nix`, `modules/chat.nix`, `modules/norcevpn.nix`, `modules/launcher.nix`. This is actually correct dendritic design (each feature owns its casks). However, the duplicate entries between `homebrew.nix` and `general.nix` should be deduplicated.

**Recommendation:** `modules/homebrew.nix` should contain ONLY the nix-homebrew infrastructure setup (taps, activation, settings). Feature-specific casks stay in their respective modules.

---

## 7. Risks & Mitigations

| Risk | Likelihood | Impact | Mitigation |
|---|---|---|---|
| **NixOS hosts fail to build** due to missing module references | Medium | High | Dry-run build before switch. Keep old `hosts/` until all hosts validated |
| **Duplicate module imports** causing infinite recursion or option conflicts | Medium | High | Audit `home-manager.sharedModules` chains carefully. The Multi Context Aspect pattern (using `sharedModules`) must not double-import `homeManager.*` aspects |
| **`import-tree` picks up `_apps/`** files unexpectedly | Low | Medium | Verify that `import-tree` respects underscore prefix convention. Test with `nix flake check` |
| **plasma-manager not imported** in workstation HM modules | Medium | Medium | Ensure `inputs.plasma-manager.homeManagerModules.plasma-manager` is in the homeManager.plasma imports |
| **`pkgs-unstable` references** in old configs break | Low | Low | New modules use the overlay pattern (`pkgs._unstable`) from `modules/nix.nix`. All old-style `pkgs-unstable` special args are eliminated |
| **sops key paths differ** between factory user module and homelab | Medium | Medium | Factory user.nix sets `sops.age.keyFile` based on username. Homelab's old config uses `idealpink` username with a different path. Verify the factory-generated path matches |
| **Factory uses `ankarhem` as username** but homelab uses `idealpink` | High | High | The `users/ankarhem.nix` sets username=`ankarhem`. Homelab's old config uses `idealpink`. Either: (a) create a `users/idealpink.nix` factory user, or (b) use `ankarhem` on homelab and set up an alias/migration, or (c) the factory user module must be parameterized. **This is a blocking question** |
| **Removing legacy dirs breaks something** still referencing them | Low | High | Run the grep validation commands (Section 5.1) before deleting |

### Blocking Decision Required

**Homelab username:** The old homelab config uses `username = "idealpink"` throughout. The new dendritic system standardizes on `ankarhem` via `users/ankarhem.nix`. Options:
1. **Keep `idealpink` on homelab** -- create `users/idealpink.nix` with a separate factory call
2. **Rename to `ankarhem` on homelab** -- requires user migration on the server (risky on production)
3. **Parameterize the host** -- pass username override in the host configuration module

Recommend option 1 for safety.

---

## 8. Definition of Done

- [ ] All three hosts (`mbp`, `workstation`, `homelab`) are defined under `modules/hosts/<name>/`
- [ ] Each host has `flake-parts.nix` (wiring) + `configuration.nix` (dendritic modules)
- [ ] `nix flake check` passes
- [ ] `nix flake show` shows all three system configurations
- [ ] All three hosts build successfully (full build on target machines)
- [ ] No references to `hosts/`, `darwinModules/`, `homeManagerModules/`, `nixosModules/`, or `presets/` in any file under `modules/`
- [ ] Legacy directories deleted
- [ ] `nix flake check` passes after cleanup
- [ ] Homelab `apps/` imported via underscore convention without any content changes
- [ ] mbp audit items (Section 3.2) resolved or explicitly deferred with tracking issues
