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