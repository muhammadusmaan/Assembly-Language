.MODEL SMALL
.STACK 100H
.DATA
HUMAN_ARM_LINE_LEFT			DW		50
HUMAN_ARM_LINE_RIGHT		DW		80
HUMAN_BODY_LINE_COLUMN		DW		65
HUMAN_FACE_UP_EN			DW		75
HUMAN_FACE_UP_START			DW		55
HUMAN_FACE_RIGHT_COLUMN		DW		75
HUMAN_FACE_BOTTOM_START		DW		55
HUMAN_FACE_BOTTOM_END		DW		75
HUMAN_FACE_LEFT_COLUMN		DW		55
HUMAN_FACE_LIPS_START		DW		62
HUMAN_FACE_LIPS_END			DW		68
HUMAN_FACE_LEFT_EYE			DW		60
HUMAN_FACE_RIGHT_EYE		DW		70
HUMAN_LEFT_LEG_START		DW		55
HUMAN_LEFT_LEG_END			DW		65
HUMAN_RIGHT_LEG_START		DW		65
HUMAN_RIGHT_LEG_END			DW		75
HUMAN_BLDE_START			DW		80
HUMAN_BLDE_GRIP				DW		85
HUMAN_BLADE_NEW_END			DW		110
v equ '0'

a db ?


.CODE
MAIN PROC
MOV AX,@DATA
MOV DS,AX


CALL SET_MODE_AND_BG_COLOR
CALL DRAW_ENEMY_OBJECT
CALL DRAW_OBJECT
CALL DRAW_HUMAN_BLADE


AGAIN:
MOV AL,0FH		;SET OBJECT COLOR
MOV AH,01		;CHECK FOR KEY PRESS
INT 16H			;USE 16H TO COMPLETE TASK
;JZ AGAIN		;IF NO KEY PRESS

MOV AH,0		;WHICH KEY IS PRESSED
INT 16H			;USE 16H TO COMPLETE THE TASK

CMP AL,'A'		;IS IT A ?
JE MOVE_LEFT	;IF YES MOVE LEFT
CMP AL,'a'		;IS IT a ?
JE MOVE_LEFT	;IF YES MOVE LEFT

CMP AL,'D'		;IS IT D ?
JE MOVE_RIGHT	;IF YES MOVE RIGHT
CMP AL,'d'		;IS IT d ?
JE MOVE_RIGHT	;IF YES MOVE RIGHT

CMP AL,'S'		;IS IT S ?
JE MOVE_BLADE	;IF YES MOVE BLADE
CMP AL,'s'		;OR IS IT select
JE MOVE_BLADE	;IF YES MOVE BLADE

JMP EXIT		;IF NOT EXIT TO DOS



MOVE_LEFT:
MOV AL,00H		;HIDE OBJECT BY SAME COLOR
CALL DRAW_OBJECT
CALL DRAW_HUMAN_BLADE		;HIDE BLADE
CALL SUB_FIVE
MOV AL,0FH							;AGAIN SHOW ME OBJECT
CALL DRAW_OBJECT
CALL DRAW_HUMAN_BLADE		;HIDE BLADE
JMP AGAIN


MOVE_RIGHT:
MOV AL,00H		;HIDE OBJECT BY SAME COLOR
CALL DRAW_OBJECT
CALL DRAW_HUMAN_BLADE		;HIDE BLADE
CALL ADD_FIVE
MOV AL,0FH							;AGAIN SHOW ME OBJECT
CALL DRAW_OBJECT
CALL DRAW_HUMAN_BLADE				;BLADE WILL SHOW
JMP AGAIN



