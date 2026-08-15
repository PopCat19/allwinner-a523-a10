# FEL passive enumeration

Purpose: record passive FEL identification without loading or executing code.

## Scope

Manual FEL entry preceded this capture.
Only `xfel version` and `xfel sid` were run.
No `xfel ddr`, `write`, `exec`, `reset`, or flash command was run.

## Result

Neither permitted query detected a FEL device.
This result does not authorize any additional `xfel` subcommand.

## Environment

Host timestamp: 20260815-212139Z
xfel version: 1.3.5
xfel SHA-256: dc472f4c52625d38bfa07d3e0ae7a92d9db7e52f1a6ad5f427c3ce70a9766625

## xfel version

```text
ERROR: Can't connect to device
ERROR: No FEL device found!
```

Exit status: 255

## xfel sid

```text
ERROR: Can't connect to device
ERROR: No FEL device found!
```

Exit status: 255
