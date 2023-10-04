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

;Move to specific position in the screen
move macro row, col
    mov ah, 02h      
    mov dh, row
    mov dl, col
    int 10h
endm

;:::functions:::;
;This function print the open screen and the options list.
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

;This func print the newfile menu that get the name of the file and open it.
;Input - offset of the var that need to contain the name of the file
;output - the name of the file
newfile_menu proc	
	push ax
	push cx
	push si
	
;open screen:
	mov ax, offset newfile_open
	push ax	
	call print
	pop ax		
 	
;get file name 	
	mov ax, offset filename
	push ax
	call getstr
	pop ax

	pop si
	pop cx
	pop ax
	
	ret                
newfile_menu endp

;This function print given string from the stack into the screen.
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
;enter new line    	
    	cmp al, '%'
    	je cont_1

;end print with enter    	
    	cmp al, '$' 
    	je stop

;end print without enter    	
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

;This function clear the screen.
;Input  - None
;Output - None
cls proc
  mov ah, 0x00
  mov al, 0x03
  int 0x10  
  
  ret
cls endp

;This function getstr (max size 25) from the user.
;Input - offset of the var that need to contain the name of the file
;output - var with the str from the user
getstr proc
	push bp
	push ax
	push bx
	push cx
	push si	
	mov bp, sp

;get the address of the var	                             
	mov si, [bp + strIn]	

;the max size of the str	
	mov cx, 24
	
;get the str char by char 	
	get_string:
		getch

;check if the user 'Enter' to new line
		cmp al, 0x0D
		je endStr

;put the new char in the end of the str
	 	mov [si], al
 	    inc si
  	    loop get_string
	
;when the input end	
	endStr:
		inc si
		mov [si], 0x00
		
		pop si
		pop cx
		pop bx
		pop ax
		pop bp
	
	ret	
getstr endp	

;:::MAIN:::;         
MAIN proc 
;set the Data segment
	mov ax, @data	
	mov ds, ax	
	
	call cls  
	call main_menu
	
;get option num from the user
	getch
	sub al, '0'
	
;newfile option	
	newfile_sec:
		cmp al, 0x01 
		jne openfile_sec
		
;print the newfile menu		
		call cls
		call newfile_menu		
	    jmp end_prog
	    
;openfile option		
	openfile_sec:
		cmp al, 0x02
		jne end_prog
			
	    jmp end_prog
	    
	end_prog:
		
MAIN endp                 
end MAIN 
