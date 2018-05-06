use16                                                                     
org 100h
 
        call input_strok 
        mov cx,ax 
        add cx,1         
        xchg di,dx ; obmen znachenii mezdu operandami
        ;in di  - strokovii adres 
        ;cx - chislo povtorenii scasb
        mov si,di;si  - the longest stroka    
        
    cycl: 
        mov bl,cl
        mov al,' '
        repne scasb  ; skanirovanie stroki dlia sravneniia (poka CX ne 0)
        je found
    failed:   
        mov di,si
        call print_enter                    
        call print_strok
        mov ax,4C00h	   
        int 21h	
    found:
        dec di  
        mov al,'$' 
        stosb
        sub bl,cl 
        cmp [maxtemp],bl
        jl remember 
        jmp cycl
        
    remember: 
        mov si,di
        sub si,bx
        mov [maxtemp],bl
        jmp cycl
print_enter:
    push ax 
    push dx  
    mov dx,endline
    mov ah,09h
    int 21h 
    pop dx
    pop ax
    ret
print_strok:
    push ax 
    xchg di,dx
    mov ah,09h
    int 21h 
    xchg di,dx
    pop ax
    ret
input_strok:   	   
    mov ah,0Ah
    mov al,254		   
    mov [string],al	    
    mov byte[string+1],0    
    mov dx,string	   
    int 21h
    mov ah,0		   
    mov al,[string+1] 
    inc al    ;uvelichit soderzimoe registra na 1
    xchg ax,bx   ; obmen znachenii mezdu operandami
    mov [string+bx+2],' ' 
    ;mov [string+bx+2],'$'
    xchg ax,bx
    add dx,2	   
    ret       

maxtemp db 0       
string rb 257 
endline db 10,13,'$' 