MOVE_BLADE:
MOV AL,00						;REMOVE COLOR FOR BLADE
CALL DRAW_HUMAN_BLADE			;BLADE GHAIBE HO GIA
MOV AL,0FH						;AGAIN FOR BLADE SHOW
CALL DRAW_HUMAN_BLADE_NEW		;SHOW BLADE AT NEW POSITION
call disp_score1
CALL GIVE_ME_TIME				;THIS WILL STAY BLADE FOR SOME TIME
call sound
mov cx,0FFFh
lop:
loop lop
MOV AL,00						;REMOVE COLOR FOR BLADE
CALL DRAW_HUMAN_BLADE_NEW		;BLADE GHAIBE HO GIA
MOV AL,0FH						;REMOVE COLOR FOR BLADE
CALL DRAW_HUMAN_BLADE			;BLADE GHAIBE HO GIA
JMP AGAIN


EXIT:

MOV AH,4CH
INT 21H
MAIN ENDP


;............sound proc.........................................
;...............................................................
sound                                            proc 

MOV     DX,200          ; number of times to repeat whole routine

MOV     BX,1ffh            ; requency value

MOV     AL, 10111011B   ; the Magic Number (by using binary)
OUT     43H, AL          ; send it to the initializing port 43H Timer 2.

NEXT_FREQUENCY:          ; this is were we will jump back to 2000 times.

MOV     AX, BX           ; move our Frequency value into AX.

OUT     42H, AL          ; send LSB to port 42H.
MOV     AL, AH           ; move MSB into AL  
OUT     42H, AL          ; Send MSB to port 42H.

IN      AL, 61H          ; Get current value of port 61H.
or      AL,00000011B    ; OR AL to this value, forcing first two bits high.
OUT     61H, AL          ; Copy it to port 61H of the PPI Chip
                         ; to turn ON the speaker.
MOV     CX,100          ; Repeat loop 100 times
DELAY_LOOP:              ; Here is where we loop back too.
LOOP    DELAY_LOOP       ; Jump repeatedly to DELAY_LOOP until CX = 0

INC     BX               ; Incrementing the value of BX lowers 
                         ; the frequency each time we repeat the
						 ; whole routine
DEC     DX               ; Decrement repeat routine count
CMP     DX, 0            ; Is DX (repeat count) = to 0
JNZ     NEXT_FREQUENCY   ; If not jump to NEXT_FREQUENCY
                         ; and do whole routine again.
                         ; Else DX = 0 time to turn speaker OFF
IN      AL,61H           ; Get current value of port 61H.
AND     AL,11111010B     ; AND AL to this value, forcing first two bits low.
OUT     61H,AL           ; Copy it to port 61H of the PPI Chip
                         ; to
						 
      RET
sound endp	

disp_score1       proc
;set cursor position
MOV AH,02H		;SET CURSET OPTION
MOV BH,00		;PAGE 0
MOV Dh,48		;ROW POSITION
MOV Dl,28	;COLUMN POSTion
                 
INT 10H


mov dx,v
mov ah,2
int 21h

;set cursor position
;MOV AH,02H		;SET CURSET OPTION
;MOV BH,00		;PAGE 0
;MOV Dh,28		;ROW POSITION
;MOV Dl,26	;COLUMN POSTion
                 
;INT 10H

mov ax,v
inc ax
mov dx,ax
;mov bx,1
;add ax,bx

;call disp_score1
;mov dx,ax
;mov ah,2
;int 21h



disp_score1 endp


  

GIVE_ME_TIME				PROC
MOV CX,0
TIME_LOOP:		;PUT FFFF IN CX FOR LOOP
INC CX
CMP CX,0FFFFH
JNE	TIME_LOOP

MOV CX,0
TIME_LOOP2:		;PUT FFFF IN CX FOR LOOP
INC CX
CMP CX,0FFFFH
JNE	TIME_LOOP2


RET
GIVE_ME_TIME				ENDP



;THIS PROCEDURE ADD FIVE IN ALL VARIABLES
ADD_FIVE					PROC

