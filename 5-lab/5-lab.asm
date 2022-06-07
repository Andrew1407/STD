include <\masm32\include\masm32rt.inc>

.data
  hLab db "Lab5", 0
  ;numbers for example arrays
  valuesA dd 6, 20, 2, 6, 8
  valuesB dd 6, 2, 20, 6, 5
  valuesC dd -1, 2, 8, -3, 8
  results dd 5 dup(?)

  exampleStr db "f(a, b, c) = (a * b / 4 - 1) / (41 - b * a + c);", 13, 13, 0
  templateStr db "a = %d;", 9, "b = %d;", 9, " c = %d;", 9, " f = %d;", 13, 0
  templateBuff db 40 dup(?)
  mainBuff db 226 dup(?)

.code
  main:
    ;clean registers
    xor edx, edx
    xor edi, edi
    push 5                          ;used for: f * 5
    push 2                          ;used for: f / 2
    push 4                          ;used for: a * b / 4

    calcCycle:
      mov ecx, valuesA[edi]
      imul ecx, valuesB[edi]
      mov eax, 41
      sub eax, ecx
      add eax, valuesC[edi]
      mov ebx, eax
      mov eax, ecx
      pop esi                       ;get 4   
      idiv esi
      dec eax
      idiv ebx

      ;multiple of two checking
      test eax, 1
      jnz @false
        pop esi                      ;get 2
        idiv esi
        sub esp, 8                   ;return stack to start position
        jmp @testOut
      @false:
        add esp, 4                   ;skip 2
        pop esi                      ;get 5
        imul esi
        sub esp, 12                  ;return stack to start position
      @testOut:

      mov results[edi], eax          ;saving result

      add edi, 4
      cmp edi, 20
    jne calcCycle

    ;output buffer generating
    xor edi, edi
    invoke szCatStr,addr mainBuff, addr exampleStr
    bufferCycle:
      invoke wsprintf, addr templateBuff, addr templateStr,
        valuesA[edi], valuesB[edi], valuesC[edi], results[edi]
      invoke szCatStr, addr mainBuff, addr templateBuff
      add edi, 4
      cmp edi, 20
    jne bufferCycle
        
    invoke MessageBox, 0, addr mainBuff, addr hLab, 0
    invoke ExitProcess, 0

  end main
