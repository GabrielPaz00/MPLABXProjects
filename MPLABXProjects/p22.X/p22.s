PROCESSOR 18F4550

		CONFIG	PLLDIV=1	 	; 
		CONFIG	CPUDIV=OSC1_PLL2 ;CUANDO SE USA 	
		CONFIG	USBDIV=2

		;CONFIG1H dir 300001h	   08
		CONFIG	FOSC=INTOSCIO_EC	;OSCILADOR INTERNO, RA6 COMO PIN, USB USA OSC EC
		CONFIG	FCMEN=OFF       ;DESHABILITDO EL MONITOREO DEL RELOJ
		CONFIG	IESO=OFF
		;CONFIG2L DIR 300002H	   	38
		CONFIG	PWRT=ON         ;PWRT HABILITADO
		CONFIG  BOR=OFF		 	;BROWN OUT RESET DESHABILITADO
		CONFIG BORV=3			;RESET AL MINIMO VOLTAJE NO UTILZADO EN ESTE CASO
		CONFIG	VREGEN=ON	 	;REULADOR DE USB ENCENDIDO
		;CONFIG2H DIR 300003H	   	1E
		CONFIG	WDT=OFF         ;WACH DOG DESHABILITADO
		CONFIG WDTPS=32768      ;TIMER DEL WATCHDOG 
		;CONFIG3H DIR 300005H 	   	81
		CONFIG	CCP2MX=ON	 	;CCP2 MULTIPLEXADAS CON RC1	
		CONFIG	PBADEN=OFF      ;PUERTO B PINES DEL 0 AL 4 ENTRADAS DIGITALES
		CONFIG  LPT1OSC=OFF	 	;TIMER1 CONFIURADO PARA OPERAR EN BAJA POTENCIA
		CONFIG	MCLRE=ON        ;MASTER CLEAR HABILITADO
		;CONFIG4L DIR 300006H	   	81
		CONFIG	STVREN=ON	 	;SI EL STACK SE LLENA CAUSE RESET		
		CONFIG	LVP=OFF		 	;PROGRAMACIÒN EN BAJO VOLTAJE APAGADO
		CONFIG	ICPRT=OFF	 	;REGISTRO ICPORT DESHABILITADO
		CONFIG	XINST=OFF  		;SET DE EXTENCION DE INSTRUCCIONES Y DIRECCIONAMIENTO INDEXADO DESHABILITADO
		;CONFIG5L DIR 300008H 		0F
		CONFIG	CP0=OFF		 	;LOS BLOQUES DEL CÒDIGO DE PROGRAMA
		CONFIG	CP1=OFF         ;NO ESTAN PROTEGIDOS
		CONFIG	CP2=OFF		 
		CONFIG	CP3=OFF
		;CONFIG5H DR 300009H  		80
		CONFIG	CPB=ON		 	;SECTOR BOOT ESTA PROTEGIDO
		CONFIG	CPD=OFF		 	;EEPROM N PROTEGIDA
		;CONFIG6L DIR 30000AH 		0F
		CONFIG	 WRT0=OFF	 	;BLOQUES NO PROTEGIDOS CONTRA ESCRITURA
		CONFIG	 WRT1=OFF
		CONFIG	 WRT2=OFF
		CONFIG	 WRT3=OFF

		;CONFIG6H DIR 30000BH		A0
		CONFIG	 WRTC=OFF	 	;CONFIGURACION DE REGISTROS NO PROTEGIDO
		CONFIG	 WRTB=ON	 	;BLOQUE BOOTEBLE NO PROTEGIDO
		CONFIG	 WRTD=OFF	 	;EEPROMDE DATOS NO PROTGIDA

		;CONFIG7L DIR 30000CH		0F
		CONFIG	 EBTR0=OFF	 	;TABLAS DE LETURA NO PROTEGIDAS
		CONFIG	 EBTR1=OFF
		CONFIG	 EBTR2=OFF
		CONFIG	 EBTR3=OFF

		;CONFIG7H DIR 30000DH		40
		CONFIG	 EBTRB=OFF	 	;TABLAS NO PROTEGIDAS
    
#include <xc.inc>
    
;===========================
; Variables en RAM
;===========================
_var:
    PSECT udata_acs
unidades: DS 1
const_ms:   DS 1
ms_count:   DS 1
    

;===========================
; Vector de reset
;===========================
_vector_reset:
    PSECT CODE, RELOC=2, ABS
_reset:
    GOTO _start

;===========================
; Inicio programa (ORG 0x20)
;===========================
ORG 0x20            

_start:
    CLRF    ADCON0, A    
    MOVLW   0x0F
    MOVWF   ADCON1, A       ; Todos los pines como digitales

    MOVLW   0x07
    MOVWF   CMCON, A        ; Comparadores desactivados

    MOVLW   0xFF
    MOVWF   OSCCON, A       ; Oscilador interno a 8 MHz
    
    BSF TRISC, 0, A
    CLRF PORTC, A
    
    CLRF   TRISA, A        
    CLRF    PORTA, A

    CLRF    TRISB, A        ; PORTB como salida
    CLRF    PORTB, A

    CLRF    unidades, A
    
    
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
    
main: 
    MOVF    unidades, W, A
    CALL    tabla7seg
    MOVWF   PORTB, A
    
preg_boton:
    BTFSS PORTC, 0, A
    BRA preg_boton
    CALL delay_20ms
    BTFSS PORTC, 0, A
    BRA preg_boton
    CALL incre
boton:
    BTFSS PORTC, 0, A
    BRA boton
    BRA preg_boton
 
incre:    
    
    MOVLW 0x12
    CPFSEQ unidades, A
    BRA incre_unidades
    CLRF unidades, A
    BRA main
    
incre_unidades:
    INCF unidades, F, A
    INCF unidades, F, A
    BRA main

delay_20ms:
    MOVLW 20
    MOVWF ms_count, A
delay_ms:
    MOVLW   498
    MOVWF   const_ms, A
loop_ms:
    NOP
    DECFSZ  const_ms, F, A
    BRA     loop_ms
    DECFSZ  ms_count, F, A
    BRA delay_ms
    RETURN

END