ADD HUMAN_FACE_UP_START,5
ADD HUMAN_FACE_UP_EN,5
ADD HUMAN_FACE_RIGHT_COLUMN,5
ADD HUMAN_FACE_BOTTOM_START,5
ADD HUMAN_FACE_BOTTOM_END,5
ADD HUMAN_FACE_LEFT_COLUMN,5
ADD HUMAN_FACE_LIPS_START,5
ADD HUMAN_FACE_LIPS_END,5
ADD HUMAN_FACE_LEFT_EYE,5
ADD HUMAN_FACE_RIGHT_EYE,5
ADD HUMAN_ARM_LINE_LEFT,5
ADD HUMAN_ARM_LINE_RIGHT,5
ADD HUMAN_BODY_LINE_COLUMN,5
ADD HUMAN_LEFT_LEG_START,5
ADD HUMAN_LEFT_LEG_END,5
ADD HUMAN_RIGHT_LEG_START,5
ADD HUMAN_RIGHT_LEG_END,5
ADD HUMAN_BLDE_START,5
ADD HUMAN_BLDE_GRIP,5
ADD HUMAN_BLADE_NEW_END,5

RET
ADD_FIVE					ENDP



;THIS PROCEDURE SUBTRACT FIVE FROM ALL VARIABLES
SUB_FIVE					PROC

SUB HUMAN_FACE_UP_START,5
SUB HUMAN_FACE_UP_EN,5
SUB HUMAN_FACE_RIGHT_COLUMN,5
SUB HUMAN_FACE_BOTTOM_START,5
SUB HUMAN_FACE_BOTTOM_END,5
SUB HUMAN_FACE_LEFT_COLUMN,5
SUB HUMAN_FACE_LIPS_START,5
SUB HUMAN_FACE_LIPS_END,5
SUB HUMAN_FACE_LEFT_EYE,5
SUB HUMAN_FACE_RIGHT_EYE,5
SUB HUMAN_ARM_LINE_LEFT,5
SUB HUMAN_ARM_LINE_RIGHT,5
SUB HUMAN_BODY_LINE_COLUMN,5
SUB HUMAN_LEFT_LEG_START,5
SUB HUMAN_LEFT_LEG_END,5
SUB HUMAN_RIGHT_LEG_START,5
SUB HUMAN_RIGHT_LEG_END,5
SUB HUMAN_BLDE_START,5
SUB HUMAN_BLDE_GRIP,5
SUB HUMAN_BLADE_NEW_END,5

RET
SUB_FIVE					ENDP




SET_MODE_AND_BG_COLOR		PROC

;CLEAR SCREEN START
MOV AX,0600H	;SCROLL THE SCREEN
MOV BH,07H		;NORMAL ATTRIBUTE
MOV CX,0000		;FROM ROW=00 , COLUMN = 00
MOV DX,184FH	;TO ROW=18,COLUMN=4F
INT 10H			;INVOKE INTERUPT TO CLEAR SCREEN
;CLEAR SCREEN END

;SET MODE START
MOV AH,00		;SET MODE
MOV AL,12H		;MODE=04 (VIDEO MODE WITH COLOR)
INT 10H			;INVOKE INTERUPT TO CHANGE MODE
;SET MODE END

;THIS IS USE TO CHANGE BACKGROUND COLOR
MOV AH,0BH 		;select palette
MOV BH,1
MOV BL,0		;palette 1
INT 10H
MOV BH,0		;set backgroud color
MOV BL,11H		;green
INT 10H
;BACKGROUND END


MOV AL,0FH		;SET OBJECT COLOR

RET
SET_MODE_AND_BG_COLOR		ENDP






DRAW_OBJECT					PROC
;-------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------
;-------------------------------------OBJECT START FROM HERE--------------------------------------
;-------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------

;DRAW ARMS LINE START
MOV CX,HUMAN_ARM_LINE_LEFT		;LINE START AT COLUMN=100 AND
MOV DX,150						;ROW = 50
BACK1:
MOV AH,0CH						;AH=0CH TO DRAW A LINE
INT 10H							;INVOKE INTERUPT TO DRWA A LINE
INC CX							;INCREMENT HOIZONTAL POSITION
CMP	CX,HUMAN_ARM_LINE_RIGHT		;DRAW LINE UNTILL COLUMN=200
JNZ BACK1
;DRAW ARMS LINE END

