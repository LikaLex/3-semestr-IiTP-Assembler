.model small
.stack 200h
.data
	a dw 9
	b dw 3
	c dw 2
	d dw 1
	result dw 0
	
.code
	
	EndPr proc
	mov ax,4c00h    
    int 21h 
	ret
	EndPr endp
	
	Main:
	mov ax, @data
	mov ds, ax
	
	mov cx, a 
	mov ax, b
	and cx,ax
	
	mov ax,c
	mul ax; 
	mul ax;
	
	cmp ax,cx
	je Result1
	
	mov cx,c 
	add cx,b 
	
	mov ax,a 
	mul ax
	mul a
	mov bx,ax
	
	mov ax,b 
	mul ax
	mul b 
	add ax,bx
	
	cmp cx,ax
	je Result2
	
	mov ax,c 
	shr ax,3
	
	call EndPr
	
	Result2: 
	
	mov ax,a 
	mov bx,b 
	add bx,c 
	xor ax,bx
	
	call EndPr
	
	Result1:
	
	mov ax,c 
	mov bx,d 
	div bx 
	mov bx,b 
	div bx 
	add ax,a 
	
	call EndPr
	
	
	end Main
