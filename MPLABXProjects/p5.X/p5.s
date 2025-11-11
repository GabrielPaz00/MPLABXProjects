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
; Configuracion de registros
;=============================
ORG 0x20            

_start:
    CLRF    ADCON0, A    
    MOVLW   0x0F            ; Todos los pines como digitales
    MOVWF   ADCON1, A      

    MOVLW   0x07            ; Desactiva comparadores
    MOVWF   CMCON, A

    ;MOVLW   0xFF            ; Oscilador interno a 8 MHz
    ;MOVWF   OSCCON, A

    MOVLW 00001111B         
    MOVWF TRISA, A  ; PORTA como entrada (solo primer nible)
    CLRF PORTA, A
    CLRF TRISB, A        ; PORTB como salida
    CLRF PORTB, A        ; Limpia PORTB

;=============================
; Programa principal
;=============================
_main:
    
    
_preg_0:    
    BTFSS PORTA,0,A
    GOTO _incorrecto
    GOTO _preg_1
_preg_1:    
    BTFSC PORTA,1,A
    GOTO _incorrecto
    GOTO _preg_2
_preg_2:    
    BTFSS PORTA,2,A
    GOTO _incorrecto
    GOTO _preg_3
_preg_3:    
    BTFSC PORTA,3,A
    GOTO _incorrecto
    GOTO _correcto    
    
_correcto:
    MOVLW 0x59 ;0x59 en hexadecimal
    MOVWF datoA,A ; guarda en datoB
    
    MOVFF datoA,PORTB  ;mueve 0x59 (datoA) a PORTB
    GOTO _main    
    
_incorrecto:
    MOVLW 0x11 ;0x11 en hexadecimal
    MOVWF datoB,A ; guarda en datoB
    
    MOVFF datoB,PORTB  ;mueve 0x11 (datoB) a PORTB
    GOTO _main

END








