.686
.model flat, stdcall
option casemap: none

.const
  four dq 4.0
  twelve dq 12.0

.code

  calcProc proc
    enter 0, 0
	  mov ebx, [ ebp + 20 ] 	  	   ;valuesA

    ;tg(a + c / 4):
  	mov ecx, [ebp + 12]   	  	   ;valuesC
    fld qword ptr [ecx]            ;push c value into st(0)
    fdiv four                 	   ;divide c by 4
    fadd qword ptr [ebx]           ;add a to (c / 4)
    fptan                          ;calculate tangent, push into st(0)
    fstp st(0)
    ;tg(a + c / 4) - 12 * d:
	  mov ecx, [ebp + 8] 	           ;valuesD
    fld qword ptr [ecx]            ;push into st(0)
    fmul twelve                    ;d * 12
    fsub                       	   ;st(1) - d * 12, push into st(0)
    ;(tg(a + c / 4) - 12 * d) / (a * b - 1):
    fld qword ptr [ebx]            ;push a into st(0)
  	mov ecx, [ebp + 16]   	       ;valuesB
    fmul qword ptr [ecx]           ;a * b
    fld1                           ;push 1 into st(0)
    fsub                           ;st(1) - st(0) = a * b - 1, push into st(0)

    ;error checkup (division by zero)
    ftst
    fstsw ax
    sahf
	  sete al
	  .if al != 1
	    fdiv                      ;divide st(1) by st(0)
	  .endif
	  leave
    ret 18
  calcProc endp

;entry point
LibMain:
	mov eax, 1
  ret 12
end LibMain