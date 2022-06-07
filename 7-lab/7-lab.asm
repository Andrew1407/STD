include <\masm32\include\masm32rt.inc>

public valuesA, valuesB
extern demoninator@0:near

.data
  hLab db "Lab7", 0
  ;numbers for example arrays
  valuesA dq 6.1 , 20.5, 2.0, 6.9, 8.0
  valuesB dq 6.0, 2.0, 20.8, 6.0, 5.2
  valuesC dq -1.0, 2.0, 8.4, -3.0, 8.8
  valuesD dq 2.0, 5.2, 6.3, 45.7, 54.0
  results dq 5 dup(?)

  exampleStr db "f(a, b, c, d) = (tg(a + c / 4) - 12 * d) / (a * b - 1);", 13, 13, 0
  templateStr db "a = %s;", 9, "b = %s;", 9, " c = %s;", 9, "d = %s;", 9, " f = %s;", 13, 0
  templateBuff db 512 dup(?)
  aBuff dq 32 dup(?)
  bBuff dq 32 dup(?)
  cBuff dq 32 dup(?)
  dBuff dq 32 dup(?)
  resultBuff dq 32 dup(?)
  mainBuff db 1024 dup(?)

  four dq 4.0
  twelve dq 12.0

  errTemplate db "%s", 0
  errStr db "ERROR: division by zero",0

.code
  ;;tg(a + c / 4):
  numerator1 proc
    fld qword ptr [eax]                   ;push c value into st(0)
    fdiv qword ptr [ecx]                  ;divide c by 4
    fadd qword ptr [ebx]                  ;add a to (c / 4)
    fptan                     ;calculate tangent, push into st(0)
    fstp st(0)
    ret
  numerator1 endp
  ;;(12 * d):
  numerator2 proc
    enter 0, 0
    mov ebx, [ebp + 8]
    mov eax, [ebp + 12]
    fld qword ptr [eax]          ;push into st(0)
    fmul qword ptr [ebx]         ;d * 12
    leave
    ret 8
  numerator2 endp

  main:
    invoke szCatStr, addr mainBuff, addr exampleStr
    xor edi, edi
    calcCycle:
      xor al, al
      ;tg(a + c / 4):
      lea eax, valuesC[edi]
      lea ebx, valuesA[edi]
      lea ecx, four
      call numerator1
      ;(12 * d):
      lea eax, valuesD[edi]
      lea ebx,  twelve
      push eax
      push ebx
      call numerator2
      ;tg(a + c / 4) - (12 * d)
      fsub                      ;numerator1 - numerator2, push into st(0)
      ;(a * b - 1):
      call demoninator@0

      ;error checkup (division by zero)
      ftst
      fstsw ax
      sahf
		  sete al 

      .if al == 1 
        invoke wsprintf, addr resultBuff, addr errTemplate, addr errStr
      .else
        fdiv                      ;divide st(1) by st(0)
        fstp results[edi]         ;pop result
        invoke FloatToStr, results[edi], addr resultBuff
      .endif

      invoke FloatToStr, valuesA[edi], addr aBuff
      invoke FloatToStr, valuesB[edi], addr bBuff
      invoke FloatToStr, valuesC[edi], addr cBuff
      invoke FloatToStr, valuesD[edi], addr dBuff

      invoke wsprintf, addr templateBuff, addr templateStr,
                          addr aBuff, addr bBuff,
                          addr cBuff, addr dBuff,
                          addr resultBuff

      invoke szCatStr, addr mainBuff, addr templateBuff

      add edi, 8
      cmp edi, 40
    jne calcCycle

    invoke MessageBox, 0, addr mainBuff, addr hLab, 0
    invoke ExitProcess, 0

  end main
