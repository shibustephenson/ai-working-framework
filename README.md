# ai-working-framework

[![Hello world tests](https://github.com/shibustephenson/ai-working-framework/actions/workflows/hello-world.yml/badge.svg?branch=claude/hello-world-c-program-4043q9)](https://github.com/shibustephenson/ai-working-framework/actions/workflows/hello-world.yml)
[![8051 Hello world (simulator)](https://github.com/shibustephenson/ai-working-framework/actions/workflows/hello-8051.yml/badge.svg?branch=claude/hello-world-c-program-4043q9)](https://github.com/shibustephenson/ai-working-framework/actions/workflows/hello-8051.yml)

## Hello world programs

| Language | File |
|---|---|
| C | [`hello.c`](hello.c) |
| C++ | [`hello.cpp`](hello.cpp) |
| Java | [`HelloWorld.java`](HelloWorld.java) |
| Python | [`hello.py`](hello.py) |
| COBOL | [`hello.cob`](hello.cob) |
| 8051 assembly | [`hello_8051.asm`](hello_8051.asm) |

The test report is in **[TEST_RESULTS.md](TEST_RESULTS.md)**. It lists
what has been tested, who tested it, the exact commands, and what is still
untested (the 8051 program on real hardware).

To run the tests yourself:

```sh
tests/run_hello_tests.sh   # Python, C, C++, Java, COBOL
tests/test_8051.sh         # 8051 in the ucsim simulator (needs as31, sdcc-ucsim)
```
