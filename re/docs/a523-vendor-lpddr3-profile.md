# A523 vendor LPDDR3 profile

Purpose: record public A523-family vendor LPDDR3 configuration evidence without treating a prebuilt boot0 or another board profile as a tablet SPL candidate.

## Scope

This note covers the public `chainsx/u-boot-sun55i-vendor` revision `69051c516018daae0f2acf354b09b094176c6155`.
The inspection used a disposable clone only.
No device command, FEL command, local recovery checkpoint access, or vendor-binary publication occurred.

## Package boundary

The repository's `boot-package-a527` and `boot-package-t527` rules copy a corresponding `sys_config.fex` and `boot0_sdcard.fex` before producing `boot_package.fex`.
The repository includes `boot0_sdcard.fex` as a prebuilt Allwinner `eGON.BT0` image.
It does not include tracked A523 boot0 DRAM-controller source.

The A527 boot0 SHA-256 is `d22683ba581786277713f444f03722c8cb73ee8d635701104f4a7f9cc39914f4`.
The T527 boot0 SHA-256 is `d9e6516d4f404b569ad9a872a9a5f08365798ffdf873d2cb51609cdcda14a987`.
These hashes identify public prebuilt artifacts only.
They are not copied into this repository and are not a FEL payload candidate.

Source:

- <https://github.com/chainsx/u-boot-sun55i-vendor/tree/69051c516018daae0f2acf354b09b094176c6155/tools/sunxi-pack>
- <https://github.com/chainsx/u-boot-sun55i-vendor/blob/69051c516018daae0f2acf354b09b094176c6155/Makefile#L1076-L1104>

## LPDDR3 profile

Both public `sys_config.fex` files contain LPDDR3 profile entries with `dram_type = 7`.
The repeated LPDDR3 profile declares clock 672 MHz, `dram_mr1 = 0xc3`, `dram_mr2 = 0x6`, `dram_mr3 = 0x2`, and named drive, ODT, and training values.

This tablet is verified as LPDDR3 through `dram_para[01] = 7`, but its published clock input is `dram_para[00] = 0x2b8` (696 MHz).
The 672 MHz vendor profile is therefore not a device-matching timing or parameter source.
No profile value may be copied into a tablet SPL without an attributable mapping and board validation.

Source:

- <https://github.com/chainsx/u-boot-sun55i-vendor/blob/69051c516018daae0f2acf354b09b094176c6155/tools/sunxi-pack/a527/sys_config.fex#L130-L163>
- <https://github.com/chainsx/u-boot-sun55i-vendor/blob/69051c516018daae0f2acf354b09b094176c6155/tools/sunxi-pack/t527/sys_config.fex#L130-L163>

## 96-word boot-parameter handoff

The A523 `sun55iw3p1_defconfig` enables `CONFIG_SUNXI_BOOT_PARAM`.
The boot-parameter header reserves a 512-byte `ddr_info` region, and `boot_dram_info_t` defines that region as 96 32-bit words.

Early U-Boot accepts the boot-parameter region only after its checksum and `bootpara` magic validate.
It then copies the region to `gd->boot_param`.
During FDT fixup, the enabled path reads `gd->boot_param->ddr_info` as `uint32_t[]` and writes word `i` to `/dram/dram_para%02d` for all indices 95 through 0.

This is source-backed identity mapping from `ddr_info[i]` to the unbracketed FDT property `dram_para%02d` in this vendor U-Boot configuration.
It does not identify the producer of `ddr_info`.

Sources:

- <https://github.com/chainsx/u-boot-sun55i-vendor/blob/69051c516018daae0f2acf354b09b094176c6155/configs/sun55iw3p1_defconfig#L319>
- <https://github.com/chainsx/u-boot-sun55i-vendor/blob/69051c516018daae0f2acf354b09b094176c6155/include/boot_param.h#L41-L56>
- <https://github.com/chainsx/u-boot-sun55i-vendor/blob/69051c516018daae0f2acf354b09b094176c6155/common/board_f.c#L492-L516>
- <https://github.com/chainsx/u-boot-sun55i-vendor/blob/69051c516018daae0f2acf354b09b094176c6155/board/sunxi/board_helper.c#L73-L106>
- <https://github.com/chainsx/u-boot-sun55i-vendor/blob/69051c516018daae0f2acf354b09b094176c6155/board/sunxi/board_helper.c#L1313-L1318>

## Distinct legacy path and tablet FDT naming

When `CONFIG_SUNXI_BOOT_PARAM` is disabled, the same source selects a separate legacy path.
That path reads 32 words from `uboot_spare_head.boot_data.dram_para` and writes bracketed properties `dram_para[00]` through `dram_para[31]`.
The legacy structure also defines only 32 words.

The tablet's redacted FDT uses bracketed property names through index 95.
The public source therefore does not establish that its 96-word boot-parameter handoff generated the tablet FDT, despite the common index range.
It also does not establish that the 32-word legacy path generated a 96-property table.

Sources:

- <https://github.com/chainsx/u-boot-sun55i-vendor/blob/69051c516018daae0f2acf354b09b094176c6155/board/sunxi/board_helper.c#L109-L134>
- <https://github.com/chainsx/u-boot-sun55i-vendor/blob/69051c516018daae0f2acf354b09b094176c6155/include/private_uboot.h#L48-L71>
- `../artifacts/live-sun55iw3-redacted.dts` lines 1144-1239

## Missing producer mapping

The pinned package build rules co-package each `sys_config.fex` with a prebuilt `boot0_sdcard.fex` image.
The inspected public source defines the U-Boot consumer of `ddr_info`, but does not parse named `dram_*` fields from either A527 or T527 `sys_config.fex` into that region.
The only `ddr_info` mutation in the public U-Boot source sets bit 31 of word 23 after the region has been accepted; it is a training flag update, not a profile-to-word conversion.

No public source in this revision proves any mapping from `dram_clk`, `dram_type`, mode-register, drive, ODT, or `dram_tpr*` fields to a `ddr_info` index.
Because the co-packaged boot0 input is prebuilt, it cannot establish boot0 field consumption without opaque-binary analysis.
No opaque binary was added to this repository or treated as source evidence.

Sources:

- <https://github.com/chainsx/u-boot-sun55i-vendor/blob/69051c516018daae0f2acf354b09b094176c6155/Makefile#L1076-L1104>
- <https://github.com/chainsx/u-boot-sun55i-vendor/blob/69051c516018daae0f2acf354b09b094176c6155/sprite/sunxi_boot_param.c#L43-L63>
- <https://github.com/chainsx/u-boot-sun55i-vendor/blob/69051c516018daae0f2acf354b09b094176c6155/tools/sunxi-pack/a527/sys_config.fex#L130-L163>

## Result

Public evidence establishes an enabled A523-family U-Boot consumer that copies validated `ddr_info[0..95]` to unbracketed FDT property names.
The tablet exposes a differently named bracketed 96-property table.
The prebuilt boot0 remains the unverified producer boundary between named `sys_config.fex` profiles and either handoff representation.

No public source proves boot0 consumption of named profile fields, a profile-field-to-`ddr_info` mapping, a `ddr_info`-to-tablet-FDT mapping, or A523 LPDDR3 controller programming.
The FEL gate remains closed.
