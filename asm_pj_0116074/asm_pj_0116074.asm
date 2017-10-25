
;========================================================
; Student Name:Yi Huei, Ho
; Student ID:0116074
; Email:ann09285734@gmail.com
;========================================================
; Instructor: Sai-Keung WONG
; Email: cswingo@cs.nctu.edu.tw
; Room: EC706
; Assembly Language 
;========================================================
; Description:
;
; IMPORTANT: always save EBX, EDI and ESI as their
; values are preserved by the callers in C calling convention.
;

INCLUDE Irvine32.inc
INCLUDE Macros.inc

invisibleObjX  TEXTEQU %(-100000)
invisibleObjY  TEXTEQU %(-100000)

MOVE_LEFT		= 0
MOVE_RIGHT		= 1
MOVE_UP			= 2
MOVE_DOWN		= 3
MOVE_LEFT_KEY	= 'a'
MOVE_RIGHT_KEY	= 'd'
MOVE_UP_KEY		= 'w'
MOVE_DOWN_KEY	= 's'
ESC_KEY			= 1Bh

; PROTO C is to make agreement on calling convention for INVOKE

c_updatePositionsOfAllObjects PROTO C

.data 

MY_INFO_AT_TOP_BAR	BYTE "My Student Name: Yi-Huei Ho , StudentID: 0116074",0 

MyMsg BYTE "Project Title: Final Project ",0dh, 0ah, 0
MyInfo BYTE "Student Name:Yi Huei, Ho",0dh, 0ah
		BYTE "Student ID:0116074",0dh, 0ah
		BYTE "Email:ann09285734@gmail.com",0dh, 0ah, 0

CaptionString	BYTE "Student Name:Yi-Huei Ho",0
MessageString	BYTE "Welcome to Wonderful World", 0dh, 0ah, 0dh, 0ah
				BYTE "My Student ID is 0116074", 0dh, 0ah, 0dh, 0ah
				BYTE "My Email is: ann09285734@gmail.com.", 0dh, 0ah, 0dh, 0ah
				BYTE "Key Usage Instruction", 0dh, 0ah, 0dh, 0ah
				BYTE "'i': toggle to show or hide the student ID", 0dh, 0ah, 0dh, 0ah
				BYTE "Manipulate student ID:'a':left; 'd':right; 'w':up; 's':down", 0dh, 0ah, 0dh, 0ah
				BYTE "'g': change the current image to a gray level image", 0dh, 0ah, 0dh, 0ah
				BYTE "'m': exchange the red component and the green component of each pixel of the background image", 0dh, 0ah, 0dh, 0ah
				BYTE "'r': restore the current image back to its initial state", 0dh, 0ah, 0dh, 0ah
				BYTE "'p': toggle the game mode state. If in game mode, show the grid", 0dh, 0ah, 0dh, 0ah
				BYTE "'o': in game mode. Randomly shuffle the subimages of the grid cells.", 0dh, 0ah, 0dh, 0ah
				BYTE "mouse:exchange two rows", 0dh, 0ah, 0dh, 0ah
				BYTE "ESC: quit the program", 0dh, 0ah, 0dh, 0ah, 0


CaptionString_EndingMessage BYTE "Student Name:Yi-Huei Ho",0
MessageString_EndingMessage BYTE "My Student ID is 0116074", 0dh, 0ah, 0dh, 0ah
							BYTE "My Email is: ann09285734@gmail.com.", 0dh, 0ah, 0dh, 0ah, 0
							
windowWidth		DWORD 8000
windowHeight	DWORD 8000

scaleFactor	DWORD	128
canvasMinX	DWORD -4000
canvasMaxX	DWORD 4000
canvasMinY	DWORD -4000
canvasMaxY	DWORD 4000
;
particleRangeMinX REAL8 0.0
particleRangeMaxX REAL8 0.0
particleRangeMinY REAL8 0.0
particleRangeMaxY REAL8 0.0
;
particleSize DWORD  2
numParticles DWORD 20000
particleMaxSpeed DWORD 3

moveDirection	DWORD	1

flgQuit		DWORD	0
maxNumObjects	DWORD 1024
numObjects	DWORD	1024
objPosX		SDWORD	1024 DUP(invisibleObjX)
objPosY		SDWORD	1024 DUP(invisibleObjY)
objTypes	BYTE	1024 DUP(1)
objSpeedX	SDWORD	1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
			SDWORD	1024 DUP(?)
objSpeedY	SDWORD	2, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20
			SDWORD	1024 DUP(?)			
objColor	DWORD	1024*3 DUP(255)

spacewidth	DWORD	2000
digitspace	DWORD	2000

IDPosX		DWORD ?
IDPosY		DWORD ?
flgID		BYTE	0
spherecount DWORD 0
DIGIT_MO_0		BYTE 0, 0, 1, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0dh
				BYTE 0, 0, 0, 0ffh
DIGIT_MO_SIZE = ($-DIGIT_MO_0)				

DIGIT_0			BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 1, 1, 0ffh

DIGIT_1			BYTE 0, 1, 0, 0dh
				BYTE 1, 1, 0, 0dh
				BYTE 0, 1, 0, 0dh
				BYTE 0, 1, 0, 0dh
				BYTE 1, 1, 1, 0ffh

DIGIT_2			BYTE 0, 1, 0, 0dh
				BYTE 1, 1, 0, 0dh
				BYTE 0, 1, 0, 0dh
				BYTE 0, 1, 0, 0dh
				BYTE 1, 1, 1, 0ffh

