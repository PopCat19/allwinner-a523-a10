#!/usr/bin/env bash
# Purpose: capture the two allowed passive FEL queries into a redacted attempt record.

set -euo pipefail

repo_root=$(git -C "$(dirname "$0")/../.." rev-parse --show-toplevel)
attempts_dir="$repo_root/re/attempts"
timestamp=$(date -u +%Y%m%d-%H%M%SZ)
xfel_bin=/nix/store/2l4c7dz25hv841rq7y65vxzsk4r2jrrz-xfel-1.3.5/bin/xfel
xfel_sha256=dc472f4c52625d38bfa07d3e0ae7a92d9db7e52f1a6ad5f427c3ce70a9766625
version_path=$(mktemp)
sid_path=$(mktemp)

cleanup() {
	rm -f "$version_path" "$sid_path"
}
trap cleanup EXIT

if [[ ! -x "$xfel_bin" ]]; then
	printf '%s\n' 'reviewed xfel binary is unavailable' >&2
	exit 127
fi

if [[ $(sha256sum "$xfel_bin" | awk '{print $1}') != "$xfel_sha256" ]]; then
	printf '%s\n' 'reviewed xfel binary checksum mismatch' >&2
	exit 126
fi

attempt_path=$(mktemp "$attempts_dir/$timestamp-fel-passive-enumeration-XXXXXX.md")

set +e
"$xfel_bin" version >"$version_path" 2>&1
version_status=$?
"$xfel_bin" sid >"$sid_path" 2>&1
sid_status=$?
set -e

{
	printf '%s\n' '# FEL passive enumeration'
	printf '%s\n' '#'
	printf '%s\n' 'Purpose: record passive FEL identification without loading or executing code.'
	printf '\n## Scope\n\n'
	printf '%s\n' 'Manual FEL entry preceded this capture.'
	printf '%s\n' 'Only `xfel version` and `xfel sid` were run.'
	printf '%s\n' 'No `xfel ddr`, `write`, `exec`, `reset`, or flash command was run.'
	printf '\n## Environment\n\n'
	printf '%s\n' "Host timestamp: $timestamp"
	printf '%s\n' 'xfel version: 1.3.5'
	printf '%s\n' "xfel SHA-256: $xfel_sha256"
	printf '\n## xfel version\n\n```text\n'
	cat "$version_path"
	printf '```\n\nExit status: %s\n\n## xfel sid\n\n```text\n' "$version_status"
	cat "$sid_path"
	printf '```\n\nExit status: %s\n' "$sid_status"
} | sed -E \
	-e 's/^([[:space:]]*(SID|Serial|Serial Number|Unique ID|USB ID)[[:space:]]*[:=][[:space:]]*).*/\1<redacted>/' \
	-e 's/([Ss][Ii][Dd]|[Ss]erial([[:space:]]+[Nn]umber)?|[Uu]nique[[:space:]]+[Ii][Dd]|USB[[:space:]]+[Ii][Dd])[[:space:]]*[:=][[:space:]]*[^[:space:]]+/\1: <redacted>/g' \
	>"$attempt_path"

printf '%s\n' "Wrote re/attempts/$(basename "$attempt_path")"
printf '%s\n' 'Review the record for identifiers before committing or publishing it.'

if ((version_status != 0 || sid_status != 0)); then
	exit 1
fi