;DRAW BODY LINE START
MOV CX,HUMAN_BODY_LINE_COLUMN		;LINE START AT COLUMN=100 AND
MOV DX,142							;ROW = 67
BACK2:
MOV AH,0CH							;AH=0CH TO DRAW A LINE
INT 10H								;INVOKE INTERUPT TO DRWA A LINE
INC DX								;INCREMENT HOIZONTAL POSITION
CMP	DX,157							;DRAW LINE UNTILL COLUMN=200
JNZ BACK2
;DRAW BODY LINE END

;DRWA FACE START
;FACE UP START
MOV CX,HUMAN_FACE_UP_START		;LINE START AT COLUMN=100 AND
MOV DX,132						;ROW = 50
F1:
MOV AH,0CH						;AH=0CH TO DRAW A LINE
INT 10H	
INC CX							;INCREASING HOIZONTAL POSITION
CMP CX,HUMAN_FACE_UP_EN			;DRAW UNTILL CX=250
JNZ F1
;FACE UP END

;FACE RIGHT START
MOV CX,HUMAN_FACE_RIGHT_COLUMN		;LINE START AT COLUMN=100 AND
MOV DX,132							;ROW = 50
F2:
MOV AH,0CH							;AH=0CH TO DRAW A LINE
INT 10H	
INC DX								;INCREASING HOIZONTAL POSITION
CMP DX,142							;DRAW UNTILL CX=250
JNZ F2
;FACE RIGHT END

;FACE BOTTOM START
MOV CX,HUMAN_FACE_BOTTOM_END		;LINE START AT COLUMN=100 AND
MOV DX,142							;ROW = 50
F3:
MOV AH,0CH							;AH=0CH TO DRAW A LINE
INT 10H	
DEC CX								;INCREASING HOIZONTAL POSITION
CMP CX,HUMAN_FACE_BOTTOM_START		;DRAW UNTILL CX=250
JNZ F3
;FACE BOTTOM END

;FACE LEFT START
MOV CX,HUMAN_FACE_LEFT_COLUMN		;LINE START AT COLUMN=100 AND
MOV DX,142							;ROW = 50
F4:
MOV AH,0CH							;AH=0CH TO DRAW A LINE
INT 10H	
DEC DX								;INCREASING HOIZONTAL POSITION
CMP DX,132							;DRAW UNTILL CX=250
JNZ F4
;FACE LEFT END

;LIPS
MOV CX,HUMAN_FACE_LIPS_START		;LINE START AT COLUMN=100 AND
MOV DX,139							;ROW = 50
F5:
MOV AH,0CH							;AH=0CH TO DRAW A LINE
INT 10H	
INC CX								;INCREASING HOIZONTAL POSITION
CMP CX,HUMAN_FACE_LIPS_END			;DRAW UNTILL CX=250
JNZ F5

;LEFT EYE
MOV CX,HUMAN_FACE_LEFT_EYE		;LINE START AT COLUMN=100 AND
MOV DX,135						;ROW = 50
MOV AH,0CH						;AH=0CH TO DRAW A LINE
INT 10H	
;LEFT EYE END

;RIGHT EYE
MOV CX,HUMAN_FACE_RIGHT_EYE		;LINE START AT COLUMN=100 AND
MOV DX,135						;ROW = 50
MOV AH,0CH						;AH=0CH TO DRAW A LINE
INT 10H	
;RIGHT EYE END
;DRAW FACE END

;LEGS START
;LEFT LEG
MOV CX,HUMAN_LEFT_LEG_END		;LINE START AT COLUMN=100 AND
MOV DX,157						;ROW = 50
L1:
MOV AH,0CH						;AH=0CH TO DRAW A LINE
INT 10H	
INC DX
DEC CX							;INCREASING HOIZONTAL POSITION
CMP CX,HUMAN_LEFT_LEG_START		;DRAW UNTILL CX=250
JNZ L1
;LEFT LEG END