DIGIT_3			BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 0, 0dh
				BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 1, 1, 0ffh

DIGIT_4			BYTE 1, 1, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 1, 1, 0ffh

DIGIT_5			BYTE 1, 1, 1, 0dh
				BYTE 0, 0, 1, 0dh
				BYTE 0, 1, 0, 0dh
				BYTE 0, 1, 0, 0dh
				BYTE 0, 1, 0, 0ffh

DIGIT_6			BYTE 1, 0, 1, 0dh
				BYTE 1, 0, 1, 0dh
				BYTE 1, 1, 1, 0dh
				BYTE 0, 0, 1, 0dh
				BYTE 0, 0, 1, 0ffh


offsetImage DWORD 0

openingMsg	BYTE	"This program shows the student ID using bitmap and manipulates images....", 0dh
			BYTE	"Great programming.", 0
movementDIR	BYTE 0
state		BYTE	0

imagePercentage DWORD	0

mImageStatus DWORD 0
mImagePtr0 BYTE 200000 DUP(?)
mImagePtr00 BYTE 200000 DUP(?)
mImagePtr0p BYTE 200000 DUP(?)
mImagePtr1 BYTE 200000 DUP(?)
mImagePtr11 BYTE 200000 DUP(?)
mImagePtr_g BYTE 200000 DUP(?)
mImagePtr_tmp BYTE 200000 DUP(?)


mTmpBuffer	BYTE	200000 DUP(?)
mImageWidth DWORD 0
mImageHeight DWORD 0
mBytesPerPixel DWORD 0
mImagePixelPointSize DWORD 6

gridWidth	DWORD 0
gridHeight	DWORD 0
flgGame	DWORD 0
Pcount	DWORD 0
GridColorRed	BYTE 0
GridColorGreen	BYTE 0
GridColorBlue	BYTE 0
cellindex DWORD 0
RandomGrid	DWORD 0
Click	DWORD 0
Selected1	DWORD 0
Selected2	DWORD 0
mouseX DWORD 0
mouseY DWORD 0

.code

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_ClearScreen()
;
;Clear the screen.
;We can set text color if you want.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ClearScreen PROC C
	mov al, 0
	mov ah, 0
	call SetTextColor
	call clrscr
	ret
asm_ClearScreen ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_ShowTitle()
;
;Show the title of the program
;at the beginning.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ShowTitle PROC C USES edx
	mov dx, 0
	call GotoXY
	xor eax, eax
	mov ah, 0h
	mov al, 0e1h
	call SetTextColor
	mov edx, offset MyMsg
	call WriteString
	ret
asm_ShowTitle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_InitializeApp()
;
;This function is called
;at the beginning of the program.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_InitializeApp PROC C USES ebx edi esi edx
	call AskForInput_Initialization
	call initGame
	ret
asm_InitializeApp ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_EndingMessage()
;
;This function is called
;when the program exits.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_EndingMessage PROC C USES ebx edx
	mov ebx, OFFSET CaptionString_EndingMessage
	mov edx, OFFSET MessageString_EndingMessage
	call MsgBox
	ret
asm_EndingMessage ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_updateSimulationNow()
;
;Update the simulation.
;For examples,
;we can update the positions of the objects.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_updateSimulationNow PROC C USES edi esi ebx
	;
	call updateGame
	call updateImage
	;call showID
	;
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;DO NOT REMOVE THIS THE FOLLOWING LINE
	call c_updatePositionsOfAllObjects 
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	ret
asm_updateSimulationNow ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void setCursor(int x, int y)
;
;Set the position of the cursor 
;in the console (text) window.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
setCursor PROC C USES edx,
	x:DWORD, y:DWORD
	mov edx, y
	shl edx, 8
	xor edx, x
	call Gotoxy
	ret
setCursor ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetNumParticles PROC C
	mov eax, 10000
	ret
asm_GetNumParticles ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetParticleMaxSpeed PROC C
	mov eax, particleMaxSpeed
	ret
asm_GetParticleMaxSpeed ENDP

;int asm_GetParticleSize()
;
;Return the particle size.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetParticleSize PROC C
	;modify this procedure
	mov eax, 1
	ret
asm_GetParticleSize ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_handleMousePassiveEvent( int x, int y )
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_handleMousePassiveEvent PROC C USES eax ebx edx,
	x : DWORD, y : DWORD
	mov eax, x
	mov mouseX, eax
	mWrite "x:"
	call WriteDec
	mWriteln " "
	mov eax, y
	mov mouseY, eax
	mWrite "y:"
	call WriteDec
	mWriteln " "
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	
	ret
asm_handleMousePassiveEvent ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_handleMouseEvent(int button, int status, int x, int y)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_handleMouseEvent PROC C USES ebx edx,
	button : DWORD, status : DWORD, x : DWORD, y : DWORD
	
	mWriteln "asm_handleMouseEvent"
	mov eax, button
	mWrite "button:"
	call WriteDec
	mWriteln " "
	mov eax, status
	mWrite "status:"
	call WriteDec
	mov eax, x
	mWriteln " "
	mWrite "x:"
	call WriteDec
	mWriteln " "
	mov eax, y
	mWrite "y:"
	call WriteDec
	mWriteln " "
	mov eax, windowWidth
	mWrite "windowWidth:"
	call WriteDec
	mWriteln " "
	mov eax, windowHeight
	mWrite "windowHeight:"
	call WriteDec
	mWriteln " "
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	cmp status, 0
	jne exit0
	inc click
	cmp y, 103
	jb cell1
	cmp y, 203
	jb cell2
	cmp y, 303
	jb cell3
	cmp y, 403
	jb cell4
	cmp y, 503
	jb cell5
	cmp y, 603
	jb cell6
	cmp y, 703
	jb cell7
	cmp y, 799
	jb cell8
	jmp exit0
