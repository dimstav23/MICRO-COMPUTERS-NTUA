        ;askhsh 3 

        PRINT macro message    
        push ax                 ;macro for the messages message     
        push dx                 ;START (..): ..
        mov dx, offset message  ;errors  etc
                                                
        mov ah, 9
        int 21h
        pop dx
        pop ax
        endm
        

        
        PRINT startornot
begin_decision:
        mov ah, 1            ;get Y(y) to begin the execution of the program
        int 21h              ;or N(n) to hlt and below are the
                             ;management of each input hlt or continue
        cmp al,78            ;N
        je end_of_execution 
        cmp al,110           ;n
        je end_of_execution
        cmp al,89            ;Y
        je start 
        cmp al,121           ;y
        je start
        call erase_char
        jmp begin_decision
        
                             ;every time we need to print on the screen
                             ;we call the proper print procedure
                             ;eg. for hex numbers in our example
                             ;or for characters like -
                             ;the same thing if we want to read
                             ;from user as in start   
start:
        PRINT newline
restart:
        mov ch,0 
        mov dx,0
        PRINT input 
        call read_hex       ;we want 3 hexadecimal digits so we call
        mov bl,al           ;read_hex 3 times
        call read_hex
        mov bh,al       
        call read_hex
        mov cl,al
          
        mov dh,bl           ;here we put the contents from bx(bh,bl) 
        mov ax,10h          ;and cl to dx as one hex number
        mul bh
        add dx,ax
        add dx,cx           ;dx=x
        
        cmp dx,0BB8h
        jnc check1
        mov ax,5            
        mul dx              ;y (Temperature) is y=5/3*x from 0(0h) to 3(BB8h) Volts
        mov bx,3           
        div bx              ;ax=y 
        jmp tupwse
check1:
        mov ax,5            
        mul dx              ;y (Temperature) is y=5*x-10000 from 3 to 4 Volts (BB8h-FA0h)
        sub ax,10000        ;ax=y
tupwse:
        cmp ax,270Fh        ;check if the temperature reaches 999.9
                            ;999.9d=270Fh
        jnc lathos
        PRINT newline       ;print integral part
        mov bx,10
        mov dx,0            ;check for possible jumps
        div bx
        cmp ax,0
        je check2                              
        call print_ax_dex
        jmp dekadiko
check2:
        mov ah,0eh
        mov al,'0' 
        int 10h

dekadiko:        
        mov ah,0eh            
        mov al,'.' 
        int 10h
        
        mov ax,dx           ;print dekadiko 
        cmp ax,0
        je check3
        call print_ax_dex
        jmp again 
check3:   
        mov ah,0eh
        mov al,'0' 
        int 10h
                            
again: 
        PRINT newline      ;restarts program          
        jmp restart
                             
end_of_execution:
        hlt
        
                            ;print the error message
                            ;and the initial message for input
lathos:  
        PRINT newline
        PRINT errormsg
        jmp restart    
               
        errormsg db "lathos"
        newline db 0Dh,0Ah, "$" ;messages
        startornot db "START (Y, N):",0Dh,0Ah, "$"
        input db "insert input: $"
 
 
 
 
        erase_char proc    ;this routine erases the last character pressed
        push ax
        mov ah,0eh
        mov al,8           
        int 10h
        mov al,32           
        int 10h
        mov al,8           
        int 10h
        pop ax 
        ret
      
      
                  
                  
        read_hex proc       ;read a valid hexadecimal digit
ksanadiavase:               ;if it's not valid read again
        mov ah, 1           ;until valid     
        int 21h
        cmp al,'n'
        je end_of_execution
        cmp al,'N'
        je end_of_execution                
        cmp al,48
        jc lathoseisodos
        cmp al,58
        jnc  mallon_lathoseisodos
        jmp swsth_eisodos       
lathoseisodos:
        call erase_char     ;erases the invalid character
        jmp ksanadiavase
mallon_lathoseisodos:
        cmp al,65
        jc lathoseisodos
        cmp al,103
        jnc lathoseisodos
        cmp al,71
        jnc check_lathos2
        sub al,7
        jmp swsth_eisodos
check_lathos2:
        cmp al,97
        jc lathoseisodos
        sub al,39
swsth_eisodos:
        sub al,30h          ;in al we have a valid hex number pressed
        ret                
   
        
        
       print_ax_dex proc
        push dx             ;here is the function that shows
        push cx             ;result on screen (ax is the result)
        mov dx,0            ;it works recursively
        cmp ax,0h           ;the result is decimal
        je proc_end
        mov cx,10           ;base 10
        div cx
        push dx
        call print_ax_dex
        pop dx
        mov ax,dx
        cmp ax,0ah
        jnc not_number
        add ax,48
        jmp number
not_number:
        add ax,55           ;the usual check for number or
                            ;characters and offset in ascii table
number:
        mov ah,0eh      
        int 10h  
proc_end: 
        pop cx
        pop dx
        ret  
        
        endp                          
         