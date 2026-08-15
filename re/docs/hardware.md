# Hardware facts

Purpose: record verified board configuration for Linux bring-up. Values come from the live Android device tree and running-device probes captured on 2026-08-15.

| Area | Verified fact | Evidence |
| --- | --- | --- |
| SoC | Allwinner A523, `sun55iw3p1` | FDT compatible strings |
| Board | `A523-PRO2-AXP717C` | FDT `board` property |
| RAM | 3 GiB LPDDR3 at `0x40000000` | FDT memory node; `dram_para[01] = 7` matches the U-Boot A523 LPDDR3 enum |
| Early UART | `ttyAS0`, 115200 baud, MMIO `0x02500000` | FDT boot arguments |
| eMMC | SDMMC2 at `0x04022000`, 8-bit HS400 | FDT `sdc2` node |
| MicroSD | SDMMC0 at `0x04020000`, 4-bit removable | FDT `sdc0` node |
| Wi-Fi | AIC8800, SDIO ID `C8A1:0082`, on SDMMC1 | live sysfs and loaded modules |
| Bluetooth | AIC8800 over `/dev/ttyAS1` | Android property and loaded modules |
| PMIC | AXP2202 at I2C6 address `0x34` | FDT node |
| Touch | GSLX680 at I2C0 address `0x40`, 800x1280, inverted Y | FDT node and input device |
| Display | `SQ101D_Q5DI404_84H501`, 1200x1920, four-lane DSI | active FDT LCD node |
| Type-C | AXP2202 USB power; HUSB311 TCPM module loaded | FDT and module list |

The vendor FDT contains a separate 800x1280 `JD9365DA_QC` LCD node. Its `status` field is absent and it does not match the active panel identification. Treat it as an unused alternate configuration.

## Artifact provenance

`../artifacts/live-sun55iw3-redacted.dts` is a text decompile of the live FDT. Standard `dtc` needs forced output because the vendor tree uses property names such as `dram_para[00]`, which violate normal DTS property naming rules.

The raw FDT remains local because its Android boot arguments contained a unique device serial. The public DTS replaces that value with `<redacted-serial>`.