cell1:
	mov edx, 0
	jmp conti
cell2:
	mov edx, 1
	jmp conti
cell3:
	mov edx, 2
	jmp conti
cell4:
	mov edx, 3
	jmp conti
cell5:
	mov edx, 4
	jmp conti
cell6:
	mov edx, 5
	jmp conti
cell7:
	mov edx, 6
	jmp conti
cell8:
	mov edx, 7
conti:
	cmp click, 1
	jne conti2
	mov selected1, edx
	jmp exit0
conti2:
	cmp click, 2
	jne exit0
	mov selected2, edx
	jmp exit0

exit0:
	ret
asm_handleMouseEvent ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_HandleKey(int key)
;
;Handle key events.
;Return 1 if the key has been handled.
;Return 0, otherwise.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_HandleKey PROC C, 
	key : DWORD
	mov eax, key
	call WriteInt
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	cmp eax, MOVE_LEFT_KEY
	jne L1
	mov moveDirection, MOVE_LEFT
	jmp exit0
L1:
	cmp eax, MOVE_RIGHT_KEY
	jne L2
	mov moveDirection, MOVE_RIGHT
L2:
	cmp eax, MOVE_UP_KEY
	jne L3
	mov moveDirection, MOVE_UP
L3:
	cmp eax, MOVE_DOWN_KEY
	jne L4
	mov moveDirection, MOVE_DOWN
L4:
	cmp eax, 'i'
	jne L5
	cmp flgID, 1
	je notzero
	mov flgID, 1
	call showID
	jmp exit0
notzero:
	mov flgID, 0
	call hideID
	jmp exit0
	cmp eax, ESC_KEY
	jne exit0
L5:
	cmp eax, 'I'
	jne L6
	cmp flgID, 1
	call hideID
	je notzero1
	mov flgID, 1
	call showID
	jmp exit0
notzero1:
	mov flgID, 0
	jmp exit0
L6:
	cmp eax, '7'
	jne L7
	call OrangeColor
L7:
	cmp eax, '8'
	jne L8
	call WhiteColor
L8:
	cmp eax, '9'
	jne L9
	call BlueColor
L9:
	cmp eax, 'g'
	jne L10
	call ImageGray
L10:
	cmp eax, 'm'
	jne L11
	call RedtoGreen
L11:
	cmp eax, 'r'
	jne L12
	call restore
L12:
	cmp eax, '1'
	jne L13
	mov mImagePixelPointSize, 1
L13:
	cmp eax, '2'
	jne L14
	mov mImagePixelPointSize, 2
L14:
	cmp eax, '3'
	jne L15
	mov mImagePixelPointSize, 3
L15:
	cmp eax, '4'
	jne L16
	mov mImagePixelPointSize, 4
L16:
	cmp eax, '5'
	jne L17
	mov mImagePixelPointSize, 5
L17:
	cmp eax, 'p'
	jne L18
	cmp flgGame, 0
	jne notzero2
	mov flgGame, 1
	inc Pcount
	call Grid
	jmp exit0
notzero2:
	mov flgGame, 0
	call Grid
	jmp exit0
L18:
	cmp eax, 'o'
	jne L19
	cmp flgGame, 1
	jne exit0
	call randomCell
	jmp exit0
L19:
	cmp eax, ESC_KEY
	jne exit0
	call asm_EndingMessage
	INVOKE ExitProcess,0
exit0:
	mov eax, 0
	ret
asm_HandleKey ENDP

Grid PROC USES esi edi ebx edx eax ecx
	cmp flgGame, 1
	jne noGrid
	mov eax, mImageHeight
	sub eax, 9
	cdq
	mov ebx, 8
	idiv ebx
	mov edx, eax
	mov gridHeight, edx
	;mov ebx, mImageWidth
	;imul eax, ebx
	;imul eax, 3
	mov eax, mImageWidth
	sub eax, 2
	imul eax, 3

	mov ecx, 9
	mov esi, OFFSET mImagePtr0
row:
	push ecx
	mov	ecx, mImageWidth
	imul ecx, 2
L0:
	mov SDWORD PTR [esi], 255
	mov SDWORD PTR [esi+1], 255
	mov SDWORD PTR [esi+2], 255
	add esi, 3
	
	loop L0
	pop ecx
	
	push ecx
	mov ecx, edx
L1:
	mov SDWORD PTR [esi], 255
	mov SDWORD PTR [esi+1], 255
	mov SDWORD PTR [esi+2], 255
	add esi, 3
	add esi, eax
	mov SDWORD PTR [esi], 255
	mov SDWORD PTR [esi+1], 255
	mov SDWORD PTR [esi+2], 255
	add esi, 3
	loop L1
	pop ecx
	loop row
	cmp Pcount, 1
	jne exit0
	mov esi, offset mImagePtr0
	mov edi, offset mImagePtr_g
	mov eax, mImageWidth
	mul mImageHeight
	mul mbytesPerPixel
	mov ecx, eax
	cld
	rep movsb
	mov Pcount, 0
	jmp exit0
