; Program:     Random_Color_Char_Screen_Fill (Chapter 11, Pr 4, Modified)
; Description: Display random characters in random colors on 50x20 console
;				50% red, 25% green, 25% yellow
; Student:     Gabriel Warkentin
; Date:        05/12/2020
; Class:       CSCI 241
; Instructor:  Mr. Ding

INCLUDE Irvine32.inc

linelen = 50
rowlen = 20

.data
saveflags		DWORD ?
bufColor		WORD  linelen DUP(0)
bufChar			BYTE  linelen DUP(0)
cellsWritten	DWORD ?
outHandle		DWORD ?
MAXCOL			DWORD linelen - 1
xyPos			COORD <0,0>
ogColor			DWORD  0

.code
;-----------------------------------------------------------------------
ChooseColor PROC
; Selects a color with 50% probability of red, 25% green and 25% yellow
; Receives: nothing
; Returns:  AX = randomly selected color
	mov eax, 4
	call RandomRange
; yellow
	cmp eax, 0
	jnz Lgreen
	mov eax, yellow
	jmp Lret
Lgreen:
	cmp eax, 1
	jne Lred
	mov eax, green
	jmp Lret
Lred:
	mov eax, red
Lret:
	ret
ChooseColor ENDP

;-----------------------------------------------------------------------
ChooseCharacter PROC
; Randomly selects an ASCII character, from ASCII code 20h to 07Ah
; Receives: nothing
; Returns:  AL = randomly selected character
	mov eax, 07Ah - 020h
	call RandomRange
	add eax, 20h
	ret
ChooseCharacter ENDP


mainColor PROC
	call GetTextColor
	mov ogColor, eax
	mov eax, black+(white*16)
	call SetTextColor
	call Clrscr

	INVOKE GetStdHandle, STD_OUTPUT_HANDLE
	mov outHandle, eax

	mov ecx, rowlen
Lrows:
	push ecx
	mov ecx, linelen
	mov edx, 0				; indexed to only use 1 reg
Lcolumns:
	call ChooseColor
	mov bufColor[edx*2], ax
	call ChooseCharacter
	mov bufChar[edx], al
	inc edx
	dec ecx
	jnz Lcolumns

	INVOKE WriteConsoleOutputAttribute, outHandle, ADDR bufColor, MAXCOL, xyPos, ADDR cellsWritten
	INVOKE WriteConsoleOutputCharacter, outHandle, ADDR bufChar, MAXCOL, xyPos, ADDR cellsWritten
	
	inc xyPos.y

	pop ecx
	dec ecx
	jnz Lrows

	mov dx, 0
	mov dh, rowlen+2
	call Gotoxy
	call WaitMsg

	mov eax, ogColor
	call SetTextColor

	exit
mainColor ENDP

END ;mainColor