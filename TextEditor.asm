.DATA
	
	;:::variables:::;
	main_open db "/-----------\", '%'
	     	  db "|Text-Editor|", '%'
	     	  db "\-----------/", '%$', 0
	
	main_options db "Please enter the num of the option:", '%'
				 db "1. Create new file", '%'
				 db "2. Open existing file", '%'
				 db "3. Exit", '%%'
				 db "option: ", 0                              
			
	newfile_open db "/---------------\", '%'
				 db "|Create new file|", '%'
	             db "\---------------/", '%%'
	             db "File Name (Please add .TXT): ", 0                       
	
	existfile_open db "/---------------\", '%'
				   db "|Open exist file|", '%'
	               db "\---------------/", '%%'
	               db "File Name: ", 0
	
	exitMSG db "Please enter for exit...", 0
	                            
	text_col dw 3
	text_row dw 0
	
	filename_col dw 0
	filename db 25 dup(0)
	file dw 0
	
	matrix db 25*30 dup(0)
	     
	;:::defines:::; 
	;print function:
	string equ 6
	
	;write function:
	inputCH equ 4
	
	;getstr function:
	strIn equ 14
	strInMaxSize equ 12
	
	;getMatrix function:
	matOffset equ 14
	matSize equ 12
	
	;editfile_screen function:
	filenameP equ 8
	          
	;getsize function:
	strCsize equ 6
	 