nogrid:
	mov esi, offset mImagePtr00
	mov edi, offset mImagePtr0
	mov eax, mImageWidth
	mul mImageHeight
	mul mbytesPerPixel
	mov ecx, eax
	cld
	rep movsb
exit0:	
	ret
Grid ENDP


ImageGray PROC USES esi edi ebx edx
	mov esi, OFFSET mImagePtr0
	mov eax, mImagewidth
	mul mImageheight
	;mul mbytesPerPixel
	mov ecx, eax
L0:
	mov al, [esi]
	movzx bx, al
	mov al, [esi+1]
	movzx dx, al
	mov al, [esi+2]
	movzx ax, al
	add ax, bx
	add ax, dx
	mov bl, 3
	div bl
	mov [esi], al
	mov [esi+1], al
	mov [esi+2], al
	add esi, 3
	loop L0

	mov esi, OFFSET mImagePtr1
	mov eax, mImagewidth
	mul mImageheight
	;mul mbytesPerPixel
	mov ecx, eax
L1:
	mov al, [esi]
	movzx bx, al
	mov al, [esi+1]
	movzx dx, al
	mov al, [esi+2]
	movzx ax, al
	add ax, bx
	add ax, dx
	mov bl, 3
	div bl
	mov [esi], al
	mov [esi+1], al
	mov [esi+2], al
	add esi, 3
	loop L1
	ret
ImageGray ENDP

RedtoGreen PROC USES esi edi ebx ecx edx
	mov esi, OFFSET mImagePtr0
	mov eax, mImagewidth
	mul mImageheight
	;mul mbytesPerPixel
	mov ecx, eax
L0:
	mov al, [esi]
	mov bl, [esi+1]
	mov [esi], bl
	mov [esi+1], al
	add esi, 3
	loop L0

	mov esi, OFFSET mImagePtr1
	mov eax, mImagewidth
	mul mImageheight
	;mul mbytesPerPixel
	mov ecx, eax
L1:
	mov al, [esi]
	mov bl, [esi+1]
	mov [esi], bl
	mov [esi+1], al
	add esi, 3
	loop L1
	ret
RedtoGreen ENDP

Restore PROC USES esi edi ebx ecx edx
	cmp flgGame, 1
	je ingame
	mov esi, OFFSET mImagePtr00
	mov edi, OFFSET mImagePtr0
	mov eax, mImagewidth
	mul mImageheight
	mul mbytesPerPixel
	mov ecx, eax
	cld
	rep movsb
	jmp exit0
ingame:
	mov esi, OFFSET mImagePtr_g
	mov edi, OFFSET mImagePtr0
	mov eax, mImagewidth
	mul mImageheight
	mul mbytesPerPixel
	mov ecx, eax
	cld
	rep movsb
exit0:
	ret
Restore ENDP

OrangeColor PROC USES esi edi ebx edx
	mov esi, OFFSET objColor
	mov ecx, spherecount
L0:
	mov SDWORD PTR [esi], 255
	mov SDWORD PTR [esi+4], 166
	mov SDWORD PTR [esi+8], 0
	add esi, 12
	loop L0

	ret
OrangeColor ENDP

WhiteColor PROC USES esi edi ebx edx
	mov esi, OFFSET objColor
	mov ecx, spherecount
L0:
	mov SDWORD PTR [esi], 255
	mov SDWORD PTR [esi+4], 255
	mov SDWORD PTR [esi+8], 255
	add esi, 12
	loop L0
	ret
WhiteColor ENDP

BlueColor PROC USES esi edi ebx edx
	mov esi, OFFSET objColor
	mov ecx, spherecount
L0:
	mov SDWORD PTR [esi], 0
	mov SDWORD PTR [esi+4], 0
	mov SDWORD PTR [esi+8], 255
	add esi, 12
	loop L0
	ret
BlueColor ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_SetWindowDimension(int w, int h, int scaledWidth, int scaledHeight)
;
;w: window resolution (i.e. number of pixels) along the x-axis.
;h: window resolution (i.e. number of pixels) along the y-axis. 
;scaledWidth : scaled up width
;scaledHeight : scaled up height

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_SetWindowDimension PROC C USES ebx,
	w: DWORD, h: DWORD, scaledWidth : DWORD, scaledHeight : DWORD
	mov ebx, offset windowWidth
	mov eax, w
	mov [ebx], eax
	mov eax, scaledWidth
	shr eax, 1	; divide by 2, i.e. eax = eax/2
	mov ebx, offset canvasMaxX
	mov [ebx], eax
	neg eax
	mov ebx, offset canvasMinX
	mov [ebx], eax
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, offset windowHeight
	mov eax, h
	mov [ebx], eax
	mov eax, scaledHeight
	shr eax, 1	; divide by 2, i.e. eax = eax/2
	mov ebx, offset canvasMaxY
	mov [ebx], eax
	neg eax
	mov ebx, offset canvasMinY
	mov [ebx], eax
	;
	finit
	fild canvasMinX
	fstp particleRangeMinX
	;
	finit
	fild canvasMaxX
	fstp particleRangeMaxX
	;
	finit
	fild canvasMinY
	fstp particleRangeMinY
	;
	finit
	fild canvasMaxY
	fstp particleRangeMaxY	
	;
	call asm_RefreshWindowSize
	ret
asm_SetWindowDimension ENDP	
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_GetNumOfObjects()
;
;Return the number of objects
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetNumOfObjects PROC C
	mov eax, numObjects
	ret
