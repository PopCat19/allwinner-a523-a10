# Linux reverse engineering

Purpose: version reproducible research toward a RAM-only Linux boot on the Caxilysh A10 tablet. This workspace contains metadata, redacted hardware descriptions, and attempt records. It does not contain vendor firmware or boot images.

## Safety rule

Every first-stage experiment must use Allwinner FEL RAM loading only. Do not write eMMC, SPI flash, Android partitions, or boot metadata. A failed RAM boot must recover with a power cycle.

## Layout

- `artifacts/`: redacted hardware descriptions and extracted DTBO entries.
- `attempts/`: one Markdown record per experiment.
- `docs/`: hardware facts, source audits, and bring-up gates.
- `scripts/`: passive capture and verification helpers.

## Current status

The device runs an Android vendor kernel. `xfel` 1.3.5 is installed on the research host and finds no FEL device while Android is running. No FEL payload has been tested from this repository.

The first candidate milestone is an A523 LPDDR3 SPL that initializes RAM and produces early UART output. A standard A523 LPDDR4 or DDR3 payload is prohibited because this tablet's vendor device tree identifies LPDDR3. Current upstream U-Boot has A523 LPDDR3 PHY branches but no complete A523 LPDDR3 configuration path; see `docs/a523-lpddr3-source-audit.md` and `docs/a523-lpddr3-port-evidence.md`.

The first manual FEL interaction is restricted to the passive capture procedure in `docs/fel-passive-capture.md`. It runs only `xfel version` and `xfel sid` and creates a reviewable redacted record.

`docs/linux-target-requirements.md` defines the post-gate RAM-only Linux boot chain, minimum kernel scope, and acceptance criteria. It does not approve a payload or relax the LPDDR3 FEL gate.

## Licensing

Repository-authored scripts and documentation are MIT-licensed under `LICENSE-MIT`. Captured device-tree artifacts are factual extracts provided under the repository's CC0 metadata license. Vendor firmware, binaries, and original images remain excluded and retain their original licenses.
