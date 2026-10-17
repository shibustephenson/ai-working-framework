; Hello world for the 8051 microcontroller.
; Sends "Hello world" out of the serial port (UART) at 9600 baud,
; assuming an 11.0592 MHz crystal.

        ORG     0000H

START:  MOV     TMOD, #20H      ; Timer 1, mode 2 (8-bit auto-reload)
        MOV     TH1, #0FDH      ; 9600 baud
        MOV     SCON, #50H      ; Serial mode 1, receiver enabled
        SETB    TR1             ; Start Timer 1

        MOV     DPTR, #MSG      ; Point to the message
NEXT:   CLR     A
        MOVC    A, @A+DPTR      ; Read next character
        JZ      DONE            ; 0 marks the end of the string
        MOV     SBUF, A         ; Transmit it
WAIT:   JNB     TI, WAIT        ; Wait until it has been sent
        CLR     TI
        INC     DPTR
        SJMP    NEXT

DONE:   SJMP    DONE            ; Stop here

MSG:    DB      "Hello world", 0DH, 0AH, 0

        END