asm_GetNumOfObjects ENDP	

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_GetObjectType(int objID)
;
;Return the object type
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetObjectType		PROC C USES ebx edx,
	objID: DWORD
	push ebx
	push edx
	xor eax, eax
	mov edx, offset objTypes
	mov ebx, objID
	mov al, [edx + ebx]
	pop edx
	pop ebx
	ret
asm_GetObjectType		ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_GetObjectColor (int &r, int &g, int &b, int objID)
;Input: objID, the ID of the object
;
;Return the color three color components
;red, green and blue.
;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetObjectColor  PROC C USES ebx edi esi,
	r: PTR DWORD, g: PTR DWORD, b: PTR DWORD, objID: DWORD
	mov ebx, objID
	imul ebx,12
	mov edi, r
	mov esi, DWORD PTR [objColor+ebx]
	mov DWORD PTR [edi], esi
	;
	mov edi, g
	mov esi, DWORD PTR [objColor+ebx+4]
	mov DWORD PTR [edi], esi
	;
	mov edi, b
	mov esi, DWORD PTR [objColor+ebx+8]
	mov DWORD PTR [edi], esi
	ret
asm_GetObjectColor ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_ComputeRotationAngle(a, b)
;return an angle*10.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputeRotationAngle PROC C USES ebx,
	a: DWORD, b: DWORD
	mov ebx, b
	shl ebx, 1
	mov eax, a
	add eax, 10
	ret
asm_ComputeRotationAngle ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_ComputeObjPositionX(int x, int objID)
;
;Return the x-coordinate in eax.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputeObjPositionX PROC C USES edi esi,
	x: DWORD, objID: DWORD
	;modify this procedure
	mov ebx, objID
	imul ebx,4 
	mov esi, offset objPosX
	mov eax, SDWORD PTR [esi+ebx]
	ret
asm_ComputeObjPositionX ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;int asm_ComputeObjPositionY(int y, int objID)
;
;Return the y-coordinate in eax.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_ComputeObjPositionY PROC C USES ebx esi edx,
	y: DWORD, objID: DWORD
	;modify this procedure
	mov ebx, objID
	imul ebx,4 
	mov esi, offset objPosY
	mov eax, SDWORD PTR [esi+ebx]
	ret
asm_ComputeObjPositionY ENDP


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; The input image's information:
; imageIndex : the index of an image, starting from 0
; imagePtr : the starting address of the image, i.e., the address of the first byte of the image
; (w, h) defines the dimension of the image.
; w: width
; h: height
; Thus, the image has w times h pixels.
; bytesPerPixel : the number of bytes used to represent one pixel
;
; Purpose of this procedure:
; Copy the image to our own database
;
asm_SetImage PROC C USES esi edi ebx,
imageIndex : DWORD,
imagePtr : PTR BYTE, w : DWORD, h : DWORD, bytesPerPixel : DWORD
	mov eax,w
	mov mImageWidth, eax
	mov eax, h
	mov mImageHeight, eax
	mov eax, bytesPerPixel
	mov mbytesPerPixel,eax

	mov esi, imagePtr
	mov edi, offset mImagePtr0
	cmp imageindex, 0
	je L0
	mov edi, offset mImagePtr1
L0:
	mov eax, w
	mul h
	mul bytesPerPixel
	mov ecx, eax
	cld
	rep movsb
	
	mov esi, imagePtr
	mov edi, offset mImagePtr00
	cmp imageindex, 0
	je L1
	mov edi, offset mImagePtr11
L1:
	mov eax, w
	mul h
	mul bytesPerPixel
	mov ecx, eax
	cld
	rep movsb

	ret
asm_SetImage ENDP

asm_GetImagePixelSize PROC C
mov eax, mImagePixelPointSize
ret
asm_GetImagePixelSize ENDP

asm_GetImageStatus PROC C
mov eax, 1
ret
asm_GetImageStatus ENDP

asm_getImagePercentage PROC C
mov eax, imagePercentage
ret
asm_getImagePercentage ENDP

;
;asm_GetImageColour(int imageIndex, int ix, int iy, int &r, int &g, int &b)
;
asm_GetImageColour PROC C USES ebx esi, 
imageIndex : DWORD,
ix: DWORD, iy : DWORD,
r: PTR DWORD, g: PTR DWORD, b: PTR DWORD
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov eax, imageIndex
	mov	ecx, ix
	mov edx, iy
	cmp eax, 0
	jne L1
L0:
	mov esi, OFFSET mImagePtr0
	jmp	L2
L1:
	mov esi, OFFSET mImagePtr1
L2:
	call getAImgPointOffset
	add esi, eax
	mov al, [esi]	
	mov ebx, r
	mov BYTE PTR [ebx], al
	mov al, [esi+1]	
	mov ebx, g
	mov BYTE PTR [ebx], al
	mov al, [esi+2]	
	mov ebx, b
	mov BYTE PTR [ebx], al
exit0:
	ret
asm_GetImageColour ENDP

getAImgPointOffset PROC USES ebx
	mov eax, mImageWidth
	mov ebx, mImageHeight
	sub ebx, edx
	dec	ebx
	mul ebx
	add eax, ecx
	mov ebx, mBytesPerPixel
	mul ebx
	;eax = ( ImgW * iy + ix ) * 3
	ret
getAImgPointOffset ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;const char *asm_getStudentInfoString()
;
;return pointer in edx
asm_getStudentInfoString PROC C
	mov eax, offset MY_INFO_AT_TOP_BAR
	ret
