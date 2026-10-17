#!/usr/bin/env bash
# Assemble hello_8051.asm and run it in the ucsim 8051 simulator (s51),
# checking that the text sent to the serial port is "Hello world\r\n".
#
# hello_8051.asm uses Intel ASM51 / Keil A51 syntax (ORG, DB, END).
# as31 (free, in Debian/Ubuntu) wants dotted directives (.org, .db, .end),
# so this script assembles a translated copy. Only those three directive
# names are changed; every instruction is assembled as written.
#
# Requires: as31, s51 (Ubuntu: sudo apt-get install as31 sdcc-ucsim)
set -euo pipefail

src="$(cd "$(dirname "$0")/.." && pwd)/hello_8051.asm"
work="$(mktemp -d)"
trap 'rm -rf "$work"' EXIT

sed -E 's/^([[:space:]]*)ORG\b/\1.org/;
        s/^([A-Za-z_][A-Za-z0-9_]*:[[:space:]]*)DB\b/\1.db/;
        s/^([[:space:]]*)END\b/\1.end/' "$src" > "$work/hello.asm"

echo "--- translated directives (diff against original) ---"
diff "$src" "$work/hello.asm" || true

echo "--- assembling with $(as31 -h 2>&1 | head -1) ---"
(cd "$work" && as31 -l -Fhex hello.asm)
cat "$work/hello.hex"

# Stop the simulation when the program reaches its final DONE loop.
done_addr="$(awk '/DONE:/ { print $1; exit }' "$work/hello.lst" | tr -d ':')"
echo "--- simulating in s51 until DONE at 0x$done_addr ---"
printf 'load "%s"\nrun 0x0000 0x%s\nquit\n' "$work/hello.hex" "$done_addr" > "$work/cmds"
s51 -t 8051 -X 11.0592M -S "out=$work/uart.out" -C "$work/cmds" \
    < /dev/null > "$work/sim.log" 2>&1 || true
tail -4 "$work/sim.log"

echo "--- serial port output (od -c) ---"
od -c "$work/uart.out"

if cmp -s "$work/uart.out" <(printf 'Hello world\r\n'); then
    echo "PASS: 8051 program sent \"Hello world\\r\\n\" to the UART"
else
    echo "FAIL: unexpected UART output" >&2
    exit 1
fi
