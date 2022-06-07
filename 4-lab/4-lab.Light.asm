include <\masm32\include\masm32rt.inc>
include <4-lab.macros.inc>    ;;including the very marcos


.data
  PersonInitials db "ПIБ: Головко Андрiй Андрiйович.", 0
  PersonBirthDate db "Дата народження: 14.07.2001.", 0
  PersonRecordBook db "Номер залікової книжки: 8506.", 0

  hPersonInitials db "ПІБ", 0 
  hPersonBirthDate db "ДАТА НАРОДДЖЕННЯ", 0
  hPersonRecordBook db "ЗАЛІКОВА КНИЖКА", 0
  
  hWrong db "Помилка вводу", 0
  wrong db "Пароль не вірний!", 0
  pswdBufLen db 60          ;buffer size for input password
  ;PASSWORD:
  pswd db "112233", 0
  pswdLength = $ - pswd		;size of password
  pswdCipherValue equ 4     ;number for XOR operation
  pswdInput db 30 dup(?)    ;input password buffer

.code	
DlgProc proc hWin:dword, uMsg:dword, wParam:dword, lParam:dword
  switch uMsg
    ;area for password tahoma
    case WM_COMMAND
      switch wParam
        case IDOK
          invoke GetDlgItemText, hWin, 1000, addr pswdInput, 512
          ;password authentication
		  pswdCiphering pswdInput, pswdLength, pswdCipherValue
          pswdComparing pswd, pswdInput
		case IDCANCEL
		  invoke ExitProcess, 0
      endsw
    ;"Cross" button click
    case WM_CLOSE
      invoke ExitProcess, 0
  endsw
  return 0      ;end of program
DlgProc endp

main:    
	Dialog "Lab4", "tahoma", 11, \            							    
        WS_OVERLAPPED or WS_SYSMENU or DS_CENTER, \   							
        4, 5, 5, 120, 65, 1024
	DlgStatic "Введіть пароль:", SS_CENTER, 7, 5, 60, 10, 100	
	DlgEdit WS_BORDER or WS_TABSTOP, 7, 20, 100, 11, 1000
	DlgButton "OK",0,20,36,30,10,IDOK
	DlgButton "Cancel",0,60,36,30,10,IDCANCEL
	CallModalDialog 0,0,DlgProc,NULL	
end main