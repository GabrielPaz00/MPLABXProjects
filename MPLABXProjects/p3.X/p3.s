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

              
    BSF   TRISA,2, A  ; PORTA como entrada (solo bit 2)
    CLRF PORTA, A
    CLRF    TRISB, A        ; PORTB como salida
    CLRF    PORTB, A        ; Limpia PORTB

;=============================
; Programa principal
;=============================
_main:
    BTFSS PORTA,2,A
    GOTO _cero
    GOTO _uno
_cero:
    MOVLW 00000001B ;0x01 en hexadecimal
    MOVWF datoA,A ; guarda en datoA
    
    MOVFF datoA,PORTB  ;mueve 0x01 (datoA) a PORTB
    GOTO _main
        
_uno:  
    MOVLW 01101010B ;0x69 en hexadecimal
    MOVWF datoB,A ; guarda en datoA
    
    MOVFF datoB,PORTB  ;mueve 0X69 a1 (datoB) a PORTB
    GOTO _main
    

END


