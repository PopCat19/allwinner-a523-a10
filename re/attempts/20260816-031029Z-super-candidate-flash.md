# Candidate super flash failure

Purpose: record the sanitized result of a candidate `super` flash that left the tablet reachable only through Allwinner FEL.

## Scope

The test used the captured A523 A10 tablet and a locally generated candidate `super` image.
The raw transcript remains local because it contains the device serial number and host-specific paths.
No vendor image or extracted vendor payload is added to this repository.

## Inputs

Both the candidate and backed-up stock `super` images were 3,758,096,384 bytes.

| Image | SHA-256 |
| --- | --- |
| Candidate `super` | `4dcf642aa36d95967bf4fee89c0f0b7b25c52d1367b8113d3060c402818b22ca` |
| Backed-up stock `super` | `6329f4f07818a1518c5916963ebd84ef1bab9843174982a876c23dec27f783b4` |

The Android preflight reported the DSU as installed and disabled.
The device then entered userspace fastbootd, where `fastboot getvar is-userspace` returned `yes`.

## Write result

`fastboot flash super` sent seven sparse chunks and reported each write as `OKAY`.
The command exited zero after 78.961 seconds.
Only the `super` block target was written.

A subsequent `fastboot fetch super` failed because the device did not expose `max-fetch-size` or support the fetch operation.
The resulting local output file was empty, so no post-write hash comparison was possible.

The raw transcript contains a policy inconsistency.
Its early decision record says write authorization was withheld because the active-DSU gate failed, while the later records show the candidate flash completed.
Treat this attempt as an executed persistent write, not as an approved validation procedure.

## Boot result

`fastboot reboot` returned `OKAY`.
Polling for 600 seconds found neither ADB nor fastboot.
Final ADB and fastboot device queries were empty.

USB enumeration then identified `1f3a:4ee1`, Allwinner FEL mode.
The device therefore did not boot the candidate Android system and requires restoration.

## Safety result

No FEL write or restore was attempted.
Restoring the stock `super` image requires a separately reviewed recovery procedure and explicit approval for any FEL write.
Do not repeat this candidate flash.
