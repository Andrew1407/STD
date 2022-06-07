include <\masm32\include\masm32rt.inc>			;masm32 modules for working with string, numbers, buffers and dialog output

.data
  hLab db "Lab8", 0
  ;numbers for example arrays
  valuesA dq 6.1, 20.5, 2.0, 6.9, 8.0
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
  
  errTemplate db "%s", 0
  errStr db "ERROR: division by zero", 0
  
  ;DLL info
  descriptorName dd ?
  dllName db "8-lab.dll", 0
  procName db "calcProc", 0


.code
  main:
    invoke szCatStr, addr mainBuff, addr exampleStr
    xor edi, edi
    xor al, al
	  invoke LoadLibrary, offset dllName
	  mov descriptorName, eax

    calcCycle:
	    lea eax, valuesA[edi]
	    lea ebx, valuesB[edi]
	    lea ecx, valuesC[edi]
	    lea edx, valuesD[edi]
	    push eax
	    push ebx
	    push ecx
	    push edx
	    invoke GetProcAddress, descriptorName, offset procName		;define calcProc into eax
	    call eax

	    ;error handling
      .if al == 1 
        invoke wsprintf, addr resultBuff, addr errTemplate, addr errStr
      .else
        fstp results[edi]         ;pop result
        invoke FloatToStr, results[edi], addr resultBuff
      .endif

      xor al, al

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