;RIGHT LEG
MOV CX,HUMAN_RIGHT_LEG_START		;LINE START AT COLUMN=100 AND
MOV DX,157							;ROW = 50
L2:
MOV AH,0CH							;AH=0CH TO DRAW A LINE
INT 10H	
INC DX
INC CX								;INCREASING HOIZONTAL POSITION
CMP CX,HUMAN_RIGHT_LEG_END			;DRAW UNTILL CX=250
JNZ L2
;RIGHT LEG END
;LEGS END

;-------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------
;--------------------------------------OBJECT END HERE--------------------------------------------
;-------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------
RET
DRAW_OBJECT ENDP


DRAW_HUMAN_BLADE			PROC

;HUMAN BLADE START
MOV CX,HUMAN_BLDE_START						;BLADE COLUMN POSITION
MOV DX,150									;BLADE ROW POSITION
BLADE_BACK:
MOV AH,0CH									;TO DRAW LINE
INT 10H										;INT TO COMPLETE TASK
INC CX										;GROW UPWARD
DEC DX										;GROW RIGHT SIDE
CMP DX,130									;GROW 10 TIMES
JNZ BLADE_BACK

;BLADE GRIP START
MOV CX,HUMAN_BLDE_GRIP						;BLADE COLUMN POSITION
MOV DX,151									;BLADE ROW POSITION
BLADE_BACK2:
MOV AH,0CH									;TO DRAW LINE
INT 10H										;INT TO COMPLETE TASK
DEC CX										;GROW UPWARD
DEC DX										;GROW RIGHT SIDE
CMP DX,144									;GROW 10 TIMES
JNZ BLADE_BACK2
;HUMAN BLDE END

RET
DRAW_HUMAN_BLADE			ENDP







DRAW_HUMAN_BLADE_NEW		PROC

;HUMAN BLADE START
MOV CX,HUMAN_BLDE_START						;BLADE COLUMN POSITION
MOV DX,150									;BLADE ROW POSITION
BLADE_BACK_NEW:
MOV AH,0CH									;TO DRAW LINE
INT 10H										;INT TO COMPLETE TASK
INC CX										;GROW UPWARD		
CMP CX,HUMAN_BLADE_NEW_END									;GROW 10 TIMES
JNZ BLADE_BACK_NEW

;BLADE GRIP START
MOV CX,HUMAN_BLDE_GRIP						;BLADE COLUMN POSITION
MOV DX,145									;BLADE ROW POSITION
BLADE_BACK_NEW2:
MOV AH,0CH									;TO DRAW LINE
INT 10H										;INT TO COMPLETE TASK
INC DX										;GROW RIGHT SIDE
CMP DX,155									;GROW 10 TIMES
JNZ BLADE_BACK_NEW2
;HUMAN BLDE END

RET
DRAW_HUMAN_BLADE_NEW		ENDP












;-------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------
;-------------------------------------OBJECT ENEMY START FROM HERE--------------------------------------
;-------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------
DRAW_ENEMY_OBJECT		PROC

;DRAW ARMS LINE START
MOV CX,600		;LINE START AT COLUMN=100 AND
MOV DX,150		;ROW = 50
E_BACK1:
MOV AH,0CH		;AH=0CH TO DRAW A LINE
INT 10H			;INVOKE INTERUPT TO DRWA A LINE
INC CX			;INCREMENT HOIZONTAL POSITION
CMP	CX,630		;DRAW LINE UNTILL COLUMN=200
JNZ E_BACK1
;DRAW ARMS LINE END


;DRAW BODY LINE START
MOV CX,615		;LINE START AT COLUMN=100 AND
MOV DX,157		;ROW = 50
E_BACK2:
MOV AH,0CH		;AH=0CH TO DRAW A LINE
INT 10H			;INVOKE INTERUPT TO DRWA A LINE
DEC DX			;INCREMENT HOIZONTAL POSITION
CMP	DX,142		;DRAW LINE UNTILL COLUMN=200
JNZ E_BACK2
;DRAW BODY LINE END




