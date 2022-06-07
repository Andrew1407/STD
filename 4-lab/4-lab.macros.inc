;;MACROS

dataOutput macro header, data_string    ;;input args: [window header, buffer]
  invoke MessageBox, 0, addr data_string, addr header, 0
endm

pswdCiphering macro password, len, cipherKey
  xor bx, bx
  ;ciphering cycle
  .while bx != len
    xor password[bx], cipherKey
    inc bx
  .endw
  xor bx, bx    ;;make bx = 0 for next input tries
endm

pswdComparing macro originalVal, inputVal
  local checkupFalse    ;;special marco label

  lea edi, originalVal
  lea esi, inputVal
  mov ecx, 6
  repe cmpsb                            ;comparing passwords bites
  jne checkupFalse
  ;;another marco using (MessageBox closure)
  dataOutput hPersonInitials, PersonInitials
  dataOutput hPersonBirthDate, PersonBirthDate
  dataOutput hPersonRecordBook, PersonRecordBook
  invoke ExitProcess, 0
  checkupFalse:
    dataOutput hWrong, wrong
endm

