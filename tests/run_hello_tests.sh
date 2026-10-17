#!/usr/bin/env bash
# Build and run the Hello world programs and check each one prints
# exactly "Hello world" followed by a newline.
#
# Usage: tests/run_hello_tests.sh [python|c|cpp|java|cobol ...]
#        (no arguments runs all five)
#
# Requires: python3, gcc, g++, a JDK (javac/java), GnuCOBOL (cobc)
set -uo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
build="$(mktemp -d)"
trap 'rm -rf "$build"' EXIT
cd "$root"

# Each function logs its tool version and build messages to stderr and
# leaves only the program's own output on stdout.
run_python() { python3 --version >&2; python3 hello.py; }
run_c()      { gcc --version | head -1 >&2; gcc -Wall -Wextra -Werror -o "$build/hello_c" hello.c >&2 && "$build/hello_c"; }
run_cpp()    { g++ --version | head -1 >&2; g++ -Wall -Wextra -Werror -o "$build/hello_cpp" hello.cpp >&2 && "$build/hello_cpp"; }
run_java()   { javac -version >&2; javac -d "$build" HelloWorld.java >&2 && java -cp "$build" HelloWorld; }
run_cobol()  { cobc --version | head -1 >&2; cobc -x -o "$build/hello_cob" hello.cob >&2 && "$build/hello_cob"; }

[ $# -eq 0 ] && set -- python c cpp java cobol
failed=0
for lang in "$@"; do
    echo "=== $lang ==="
    "run_$lang" > "$build/out"
    status=$?
    echo "program output (od -c):"
    od -c "$build/out"
    if [ "$status" -eq 0 ] && cmp -s "$build/out" <(printf 'Hello world\n'); then
        echo "PASS: $lang"
    else
        echo "FAIL: $lang (exit status $status)"
        failed=1
    fi
done
exit "$failed"