asm_getStudentInfoString ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;
; Return the particle system state in eax
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
asm_GetParticleSystemState PROC C
	mov eax, 1
	ret
asm_GetParticleSystemState ENDP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;void asm_GetImageDimension(int &iw, int &ih)
asm_GetImageDimension PROC C USES ebx,
iw : PTR DWORD, ih : PTR DWORD
	mov ebx, iw
	mov eax, mImageWidth
	mov [ebx], eax
	mov ebx, ih
	mov eax, mImageHeight
	mov [ebx], eax
	ret
asm_GetImageDimension ENDP
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;
; Compute a position to place an image.
; This position defines the lower left corner
; of the image.
;
asm_GetImagePos PROC C USES ebx,
	x : PTR DWORD,
	y : PTR DWORD
	mov eax, canvasMinX
	mov ebx, scaleFactor
	cdq
	idiv ebx
	mov ebx, x
	mov [ebx], eax
;
	mov eax, canvasMinY
	mov ebx, scaleFactor
	cdq
	idiv ebx
	mov ebx, y
	mov [ebx], eax
	ret
asm_GetImagePos ENDP

AskForInput_Initialization PROC USES ebx edi esi
	mov edx, offset MyInfo
	call WriteString
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	mov ebx, OFFSET CaptionString
	mov edx, OFFSET MessageString
	call MsgBox
	ret
AskForInput_Initialization ENDP

asm_RefreshWindowSize PROC
	ret
asm_RefreshWindowSize ENDP

initGame PROC
	;mov objPosX[0], 2000
	;mov objPosY[0], 2000
	mov spherecount, 100
	call hideID
	
	ret
initGame ENDP

updateGame PROC USES esi edi
	mov eax, moveDirection
	cmp eax, MOVE_LEFT
	jne right
	mov ecx, spherecount
	mov esi, 0
L0:
	sub objPosX[esi], 200
	add esi, 4
	loop L0
	mov eax, canvasMinX
	cmp objPosX[0], eax
	jne Lexit
	mov moveDirection, MOVE_RIGHT
	jmp Lexit
	
right:
	cmp eax, MOVE_RIGHT
	jne up
	mov ecx, spherecount
	mov esi, 0
L1:
	add objPosX[esi], 200
	add esi, 4
	loop L1
	mov eax, canvasMaxX
	mov edi, spherecount
	dec edi
	cmp objPosX[edi*4], eax
	jne Lexit
	mov moveDirection, MOVE_LEFT
	jmp Lexit
up:
	cmp eax, MOVE_UP
	jne down
	mov ecx, spherecount
	mov esi, 0
L2:
	add objPosY[esi], 200
	add esi, 4
	loop L2
	mov eax, canvasMaxY
	mov edi,0
	cmp objPosY[edi], eax
	jne Lexit
	mov moveDirection, MOVE_DOWN
	jmp Lexit
down:
	cmp  eax, MOVE_DOWN
	jne Lexit
	mov esi, 0
	mov ecx, spherecount
L3:
	sub objPosY[esi], 200
	add esi, 4
	loop L3
	mov eax, canvasMinY
	mov edi, spherecount
	dec edi
	cmp objPosY[edi*4], eax
	jne Lexit
	mov moveDirection, MOVE_UP
	jmp Lexit
Lexit:
	
	ret
updateGame ENDP

updateImage PROC USES esi edi ebx ecx edx
	mov eax, mImageWidth
	mov ebx, gridHeight
	add ebx, 2
	mul ebx
	imul eax, 3
	mov cellindex, eax

	cmp flgGame, 1
	jne exit0
	call grid
	mov esi, OFFSET mImagePtr0
	cmp mouseY, 103
	jb cell1
	cmp mouseY, 203
	jb cell2
	cmp mouseY, 303
	jb cell3
	cmp mouseY, 403
	jb cell4
	cmp mouseY, 503
	jb cell5
	cmp mouseY, 603
	jb cell6
	cmp mouseY, 703
	jb cell7
	cmp mouseY, 799
	jb cell8
	jmp exit0 

cell1:
	jmp L0
cell2:
	mov eax, cellindex
	add esi, eax
	jmp L0
cell3:
	mov eax, cellindex
	imul eax, 2
	add esi, eax
	jmp L0
cell4:
	mov eax, cellindex
	imul eax, 3
	add esi, eax
	jmp L0
cell5:
	mov eax, cellindex
	imul eax, 4
	add esi, eax
	jmp L0
cell6:
	mov eax, cellindex
	imul eax, 5
	add esi, eax
	jmp L0
cell7:
	mov eax, cellindex
	imul eax, 6
	add esi, eax
	jmp L0
cell8:
	mov eax, cellindex
	imul eax, 7
	add esi, eax
L0:
	mov eax, 256
	call RandomRange
	mov GridColorRed, al
	mov eax, 256
	call RandomRange
	mov GridColorGreen, al
	mov eax, 256
	call RandomRange
	mov GridColorBlue, al

	mov	ecx, mImageWidth
	imul ecx, 2
L1:
	mov al, GridColorRed
	mov [esi], al
	mov al, GridColorGreen
	mov [esi+1], al
	mov al, GridColorBlue
	mov [esi+2], al
	add esi, 3
	loop L1
	sub esi, 3

	mov ecx, GridHeight
	add ecx, 2
L2:
	mov eax, mImageWidth
	imul eax, 3
	add esi, eax

	mov al, GridColorRed
	mov [esi], al
	mov al, GridColorGreen
	mov [esi+1], al
	mov al, GridColorBlue
	mov [esi+2], al
	loop L2

	mov	ecx, mImageWidth
	imul ecx, 2
