list p=18F452
include  <P18f452.INC>
COUNT1 EQU 0xF0
COUNT2 EQU 0xF1
COUNT3 EQU 0xF2
org 0x00
SETF TRISB
MOVLW B'10000000'
MOVWF TRISC
CLRF TRISD
ClRF TRISA
MOVLW 0xAA
MOVWF PORTA
MOVLW 0x05
MOVWF SPBRG
MOVLW 0x20
MOVWF TXSTA
MOVLW 0x90
MOVWF RCSTA

LOOP:
RCALL TRANSMIT
RCALL DELAY
RCALL RECEIVE
RCALL DELAY
goto LOOP


DELAY:;delay counters were calculated to provide a 100ms delay
MOVLW D'5' ;code kept getting stuck at delay due to an unknown reason
MOVWF COUNT1 ; setting these low values by random seemed to solve the problem (but doesn't actually generate delay) which is better than a delay that gets stuck forever 
AGAIN1:
MOVLW D'1'
MOVWF COUNT2
AGAIN2:
MOVLW D'1'
MOVWF COUNT3
AGAIN3:
NOP
DECFSZ COUNT3
BRA AGAIN3
DECFSZ COUNT2
BRA AGAIN2
DECFSZ COUNT1
BRA AGAIN1
RETURN

TRANSMIT:
MOVF PORTB,W
MOVWF TXREG
TXCHECK:	;wait until byte is fully transmitted
BTFSS PIR1,4
GOTO TXCHECK
RETURN

RECEIVE:
BTFSS PIR1,5 ; make sure there is received data
RETURN
MOVF RCREG,W
MOVWF PORTD
RETURN


END
