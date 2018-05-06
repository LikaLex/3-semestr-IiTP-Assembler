org 100h
 
jmp start:

start:

   call scanfSize 
   mov matrixSize,ax  
   call newline 
   call inputMatrix      
   call newline
   call outputMatrix
   call newline
   call calcMatrix
   
   ret       
   
   calcMatrix PROC
   call newline
   cmp matrixSize,1
   je finalOne  
   cmp matrixSize,2
   je finalTwo
   cmp matrixSize,3
   je finalThree
   
   finalOne:         
   mov ax,matrix[0][0]
   call printf  
   jmp final2 
   
   string_one db ' Error $'  
   err:
   xor ax,ax
	lea dx, string_one                     
	mov ah, 09h	                           
	int 21h  
	ret
	
	 
        
   
   finalTwo:
   mov ax, matrix[0][0]
   mul matrix[8][2]
   mov cx,ax
   mov ax,matrix[0][2]
   mul matrix[8][0]
   mov dx,ax
   mov ax,cx
   sub ax,dx       
   cmp ax, 0  
   jmp beglo
   jl isNegative     
   jmp cont2 
   
   isNegative:  
   push ax
   mov al,'-'
   mov ah, 0eh
   int 10h
   pop ax  
   neg ax
   beglo:
       mov  bx,-32700   
        cmp ax, bx 
        jl err
   cont2:
   call printf 
   jmp final2
   
   finalThree:
   mov ax, matrix[0][0]
   imul matrix[8][2]
   imul matrix[16][4]
   mov cx,ax
   mov ax,matrix[0][2]
   imul matrix[8][4]
   imul matrix[16][0]
   add ax,cx
   mov cx,ax           
   mov ax,matrix[0][4]
   imul matrix[8][0]
   imul matrix[16][2]
   add ax,cx
   mov cx,ax
   mov ax,matrix[0][4]
   imul matrix[8][2]
   imul matrix[16][0]
   mov bx,ax
   mov ax,cx
   sub ax,bx
   mov cx,ax
   mov ax,matrix[0][0]
   imul matrix[8][4]
   imul matrix[16][2]
   mov bx,ax
   mov ax,cx
   sub ax,bx
   mov cx,ax
   mov ax,matrix[0][2]
   imul matrix[8][0]
   imul matrix[16][4]
   mov bx,ax
   mov ax,cx
   sub ax,bx 
   call printf
   jmp final2
   
   jmp final2
   
   final2:
   
   ret
   calcMatrix ENDP      
   
   inputMatrix PROC
     
   matrixinput: 
   xor ax,ax
   mov si,0
   mov bx,0
   mov cx,matrixSize         
   
   external:
   push cx
   mov cx, matrixSize
   mov si,0
   iternal:
   call newline
   call scanf
   mov matrix[bx][si],ax  
   add si, size_elem
   loop iternal
   next:
   pop cx      
   add bx,8
   
   loop external     
   ret
   inputMatrix ENDP  
   
   outputMatrix PROC   
    
   matrixoutput: 
   xor ax,ax
   mov si,0
   mov bx,0
   mov cx,matrixSize         
   
   externaloutput:
   push cx
   mov cx, matrixSize
   mov si,0         
   call newline
   iternaloutput:
   mov ax, matrix[bx][si]
   call printf
   add si, size_elem 
   loop iternaloutput
   nextoutput:
   pop cx   
   add bx,8
   loop externaloutput     
   ret
   outputMatrix ENDP
    
   scanfSize PROC
   
   digit1:
   mov ah,00h    ; vvod simvola v al
   int 16h
   
   mov ah, 0eh   ; vivod simvola iz al
   int 10h 
   
   jmp check
   
   check:
   cmp al,'1' 
   jae check2
   jmp deletedigit1
   
   check2:
   cmp al, '3'
   jbe calcdigit1
   jmp deletedigit1
   
   calcdigit1:
   push ax
   mov ax,cx
   mul cs:ten
   mov cx,ax 
   pop ax 
   
   sub al,'0'           ;convert iz ascii
   
   mov ah,0
   add cx,ax  
   jmp final
    
   deletedigit1:      
   mov al, 8
   mov ah, 0eh
   int 10h  
   mov al, ' '
   mov ah, 0eh
   int 10h
   mov al, 8
   mov ah, 0eh
   int 10h    
   jmp digit1
   
   final:
    
   ret        
         
             
         
   scanf proc near      
    
      push bx
    push cx
    push dx
   
    xor bx,bx 
    xor ax,ax
    xor dx,dx
    xor cx,cx
  
  beg0:
    
    mov dl,8
    mov ah, 02h
    int 21h 
        
    mov dl,0
    mov ah, 02h
    int 21h 
        
    mov dl,8
    mov ah, 02h
    int 21h
    
    mov ah, 08h
    int 21h
    
    cmp al, 45
    jnz lb
    
    minout:
    mov dl,45
    mov ah,02h
    int 21h
    
    begn:
    
    cmp bx,3276
        jb menn
        jz rawn
        ja finn
        
        
    menn:
        mov ah, 08h
        int 21h
       
        cmp al,13
        jz finn 
        
        cmp al,8
        jz back 
        
        cmp al,27
        jz esc
       
        cmp al,'0'
        jb begn 
        ;<0
       
        cmp al,'9'
        ja begn 
        ;>9
       
        mov dl, al
        mov ah, 02h
        int 21h
       
        sub dl,'0'
        mov cl,dl
        mov ax,bx
        mul ten
        mov bx,ax
        add bx,cx
        jmp begn
        
     rawn:
        mov ah, 08h
        int 21h
        
        cmp al,13
        jz fin
        
        cmp al,'0'
        jb rawn 
        ;<0
        
        cmp al,'8'
        ja rawn 
        ;>6
        
        mov dl, al
        mov ah, 02h
        int 21h
        
        sub dl,'0'
        mov cl,dl
        mov ax,bx
        mul ten
        mov bx,ax
        add bx,cx
        jmp finn
    
    beg:
        cmp bx,3276
        jb men
        jz raw
        ja fin
        
        
    men:
        mov ah, 08h
        int 21h
    lb:   
        cmp al,13
        jz fin 
        
        cmp al,8
        jz back 
        
        cmp al,27
        jz esc
       
        cmp al,'0'
        jb beg 
        ;<0
       
        cmp al,'9'
        ja beg 
        ;>9
       
        mov dl, al
        mov ah, 02h
        int 21h
       
        sub dl,'0'
        mov cl,dl
        mov ax,bx
        mul ten
        mov bx,ax
        add bx,cx
        jmp beg
        
     raw:
        mov ah, 08h
        int 21h
        
        cmp al,13
        jz fin
        
        cmp al,'0'
        jb raw 
        ;<0
        
        cmp al,'7'
        ja raw 
        ;>7
        
        mov dl, al
        mov ah, 02h
        int 21h
        
        sub dl,'0'
        mov cl,dl
        mov ax,bx
        mul ten
        mov bx,ax
        add bx,cx
        jmp fin
        
        
     finn:
        neg bx
                
     fin:
        lea dx, ent
        mov ah,09h
        int 21h
        mov ax, bx 
        pop dx
        pop cx
        pop bx
      
     ret
     
     back:
        mov dl,8
        mov ah, 02h
        int 21h 
        
        mov dl,0
        mov ah, 02h
        int 21h 
        
        mov dl,8
        mov ah, 02h
        int 21h
        
        mov ax, bx
        xor dx, dx
        div ten
        mov bx,ax
        cmp bx,0
        jz beg0
        jmp beg
        
    backn:
        mov dl,8
        mov ah, 02h
        int 21h 
        
        mov dl,0
        mov ah, 02h
        int 21h 
        
        mov dl,8
        mov ah, 02h
        int 21h
        
        mov ax, bx
        xor dx, dx
        div ten
        mov bx,ax
        cmp bx,0
        jz beg0
        jmp begn     
        
    esc:
        cmp bx,0
        mov dl,8
        mov ah, 02h
        int 21h 
        
        mov dl,0
        mov ah, 02h
        int 21h 
        
        mov dl,8
        mov ah, 02h
        int 21h
        
        jz beg0
        
        mov dl,8
        mov ah, 02h
        int 21h 
        
        mov dl,0
        mov ah, 02h
        int 21h 
        
        mov dl,8
        mov ah, 02h
        int 21h
        
        mov ax, bx
        xor dx, dx
        div ten
        mov bx,ax
        cmp bx,0
        
        ja esc
        
        mov dl,8
        mov ah, 02h
        int 21h 
        
        mov dl,0
        mov ah, 02h
        int 21h 
        
        mov dl,8
        mov ah, 02h
        int 21h
        jmp beg0

   ret
   
