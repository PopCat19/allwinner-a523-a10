# FEL passive enumeration

Purpose: record passive FEL identification without loading or executing code.

## Scope

Manual FEL entry preceded this capture.
Only `xfel version` and `xfel sid` were run.
No `xfel ddr`, `write`, `exec`, `reset`, or flash command was run.

## Result

The A523-family FEL ROM responded to both permitted queries.
The returned SID was redacted before publication.
This result does not authorize any additional `xfel` subcommand.

## Environment

Host timestamp: 20260815-212909Z
xfel version: 1.3.5
xfel SHA-256: dc472f4c52625d38bfa07d3e0ae7a92d9db7e52f1a6ad5f427c3ce70a9766625

## xfel version

```text
AWUSBFEX ID=0x00189000(A523/A527/T527/MR527) dflag=0x44 dlength=0x08 scratchpad=0x00061500
```

Exit status: 0

## xfel sid

```text
<redacted-sid>
```

Exit status: 0
