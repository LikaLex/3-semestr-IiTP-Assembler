    .model tiny
     
    .code
    org 100h
    start:
            jmp install
    hook:
			pushf
			
			cmp ah,0AFh
			jne lb9
			mov ax,64D9h
			popf
			iret
	lb9:
	
            cmp ah, 4fh     
            jne jmp_old
            
			push cx
			push es
			xor cx, cx
			mov es, cx
			test byte ptr es:417h, 00000010b
			jz lb6
			inc cx
	lb6:
			test byte ptr es:417h, 00000001b
			jz lb7
			inc cx
	lb7:
			test byte ptr es:417h, 01000000b
			jz lb8
			inc cx
	lb8:
			cmp cx,1
			je shift_or_caps
	
			and byte ptr es:417h, 10111100b
			cmp al,1eh
			jne lb1
			mov al,02h
	lb1:
			cmp al,30h
			jne lb2
			mov al,03h
	lb2:
			cmp al,2eh
			jne lb3
			mov al,04h
	lb3:
			cmp al,20h
			jne lb4
			mov al,05h
	lb4:
			cmp al,12h
			jne lb5
			mov al,06h
	lb5:
	shift_or_caps:
			pop es
			pop cx
			popf 
			
    jmp_old:                 
            db      0eah           
    to_ofs  dw      ?    
    to_seg  dw      ?
     
     
    install:
			mov al,'-'
			mov cx,80
			mov di,80h
			repne scasb 
			je found
			failed:
			mov ah,0AFh                  
			int 15h
			cmp ax,64D9h
			jne lb10
			
			mov ah,9
			mov dx,offset mes2
			int 21h
	
			mov ah, 4ch
			int 21h	
	lb10:
			mov ah,9
			mov	dx,offset mes1
			int 21h
            mov ax, 3515h       
            int 21h
            mov [to_seg], es
            mov [to_ofs], bx
            push cs
            pop ds
            mov dx, offset hook
            mov ax, 2515h
            int 21h            
     
        
            mov dx,offset install
			int 27h
	found:
			mov al,'r'
			scasb
			jne err_mes
			mov ah,0AFh                   
			int 15h
			cmp ax,64D9h
			jne err_mes
			mov ax, 3515h   
            int 21h
			push ds
			mov dx, es:[to_ofs]
			push es:[to_seg]
			pop ds 
			mov ax, 2515h
			int 21h
			pop ds
			mov ah,9
			mov	dx,offset mes5
			int 21h
			mov ah, 4ch
			int 21h	
	err_mes:
			mov ah,9
			mov	dx,offset mes4
			int 21h
			mov ah, 4ch
			int 21h	
	mes1 db 'handler is installed',13,10,'$'
	mes2 db 'handler has already been installed',13,10,'$' 
	mes3 db 'handler is deleted',13,10,'$'
	mes4 db 'error',13,10,'$'
	mes5 db 'deleted',13,10,'$'
    end start