.CODE
	;:::macro:::;
	;Get char from the user input into the ax Register
	getch macro
	    mov ah, 00h
	    int 16h
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
	    mov dx, 0x0A
	    mov ah, 2
	    int 21h
	
	;back to start of the line    
	    mov dx, 0x0D
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
		mov ax, 25
		push ax
		call getstr
		pop ax
		pop ax
	
		pop si
		pop cx
		pop ax
		
		ret                
	newfile_menu endp
	
	editfile_screen proc
		push bp
		push ax
		push bx
		push cx
		mov bp, sp      
		
	;get the filename size	
		mov ax, offset filename	
		push ax
		call getsize
		pop cx
	
	;save the size in another registers	
		mov cx, ax
		mov bx, cx
		add cx, 2    
		
	;print the first line of the title	
		putch '/' 
		line_1:
			putch '-'		
			loop line_1
		putch '\'
		
		enter
		
	;print the start of the second line of the title		
		putch '|'
		putch ' '
	
	;get the filename size	
		mov cx, bx
		add cx, 2
		
	;print the name of the file in the title	
		mov ax, offset filename
		push ax
		call print
		pop ax
	        
	;print the end of the second line of the title			        
		putch ' '
		putch '|'
		
		
		enter
	
	;print the last line of the title	
		putch '\' 
		line_2:
			putch '-'		
			loop line_2
		
		putch '/'		        
		
		enter
				
		pop cx
		pop bx
		pop cx
		pop bp
		            
		ret	            
	editfile_screen endp	
	
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
	    	cmp al, 0
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
	
	;if the string end with NULL(0) continu in the same line    	
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
	;Input - offset of the var that need to contain the str
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
		mov cx, [bp + strInMaxSize]
		
	;get the str char by char 	
		get_string:
			getch
			putch al
			
	;check if the user 'Enter' to new line
			cmp al, 0x0D
			je endStr
	
	;put the new char in the end of the str
			mov [si], al
		 	inc si
	  	    	loop get_string
		
	;when the input end	
		endStr:
			mov [si], 0
			
			pop si
			pop cx
			pop bx
			pop ax
			pop bp
		
		ret	
	getstr endp	
	
	getMatrix PROC
		push bp
		push ax
		push bx
		push cx
		push si	
		mov bp, sp
	
	;get the address of the Matrix	                             
		mov si, [bp + matOffset]
		push si
		call getSize
		INT 3
		pop si
		add si, ax
	
	;the max size of the Matrix	
		mov cx, [bp + matSize]
		
	;get the Matrix char by char 	
		get_mat:
			getch
			
			
	;check if the user 'Enter' to new line		
			cmp al, 0x0D
			je NewLineMat
			
	;check if the user press 'CTRL + S' (file save key)		
			cmp al, 0x13
			je endMat
			
			jmp conMat
			 		
			NewLineMat:
				mov [si], 0x0A
				inc si
				mov [si], 0x0D
				inc si
				enter
				
				jmp con_input
					
	;put the new char in the end of the Matrix
			conMat:
				putch al 
				mov [si], al
			 	inc si
			 	con_input: 	        
		  	    	loop get_mat
		
	;when the input end	
		endMat:
			mov [si], 0
			
			pop si
			pop cx
			pop bx
			pop ax
			pop bp
		
		ret	
	getMatrix ENDP	
	
	;This function return the size of str.
	;Input - offset of the var that contain the str            
	;Output - the size of the str in the 'ax' Register
	getsize proc
		push bp
		push si
		mov bp, sp
		
	;get the offset of the var	
		mov si, [bp + strCsize]
		mov ax, 0
	
	;loop on the str	
		size:          
	;check if this is the last char in the str	
			cmp [si], 0x00
			je Esize
	
	;go to the next char and inc the count of the size		
			inc ax
			inc si
	
	;check if the format of the string isnt correct		
			cmp ax, 25
			je Esize
			
			jmp size
	
	;end of the check		
		Esize:		
			pop si   
			pop bp	   
		
		ret
	getsize endp
	
	create_file proc
		push bp
		push bx
		push cx
		push dx
		mov bp, sp
		
		;open \ create file by filename
		mov ah, 3Ch         
	    mov cx, 0          
	    lea dx, [filename]  
	    int 21h
	    
	    ;Store the file handle
	    mov [file], ax
	
	    ;write content that store in the matrix var into the file
	    mov ah, 40h       
        mov bx, file      
        mov dx, offset matrix
        mov cx, 50
        int 21h 
    
	    ;Close the file
	    mov ah, 3Eh       
	    mov bx, [file]
	    int 21h 
		
		pop dx
		pop cx
		pop bx
		pop bp
		
		ret
	create_file endp
	
	read_file proc
		push bp
		push bx
		push cx
		push dx
		
		mov bp, sp
		
		;open \ create file by filename
		mov ah, 3Ch         
	    mov cx, 0          
	    lea dx, [filename]  
	    int 21h
		
		mov [file], ax
		
		mov ah, 3Fh       ; DOS function code for reading from a file
	    mov bx, file; File handle
	    mov dx, offset matrix  ; Pointer to the buffer to store file content
	    mov cx, 50       ; Number of bytes to read (adjust as needed)
	    int 21h           ; Call DOS interrupt
		
		push dx
		call print
		pop dx
		
		pop dx
		pop cx
		pop bx
		pop bp
		
		ret
	read_file endp            
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
			
			call cls
			call editfile_screen		
			
	;input text from the user				
			mov ax, offset matrix
			push ax
			mov ax, 50
			push ax
			call getMatrix
			pop ax
			
		    jmp end_prog
		    
	;openfile option		
		openfile_sec:
			cmp al, 0x02
			jne end_prog
			
	;print the newfile menu		
			call cls
			call newfile_menu
			
			call read_file
			
			call cls
			call editfile_screen		
			
	;input text from the user				
			mov ax, offset matrix
			push ax
			mov ax, 50
			push ax
			call getMatrix
			pop ax
			
		    jmp end_prog
				
		    jmp end_prog
		     
	;print the exit message and exit	     
		end_prog:
		call cls
		mov ax, offset exitMSG
		push ax
		call print
		pop ax
		
		getch
		call create_file
		mov ah, 4Ch         ; DOS function for program termination
	    int 21h             ; Call DOS interrupt
			
	MAIN endp                 
	end MAIN 
