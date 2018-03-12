use16
org 100h

    mov cx,print_str	    
    mov bx,print_endline
    

in_sword_lp1:
    mov di,string1
    call cx		    
    call input_sdec_word   
    call bx		   
    jnc cont1 
    mov di,error
    call cx		   
    jmp in_sword_lp1
    	 
cont1:
    mov [temp],ax
    xor ax,ax
    
in_sword_lp2:
    mov di,string2
    call cx		   
    call input_sdec_word   
    call bx		    
    jnc cont2
zero_error:	  
    mov di,error
    call cx		    
    jmp in_sword_lp2	 
cont2: 
    
    cmp ax,0
    je zero_error
    mov [temp1],ax
    mov ax,[temp]
    cwd
    idiv [temp1]  
    
    mov di,string3
    call cx		  
    call print_word_sdec   
    call bx			    

    mov di,pak
    call cx		    
    mov ah,8		    
    int 21h

    mov ax,4C00h	   
    int 21h		  	
;-------------------------------------------------------------------------------

input_sdec_word:
    push dx		   
    mov al,7		   
    call input_str	   
    call str_to_sdec_word   
    pop dx		    
    ret
;-------------------------------------------------------------------------------
    
str_to_sdec_word:
    push bx		   
    push dx

    test al,al		   
    jz stsdw_error	  
    mov bx,dx		    
    mov bl,[bx] 	   
    cmp bl,'-'		    
    jne stsdw_no_sign	   
    inc dx		  
    dec al		   
stsdw_no_sign:
    call str_to_udec_word   
    jc stsdw_exit	    
    cmp bl,'-'		   
    jne stsdw_plus	  
    cmp ax,32768	   
    ja stsdw_error	   
    neg ax		  
    jmp stsdw_ok	  
stsdw_plus:
    cmp ax,32767	  
    ja stsdw_error	    

stsdw_ok:
    clc 		   
    jmp stsdw_exit	   
stsdw_error:
    xor ax,ax		    
    stc 		   
stsdw_exit:
    pop dx		  
    pop bx
    ret
;-------------------------------------------------------------------------------

str_to_udec_word:
    push cx		   
    push dx
    push bx
    push si
    push di

    mov si,dx		   
    mov di,10
    mov ch,0		  
    mov cl,al 	   
    jcxz studw_error	  
    xor ax,ax		    
    xor bx,bx		    

studw_lp:
    mov bl,[si] 	 
    inc si		   
    cmp bl,'0'		  
    jl studw_error	  
    cmp bl,'9'		   
    jg studw_error	   
    sub bl,'0'		   
    mul di		    
    jc studw_error	   
    add ax,bx		   
    jc studw_error	   
    loop studw_lp	   
    jmp studw_exit	   

studw_error:
    xor ax,ax	
    stc 		   

studw_exit:
    pop di		 
    pop si
    pop bx
    pop dx
    pop cx
    ret
;--------------------------------------------------------------------------------

input_str:
    push cx		   
    mov cx,ax		 
    mov ah,0Ah		   
    mov [buffer],al	   
    mov byte[buffer+1],0   
    mov dx,buffer	  
    int 21h		    
    mov al,[buffer+1]	    
    add dx,2		  
    mov ah,ch		 
    pop cx		   
    ret

;-------------------------------------------------------------------------------

print_word_sdec:
    push di
    mov di,buffer	   
    push di		  
    call word_to_sdec_str   
    mov byte[di],'$'	   
    pop di		   
    call print_str	   
    pop di
    ret
;-------------------------------------------------------------------------------

word_to_sdec_str:
    push ax
    test ax,ax		   
    jns wtsds_no_sign	   
    mov byte[di],'-'	   
    inc di		   
    neg ax		  
wtsds_no_sign:
    call word_to_udec_str  
    pop ax
    ret
;----------------------------------------------------------------------------- 

print_word_udec:
    push di
    mov di,buffer	    
    push di		   
    call word_to_udec_str   
    mov byte[di],'$'	   
    pop di		    
    call print_str	    
    pop di
    ret
;----------------------------------------------------------------------------- 

word_to_udec_str:
    push ax
    push cx
    push dx
    push bx
    xor cx,cx		   
    mov bx,10		   

wtuds_lp1:		   
    xor dx,dx		  
    div bx		   
    add dl,'0'		   
    push dx		  
    inc cx		  
    test ax,ax		  
    jnz wtuds_lp1	   

wtuds_lp2:		
    pop dx		   
    mov [di],dl 	 
    inc di		   
    loop wtuds_lp2	   

    pop bx
    pop dx
    pop cx
    pop ax
    ret



;---------------------------------------------------------------------        
print_str:
    push ax
    mov ah,9		    
    xchg dx,di		   
    int 21h		   
    xchg dx,di		   
    pop ax
    ret
;-------------------------------------------------------------------------------

print_endline:
    push di
    mov di,endline	   
    call print_str	   
    pop di
    ret


string1  db 'dividend  : $' 
string2  db 'divider  : $'     
string3  db 'result  : $'
error    db 'ERROR!',13,10,'$'
pak	     db 'Press any key...$'
endline  db 13,10,'$'
buffer	 rb 9
temp     dw ? 
temp1 dw ?
