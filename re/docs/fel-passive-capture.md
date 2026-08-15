# FEL passive capture

Purpose: define the only permitted first command sequence after manual FEL entry.

Run `scripts/capture-fel-enumeration.sh` only after the tablet is fully powered off, connected through the known FEL-capable USB port, and manually entered into FEL with the known button and cable sequence.
The helper runs only `xfel version` and `xfel sid`.
It makes no RAM upload, reset, flash, eMMC, SPI, or Android partition access.

The helper writes a review-pending attempt record beneath `attempts/`.
It pins the reviewed `xfel` 1.3.5 executable by absolute Nix-store path and SHA-256 before it contacts the tablet.
Review the generated record before committing because a new `xfel` output format can evade its conservative identifier filter.
Do not publish an unreviewed record.

The helper accepts no device-control arguments:

```sh
./re/scripts/capture-fel-enumeration.sh
```

The attempt succeeds only when both command exit statuses are zero and the saved output has been reviewed for identifiers.
Any other result is a recorded enumeration failure, not permission to run another `xfel` subcommand.
