# Hello world test results

This report covers the six Hello world programs on branch
`claude/hello-world-c-program-4043q9`. It keeps results from three
sources apart, so you can see who ran what:

1. **Manual (owner).** Results the repository owner reported from GitHub
   Codespaces. No logs from those runs are stored in this repository.
2. **Claude (container).** Runs that Claude Code did in its own
   Ubuntu 24.04 cloud container on 2026-10-17. The commands and output
   are recorded below.
3. **GitHub Actions.** The automated workflows in `.github/workflows/`.
   Their logs are public on the repository's
   [Actions page](https://github.com/shibustephenson/ai-working-framework/actions).

## Summary

| Program | Source | Manual (owner, Codespaces) | Claude (container) | GitHub Actions |
|---|---|---|---|---|
| Python | [`hello.py`](hello.py) | Passed (reported) | Passed | [Passed](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674409/job/117396154112) |
| C | [`hello.c`](hello.c) | Passed (reported) | Passed | [Passed](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674409/job/117396154082) |
| C++ | [`hello.cpp`](hello.cpp) | Passed (reported) | Passed | [Passed](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674409/job/117396154109) |
| Java | [`HelloWorld.java`](HelloWorld.java) | Passed (reported) | Passed | [Passed](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674409/job/117396154135) |
| COBOL | [`hello.cob`](hello.cob) | Passed (reported) | Passed | [Passed](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674409/job/117396154010) |
| 8051 assembly | [`hello_8051.asm`](hello_8051.asm) | Not yet tested | **Simulator only**, see below | [Simulator only](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674414/job/117396153901) |

**Expected output.** Python, C, C++, Java and COBOL must print exactly
`Hello world` followed by a newline (`\n`). The 8051 program must send
exactly `Hello world\r\n` out of the serial port.

**Not yet tested.** No one has run the 8051 program on a real 8051 chip.
It has also not been assembled, unchanged, with an assembler built for its
syntax (Keil A51 or ASEM-51). The 8051 status is therefore **not "passed"**.

## How to reproduce

The test scripts are in [`tests/`](tests). Each script exits with a
non-zero status if any program fails to build, fails to run, or prints
anything other than the expected text.

```sh
# Python, C, C++, Java, COBOL. Needs python3, gcc, g++, a JDK and GnuCOBOL.
sudo apt-get install -y gnucobol          # Ubuntu/Debian, if cobc is missing
tests/run_hello_tests.sh                  # all five
tests/run_hello_tests.sh java cobol       # or just some of them

# 8051. Needs as31 and the ucsim simulator.
sudo apt-get install -y as31 sdcc-ucsim
tests/test_8051.sh
```

These are the commands the scripts run for each program:

| Program | Build | Run |
|---|---|---|
| Python | (none) | `python3 hello.py` |
| C | `gcc -Wall -Wextra -Werror -o hello_c hello.c` | `./hello_c` |
| C++ | `g++ -Wall -Wextra -Werror -o hello_cpp hello.cpp` | `./hello_cpp` |
| Java | `javac -d build HelloWorld.java` | `java -cp build HelloWorld` |
| COBOL | `cobc -x -o hello_cob hello.cob` | `./hello_cob` |
| 8051 | `as31 -l -Fhex hello.asm` (translated copy, see below) | `s51 -t 8051 -X 11.0592M -S out=uart.out` with a command file that loads the hex and runs it to the `DONE` loop |

## Manual results (reported by the owner)

The owner tested these in GitHub Codespaces on this branch. They are
recorded here as the owner reported them. Claude did not see or verify
those runs.

| Program | Reported status |
|---|---|
| Python, `hello.py` | Executed successfully |
| C, `hello.c` | Compiled and executed successfully |
| C++, `hello.cpp` | Compiled and executed successfully |
| Java, `HelloWorld.java` | Compiled and executed successfully |
| COBOL, `hello.cob` | Compiled and executed successfully |
| 8051, `hello_8051.asm` | Not yet assembled or executed; pending investigation |

## Claude's results (cloud container)

Claude ran `tests/run_hello_tests.sh` and `tests/test_8051.sh` in a
Claude Code cloud container on 2026-10-17. Tool versions:

| Tool | Version |
|---|---|
| OS | Ubuntu 24.04.5 LTS, x86_64 |
| Python | 3.13.16 |
| gcc / g++ | 13.3.0 (Ubuntu 13.3.0-6ubuntu2~24.04.1) |
| Java | OpenJDK 21.0.12.1 |
| GnuCOBOL | 3.1.2.0 |
| as31 | 2.3.1 (Ubuntu package 2.3.1-10) |
| ucsim (s51) | 0.6.4 (Ubuntu package sdcc-ucsim 4.2.0+dfsg-1) |

Output of `tests/run_hello_tests.sh`. The `JAVA_TOOL_OPTIONS` proxy notice
that this container prints has been left out. So has a GCC
`_FORTIFY_SOURCE redefined` warning from the container's default C flags
during the COBOL build.

```
=== python ===
Python 3.13.16
program output (od -c):
0000000   H   e   l   l   o       w   o   r   l   d  \n
0000014
PASS: python
=== c ===
gcc (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0
program output (od -c):
0000000   H   e   l   l   o       w   o   r   l   d  \n
0000014
PASS: c
=== cpp ===
g++ (Ubuntu 13.3.0-6ubuntu2~24.04.1) 13.3.0
program output (od -c):
0000000   H   e   l   l   o       w   o   r   l   d  \n
0000014
PASS: cpp
=== java ===
javac 21.0.12.1
program output (od -c):
0000000   H   e   l   l   o       w   o   r   l   d  \n
0000014
PASS: java
=== cobol ===
cobc (GnuCOBOL) 3.1.2.0
program output (od -c):
0000000   H   e   l   l   o       w   o   r   l   d  \n
0000014
PASS: cobol
```

The script exited with status 0. As negative checks, Claude also made
these runs, and each exited with status 1 as expected:

- `hello.py` temporarily changed to print `Hello`.
- An unknown language name passed to the script.
- `hello_8051.asm` temporarily changed to send `Hello wrld`.

The original files were restored afterwards.

## GitHub Actions results

The first runs of both workflows used commit
[`42b8d92`](https://github.com/shibustephenson/ai-working-framework/commit/42b8d92759ed997ef338e0762c104388c9124bbd)
on `ubuntu-24.04` runners. Every later push runs them again. The latest
results are on the
[Actions page](https://github.com/shibustephenson/ai-working-framework/actions).

| Workflow | Run | Job | Result | Last log line of the test step |
|---|---|---|---|---|
| Hello world tests | [#1](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674409) | [python](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674409/job/117396154112) | success | `PASS: python` |
| Hello world tests | [#1](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674409) | [c](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674409/job/117396154082) | success | `PASS: c` |
| Hello world tests | [#1](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674409) | [cpp](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674409/job/117396154109) | success | `PASS: cpp` |
| Hello world tests | [#1](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674409) | [java](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674409/job/117396154135) | success | `PASS: java` |
| Hello world tests | [#1](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674409) | [cobol](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674409/job/117396154010) | success | `PASS: cobol` |
| 8051 Hello world (simulator) | [#1](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674414) | [simulate](https://github.com/shibustephenson/ai-working-framework/actions/runs/39032674414/job/117396153901) | success (simulator only) | `PASS: 8051 program sent "Hello world\r\n" to the UART` |

The Intel HEX file that as31 produced in CI is byte-for-byte the same as
the one in Claude's container run shown below.

## 8051 investigation

### Syntax

`hello_8051.asm` uses the **Intel ASM51 / Keil A51** syntax:

- undotted directives: `ORG`, `DB` and `END`
- hex numbers written with an `H` suffix and a leading `0` (`0FDH`)
- labels ending in a colon
- the standard SFR names `TMOD`, `TH1`, `SCON`, `SBUF`, `TR1` and `TI`

It is written for an 11.0592 MHz crystal. With that crystal, `TH1 = 0FDH`
in timer 1 mode 2 gives 9600 baud. The program has no display, so it sends
the text out of the serial port (UART).

### Recommended tools

| Purpose | Tool | Notes |
|---|---|---|
| Assemble unchanged | [ASEM-51](http://plit.de/asem-51/) (free, Linux/DOS/Windows) or Keil A51 (commercial, Windows) | These accept this syntax as written. Claude could not install ASEM-51 because the container's network policy blocks the download site, so it is **not tested**. |
| Assemble on Linux from apt | `as31` (`apt-get install as31`) | Needs dotted directives (`.org`, `.db`, `.end`). It **rejects the file as written** ("syntax error" on the `ORG` and `DB` lines). |
| Simulate | ucsim `s51` (`apt-get install sdcc-ucsim`) | Runs Intel HEX files and can save serial-port output to a file. |
| Real hardware | Any 8051/8052 board with an 11.0592 MHz crystal, plus a serial terminal at 9600 8N1 | **Not tested.** |

### What was actually tested

`tests/test_8051.sh` makes a temporary copy of the source and renames only
the three directives (`ORG` to `.org`, `DB` to `.db`, `END` to `.end`). It
prints the diff, so the logs show exactly what changed. It then assembles
the copy with as31 and runs the hex file in s51. The simulation stops when
the program reaches its final `DONE` loop. The script then checks that the
bytes the program wrote to the serial port are exactly `Hello world\r\n`.

Claude's run of that script:

```
--- translated directives (diff against original) ---
5c5
<         ORG     0000H
---
>         .org     0000H
24c24
< MSG:    DB      "Hello world", 0DH, 0AH, 0
---
> MSG:    .db      "Hello world", 0DH, 0AH, 0
26c26
<         END
---
>         .end
--- assembling with AS31 2.3.1 ---
Begin Pass #1
Begin Pass #2
:10000000758920758DFD759850D28E90001EE493F1
:10001000600AF5993099FDC299A380F280FE486587
:0C0020006C6C6F20776F726C640D0A002E
:00000001FF
--- simulating in s51 until DONE at 0x001C ---
F 0x00001c
Simulated 154332 ticks (1.396e-02 sec)
Host usage: 0.001588 sec, rate=8.788565
quit
--- serial port output (od -c) ---
0000000   H   e   l   l   o       w   o   r   l   d  \r  \n
0000015
PASS: 8051 program sent "Hello world\r\n" to the UART
```

**What this proves.** Every instruction in the program assembles. In a
simulated 8051, the code sends `Hello world\r\n` through the UART in order
and then stops in the `DONE` loop.

**What it does not prove.**

- That the file assembles unchanged in ASEM-51 or Keil A51.
- That the baud rate is right on real hardware. The simulator captures the
  bytes written to `SBUF`, but this test does not check serial timing.
- That the program works on a physical 8051 board.

### Steps to mark 8051 as passed

1. Assemble the unchanged file with ASEM-51 (`asem hello_8051.asm`) or
   Keil A51, and confirm it produces the same bytes as the hex above.
2. Flash the hex to an 8051 board with an 11.0592 MHz crystal. Open a
   serial terminal at 9600 baud, 8 data bits, no parity, 1 stop bit, and
   confirm that `Hello world` appears.
3. Record the board, the tools used and the result in this file.
