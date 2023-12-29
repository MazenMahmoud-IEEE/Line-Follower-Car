ORG 0000H
AJMP MAIN

ORG 000BH  ; Timer Interrupt ISR, When TCON.5 is set, this ISR is executed
ACALL PWM
RETI

ORG 0030H
MAIN:
MOV P1,#0FFH      ;INIT as INPUT pins
MOV P2,#00H 	  ;INIT as OUTPUT pins
MOV R7,#0FFH      ;R7 is responsible for switching ON and OFF
MOV TMOD, #01H    ;Setting Timer Mode to 1
MOV IE,#82H       ;Enabling Timer0 Interrupt and global interrupt
MOV TH0,#00H      ;INIT TH0
MOV TL0,#00H      ;INIT TL0
CLR P2.0
CLR P2.2
SETB TCON.4       ;Starting the timer

MAINLOOP:
JNB P1.0,StraightOrRight
JNB P1.1,TurnLeft   
STOP: ;Stops both motors
CLR P2.1
CLR P2.3
AJMP MAINLOOP

TurnLeft: ;Stops left motor and starts right motor
CLR P2.1
SETB P2.3
AJMP MAINLOOP

StraightOrRight:
JNB P1.1,Straight
TurnRight: ;Stops right motor and starts left motor 
SETB P2.1
CLR P2.3
AJMP MAINLOOP

Straight: ;Starts both motors
SETB P2.1
SETB P2.3
AJMP MAINLOOP

ORG 0400H

PWM:
CJNE R7,#0FFH,OFF ;Checks value of R7 and goes to ON/OFF label accordingly

ON:              ;To set the Delay for ON time
MOV R7,#00H
SETB P2.4
SETB P2.5
MOV TH0,#0F8H
MOV TL0,#30H
RET

OFF:            ;To set the delay for OFF time
MOV R7,#0FFH
CLR P2.4 
CLR P2.5
MOV TH0,#0F4H
MOV TL0,#48H
RET

END