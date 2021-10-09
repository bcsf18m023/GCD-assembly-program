.model small
.stack 100h
.data
inputMsg1 db "Enter First number: $"
inputMsg2 db "Enter Second number: $"
inputAgain db "Input again : $"
outputMsg db "GCD : $"
val dw 0				;store input number
num1 dw 0				; first number
num2 dw 0				; second number
count db 0				; store the no of digits
temp dw 0				; temp value
newLine db 13,10,'$'	; new line string
invalidFlag db 0
.code

; main proc
main proc
	mov ax,@data
	mov ds,ax
	
	mov ah,09h
	mov dx,offset inputMsg1				;display input 1 msg
	int 21h
	
	call inputNumber				;take input from user
	
	mov ax,val
	mov num1,ax

	mov ah,09h
	mov dx,offset inputMsg2				;display input 2 msg
	int 21h
	
	call inputNumber				;take input from user
	
	mov ax,val
	mov num2,ax
	
	mov ah,09h
	mov dx,offset outputMsg				;display Gcd : 
	int 21h
	
	call findGCD						;find gcd
	call outputNumber					; display result
	

	mov ah,4ch
	int 21h
main endp

; this proc will take input from user and store answer in val
inputNumber proc

repeatInput:	
	mov invalidFlag,0
	mov val,0
startInput:
	mov ah,01h
	int 21h
	cmp al,0dh
	JE endInput
	sub al,30h
	mov ch,0
	mov cl,al
	mov ax,val
	mov bx,10
	cmp cx,10
	JAE invalidInputCase
	mul bx
	add ax,cx
	mov val,ax
	JMP startInput
invalidInputCase:
	push ax
	push bx
	push cx
	push dx
	call printNewLine
	mov ah,09h
	mov dx,offset inputAgain
	int 21h
	jmp repeatInput
	
endInput:
ret
inputNumber endp

;this proc will display the number stored in val
outputNumber proc
	
	mov ax,val
	mov bl,10
pushCode:
	div bl
	mov dl,ah
	mov ah,0
	push dx
	inc count
	cmp ax,0
	JE endPush
	JMP pushCode
endPush:
	mov bl,1
startPop:
	cmp bl,count	
	JA endPop
	pop dx
	inc bl
	add dl,30h
	mov ah,02h
	int 21h
	JMP startPop
endPop:
ret
outputNumber endp

printNewLine proc
	mov ah,09h
	mov dx,offset newLine
	int 21h
ret
printNewLine endp

;this proc will find the gcd
findGCD proc

	mov ax,num1
	mov bx,num2
label1:
	mov dx,0
	push ax
	push bx
	mov cx,bx
	div cx
	pop bx
	pop ax
	mov ax,bx
	mov bx,dx
	cmp bx,0
	JA label1
	mov val,ax
ret
findGCD endp 
	
end main