;DRWA FACE START
;FACE UPPER LINE START
MOV CX,605		;LINE START AT COLUMN=100 AND
MOV DX,132		;ROW = 50
E_F1:
MOV AH,0CH		;AH=0CH TO DRAW A LINE

INT 10H	
INC CX			;INCREASING HOIZONTAL POSITION
CMP CX,625		;DRAW UNTILL CX=250
JNZ E_F1
;FACE UPPER LINE END

;FACE RIGHT LINE START
MOV CX,625		;LINE START AT COLUMN=100 AND
MOV DX,132		;ROW = 50
E_F2:
MOV AH,0CH		;AH=0CH TO DRAW A LINE
INT 10H	
INC DX			;INCREASING HOIZONTAL POSITION
CMP DX,142		;DRAW UNTILL CX=250
JNZ E_F2
;FACE RIGHT LINE END

;FACE BOTTOM LINE START
MOV CX,625		;LINE START AT COLUMN=100 AND
MOV DX,142		;ROW = 50
E_F3:
MOV AH,0CH		;AH=0CH TO DRAW A LINE
INT 10H	
DEC CX			;INCREASING HOIZONTAL POSITION
CMP CX,605		;DRAW UNTILL CX=250
JNZ E_F3
;FACE BOTTOM LINE END

;FACE LEFT LINE START
MOV CX,605		;LINE START AT COLUMN=100 AND
MOV DX,142		;ROW = 50
E_F4:
MOV AH,0CH		;AH=0CH TO DRAW A LINE
INT 10H	
DEC DX			;INCREASING HOIZONTAL POSITION
CMP DX,132		;DRAW UNTILL CX=250
JNZ E_F4
;FACE LEFT LINE END

;LIPS
MOV CX,612		;LINE START AT COLUMN=100 AND
MOV DX,139		;ROW = 50
E_F5:
MOV AH,0CH		;AH=0CH TO DRAW A LINE
INT 10H	
INC CX			;INCREASING HOIZONTAL POSITION
CMP CX,618		;DRAW UNTILL CX=250
JNZ E_F5

;LEFT EYE
MOV CX,610		;LINE START AT COLUMN=100 AND
MOV DX,135		;ROW = 50
MOV AH,0CH		;AH=0CH TO DRAW A LINE
INT 10H	
;LEFT EYE END

;RIGHT EYE
MOV CX,620		;LINE START AT COLUMN=100 AND
MOV DX,135		;ROW = 50
MOV AH,0CH		;AH=0CH TO DRAW A LINE
INT 10H	
;RIGHT EYE END
;DRAW FACE END

;LEGS START
;LEFT LEG
MOV CX,615		;LINE START AT COLUMN=100 AND
MOV DX,157		;ROW = 50
E_L1:
MOV AH,0CH		;AH=0CH TO DRAW A LINE
INT 10H	
INC DX
DEC CX			;INCREASING HOIZONTAL POSITION
CMP CX,605		;DRAW UNTILL CX=250
JNZ E_L1
;LEFT LEG END

;RIGHT LEG
MOV CX,615		;LINE START AT COLUMN=100 AND
MOV DX,157		;ROW = 50
E_L2:
MOV AH,0CH		;AH=0CH TO DRAW A LINE
INT 10H	
INC DX
INC CX			;INCREASING HOIZONTAL POSITION
CMP CX,625		;DRAW UNTILL CX=250
JNZ E_L2
;RIGHT LEG END
;LEGS END


RET
DRAW_ENEMY_OBJECT ENDP
;-------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------
;--------------------------------------OBJECT ENEMY END HERE--------------------------------------------
;-------------------------------------------------------------------------------------------------
;-------------------------------------------------------------------------------------------------








END MAIN