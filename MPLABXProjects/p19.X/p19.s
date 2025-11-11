PROCESSOR 18F4550
#include <xc.inc>

;=============================
; CONFIGURACIÓN DE FUSES
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
PSECT udata_acs
counter: DS 1
datoA: DS 1    
datoB: DS 1

;=============================
; Vector de reset
;=============================
PSECT CODE, RELOC=2, ABS
_reset:
    GOTO _start  

;=============================
; INICIALIZACIÓN DEL SISTEMA
;=============================
ORG 0x20
_start:
    CLRF    ADCON0, A    
    MOVLW   0x0F
    MOVWF   ADCON1, A

    MOVLW   0x07
    MOVWF   CMCON, A

    MOVLW   0xFF
    MOVWF   OSCCON, A
    
    MOVLW 0x03
    MOVWF TRISA, A
    
    CLRF PORTA, A
    
    CLRF    TRISB, A
    CLRF    PORTB, A
    CLRF counter, A
    BCF INTCON, 2, A 
   
BRA main
    
;=============================
; TABLA HEXADECIMAL
;=============================
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
    RETLW   0x77 ; A
    RETLW   0x7C ; B
    RETLW   0x39 ; C
    RETLW   0x5E ; D
    RETLW   0x79 ; E
    RETLW   0x71 ; F
    
;=============================
; BUCLE PRINCIPAL
;=============================
main:  
    MOVF    PORTA, W, A 
    MOVWF   datoA, A
    ANDLW   0x03   ; Enmascaramiento puerto A
    SUBLW   0x00
    BTFSS STATUS, 2, A
    GOTO preg_1
    GOTO hexa_reset 
    
preg_1:
    MOVF    PORTA, W, A       
    ANDLW   0x03   ; Enmascaramiento puerto A
    SUBLW   0x01
    BTFSS STATUS, 2, A
    GOTO preg_2
    GOTO decimal_reset
preg_2:
    MOVF    PORTA, W, A       
    ANDLW   0x03   ; Enmascaramiento puerto A
    SUBLW   0x02
    BTFSS STATUS, 2, A
    GOTO preg_3
    GOTO seis
preg_3:
    MOVF    PORTA, W, A       
    ANDLW   0x03   ; Enmascaramiento puerto A
    SUBLW   0x03
    BTFSS STATUS, 2, A
    GOTO main
    GOTO octal_reset    
;=============================
; BUCLE HEXADECIMAL
;=============================       
hexa_reset:
    MOVLW 0x1E
    MOVWF counter, A
hexa_main:
    MOVF    counter, W, A
    CALL    tabla7seg
    MOVWF   datoB, A
    MOVFF   datoB, PORTB
    CALL    ret_1seg
    
    CALL check_portA
    
    MOVF    counter, W, A
    BTFSS   STATUS, 2, A
    BRA     decre
    BRA     main
;=============================
; DECREMENTO HEXADECIMAL
;=============================
decre:
    DECF counter, F, A
    DECF counter, F, A
    BRA hexa_main    
;=============================
; BUCLE OCTAL
;=============================    
octal_reset:
    CLRF counter, A
octal_main:
    MOVF    counter, W, A
    CALL    tabla7seg
    MOVWF   datoB, A
    MOVFF   datoB, PORTB
    CALL    ret_1seg

    CALL check_portA
    
    MOVF    counter, W, A
    SUBLW   0x0E
    BTFSS   STATUS, 2, A
    BRA     incre_octal
    BRA     main
;=============================
; INCREMENTO OCTAL
;=============================
incre_octal:
    INCF counter, F, A
    INCF counter, F, A
    BRA octal_main    
;=============================
; BUCLE DECIMAL
;=============================    
decimal_reset:
    MOVLW 0x12
    MOVWF counter, A
decimal_main:
    MOVF    counter, W, A
    CALL    tabla7seg
    MOVWF   datoB, A
    MOVFF   datoB, PORTB
    CALL    ret_1seg

   CALL check_portA
    
    MOVF    counter, W, A
    BTFSS   STATUS, 2, A
    BRA     decre
    BRA     main
;=============================
; INCREMENTO DECIMAL
;=============================
decre_decimal:
    DECF counter, F, A
    DECF counter, F, A
    BRA decimal_main 
;=============================
; SEIS
;=============================
seis:    
    MOVLW 0x0C
    MOVWF counter, A
    MOVF    counter, W, A
    CALL    tabla7seg
    MOVWF   datoB, A
    MOVFF   datoB, PORTB
    CALL    ret_1seg
    BRA main
 
check_portA:
    MOVF    PORTA, W, A  
    CPFSEQ  datoA, A
    GOTO main
    RETURN 
   
;=============================
; RETARDO DE 1 SEGUNDO
;=============================
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