scanf ENDP

printf  PROC
    
   push ax
    push bx
    push cx
    push dx

    xor cx,cx
    test ax,1000000000000000b
    jz positiv
    jnz negativ
    
    positiv:
    
    del1:
        
        mov bx, 10
        xor dx,dx
        div bx
        add dl,'0'
        push dx
        inc cx
        test ax,ax              
        jnz del1

        xor dl,dl

    vv1:
        xor dx,dx
        pop dx
        mov ah,02h
        int 21h
        loop vv1
        jmp fino
        
    negativ:
        neg ax
        
     del2:   
        mov bx, 10
        xor dx,dx
        div bx
        add dl,'0'
        push dx
        inc cx
        test ax,ax              
        jnz del2

        xor dl,dl
        
        mov dl,'-'
        mov ah,02h
        int 21h
        
    vv2:
        xor dx,dx
        pop dx
        mov ah,02h
        int 21h
        loop vv2
    
    fino:
    pop dx
    pop cx
    pop bx
    pop ax

    ret

        
printf   ENDP
    

   newline PROC
    push ax
    push dx
    mov dx,13
    mov ah,02h
    int 21h  
    mov dx,10
    mov ah,2
    int 21h
    pop dx
    pop ax
          
    ret   
    
ent db 10,13,'$'
overflowcheck dw 6553  
two dw 2
ten dw 10 
zero dw 0
size_elem dw 2
fnMSG db "Enter matrix size: $" 
matrixSize dw 0   
matrix dw 3 dup (3 dup(?))

ret




