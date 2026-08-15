# A523 LPDDR3 source leads

Purpose: assess public A523 LPDDR3 source and parameter leads without treating adjacent-board data as tablet provenance.

## Scope

This note records public-source and public-device-tree review after the local boot-chain analysis.
No device command, FEL command, checkpoint modification, or proprietary binary extraction occurred.

## Upstream U-Boot

The upstream U-Boot A523 driver defines LPDDR3 as DRAM type 7 and defines `MSTR_DEVICETYPE_LPDDR3`.
Its A523 controller switch still handles only DDR3 and LPDDR4.
Its A523 Kconfig choice still exposes only DDR3 and LPDDR4 timing selections.

Source:

- <https://github.com/apritzel/u-boot/commit/bfee98c77d5737f2ae0c61990554ba9c79526986>
- <https://github.com/u-boot/u-boot/blob/527115ef6783cec49e5610c523c124b399011361/arch/arm/mach-sunxi/dram_sun55i_a523.c>
- <https://github.com/u-boot/u-boot/blob/527115ef6783cec49e5610c523c124b399011361/arch/arm/mach-sunxi/Kconfig>

This confirms the prior port gap.
It does not supply the missing A523 LPDDR3 ODT configuration, mode-register sequence, or tablet parameter mapping.

## SyterKit wrapper

SyterKit commit `35ae1dc624cf2c3c91042654f3e2a3029612a0d4` supplies an Apache-2.0 sun55iw3 wrapper around an embedded DRAM payload.
The wrapper passes parameter element 0 as clock and element 30 as training control through RTC scratch registers before jumping to `ddr.bin`.

Its Avaota A1 sample sets element 1 to 8, which is LPDDR4, not the tablet's LPDDR3 value 7.
The sample also uses clock 1200 and training value `0x860`, unlike the tablet's published element 0 value `0x2b8` and element 30 value `0x16421`.

The referenced `YuzukiHD/SyterKit-Payloads` submodule was not publicly retrievable during this analysis.
The SyterKit history separately records payload removal for copyright handling.
The opaque payload therefore cannot provide attributable A523 LPDDR3 source or controller settings.

Sources:

- <https://github.com/apritzel/SyterKit/commit/35ae1dc624cf2c3c91042654f3e2a3029612a0d4>
- <https://github.com/apritzel/SyterKit/commit/acdc9e3>

## Comparable P85T parameters

A public Teclast P85T FDT identifies `A523-PRO2-AXP717C`, A523, and LPDDR3 through `dram_para[01] = 7`.
It reports 2 GiB at `0x40000000`, whereas this tablet has verified 3 GiB.

The public P85T FDT shares `dram_para[06] = 0x30fa` and `dram_para[22] = 0x80807880` with the tablet.
It differs at least in `dram_para[00]` (`0x318` vs `0x2b8`), `dram_para[26]` (`0xb80000` vs `0xb40000`), and `dram_para[30]` (`0x6421` vs `0x16421`).

This makes the P85T record useful comparative evidence for vendor parameter-table layout.
It is not parameter provenance for this tablet and cannot justify copying any P85T value into an SPL.

Source: <https://gist.github.com/iuncuim/1d395c259c4d3a0bb1b8772cd08dd3b0>

## Result

No attributable A523 LPDDR3 controller implementation or tablet-specific mapping from `dram_para[]` to U-Boot fields was found.
The FEL gate remains closed.
