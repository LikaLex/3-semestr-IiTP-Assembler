.model   small
.stack   200h
.data
	axproc dw 200
	string_one db ' 1-st number: $'	
	string_two db ' 2-nd number: $'
	string_res db ' result: $'
	string_esc db 10, 13,'again:' , '$'
	string_bsp db 10, 13, '$'
	inone dw 0
	intwo dw 0
	ten dw 10
	limit dw 65535
.code
start:
	mov ax, @data	
	mov ds, ax

	

	lea dx,string_one
	mov ah,09h	; output line (stroki)
	int 21h
	
	call inproc
	mov inone,ax ;enter our number in  inone
	
		

	lea dx,string_two
	mov ah,09h	;  output line (stroki)
	int 21h

	call inproc
	mov intwo,ax		; enter our number in  intwo
	
		

	lea dx,string_res
	mov ah,09h	; output line (stroki)
	int 21h

	
	xor ax, ax; reset(obnulenie) the registers
	
	xor cx, cx
	xor dx, dx

	mov ax, inone ; divide the entered numbers
	mov cx, intwo
	div cx

	
	call outproc	; output of result


mov ah,4ch   ;function 4Ch: program termination
int 21h

outproc proc
	push cx		;save registers

	push dx
	push bx
	push ax

	mov bx, ten	
    xor cx,cx ;  do cx = 0
    for1:
        xor dx, dx 	;do dx=0
        div bx	
        push dx	; we transfer the remainder(ostatoc) to the stack
        inc cx	;   increase the counter
        test ax,ax	;if the value is not zero, then we start the output 
        jnz for1

        mov ah, 02h	;function for output
        for2:
            pop dx	;take the number from the stack
            add dl, 30h	;convert it to symbols
            int 21h	
            loop for2	

	pop ax		;   renew registers
	pop bx
	pop dx
	pop cx

		
ret
outproc endp


inproc proc

	push bx		; save registers
	push cx
	push dx
	push di		; save ukasatel di
	xor di,di 	; set di = 0
	

startin:
	
	xor dx, dx
	xor ax, ax
	
	mov ah,08h	;reads a sumbol from the user
	int 21h

	xor ah,ah
	cmp al,13 	; al stores the last character 13 - press enter
	jz saving	; if pressed enter then save to register
	cmp al,8 	;8 - backspace
	jz delete	;if 8 - delete last symbol
	cmp al,27 	; 27 - esc 
	jz delall	; delete all symbols


	;check for validity characters from 0 to 9		
	cmp al, '9'
	ja startin	
	cmp al, '0'
	jb startin	

	
	mov ah,02h 	; display
	mov dl,al	; dl stores symbol for output
	int 21h

	xor ah,ah
	sub ax, 30h	;  translate the symbol into a chislo
	push ax		; save chislo

	mov ax, di	; we transfer to ax the last value
	mov bx, ten	; value *10
	mul bx
	jc delall	;if the overflow then delete the number (as esc)
	
	pop di
	add ax, di	;add to our number, multiplied by 10, the current figure from di
	jc delall; if overflow removes the number
	
	mov di,ax	; save into di
	jmp startin	; then add the number


delall:
	xor ax,ax	;clean ax
	xor di,di	; clean di
	
	lea dx,string_esc
	mov ah,09h	;  output stroki
	int 21h
	jmp startin	; start input one more time

delete: ;  when you press backspace


	
	lea dx,string_bsp
	mov ah,09h	;output stroki
	int 21h
	xor dx, dx
	mov ax, di
	mov bx, ten
	div bx
	
	call outproc
	mov di, ax
	xor dx,dx
	
	jmp startin
saving:
	lea dx,string_bsp
	mov ah,09h	
	int 21h

	mov ax,di	; enter a number in ax

	pop di		;  return registers
	pop dx
	pop cx
	pop bx
ret
inproc endp

end start