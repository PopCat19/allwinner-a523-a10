# Boot-chain read-only analysis

Purpose: inspect the immutable local recovery checkpoint for attributable A523 LPDDR3 DRAM-init evidence without device interaction.

## Scope

The immutable local checkpoint is identified by the capture label `a523-recovery-20260815-164943`.
It was not modified.
All derived files were extracted under a fresh `/tmp/a523-boot-chain.*` directory.
No FEL command, Android command, partition write, or boot attempt ran.

## Integrity

The checkpoint's `SHA256SUMS.tsv` manifest has SHA-256 `6a9fef311c5b62f1e8740f7570b70a3d56b5743c1993828f50c07ffd525f8f63`.
The following fail-closed command exited zero and reported every manifest entry as `OK`:

```sh
set -euo pipefail
cd "$CHECKPOINT"
entries=$(tail -n +2 SHA256SUMS.tsv)
test -n "$entries"
printf '%s\n' "$entries" | awk '{print $2 "  " $1}' | sha256sum -c -
```

The omitted first line is the manifest's descriptive header, not a checksum entry.

Relevant checkpoint image hashes:

| Image | SHA-256 |
| --- | --- |
| `bootloader_a.img` | `795b4ad5a052e109cf4ac0576101724af065332186ef1912aa2da81234b76728` |
| `env_a.img` | `25b0a03a184fc160ec72f46341a51bb3eb127af807bd7cd1e2fce7f95214e551` |
| `vendor_boot_a.img` | `32d7b8e45cd119951830e911eb2bb0ade4868cb9e9db8fb03361dd2fdecc3b03` |
| `super.img` | `6329f4f07818a1518c5916963ebd84ef1bab9843174982a876c23dec27f783b4` |

## Boot-stage results

`bootloader_a.img` is a 32 MiB FAT16 volume.
Its boot sector identifies FAT16 and no `boot0`, SPL, DRAM, LPDDR, or U-Boot string was found.
This independently confirms the earlier asset-container finding.

`env_a.img` is a U-Boot environment with Android boot commands.
It names `bootloader`, `env`, `boot`, `vendor_boot`, `dtbo`, `vbmeta`, `vbmeta_system`, `vbmeta_vendor`, and `init_boot` as A/B partitions.
It contains no DRAM-init payload or parameter table.

`vendor_boot_a.img` is Android vendor boot image v4.
`unpack_bootimg` reported a 2 KiB page size, a 22,186,918-byte vendor ramdisk, a 154,264-byte DTB, and 177-byte bootconfig.
Its DTB identifies `A523-PRO2-AXP717C`, `allwinner,a523`, and `allwinner,dram`, but has no `dram_para[]` properties.
The live redacted FDT remains the only local source of the full `dram_para[00..95]` table.

No attributable pre-DRAM payload was found in the inspected boot-stage images.

## Runtime-only artifacts

`lpdump` identifies `vendor_a` and `vendor_dlkm_a` as active logical partitions in `super.img`.
They extract as EROFS filesystems.
`vendor_dlkm_a` contains `ccu-ddr.ko`, `sun55iw3-devfreq.ko`, and `sunxi-ddrpmu.ko`.
`vendor_a` contains `etc/init/com.softwinner.dramdfs-service.rc`, `etc/init/init.sun55iw3p1.ntc.rc`, and firmware files named `OS_ROM.bin`, `EXEC_KERNEL_IMAGE.bin`, and `amp_dsp0.bin`.

These files load after the vendor kernel has started and are runtime provenance only.
They do not establish boot-ROM or SPL LPDDR3 controller parameters, mode registers, or timing values.
No proprietary content was copied into this repository.

## Result

The evidence gate remains closed.
The analysis recovered no attributable A523 LPDDR3 DRAM-init source, binary, or board parameter mapping.
Do not prepare or upload an FEL SPL from these findings.

## Reproduction

Set `CHECKPOINT` to the immutable local checkpoint and use a new temporary directory:

```sh
export TMPDIR=$(mktemp -d /tmp/a523-boot-chain.XXXXXX)
test -n "$TMPDIR"
file "$CHECKPOINT/partitions/bootloader_a.img" \
    "$CHECKPOINT/partitions/env_a.img" \
    "$CHECKPOINT/partitions/vendor_boot_a.img" \
    "$CHECKPOINT/partitions/super.img"
unpack_bootimg --boot_img "$CHECKPOINT/partitions/vendor_boot_a.img" \
    --out "$TMPDIR/vendor_boot"
lpdump "$CHECKPOINT/partitions/super.img"
lpunpack "$CHECKPOINT/partitions/super.img" "$TMPDIR/super"
nix shell nixpkgs#erofs-utils -c dump.erofs --ls --path=/etc/init \
    "$TMPDIR/super/vendor_a.img"
nix shell nixpkgs#erofs-utils -c dump.erofs --ls --path=/lib/modules \
    "$TMPDIR/super/vendor_dlkm_a.img"
```

The analysis also used read-only `sha256sum`, `od`, and `strings` queries.
`unpack_bootimg`, `lpdump`, and `lpunpack` came from the host Android platform-tools profile.
`dump.erofs` was `erofs-utils` 1.9.2 in an ephemeral `nix shell nixpkgs#erofs-utils` invocation.
