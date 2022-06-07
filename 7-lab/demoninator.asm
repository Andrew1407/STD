.686
.model flat, stdcall
option casemap: none

public demoninator
extern valuesA: qword, valuesB: qword

.code
  ;(a * b - 1):
  demoninator proc
    fld valuesA[edi]          ;push a into st(0)
    fmul valuesB[edi]         ;a * b
    fld1                      ;push 1 into st(0)
    fsub                      ;st(1) - st(0) = a * b - 1, push into st(0)
    ret
  demoninator endp
  end