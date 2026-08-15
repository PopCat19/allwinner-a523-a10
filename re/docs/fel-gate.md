# FEL bring-up gate

Purpose: define the required proof before testing a Linux payload through Allwinner FEL.

## Tooling

Host tool: `xfel` 1.3.5. It is installed in the researcher user profile. Its status query returned `No FEL device found` while Android was running, which is expected.

Relevant non-writing commands after manually entering FEL:

```sh
xfel version
xfel sid
```

Do not run `xfel ddr`, `xfel write`, `xfel exec`, flash commands, or reset commands until a reviewed A523 LPDDR3 payload exists. They affect volatile device state or invoke code.

## Required proof

1. Start from a fully charged tablet and retain a working Android USB connection.
2. Enter FEL through the known hardware procedure.
3. Confirm the USB device with `xfel version` and save its output in a new attempt record.
4. Obtain an A523 SPL configured for LPDDR3, derived from current U-Boot A523 code and cross-checked against the values in `artifacts/live-sun55iw3-redacted.dts`.
5. Review the SPL hash, build config, load address, and expected UART output before connection.
6. Perform a RAM-only upload. Do not access eMMC or Android block devices.
7. Power-cycle after the test, boot Android, and record the result.

## Known limitation

Upstream U-Boot contains A523 FEL, clock, and DRAM work. Its A523 DRAM source documents DDR3 and LPDDR4 support. This tablet identifies LPDDR3, so an unmodified upstream board build is not evidence of compatibility.
