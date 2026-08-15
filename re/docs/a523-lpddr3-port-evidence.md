# A523 LPDDR3 port evidence

Purpose: bound the source evidence required before an A523 LPDDR3 SPL port.

## Scope

This note records read-only analysis after passive FEL enumeration.
No FEL command ran during this analysis.
No recovery artifact or vendor binary was modified or added to this repository.

## Checkpoint integrity

The local recovery checkpoint manifest verified every listed file by SHA-256.
The active `bootloader_a` image is 33,554,432 bytes with SHA-256 `795b4ad5a052e109cf4ac0576101724af065332186ef1912aa2da81234b76728`.
Its container is a FAT-formatted vendor asset volume.
This inspection exposed UI assets and did not locate an attributable boot0 DRAM payload.

## Confirmed upstream port work

The local upstream U-Boot source is commit `527115ef6783cec49e5610c523c124b399011361` from `https://github.com/u-boot/u-boot.git`.
A523 defines `MSTR_DEVICETYPE_LPDDR3` as bit 3 in `arch/arm/include/asm/arch-sunxi/dram_sun55i_a523.h:100-110`.

A133 and H616 initialize LPDDR3 with `MSTR_DEVICETYPE_LPDDR3 | MSTR_BURST_LENGTH(8)` in `dram_sun50i_a133.c:383-385` and `dram_sun50i_h616.c:1227-1229`.
The A523 driver currently initializes only DDR3 and LPDDR4 in `dram_sun55i_a523.c:1318-1327`.
The LPDDR3 controller `mstr` case is therefore a source-backed candidate for an A523 port.
It is not proof that A133 or H616 ODT values, mode-register values, timings, or training paths apply to this tablet.

## Unresolved A523 work

The A523 driver has no LPDDR3 branch for `odtcfg` at `dram_sun55i_a523.c:1339-1348`.
It has no LPDDR3 mode-register sequence at `dram_sun55i_a523.c:1171-1243`.
The A523 `dram_para` and `dram_config` structures do not expose LPDDR3 mode-register parameters at `dram_sun55i_a523.h:120-142`.

A133 has an LPDDR3 sequence, but it relies on a different helper encoding and parameters: `mctl_mr_write_lpddr3()` at `dram_sun50i_a133.c:694-699` and MR1, MR2, MR3, MR11 writes at `:768-773`.
H616 has a different LPDDR3 ODT value and mode-register sequence.
Neither implementation is approved for direct reuse on A523.

## Parameter handling

The redacted tablet DTS reports LPDDR3 through `dram_para[01] = <0x07>`.
Its published values include `dram_para[06] = <0x30fa>` and `dram_para[22] = <0x80807880>`.
The upstream A523 driver consumes only its own config fields `dx_odt`, `dx_dri`, `ca_dri`, `tpr0`, `tpr1`, `tpr2`, `tpr6`, and `tpr10`.
No public mapping from this tablet's vendor `dram_para[]` indices to those U-Boot fields has been verified.

The U-Boot maintainer discussion for H616 LPDDR3 states that vendor `TPR6` byte order is DDR3, DDR4, LPDDR3, LPDDR4 from least to most significant byte.
A523 source uses the third byte for LPDDR3 in `dram_sun55i_a523.c:1092-1103`.
This establishes one field-selection rule, but not the tablet's complete parameter mapping.

Sources:

- `https://lists.denx.de/pipermail/u-boot/2026-April/614425.html`
- `https://github.com/u-boot/u-boot/commit/c453a80cc3b999ad515ed7fcfcf3062e8de1f696`

## External A523 result

A public log by Mikhail Kalashnikov reports an A523 LPDDR3 SPL booting a Teclast P85T with 2 GiB DRAM.
The log proves that A523 LPDDR3 bring-up is feasible on a different board.
It contains no patch, board configuration, DRAM parameter values, or mode-register sequence.
It cannot serve as parameter provenance for this 3 GiB tablet.

Source: `https://gist.github.com/iuncuim/1206c234a8ecec6dd2d0343a03b6b956`.

## Further boot-chain analysis

The immutable recovery checkpoint was re-inspected read-only after this note's initial publication.
`bootloader_a.img`, `env_a.img`, and `vendor_boot_a.img` did not provide an attributable pre-DRAM payload.
The `vendor_boot_a` DTB identifies the A523 board and an `allwinner,dram` node, but has no `dram_para[]` table.
The logical `vendor_a` and `vendor_dlkm_a` partitions expose only post-kernel DDR DFS runtime artifacts.
They are not source or parameter provenance for SPL DRAM initialization.

The reproducible commands, checkpoint hashes, and negative result are recorded in `../attempts/20260815-221711Z-boot-chain-read-only-analysis.md`.
No vendor binary was copied into this repository.

## Next evidence gate

Do not write an SPL yet.
Obtain an attributable A523 LPDDR3 implementation with source diff and board parameters, or recover a documented DRAM payload from the vendor boot chain.
Then cross-check every field against the tablet's redacted DTS before an independent review.
