PROCESSOR 18F4550
#include <xc.inc>

;=============================
; 
;=============================
 ;CONFIG1L dir 300000h 		20
		CONFIG	PLLDIV=1	 	; 
		CONFIG	CPUDIV=OSC1_PLL2 ;CUANDO SE USA 	
		CONFIG	USBDIV=2

		;CONFIG1H dir 300001h	   08
		CONFIG	FOSC=INTOSCIO_EC	;OSCILADOR INTERNO, RA6 COMO PIN, USB USA OSC EC
		CONFIG	FCMEN=OFF       ;DESHABILITDO EL MONITOREO DEL RELOJ
		CONFIG	IESO=OFF
		;CONFIG2L DIR 300002H	   	38
		CONFIG	PWRT=ON         ;PWRT HABILITADO
		;CONFIG  BOR=OFF		 	;BROWN OUT RESET DESHABILITADO
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
;=============================
; Declaración de variables
;=============================
_var:; Vector de reset

PSECT udata_acs
    datoA: DS 1 
    datoB: DS 1
    ; sec: DS 1

;=============================
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

    MOVLW 0xFF
    MOVWF TRISA, A
    
    CLRF PORTA, A
    
    CLRF  TRISB, A        ; PORTB como salida
    CLRF  PORTB, A        ; Limpia PORTB
    CLRF TRISB, A        ; PORTB como salida
    CLRF PORTB, A        ; Limpia PORTB
    
    BSF   TRISC,0, A  ; PORTC como entrada (solo bit 2)
    CLRF PORTC, A

;=============================
; Programa principal
;=============================
_main:
    
    
_preg_0:    
    BTFSC PORTA,0,A
    GOTO _incorrecto
    GOTO _preg_1
_preg_1:    
    BTFSS PORTA,1,A
    GOTO _incorrecto
    GOTO _preg_2
_preg_2:    
    BTFSC PORTA,2,A
    GOTO _incorrecto
    GOTO _preg_3
_preg_3:    
    BTFSS PORTA,3,A
    GOTO _incorrecto
    GOTO _preg_4    
_preg_4:    
    BTFSC PORTA,4,A
    GOTO _incorrecto
    GOTO _preg_5
_preg_5:    
    BTFSS PORTA,5,A
    GOTO _incorrecto
    GOTO _preg_6
_preg_6:    
    BTFSC PORTA,6,A
    GOTO _incorrecto
    GOTO _preg_7 
_preg_7:
    BTFSS PORTC,0,A
    GOTO _incorrecto
    GOTO _correcto
    
_correcto:
    MOVLW 0x81 ;0x81 en hexadecimal
    MOVWF datoA,A ; guarda en datoB
    
    MOVFF datoA,PORTB  ;mueve 0x81 (datoA) a PORTB
    GOTO _main    
    
_incorrecto:
    MOVLW 0xFF ;0xFF en hexadecimal
    MOVWF datoB,A ; guarda en datoB
    
    MOVFF datoB,PORTB  ;mueve 0xFF (datoB) a PORTB
    GOTO _main

END











