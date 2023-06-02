.MODEL small
.stack 100h
.data  
long1  db '                                      ' ,13,10,
       db '   ____  _ _                          ' ,13,10,                 
       db '  |  _ \(_) |                         ' ,13,10,                  
       db '  | |_) |_| |_                        ' ,13,10,                  
       db '  |  _ <| | __|                       ' ,13,10,                  
       db '  | |_) | | |_                        ' ,13,10,                  
       db '  |____/|_|\__|       _               ' ,13,10,      
       db '  |  ____(_)         | |              ' ,13,10,       
       db '  | |__   _ _ __   __| | ___ _ __     ' ,13,10,'$' 
       db '  |  __| | | '_ \ / _` |/ _ \ __|     ' ,13,10,'
long2  db '  | |    | | | | | (_| |  __/ |       ' ,13,10 ,
       db '  |_|    |_|_| |_|\__,_|\___|_|       ' ,13,10 ,'$'
                                  
                                



                                            
arr db 17 dup(0)  ;
arr2 db 17,?, 17 dup('$')  ; get binary number
msg1 db 13,10,'Enter a decimal number :  $'
msg2 db 13,10,'this is the binary  number of the decimal number you entered befote: $'
msg3 db 13,10,' Enter a binary number: $'
msg4 db 13,10,'this is the decimal  number of the binary number you entered befote: $'  
char1 db 0  ;                                                                                
char2 db 0    ;   get decimal number
char3 db 0    ;  
char4 db 0  ;

.code
    mov ax,@data
    mov ds,ax    
   
    lea dx,long1
    mov ah,09h   ;print to screen msg1
    int 21h
        
    lea dx,long2
    mov ah,09h   ;print to screen msg1
    int 21h             
      
    ;load array
    
    lea bx,arr        ;the adrees arr mov to bx
    
    add bx,16
    
    mov [bx],'$'     ; $ for the and arr
    dec bx
     
    
   
    lea dx,msg1
    mov ah,09h   ;print to screen msg1
    int 21h
    
       
    call get_chars      ;call proc
               
    
    
    xor bx,bx
    ;initialize dx, ah to 0
    xor dx,dx
    xor cx,cx
    
    lea bx,arr
    add bx,15
  
    call loop_num_division_2  ; call proc
    
    lea dx,msg2
    mov ah,09h             ;print to screem msg2
    int 21h
    
    lea dx,arr           ;print to screen arr
    mov ah,09h
    int 21h                
    
    xor ax,ax
    xor bx,bx
    xor cx,cx
    xor dx,dx
       
   
    
    lea dx,msg3  ;request user to enter binary number
    mov ah,09h
    int 21h
    
    mov dx, offset arr2  ;get arr2 from the user
	mov ah, 0ah
	int 21h
	
	lea bx, arr2
	;[bx+1] = length  
	;[bx+2] = start of the string
	; add $ at the end of the string
	push ax
	mov ax, [bx+1]
	add ax, 2 
	xor ah,ah
	add bx, ax
	mov [bx], '$'
	pop ax

    
    lea bx, arr2
    xor dx,dx
            
            
    call chang_number
  
     
    lea dx,msg4     
    mov ah,09h
    int 21h
    
    
    xor ax,ax
    mov ax,bx
    xor bx,bx 
    xor dx,dx
    
    call print_ax_r 
  
   
     
exit:
       mov ah, 4ch
       int 21h
          
     ;;;;;;;;;;;;; functioms:     
          
          
         proc power       ;make power
         push bp
         mov bp, sp
         
         push ax
         push cx
         ;cx = power
         mov cx, [bp+4]
         ;ax = number
         mov ax, [bp+6]
                    
         mov bx, 1           
         cmp cx, 0
         je func_end   
         cmp cx, 1
         je result
                 
         mov bx, ax 
         power_loop:
             mul bx  
             dec cx
         cmp cx,1
         jne power_loop 
         result:
         mov bx, ax
         func_end: 
         pop cx
         pop ax
         
         pop bp
         ret 4
     endp  ;result in bx
   
    
         print_ax_r:    ;print ax (int)
         pusha
         mov dx, 0
         cmp ax, 0
         je pn_done
         mov bx, 10
         div bx    
         call print_ax_r
         mov ax, dx
         add al, 30h
         mov ah, 0eh
         int 10h    
         jmp pn_done
         pn_done:
         popa  
         ret  
     endp
   
    ;;;;;;;;;;;;;;;;;;
    
         proc  chang_number  ; Takes the binary number and converts it to a regular number     
         push 0 ;result       
         run:
     
         push ax ;get to the last char in the string 
         mov ax,[bx+1] ;get length
         inc ax    
         xor ah,ah
         add bx, ax
         pop ax 
     
         sub bx, cx    
         sub [bx],30h   ; not 15 but length -1   
                
         mov al,[bx] ;ax = 0 or 1   ;not 15 but length -1
         xor ah,ah 
         push 2 ;make sure it's not cx and then 2
         push cx
         call power ;bx = 2^cx             
         mul bx ;ax*bx
    
         pop bx
         add bx,ax
         push bx
         mov bx,offset arr2
         inc cx
      
         push ax
         mov ax,[bx+1]    
         xor ah,ah 
         cmp cx,ax ; get the length of the array and compare cx to the length (ax)
         pop ax ;restore ax
         jne run
         pop bx ; stores the result           
     
         ret 
      
     endp
            
            
        proc loop_num_division_2
        lo:
    
        xor dx,dx    
    
       ;dx = reminder, ax = , where dx ax / 2
        mov cx,2
        div cx
    
        mov [bx],30h
        add [bx],dx ;
        dec bx
    
        cmp ax,0
        jne lo  
    
        ret
    endp
          
  
       proc get_chars
    
       mov ah,01h
       int 21h
     
                         
       mov char1,al                ;get char1
                                 
       xor ax,ax 
     
       sub char1,30h               ;char1-30h 
     ;;;;;  ;;;;; ;;;;
       mov ah,01h
       int 21h                     ;get char2
                                
       mov char2,al
           
       xor ax,ax
        
       sub char2,30h               ;char2-30h
     ;;;;;  ;;;;; ;;;;      
       mov ah,01h
       int 21h                     ;get char3
              
       mov char3,al
     
       xor ax,ax 
                               
       sub char3,30h               ;char3-30h
     ;;;;;  ;;;;; ;;;;
       mov ah,01h
       int 21h                     ;get char4
              
       mov char4,al
     
       xor ax,ax
     
       sub char4,30h               ;char4-30h
     ;;;;;  ;;;;; ;;;; 
     
       xor bx,bx
    
       mov bl,char1 
  
       mov ax,bx
     
       xor bx,bx
     
       mov bx,3e8h
     
       mul bx  
     
       xor cx,cx
     
       mov cx,ax
     
       xor ax,ax
           ;;;;;;;;
       xor bx,bx
     
       mov bl,char2
     
       add ax,bx 
              
       xor bx,bx
     
       mov bx,64h
     
       mul bx
     
       add cx,ax         
              
       xor ax,ax
     ;;;;;;;;         
      xor bx,bx
     
      mov bl,char3
     
      add ax,bx
     
      xor bx,bx
     
      mov bx,0Ah
     
      mul bx
     
      add cx,ax         
              
      xor ax,ax 
     
      ;;;;;
      xor bx,bx
     
      mov bl,char4
      
      add ax,bx
       
      xor bx,bx
      
      mov bx,1
      
      mul bx
      
      add cx,ax         
               
      xor ax,ax
      ;;;;;
      
      mov ax,cx
      
      
      ret      
  endp          
           