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

## Archived SyterKit payload boundary

Historical SyterKit revision `7a3bd4c9be0720d3e5e0dbd3080e25c980e9afb6` records `payloads` as a gitlink to commit `2d773bf4b9fd804e900cc62e0da3c3962f09c09c`.
Its `.gitmodules` names `https://github.com/YuzukiHD/SyterKit-Payloads` as that submodule's public URL.
The GitHub source archive for this revision contains `.gitmodules` but no populated `payloads/` tree.

SyterKit revision `35ae1dc624cf2c3c91042654f3e2a3029612a0d4` configures its Avaota A1 board to build `payloads/sun55iw3_libdram` and convert `output/ddr.bin` into `board/avaota-a1/payloads/init_dram_bin.c`.
The immediately later revision `a86e1aaf084f61eb20c115b4dfbd6449f56d0239` switches that board back to its embedded prebuilt payload mode while retaining the same source and output paths.
The embedded C array is an opaque binary representation, not A523 LPDDR3 controller source.

Direct Git transport and GitHub REST lookups for `YuzukiHD/SyterKit-Payloads` returned repository `404`.
Historical wrapper revisions also reference other submodule commits, including `bc7cb5010298da3e2bfe4a311357b56bf740b84a` at `35ae1dc624cf2c3c91042654f3e2a3029612a0d4` and `ccd5be8e664caf6342f4cda3e59340fc085327d9` at `8c3e06c5e991e53e18885c674d238ae8fed0ba2c`.
Those references identify missing revisions but do not recover their trees.

Sources:

- <https://github.com/apritzel/SyterKit/blob/7a3bd4c9be0720d3e5e0dbd3080e25c980e9afb6/.gitmodules>
- <https://github.com/apritzel/SyterKit/tree/7a3bd4c9be0720d3e5e0dbd3080e25c980e9afb6>
- <https://github.com/apritzel/SyterKit/commit/35ae1dc624cf2c3c91042654f3e2a3029612a0d4>
- <https://github.com/apritzel/SyterKit/commit/a86e1aaf084f61eb20c115b4dfbd6449f56d0239>
- <https://github.com/apritzel/SyterKit/commit/8c3e06c5e991e53e18885c674d238ae8fed0ba2c>
- <https://api.github.com/repos/YuzukiHD/SyterKit-Payloads>

This archival route recovered provenance for an unavailable opaque payload, not its source or a suitable binary.
It provides no A523 LPDDR3 controller implementation, no LPDDR3 parameter profile, and no tablet-specific mapping.

## Vendor boot0 configuration

A public A523-family vendor U-Boot package contains LPDDR3 `sys_config.fex` profiles and prebuilt A527/T527 boot0 images.
The profile supplies named LPDDR3 mode-register, drive, ODT, and training fields at 672 MHz.
The vendor U-Boot source also identifies a 96-word DRAM handoff to FDT properties when its boot-parameter path is active.

The boot0 implementation itself is prebuilt, and the profile clock differs from this tablet's verified 696 MHz input.
The profile therefore provides A523-family packaging and handoff evidence only.
It does not provide attributable controller source, a mapping to this tablet's `dram_para[]`, or an SPL candidate.

See `a523-vendor-lpddr3-profile.md` for revision-pinned source links and public-artifact hashes.

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
