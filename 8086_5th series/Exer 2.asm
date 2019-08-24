;exercise 2

        ON_SCREEN macro screen    
        push ax             ;macro that prints each message    
        push dx             
        mov dx, offset screen
        mov ah, 9
        int 21h
        pop dx
        pop ax
        endm

        
begin:  mov dl,0       ;flag for success of failure
        ON_SCREEN first_number      ;ask for the first number
        ;first digit of the first number
        mov ah,1                    ;get the first number
        int 21h
                                      
        cmp al,48       ;check if our input is a valid digit
        jc fail1        ;ascii code between 48 and 58 (we include zero as first digit)
        cmp al,58       ;if it's true correct input else wrong 
        jnc  fail1      ;and print message
        jmp success1  
        
fail1:               
        mov dl,1
        
success1:
        sub al,30h
        mov bh,10
        mul bh
        mov bh,al  ;mul first digit x10 and store it in bh
        ;second digit of the first number
        mov ah, 1 
        int 21h 
        cmp al,48
        jc fail2
        cmp al,58
        jnc  fail2
        jmp success2
        
fail2:
        mov dl,1
        
success2: 
        sub al,30h
        add bh,al               ;add the second digit to bh now first number is ready in bh
        ON_SCREEN enter         ;print the \n       
        ON_SCREEN second_number ;ask for the second number
        ;first digit of the second number
        mov ah, 1           ; get the second number
        int 21h
                
        cmp al,48           ;check is our input is a valid digit
        jc fail3     ;ascii code between 48 and 58 (we include zero as first digit)
        cmp al,58           ;if it's true correct input else wrong
        jnc  fail3   ;and print message
        jmp success3                 
        
fail3:
        mov dl,1
        
success3:

        sub al,30h
        mov bl,10
        mul bl      ;mul first digit x10 and store it in bl
        mov bl,al
        ;second digit of the second number
        mov ah, 1 
        int 21h
        cmp al,48
        jc fail4
        cmp al,58
        jnc  fail4
        jmp success4 
        
fail4:
        mov dl,1 
        
success4:
        sub al,30h
        add bl,al   ;add the second digit to bl now second number is ready in bl
        
        ON_SCREEN enter                  ;print the \n
                                         ;first number in bh   
        ON_SCREEN printx                 ;second number in bl, print x value
      
        cmp dl,1            
        je fail5
        mov al,bh   ;put first number in al and print its decimal value
        call decprint
        jmp success5 
        
fail5:
        ON_SCREEN bar 
        
success5:
        
        
        ON_SCREEN printy                ;print y value
    
        cmp dl,1    ;check for any failure       
        je fail6 
        mov al,bl   ;put second number in al and print its decimal value
        call decprint
        jmp stand_by;success6
        
fail6:
        ON_SCREEN bar

stand_by:                   ;stand by for a user's enter       
        mov ah,00h
        int 16h 
        cmp al,0dh        
        jne stand_by

        cmp dl,1            ;check for valid inputs
        je invalid          ;if not print an appropriate message
                            
        ON_SCREEN enter            
          
        push bx
        mov bl,bh
        mov bh,0
        mov cx,bx
        pop bx
        push bx
        mov bh,0
        add cx,bx
        mov ax,cx
        pop bx
        
        ON_SCREEN plus  ;print x+y
  
        mov ax,cx           
        call hexprint   ;print the sum  in hex mode
        
        
        ON_SCREEN minus ;print x-y
        
             
        push bx                     ;check for negative or positive values
        mov bl,bh
        mov bh,0
        mov cx,bx
        pop bx
        mov bh,0
        sub cx,bx 
        mov ax,cx
        test ax,ax                  ;perform AND for double reg a with itself
        jns greater_than_zero       
        push ax                     ;to check if result of sub is < or > 0
        mov al, '-'                 ;if its not print minus
        mov ah,0eh      
        int 10h
        pop ax  
        neg ax
        
greater_than_zero: 
        cmp ax,0
        je zero              ;check if x-y equals to 0
        call hexprint        ;print x-y in hex mode
        jmp continue
        
zero:           
        mov al,'0'          ;print '0' if x-y equals to zero
        mov ah,0eh      
        int 10h   
        
continue:
        ON_SCREEN enter  
        jmp begin
         
        hlt

invalid: 
        ON_SCREEN wrong      ;invalid input
        jmp begin            ;restart again
                
                
        first_number db "first number:  $" 
        second_number db "second number:  $"
        enter db 0Dh,0Ah, "$"                  
        printx db "x=$"
        printy db "  y=$"
        plus db "x+y=$"
        minus db " x-y=$"
        wrong db 0Dh,0Ah,"Invalid Input",0Dh,0Ah,"$"
        bar db "-$"
        
          
              
        hexprint proc   
                       
        push dx         ;this procedure prints the desired result on screen in hex mode
        push cx         
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
        
        
        decprint proc   ;prints the result in decimal
        push dx         
        push cx         
        push ax         
        mov ah,0        
        mov dx,0        
        cmp al,0h
        je dec_finish
        mov cx,10
        div cx
        push dx
        call decprint
        pop dx
        mov al,dl
        cmp al,0ah
        jnc NaN
        add al,30h
        jmp dec_number
NaN:
        add al,37h
dec_number:
        mov ah,0eh      
        int 10h  
dec_finish:
        pop ax 
        pop cx
        pop dx
        ret 
              
        endp