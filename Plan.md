# Dendritic Alignment Plan

## Intent

This plan aligns this repository more closely with the dendritic flake-parts approach from the referenced wiki pages:

- Feature-first composition over host-first wiring.
- Thin `flake.nix` with recursive module discovery.
- Clear aspect patterns (simple, inheritance, multi-context, factory, constants, collector/DRY where useful).
- Stable composition boundaries between `nixos`, `darwin`, `homeManager`, and `generic`.

## Current State (What is already good)

1. `flake.nix` is already fairly thin and uses `import-tree` to auto-import `./modules`.
2. The repo already uses classed aspects via `flake.modules.<class>.<name>` across many modules.
3. Factory primitives exist (`flake.factory.nixos`, `flake.factory.darwin`, `flake.factory.homeManager`, and `flake.factory.user`).
4. Hosts are composed by imports rather than many feature booleans.
5. A `generic.constants` aspect exists and is shared into host/home-manager composition.

## Gaps To Address

1. Some feature modules are large monoliths (for example, `modules/general.nix`) and would be easier to evolve if split by class/concern.
2. Host modules have long, mostly manual import lists with repeated patterns that could become role/base aspects.
3. Per-user modules duplicate common logic (especially SOPS key and baseline imports) that should be centralized.
4. The path `modules/nix/flake-parts []/darwinConfigurations-fix.nix` is hard to maintain and should be moved to a clearly named compatibility feature path.
5. Workstation host composition should be audited because both `configuration.nix` and `hardware-configuration.nix` define `flake.modules.nixos.workstation`.
6. Internal factory/lib APIs are not documented as a contract, making future contribution/refactor harder.

## Implementation Phases

### Phase 1: Formalize Architecture Contracts

Deliverables:

1. Add a short architecture doc (for example `docs/dendritic-architecture.md`) with:
   - Naming conventions for aspects (`flake.modules.<class>.<aspect>`).
   - Allowed class boundaries (`nixos` != `darwin`; shared logic via `generic`).
   - Import rules (no conditional imports, avoid duplicate imports through multiple paths).
   - Expected role of `factory`, `lib`, and host/user aspects.
2. Add a map of current high-level aspects and their purpose (hosts, users, common features, apps/services).

Exit criteria:

- New contributors can add a feature/host/user without guessing repository conventions.

### Phase 2: Normalize Core Building Blocks

Deliverables:

1. Move `modules/nix/flake-parts []/darwinConfigurations-fix.nix` to a stable path, for example:
   - `modules/compat/flake-parts/darwin-configurations.nix`
2. Keep the same behavior, but document why it exists and when it can be removed.
3. Add minimal validation/contract notes for `flake.factory.*` functions:
   - Required arguments.
   - Returned shape.
   - Supported classes.

Exit criteria:

- Compatibility plumbing is discoverable and intentionally named.
- Factory API expectations are explicit.

### Phase 3: Refactor Monolithic Features Into Dendritic Aspects

Deliverables:

1. Split large modules (start with `modules/general.nix`) into per-class and per-concern files, for example:
   - `modules/general/flake-parts.nix` (optional index/boilerplate)
   - `modules/general/nixos.nix`
   - `modules/general/darwin.nix`
   - `modules/general/home-manager.nix`
2. Keep exported aspect names stable while moving internals, so consumers do not break.
3. Where sensible, create sub-aspects (inheritance pattern), for example:
   - `darwin.general-base` + `darwin.general-desktop` imported by `darwin.general`.

Exit criteria:

- Large features are decomposed without changing effective behavior.
- Aspect boundaries become easier to test and reuse.

### Phase 4: Introduce Role/Base Host Aspects

Deliverables:

1. Create baseline host-role aspects for repeated imports, for example:
   - `nixos.base`
   - `nixos.cli-base`
   - `nixos.desktop-base`
   - `darwin.base`
2. Refactor host modules (`workstation`, `homelab`, `mbp`) to import role/base aspects plus host-specific deltas.
3. Audit duplicate import paths, especially via `home-manager.sharedModules` and host imports.

Exit criteria:

- Host files are shorter and mostly express host-specific intent.
- Shared import stacks live in reusable role aspects.

### Phase 5: Consolidate User Pattern With Factory + Inheritance

Deliverables:

1. Extract shared user baseline into one reusable aspect (for example `users/common` or `homeManager.user-base`).
2. Keep per-user files focused on differences (groups, keys, app choices).
3. Consolidate repeated SOPS key wiring into a reusable user/security aspect.

Exit criteria:

- Adding a new user mostly means factory invocation + small delta module.
- Repeated user bootstrap logic exists in one place.

### Phase 6: Resolve Workstation Hardware Composition Risk

Deliverables:

1. Audit how `modules/hosts/workstation/configuration.nix` and `modules/hosts/workstation/hardware-configuration.nix` merge into `flake.modules.nixos.workstation`.
2. Refactor so the generated hardware module is imported by the host aspect instead of redefining the same aspect key in parallel.
3. Keep generated content isolated and clearly marked as generated.

Exit criteria:

- Workstation module composition is deterministic and obvious.
- Hardware regeneration workflow is documented.

### Phase 7: Optional Advanced Dendritic Patterns

Deliverables (only if beneficial after phases 1-6):

1. Collector aspect for distributed constants/data (only where multiple features contribute to one output).
2. DRY mini-classes for repeated nested attrset fragments (for example repeated networking blocks).

Exit criteria:

- Advanced patterns are introduced only where they reduce duplication without reducing readability.

## Validation Strategy

After each phase:

1. Run `nix flake check`.
2. Evaluate all target outputs (`nixosConfigurations`, `darwinConfigurations`, and relevant `homeConfigurations`).
3. Verify no class-mismatched imports and no accidental duplicate imports.
4. For refactor-heavy phases, compare before/after realized options for at least one Linux and one Darwin target.

## Suggested Execution Order

1. Phase 1 (contracts)
2. Phase 2 (core normalization)
3. Phase 6 (workstation composition risk)
4. Phase 3 (feature decomposition)
5. Phase 4 (host role/base aspects)
6. Phase 5 (user consolidation)
7. Phase 7 (advanced patterns, optional)

This order reduces risk by clarifying conventions first, fixing structural hazards early, and then doing larger refactors incrementally.