L3:
	mov al, GridColorRed
	mov [esi], al
	mov al, GridColorGreen
	mov [esi+1], al
	mov al, GridColorBlue
	mov [esi+2], al
	sub esi, 3
	loop L3
	add esi, 3

	mov ecx, GridHeight
	add ecx, 2
L4:
	mov eax, mImageWidth
	imul eax, 3
	sub esi, eax
	mov al, GridColorRed
	mov [esi], al
	mov al, GridColorGreen
	mov [esi+1], al
	mov al, GridColorBlue
	mov [esi+2], al
	
	loop L4
exit0:
	cmp click, 0
	je exit2
	cmp click, 1
	je hightlight
	cmp click, 2
	je shiftcell
hightlight:
	mov esi, OFFSET mImagePtr0
	mov eax, cellIndex
	mul selected1
	add esi, eax
	
	mov	ecx, mImageWidth
	imul ecx, 2
L5:
	mov al, GridColorRed
	mov [esi], al
	mov al, GridColorGreen
	mov [esi+1], al
	mov al, GridColorBlue
	mov [esi+2], al
	add esi, 3
	loop L5
	sub esi, 3

	mov ecx, GridHeight
	add ecx, 2
L6:
	mov eax, mImageWidth
	imul eax, 3
	add esi, eax

	mov al, GridColorRed
	mov [esi], al
	mov al, GridColorGreen
	mov [esi+1], al
	mov al, GridColorBlue
	mov [esi+2], al
	loop L6

	mov	ecx, mImageWidth
	imul ecx, 2
L7:
	mov al, GridColorRed
	mov [esi], al
	mov al, GridColorGreen
	mov [esi+1], al
	mov al, GridColorBlue
	mov [esi+2], al
	sub esi, 3
	loop L7
	add esi, 3

	mov ecx, GridHeight
	add ecx, 2
L8:
	mov eax, mImageWidth
	imul eax, 3
	sub esi, eax
	mov al, GridColorRed
	mov [esi], al
	mov al, GridColorGreen
	mov [esi+1], al
	mov al, GridColorBlue
	mov [esi+2], al
	
	loop L8
	jmp exit2
shiftcell:
	mov esi, OFFSET mImagePtr0
	mov edi, OFFSET mImagePtr_tmp
	mov eax, cellIndex
	mul selected1
	add esi, eax 
	mov ecx, cellindex
	cld
	rep movsb 

	mov esi, OFFSET mImagePtr0
	mov edi, OFFSET mImagePtr0
	mov eax, cellIndex
	mul selected2
	add esi, eax
	mov eax, cellIndex
	mul selected1
	add edi, eax
	mov ecx, cellindex
	cld
	rep movsb 

	mov esi, OFFSET mImagePtr_tmp
	mov edi, OFFSET mImagePtr0
	mov eax, cellIndex
	mul selected2
	add edi, eax
	mov ecx, cellindex
	cld
	rep movsb 
	mov click, 0
exit2:
	ret
updateImage ENDP

randomCell PROC USES esi edi ebx ecx edx
	mov eax, mImageWidth
	mov ebx, gridHeight
	add ebx, 2
	mul ebx
	imul eax, 3
	mov cellindex, eax
;;;;;;;;;;;;;;;;;;;;random1
	mov esi, OFFSET mImagePtr0
	mov edi, OFFSET mImagePtr_tmp
	mov eax, 7
	call randomRange
	add eax, 1
	mov RandomGrid, eax
	mul cellindex
	add esi, eax 
	mov ecx, cellindex
	cld
	rep movsb 

	mov esi, OFFSET mImagePtr0
	mov edi, OFFSET mImagePtr0
	mov eax, RandomGrid
	mul cellindex
	add edi, eax
	mov ecx, cellindex
	cld
	rep movsb 

	mov esi, OFFSET mImagePtr_tmp
	mov edi, OFFSET mImagePtr0
	mov ecx, cellindex
	cld
	rep movsb 
;;;;;;;;;;;;;;;;;;;;random2
	mov esi, OFFSET mImagePtr0
	mov edi, OFFSET mImagePtr_tmp
	mov eax, 6
	call randomRange
	add eax, 2
	mov RandomGrid, eax
	mul cellindex
	add esi, eax 
	mov ecx, cellindex
	cld
	rep movsb 

	mov esi, OFFSET mImagePtr0
	mov eax, cellindex
	add esi, eax

	mov edi, OFFSET mImagePtr0
	mov eax, RandomGrid
	mul cellindex
	add edi, eax
	mov ecx, cellindex
	cld
	rep movsb 

	mov esi, OFFSET mImagePtr_tmp
	mov edi, OFFSET mImagePtr0
	mov eax, cellindex
	add edi, eax
	mov ecx, cellindex
	cld
	rep movsb 

;;;;;;;;;;;;;;;;;;;;random3
	mov esi, OFFSET mImagePtr0
	mov edi, OFFSET mImagePtr_tmp
	mov eax, 5
	call randomRange
	add eax, 3
	mov RandomGrid, eax
	mul cellindex
	add esi, eax 
	mov ecx, cellindex
	cld
	rep movsb 

	mov esi, OFFSET mImagePtr0
	mov eax, cellindex
	imul eax, 2
	add esi, eax

	mov edi, OFFSET mImagePtr0
	mov eax, RandomGrid
	mul cellindex
	add edi, eax
	mov ecx, cellindex
	cld
	rep movsb 

	mov esi, OFFSET mImagePtr_tmp
	mov edi, OFFSET mImagePtr0
	mov eax, cellindex
	imul eax, 2
	add edi, eax
	mov ecx, cellindex
	cld
	rep movsb 

