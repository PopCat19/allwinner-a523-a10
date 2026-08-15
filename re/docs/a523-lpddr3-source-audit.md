# A523 LPDDR3 source audit

Purpose: record the upstream U-Boot source gap before an A523 LPDDR3 SPL port.

## Scope

This audit reads an unmodified clone of upstream U-Boot commit `527115ef6783cec49e5610c523c124b399011361`.
Source remote: `https://github.com/u-boot/u-boot.git`.
No U-Boot source or recovery artifact was modified.

## Verified device inputs

The public redacted DTS artifact has SHA-256 `6e06b28c0887598e66a1e4660b166df4bad8933f071f51c0cd6aa2cce19acf81`.
Its `dram` node reports `dram_para[01] = <0x07>`.
Its memory node reports 3 GiB at `0x40000000`.

`SUNXI_DRAM_TYPE_LPDDR3` is the matching U-Boot DRAM type enum.
The FDT type value does not establish the complete controller timing or mode-register configuration.

## Upstream status

`arch/arm/mach-sunxi/Kconfig:624` defaults A523 to `SUNXI_DRAM_A523_LPDDR4`.
`arch/arm/mach-sunxi/Kconfig:708-722` exposes A523 DDR3 and LPDDR4 selections only.
`arch/arm/mach-sunxi/dram_timings/Makefile:11-12` builds only `a523_ddr3.o` and `a523_lpddr4.o` for A523.

`arch/arm/mach-sunxi/dram_sun55i_a523.c:958-961` has an LPDDR3 PHY branch.
`arch/arm/mach-sunxi/dram_sun55i_a523.c:1003-1012` programs LPDDR3-specific PHY values.
`arch/arm/mach-sunxi/dram_sun55i_a523.c:1171-1215` omits LPDDR3 mode-register programming.
`arch/arm/mach-sunxi/dram_sun55i_a523.c:1318-1327` omits LPDDR3 controller setup and panics for that type.

## Consequence

No upstream A523 board config is a valid LPDDR3 SPL candidate for this tablet.
Changing only the A523 `para.type` selection is prohibited because controller setup and mode-register programming remain incomplete.

## Port review gate

A proposed RAM-only SPL must provide all items below before FEL upload review:

1. Add an explicit A523 LPDDR3 Kconfig choice and timing object.
2. Set the A523 DRAM parameter type to `SUNXI_DRAM_TYPE_LPDDR3`.
3. Implement LPDDR3 controller `mstr` device type, burst length, ODT config, and LPDDR3 mode-register writes from attributable source evidence.
4. Cross-check every consumed board parameter against the redacted FDT and label unavailable mappings as unknown.
5. Produce a clean build log, SPL hash, diff, load address, and expected UART output.
6. Obtain an independent source review before a RAM-only upload plan is approved.

## Open evidence

The public FDT provides vendor `dram_para` values but not their complete mapping to upstream U-Boot config symbols.
The mode-register values and controller settings for this tablet's LPDDR3 population remain unverified.
No candidate SPL exists.
