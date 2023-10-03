.DATA

;:::variables:::;
main_open db "/-----------\", '%'
     	  db "|Text-Editor|", '%'
     	  db "\-----------/", '%$'

main_options db "Please enter the num of the option:", '%'
			 db "1. Create new file", '%'
			 db "2. Open existing file", '%'
			 db "3. Exit", '%%'
			 db "option: ", '#'                              
		
newfile_open db "/---------------\", '%'
			 db "|Create new file|", '%'
             db "\---------------/", '%%'
             db "File Name: ", '#'                       

existfile_open db "/---------------\", '%'
			   db "|Open exist file|", '%'
               db "\---------------/", '%%'
               db "File Name: ", '#'
                              
text_col dw 0
text_row dw 0

filename_col dw 0
filename db 25 dup(0)
     
;:::defines:::; 
;print function:
string equ 6

;write function:
inputCH equ 4

;getstr function:
strIn equ 6    

;:::macro:::;
;Get char from the user input into the ax Register
getch macro
    mov ax, 0
    mov ah, 0x01   
    int 0x21
    
endm

;Put char into the screen
putch macro char
	mov ah, 0eh
	mov al, char
	int 10h
endm

;Enter to new line
enter macro
    push bp
    push dx
    mov bp, sp

;enter to new line    
    mov dx, 10
    mov ah, 2
    int 21h

;back to start of the line    
    mov dx, 13
    mov ah, 2
    int 21h
    
    mov sp, bp
    pop dx
    pop bp
endm 

move macro row, col
    mov ah, 02h      ;set text position in middle screen
    mov dh, row
    mov dl, col
    int 10h
endm

;:::functions:::;
;This function print the open screen and the options list
;Input - None
;Output - None
main_menu proc	
;open screen:
	mov ax, offset main_open
	push ax
	call print
	pop ax 	      
	
;options list
	mov ax, offset main_options
	push ax
	call print
	pop ax		                 	        
	
	ret
main_menu endp

newfile_menu proc
;open screen:	
	push ax
	push cx
	push si
	
	mov ax, offset newfile_open
	push ax	
	call print
	pop ax	
	
 	mov cx, 25
 	mov si, offset filename
 	
;get file name 	
	file_name:
		getch

		cmp al, 0x0D
		je ENTER
	
	 	mov [si], al
	    inc si
	    loop file_name
	    
	ENTER:	
		pop si
		pop cx
		pop ax
	
	ret                
newfile_menu endp

;This function print given string from the stack into the screen
;Input - string in the string (define) place of the stack for print
;Output - None
print proc
    push bp
    push bx
    mov bp, sp          
                  
    mov bx, 0
    mov bx, [bp + string]
    
;print all the string  chars
    output:                                                   
    	mov al, [bx]
    	
    	cmp al, '%'
    	je cont_1
    	
    	cmp al, '$' 
    	je stop
    	
    	cmp al, '#'
    	je pass_stop
    	    	
    	putch al            
    	
    	jmp cont_2
    	
    	cont_1:
    		enter
    		
    	cont_2:
    		inc bx
    		jmp output

;if the strings end with $ the enter new line    	
    stop:
    	enter    

;if the string end with # continu in the same line    	
    pass_stop:
    	pop bx ;Restore the base pointer
    	pop bp
    
    ret                 
print endp