;;;;;;;;;;;;;;;;;;;;random4
	mov esi, OFFSET mImagePtr0
	mov edi, OFFSET mImagePtr_tmp
	mov eax, 4
	call randomRange
	add eax, 4
	mov RandomGrid, eax
	mul cellindex
	add esi, eax 
	mov ecx, cellindex
	cld
	rep movsb 

	mov esi, OFFSET mImagePtr0
	mov eax, cellindex
	imul eax, 3
	add esi, eax

	mov edi, OFFSET mImagePtr0
	mov eax, RandomGrid
	mul cellindex
	add edi, eax
	mov ecx, cellindex
	cld
	rep movsb 

	mov esi, OFFSET mImagePtr_tmp
	mov edi, OFFSET mImagePtr0
	mov eax, cellindex
	imul eax, 3
	add edi, eax
	mov ecx, cellindex
	cld
	rep movsb
;;;;;;;;;;;;;;;;;;;;random5
	mov esi, OFFSET mImagePtr0
	mov edi, OFFSET mImagePtr_tmp
	mov eax, 3
	call randomRange
	add eax, 5
	mov RandomGrid, eax
	mul cellindex
	add esi, eax 
	mov ecx, cellindex
	cld
	rep movsb 

	mov esi, OFFSET mImagePtr0
	mov eax, cellindex
	imul eax, 4
	add esi, eax

	mov edi, OFFSET mImagePtr0
	mov eax, RandomGrid
	mul cellindex
	add edi, eax
	mov ecx, cellindex
	cld
	rep movsb 

	mov esi, OFFSET mImagePtr_tmp
	mov edi, OFFSET mImagePtr0
	mov eax, cellindex
	imul eax, 4
	add edi, eax
	mov ecx, cellindex
	cld
	rep movsb

;;;;;;;;;;;;;;;;;;;;random6
	mov esi, OFFSET mImagePtr0
	mov edi, OFFSET mImagePtr_tmp
	mov eax, 2
	call randomRange
	add eax, 6
	mov RandomGrid, eax
	mul cellindex
	add esi, eax 
	mov ecx, cellindex
	cld
	rep movsb 

	mov esi, OFFSET mImagePtr0
	mov eax, cellindex
	imul eax, 5
	add esi, eax

	mov edi, OFFSET mImagePtr0
	mov eax, RandomGrid
	mul cellindex
	add edi, eax
	mov ecx, cellindex
	cld
	rep movsb 

	mov esi, OFFSET mImagePtr_tmp
	mov edi, OFFSET mImagePtr0
	mov eax, cellindex
	imul eax, 5
	add edi, eax
	mov ecx, cellindex
	cld
	rep movsb

;;;;;;;;;;;;;;;;;;;;random7
	mov esi, OFFSET mImagePtr0
	mov edi, OFFSET mImagePtr_tmp
	mov eax, 1
	call randomRange
	add eax, 7
	mov RandomGrid, eax
	mul cellindex
	add esi, eax 
	mov ecx, cellindex
	cld
	rep movsb 

	mov esi, OFFSET mImagePtr0
	mov eax, cellindex
	imul eax, 6
	add esi, eax

	mov edi, OFFSET mImagePtr0
	mov eax, RandomGrid
	mul cellindex
	add edi, eax
	mov ecx, cellindex
	cld
	rep movsb 

	mov esi, OFFSET mImagePtr_tmp
	mov edi, OFFSET mImagePtr0
	mov eax, cellindex
	imul eax, 6
	add edi, eax
	mov ecx, cellindex
	cld
	rep movsb
	ret
randomCell ENDP

showID PROC USES esi edi ebx
	mov spherecount, 0
	mov IDposX, -30000
	mov IDposY, 4000
	mov esi, OFFSET DIGIT_0
	
	mov edi, OFFSET objPosX
	mov ebx, OFFSET objPosY
	mov ecx, 7
start:
	mov al, [esi]
	cmp al, 0dh
	je nextrow
	cmp al, 0ffh
	je nextdigit
	cmp al, 0
	je conti
	mov eax, IDposX
	mov SDWORD PTR [edi], eax
	mov eax, IDposY
	mov SDWORD PTR [ebx], eax
	add edi, 4
	add ebx, 4
	inc spherecount
conti:
	mov eax, spacewidth
	add IDposX, eax
	inc esi
	jmp start
nextrow:
	mov eax, spacewidth
	imul eax, 3
	sub IDposX, eax
	mov eax, spacewidth
	sub IDposY, eax
	inc esi
	jmp start
nextdigit:
	dec ecx
	cmp ecx, 0
	je exit0
	mov eax, digitspace
	add IDposX, eax
	mov eax, spacewidth
	imul eax, 4
	add IDposY, eax
	inc esi
	jmp start
exit0:
	ret
showID ENDP

hideID PROC USES esi edi ebx
	mov ecx, spherecount
	mov esi, OFFSET objPosX
	mov edi, OFFSET objPosY
L0:
	mov SDWORD PTR [esi], invisibleObjX
	mov SDWORD PTR [edi], invisibleObjY
	add esi, 4
	add edi, 4
	loop L0
	ret
hideID ENDP

END
