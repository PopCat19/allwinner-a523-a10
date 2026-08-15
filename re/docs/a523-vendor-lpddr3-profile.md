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

## 96-word handoff

The vendor U-Boot header defines a 96-word DRAM information region.
When the `SUNXI_BOOT_PARAM` path is active, the U-Boot FDT handoff copies those words from `ddr_info` to `dram_para00` through `dram_para95`.

This provides public source evidence that a 96-word vendor DRAM parameter handoff exists in this A523-family boot chain.
It does not document how boot0 derives the words from named `sys_config.fex` fields or how it programs the A523 LPDDR3 controller.

Sources:

- <https://github.com/chainsx/u-boot-sun55i-vendor/blob/69051c516018daae0f2acf354b09b094176c6155/include/boot_param.h#L41-L56>
- <https://github.com/chainsx/u-boot-sun55i-vendor/blob/69051c516018daae0f2acf354b09b094176c6155/board/sunxi/board_helper.c#L73-L106>

## Result

Public evidence now establishes co-packaged A523-family LPDDR3 configuration profiles, prebuilt boot0 artifacts, and a separate 96-word vendor U-Boot FDT handoff.
It does not prove how boot0 consumes the named profile fields.
It still does not supply attributable A523 LPDDR3 controller source, tablet-specific parameters, or an auditable mapping between named fields and this tablet's `dram_para[]` values.
The FEL gate remains closed.
