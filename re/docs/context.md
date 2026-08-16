# RE documentation context

Purpose: index the reviewed hardware facts, source evidence, and execution gates for A523 Linux bring-up.

This directory:

- Records verified board facts and public research evidence.
- Defines the FEL and target-boot review gates.
- Excludes vendor binaries and unverified payloads.

## Files

- `a523-lpddr3-port-evidence.md`: Purpose: bounds source and parameter evidence for an A523 LPDDR3 SPL port.
- `a523-lpddr3-source-audit.md`: Purpose: records the upstream U-Boot A523 LPDDR3 source gap.
- `a523-lpddr3-source-leads.md`: Purpose: assesses public A523 LPDDR3 source and payload leads.
- `a523-vendor-lpddr3-profile.md`: Purpose: records A523-family vendor LPDDR3 profile evidence without approving a candidate.
- `fel-gate.md`: Purpose: defines the proof required before a FEL payload test.
- `fel-passive-capture.md`: Purpose: documents the read-only FEL identification procedure.
- `hardware.md`: Purpose: records verified tablet configuration for Linux bring-up.
- `linux-target-requirements.md`: Purpose: defines the post-gate RAM-only Linux target boot requirements.
