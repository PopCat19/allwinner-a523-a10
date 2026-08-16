# Linux target requirements

Purpose: define the minimum RAM-only Linux boot requirements for the verified A523 tablet without approving a FEL payload.

## Scope

This note defines the target boot chain, kernel requirements, and acceptance criteria after a reviewed A523 LPDDR3 SPL exists.
It does not authorize FEL entry or any device command.
The FEL gate in `fel-gate.md` remains controlling until the LPDDR3 port review gate is satisfied.

## Boot chain

The reviewed RAM-only chain must contain these independently hashed inputs:

1. An A523 LPDDR3 SPL that initializes the tablet's 3 GiB LPDDR3 and returns control without accessing persistent storage.
2. A second-stage bootloader that receives the initialized DRAM state and loads a DTB, Linux kernel, and initramfs from host-provided RAM data.
3. A DTB derived from the public redacted live FDT, with unsupported nodes disabled only when required for boot.
4. A self-contained arm64 Linux kernel and initramfs with no dependency on eMMC, Android partitions, or an external root device.

The first execution target is the early console on `ttyAS0` at 115200 baud.
The initial root filesystem is an initramfs so storage discovery is not a boot prerequisite.

## Kernel requirements

The kernel config must include arm64, the sunxi A523 platform support used by the selected kernel tree, serial console support, devtmpfs, initramfs support, and the device-tree support needed by that tree.
It must include the clock, reset, pinctrl, interrupt-controller, timer, and PMIC drivers required before console and userspace start.

The initial hardware scope is limited to UART and memory.
SDMMC0 removable storage support is the first optional expansion because the live FDT identifies it as a four-bit removable controller at `0x04020000`.
Do not make eMMC, Wi-Fi, Bluetooth, touch, display, USB, or Android compatibility a first-boot requirement.

The selected kernel source revision, defconfig or config fragment, DTB source, kernel image hash, and initramfs hash must be recorded before any RAM-only execution review.

## Device-tree requirements

The boot DTB must preserve the verified A523 compatible strings, 3 GiB memory range beginning at `0x40000000`, and early console path for `ttyAS0`.
It must not expose the public redacted serial placeholder as a real device identifier.

DRAM properties remain evidence for SPL review rather than Linux runtime configuration.
The Linux DTB does not establish any missing SPL controller or mode-register values.

## Acceptance criteria

A proposed RAM-only Linux boot is ready for execution review only after all items below are available:

1. The LPDDR3 SPL has passed the existing independent source review gate.
2. Each executable stage has a recorded source revision, reproducible build command, SHA-256 hash, load address, and entry address.
3. The reviewed plan proves that no command writes eMMC, SPI flash, Android partitions, boot metadata, or other persistent storage.
4. The expected UART transcript identifies the SPL, second-stage bootloader, kernel, and initramfs handoffs.
5. Linux reaches an initramfs shell and reports the expected 3 GiB memory region.
6. A post-test power cycle returns the tablet to Android, with the result recorded in a new attempt note.

A UART banner without Linux reaching the initramfs shell is a partial result, not a successful target boot.

## Deferred requirements

Display output, touch input, Wi-Fi, Bluetooth, Type-C, eMMC, audio, camera, suspend, charging behavior, and Android dual-boot integration are deferred.
Each requires a separate device-tree and driver review after the RAM-only console boot succeeds.

## Current blocker

No reviewed A523 LPDDR3 SPL exists.
The missing controller setup, mode-register programming, and tablet-specific parameter mapping are recorded in `a523-lpddr3-source-audit.md` and `a523-lpddr3-port-evidence.md`.
No Linux image, kernel config, or downstream bootloader can bypass that pre-DRAM requirement.
