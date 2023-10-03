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
