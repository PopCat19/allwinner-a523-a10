# Allwinner A523 A10

Raw firmware research archive for an unbranded A10 tablet built on the Allwinner A523 (`sun55iw3p1`) platform.

## Captured device

| Field | Value |
| --- | --- |
| SoC | Allwinner A523, arm64-v8a |
| Board identity | A10 |
| Stock vendor build | Android 13, `Caxilysh/A10/A10:13/TQ2A.230405.003.B2/20240710:user/release-keys` |
| Kernel | 5.15.144-android13-8 |
| Dynamic partition | `super`, 3,758,096,384 bytes |
| Logical partitions | `system_a`, `vendor_a`, `vendor_dlkm_a`, `system_dlkm_a` |
| Installed GSI during capture | LineageOS 22.2 PHH Treble, Android 15 |
| Boot slots | A/B; only slot A had logical-partition extents during capture |

## Release contents

The release contains a zstd-compressed tar archive split below GitHub's 2 GiB asset limit. It includes:

- `super.img`, a raw dump of the full dynamic-partition container.
- Boot-chain images from slots A and B: boot, init_boot, vendor_boot, dtbo, and vbmeta.
- Active logical vendor, vendor_dlkm, and system_dlkm images.
- An extracted active vendor EROFS filesystem and file manifests.
- Device partition metadata and SHA-256 checksums.

`device-inventory-redacted.txt` omits the USB serial number and ADB Wi-Fi GUID.

## Verify and extract

Download every `a523-a10-backup-20260815.tar.zst.part-*` asset and `a523-a10-backup-20260815.sha256`.

```sh
sha256sum -c a523-a10-backup-20260815.sha256
cat a523-a10-backup-20260815.tar.zst.part-* | zstd -d | tar -xvf -
```

The archive expands into `a523-backup-20260815-154603/`.

## Warning

This is a device-specific research dump. It includes bootloader-adjacent and partition images. Do not flash it to another model or another A523 board revision. The `super.img` dump includes only the dynamic partition container, not a complete eMMC image.

The capture device had an unlocked bootloader. Magisk 30.7 was installed by patching `init_boot_a` after this backup was made.

## Archive hosts

GitHub Releases is the primary mirror for this split archive. Codeberg Releases, SourceForge Files, and Internet Archive are suitable secondary public mirrors. Keep the SHA-256 manifest with every mirror.

## License

The repository metadata is CC0-1.0. Firmware and vendor binaries remain subject to their respective copyright and license terms.
