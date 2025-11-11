# 1 "p1.s"
# 1 "<built-in>" 1
# 1 "<built-in>" 3
# 296 "<built-in>" 3
# 1 "<command line>" 1
# 1 "<built-in>" 2
# 1 "p1.s" 2
LIST P=18F4550


v1 EQU 0x0E
v2 EQU 0x0F

r_add EQU 0x01
r_sub EQU 0x02




ORG 0x00

_start:

;Suma
MOVLW 0x12
MOVWF v1, A
MOVLW 0x24
MOVWF v2, A
ADDWF v1, W, A

GOTO _start

END
