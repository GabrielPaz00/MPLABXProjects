PROCESSOR 18F4550
#include <xc.inc>

;=============================
; CONFIGURACIÓN DE FUSES
;=============================
CONFIG PLLDIV = 1           ; Divide por 1 (4 MHz mínimo para USB)
CONFIG CPUDIV = OSC1_PLL2   ; CPU usa PLL dividido entre 2
CONFIG USBDIV = 2           ; USB usa PLL dividido entre 2

CONFIG FOSC = INTOSCIO_EC   ; Oscilador interno, RA6 como I/O, USB usa EC
CONFIG FCMEN = OFF          ; Sin monitoreo de falla de reloj
CONFIG IESO = OFF           ; Sin cambio entre relojes

CONFIG PWRT = ON            ; Power-up Timer habilitado
CONFIG BORV = 3             ; Nivel de Brown-out (no usado)
CONFIG VREGEN = ON          ; Regulador USB habilitado

CONFIG WDT = OFF            ; Watchdog Timer deshabilitado
CONFIG WDTPS = 32768        ; Postscaler del WDT

CONFIG CCP2MX = ON          ; CCP2 en RC1
CONFIG PBADEN = OFF         ; PORTB<0:4> como digitales
CONFIG LPT1OSC = OFF        ; Timer1 sin modo de bajo consumo
CONFIG MCLRE = ON           ; MCLR habilitado

CONFIG STVREN = ON          ; Reset por desbordamiento de pila
CONFIG LVP = OFF            ; Programación en bajo voltaje deshabilitada
CONFIG ICPRT = OFF          ; Puerto ICP deshabilitado
CONFIG XINST = OFF          ; Modo extendido deshabilitado

CONFIG CP0 = OFF, CP1 = OFF, CP2 = OFF, CP3 = OFF ; Sin protección de código
CONFIG CPB = ON             ; Protección del sector de arranque
CONFIG CPD = OFF            ; EEPROM sin protección

CONFIG WRT0 = OFF, WRT1 = OFF, WRT2 = OFF, WRT3 = OFF ; Sin protección de escritura
CONFIG WRTC = OFF           ; Config sin protección
CONFIG WRTB = ON            ; Bootblock protegido
CONFIG WRTD = OFF           ; EEPROM sin protección

CONFIG EBTR0 = OFF, EBTR1 = OFF, EBTR2 = OFF, EBTR3 = OFF ; Sin protección de lectura
CONFIG EBTRB = OFF          ; Bootblock sin protección de lectura

;=============================
; Declaración de variables
;=============================
PSECT udata_acs
unidades: DS 1 
decenas: DS 1

;=============================
; Vector de reset
;=============================
PSECT resetVec, class=CODE, reloc=2, abs
_reset:
    GOTO _start  

;=============================
; INICIALIZACIÓN DEL SISTEMA
;=============================
PSECT CODE
ORG 0x20            

_start:
    CLRF    ADCON0, A    
    MOVLW   0x0F
    MOVWF   ADCON1, A       ; Todos los pines como digitales

    MOVLW   0x07
    MOVWF   CMCON, A        ; Comparadores desactivados

    MOVLW   0xFF
    MOVWF   OSCCON, A       ; Oscilador interno a 8 MHz
    
    CLRF   TRISA, A        ; PORTA como entrada
    CLRF    PORTA, A

    CLRF    TRISB, A        ; PORTB como salida
    CLRF    PORTB, A

    CLRF    unidades, A
    CLRF    decenas, A
    
BRA clear

tabla7seg:
    ADDWF   PCL, F, A
    RETLW   0x3F ; 0
    RETLW   0x06 ; 1
    RETLW   0x5B ; 2
    RETLW   0x4F ; 3
    RETLW   0x66 ; 4
    RETLW   0x6D ; 5
    RETLW   0x7D ; 6
    RETLW   0x07 ; 7
    RETLW   0x7F ; 8
    RETLW   0x6F ; 9
  
clear:
    CLRF unidades, A
    CLRF decenas, A
    
main: 
    MOVF    unidades, W, A
    CALL    tabla7seg
    MOVWF   PORTB, A

    MOVF    decenas, W, A
    CALL    tabla7seg
    MOVWF   PORTA, A
   
    CALL ret_1seg
    
    MOVLW 0x12
    CPFSEQ unidades, A
    BRA incre
    
    MOVLW 0x12
    CPFSEQ decenas, A
    BRA incre_decenas
    CLRF unidades, A
    CLRF decenas, A
    BRA main
    
incre_decenas:
    MOVLW 0x12
    CPFSEQ unidades, A
    BRA incre
    CLRF unidades, A
    INCF decenas, F, A
    INCF decenas, F, A
    BRA main
   
incre:
    INCF unidades, F, A
    INCF unidades, F, A
    BRA main
   
ret_1seg:
    MOVLW   0x85
    MOVWF   TMR0H, A
    MOVLW   0xEE
    MOVWF   TMR0L, A
    MOVLW 10010101B
    MOVWF T0CON, A

loop:
    BTFSS   INTCON, 2, A
    BRA     loop
    BCF     INTCON, 2, A
    RETURN
    
    
    
    

END


