.model tiny

.data
  pswdInputField db "Введiть пароль: ", "$"
  pswdWrong db "Пароль не вiрний! Спробуйте ще раз.", 13, 10, "$"
  Person db "ПIБ: Головко Андрiй Андрiйович.", 13, 10,
            "Дата народження: 14.07.2001.", 13, 10,
            "Номер залiкової книжки: 8506.$"
			
  pswdLength dw 6           ;size of password
  pswdBufLen db 60          ;buffer size for input password
  ;PASSWORD:
  pswd db "112233", "$"
  pswdCipherValue equ 4     ;number for XOR operation
  pswdInput db 30 dup(?)    ;input password buffer

.code
  org 256; bytes for segment reservation

  main:
  mov ax, 5       			                  ;[int parameter]: output text visualization
  int 10h         			                  ;clean disp

  ;start comparing cycle
  compare: 
    mov ah, 09h                           ;[int parameter]: show string
    mov dx, offset pswdInputField         ;[int parameter]: password query string
    int 21h                               ;call necessary DOS function

    mov ah, 3fh                           ;[int parameter]: read input string
    mov bx, 0                             ;[int parameter]: file descriptor
    mov cx, offset pswdBufLen             ;[int parameter]: buffer size
    mov dx, offset pswdInput              ;[int parameter]: buffer for keyboard input
    int 21h                               ;call necessary DOS function
       
    xor di, di                              ;index value (set 0)
    pswdCipher:
      xor pswdInput[di], pswdCipherValue         ;xor for each input password sympol
      inc di
      cmp di, pswdLength
      jne pswdCipher

    ;set passwords in registers for comparison
    lea di, pswd
    lea si, pswdInput

    mov ax, 5                             ;[int parameter]: output text visualization
    int 10h                               ;clean disp
    
    ;comparing    
    mov cx, pswdLength
    repe cmpsb                            ;comparing passwords bites
    je checkupTrue

    ;wrong case
    mov ah, 09h                           ;[int parameter]: show string
    mov dx, offset pswdWrong              ;[int parameter]: warning
    int 21h                               ;call necessary DOS function
    jmp compare                           ;ask for input again

    checkupTrue:
    mov ah, 09h                           ;[int parameter]: show string
    mov dx, offset Person                 ;[int parameter]: person's data
    int 21h                               ;call necessary DOS function
    ret
  end main