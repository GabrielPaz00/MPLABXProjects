PROCESSOR 18F4550
#include <xc.inc>

;=============================
; CONFIGURACIÓN DE FUSES
;=============================

;=============================
; Declaración de variables
;=============================
_var:
PSECT udata_acs
    datoA: DS 1 
    datoB: DS 1

;=============================
; Vector de reset
;=============================
_vector_reset:
PSECT CODE, RELOC=2, ABS

_reset:
    GOTO _start  

;=============================
; INICIALIZACIÓN DEL SISTEMA
;=============================
ORG 0x20            

_start:
    CLRF    ADCON0, A    
    MOVLW   0x0F            ; Todos los pines como digitales
    MOVWF   ADCON1, A       ; ? CORREGIDO: ADCON1, no ADCON0

    MOVLW   0x07            ; Desactiva comparadores
    MOVWF   CMCON, A

    MOVLW   0xFF            ; Oscilador interno a 8 MHz
    MOVWF   OSCCON, A

    MOVLW   0xFF            ; PORTA como entrada
    MOVWF   TRISA, A

    CLRF    TRISB, A        ; PORTB como salida
    CLRF    PORTB, A        ; Limpia PORTB

;=============================
; Bucle principal
;=============================
_main:
    MOVF    PORTA, W, A     ; Leer PORTA
    MOVWF   PORTB, A        ; Escribir en PORTB
    GOTO    _main

END