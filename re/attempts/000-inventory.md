# 000: passive inventory

Purpose: establish an immutable starting point before FEL interaction.

## Scope

Read-only host and Android inspection. No reboot, FEL entry, RAM upload, or persistent write occurred.

## Result

Captured the running device's merged FDT. Extracted three DTBO entries from the backed-up `dtbo_a.img`. Installed `xfel` 1.3.5 in the host user profile and confirmed it finds no FEL device while Android runs.

## Artifacts

| Artifact | SHA-256 |
| --- | --- |
| Raw local FDT, 196608 bytes | `c0a28b161d088ed422769ff14ef2815736422608043ebafe45471e6b7b6beab1` |
| Public redacted DTS | `6e06b28c0887598e66a1e4660b166df4bad8933f071f51c0cd6aa2cce19acf81` |
| DTBO entry 0 | `d881d8ba6b7f9a97cda8d9d361aef45115553e48ddbd12735d930083a3de3f7a` |
| DTBO entry 1 | `ca0aaa6e066f7eb9eb17e4aae566bce6807125b561a61deff6811d1c87b28c70` |
| DTBO entry 2 | `3be54ed98c3a6c661078a2f32c5d5a3c1b2ae48962a996ee627af1b45d6fa4b9` |

## Finding

The FDT sets `dram_para[01] = 7`. U-Boot's A523 DRAM enum maps value 7 to LPDDR3. This blocks use of a stock upstream LPDDR4 or DDR3 SPL.

## Next gate

Produce a reviewed A523 LPDDR3 SPL configuration before entering FEL.
