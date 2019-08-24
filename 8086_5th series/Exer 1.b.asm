;exercise 1.b  


ADDRN = 0800h          ;some random numbers
N = 8  
                       
        mov bx,ADDRN 
        
        
set_values:            ;we set our values in memory so as to check if our program works properly 
        mov [bx],50    ;even
        mov [bx+1],47  ;odd
        mov [bx+2],27  ;odd
        mov [bx+3],80  ;even
        mov [bx+4],96  ;even
        mov [bx+5],137 ;odd
        mov [bx+6],84  ;even
        mov [bx+7],7   ;odd  
         
                                     
        mov cl,N       ;cl=8
        mov ch,0       ;ch=0
        mov dl,0ffh    ;max possible value since it is composed by 8 bits
        mov dh,0h      ;min possilbe value since it is composed by 8 bits
        
checkloop:              
        mov al,[bx]     ;load starting address and 
                        ;check if a value is greater than max or lower than min
        inc bx          ;point to the next memory address
        cmp al, dl
        jc min          ;if we find new min store it in dl
min_max:
        cmp al, dh
        jnc max         ;if we find new max store is in dh
        jmp end
min: 
        mov dl,al
        jmp min_max 
max:
        mov dh,al
end:
        loop checkloop
        
        mov ah,0        ;ah=0
        mov al,dh       ;al=maxvalue 
        call hexprint   ;print max on screen
        mov al,' '      ;al=' '
        mov ah,0eh      ;ah=0eh
        int 10h         ;print the space that is required
        mov ah,0h       ;ah=0
        mov al,dl       ;al=minvalue
        call hexprint   ;print min on screen
        hlt     
         
         
        hexprint proc   
                        
        push dx         ;this procedure prints the desired result on screen
        push cx         ;which is in the double reg a
        mov dx,0        
        cmp ax,0h
        je finish
        mov cx,10h
        div cx          
        push dx
        call hexprint   ;recursion
        pop dx
        mov ax,dx
        cmp ax,0ah
        jnc letter
        add ax,30h      ;add 30h to print the number
        jmp number
letter:
        add ax,37h      ;add 37h to print the letter
number:
        mov ah,0eh      
        int 10h          ;print
finish: 
        pop cx
        pop dx
        ret
          
        endp            ;it correctly print 89h=137dec and 7h=7dec with a space between them
