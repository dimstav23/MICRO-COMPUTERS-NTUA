        ;askhsh4 

        PRINT macro message    
        push ax                 ;macro that prints a message    
        push dx                 ;on screen
        mov dx, offset message  ;for the messages we need to print 
        mov ah, 9
        int 21h
        pop dx
        pop ax
        endm
        
        
begin:  mov cl,20
        mov dl,20
        mov bx,0800h  
read:                       ;read alla the valid input 0-9 a-z
        call read_char      ;and store them through bx 
        mov [bx],al         ;in memory
        inc bx
        loop read
          
        PRINT newline
        mov cl,dl
        mov bx,0800h
               
write:                      ;print the numbers as they are
        mov al,[bx]         ;and change letters to 
        inc bl              ;capital letters from 
        cmp al,97           ;small
        jc arithmos
        cmp al,123
        jnc arithmos
        sub al,32
arithmos:
        mov ah,0eh      
        int 10h  
        loop write
        
        PRINT newline
        jmp begin
end_program:
        hlt               

        newline db 0Dh,0Ah, "$" ;messages
                  
        
        
        erase_char proc     ;this routine erases the last printed
        push ax             ;character
        mov ah,0eh
        mov al,8           
        int 10h
        mov al,32           
        int 10h
        mov al,8           
        int 10h
        pop ax 
        ret 
        
        
                  
        read_char proc       ;reads one character as input
read_again:                  ;and stores it if it's ok (a-z)(0-9) 
        mov ah, 1            ;if it's not reads again .
        int 21h
        cmp al,61            ;if input is "=" 61 in ascii table end program
        je end_program 
        cmp al,13            ;if input is ENTER (ascii code 13) we stop reading 
        jne wait_enter       ;by making cl=1 and store the number of the characters
        mov dl,20            ;we have read in dl through substraction 
        sub dl,cl            ;so we can print them
        mov cl,1 
        cmp dl,0             ;check if enter pressed with no valid characters pressed
        jne wait_for_correct_input      ;to restart
        PRINT newline
        jmp begin
wait_for_correct_input:       
        jmp correct
wait_enter:
        cmp al,48
        jc wrong                   ;we check if the input is wrong 
        cmp al,58                  ;for the numbers
        jnc check_if_wrong_input
        jmp correct
check_if_wrong_input:
        cmp al,97
        jc wrong                   ;and for the letters
        cmp al,123
        jnc wrong
        jmp correct
wrong:
        call erase_char     ;erase the invalid character
        jmp read_again
correct:
        ret
                      
        endp