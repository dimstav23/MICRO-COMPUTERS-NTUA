;exercise 1.a    
         
         
ADDRN = 0800h          ;some random numbers
N = 8 
                       
        mov bx,ADDRN   ;load the starting address
        
set_values:            ;we set our values in memory so as to check if our program works properly 
        mov [bx],50    ;even
        mov [bx+1],47  ;odd
        mov [bx+2],27  ;odd
        mov [bx+3],80  ;even
        mov [bx+4],96  ;even
        mov [bx+5],137 ;odd
        mov [bx+6],84  ;even
        mov [bx+7],7   ;odd      
         
                       
        mov cl,N ;cl = 8
        mov ch,0 ;ch = 0
        mov dx,0 ;register for our sum
        mov ah,0 ;register for the number of even values
        
        
mainloop:               ;loop for computing our sum
        mov al,[bx]     ;start from the bx address
        inc bx          ;point to the next memory address
        rcr al,1        ;right shift 1
        jc isodd        ;if last bit is 1 then the value is odd so dont put it in the sum
        rcl al,1        ;if it's not odd restore the starting value by shifting 1 left
        push ax         ;push double reg a in the stack
        mov ah,0        
        add dx,ax       ;dx=dx+ax  
        pop ax
        inc ah          ;if value is even then ah=ah+1
isodd:
        loop mainloop 
        
        mov cl,ah       ;calculation of the average
        mov ch,0        ;double reg c now has the number of the sumed values
        mov ax,dx       ;move the sum to double reg a
          
        cmp cl,0        ;if we dont have any even values or the sum is equal to zero then
        jz zero         ;jump to zero and print 0
        mov dx,0         
        div cx          ;else make the division
        call hexprint   ;and print the result in hex mode 
        jmp end     ;go to the end and halt
zero:  
        mov al,'0'      ;print 0 on screen
        mov ah,0eh
        int 10h             
end:        
        hlt     
       
        hexprint proc   
                        
        push dx         ;this procedure prints the desired result on screen
        push cx         ;which is in the double reg a
        mov dx,0        
        cmp ax,0h
        je finish
        mov cx,10h
        div cx          ;division to take the int part of average
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
          
        endp       ;it correctly prints 4Dhex which is 77dec, our average is 77.5 