include <\masm32\include\masm32rt.inc>
include <\masm32\include\fpu.inc>
includelib <\masm32\lib\fpu.lib>

.const
  header db "Lab1",0              ;window header
  charArray db "14072001",0       ;{C} value in array of chars

  ;{A} value in different formats
  A_db db 14
  A_dw dw 14
  A_dd dd 14
  A_dq dq 14
  
  ;{-A} value in different formats
  _A_db db -14
  _A_dw dw -14
  _A_dd dd -14
  _A_dq dq -14
  
  ;{B} value in different formats
  B_dw dw 1407
  B_dd dd 1407
  B_dq dq 1407

  ;{-B} value in different formats
  _B_dw dw -1407
  _B_dd dd -1407
  _B_dq dq -1407

  ;{C} value in different formats
  C_dd dd 14072001
  C_dq dq 14072001

  ;{-C} value in different formats
  _C_dd dd -14072001
  _C_dq dq -14072001

  ;{D}, {-D} value in Single (float) format
  D_dd dd 0.002
  _D_dd dd -0.002

  ;{D}, {-D} in Extended (long double) format
  D_dt dt 0.002
  _D_dt dt -0.002

  ;{E}, {-E} value in Double format
  E_dq dq 0.165
  _E_dq dq -0.165

  ;{F}, {-F} in Extended (long double) format
  F_dt dt 1654.362
  _F_dt dt -1654.362

  ;template strings
  A_str db "%d",0
  B_str db "%d",0
  C_str db "%d",0
  D_str db "%d",0
  E_str db "%d",0
  F_str db "%d",0

  _A_str db "%d",0
  _B_str db "%d",0
  _C_str db "%d",0
  _D_str db "%d",0
  _E_str db "%d",0
  _F_str db "%d",0

  ;main string
  output_str db "A = %s", 13,
                "-A = %s", 13,
                "B = %s", 13,
                "-B = %s", 13,
                "C = %s", 13,
                "-C = %s", 13,
                "D = %s", 13,
                "-D = %s", 13,
                "E = %s", 13,
                "-E = %s", 13,
                "F = %s", 13,
                "-F = %s",0

.data; output strings and its buffers
  buffer db 260 dup(?)    ;main buffer
  
  A_buff db 30 dup(?)
  B_buff db 30 dup(?)
  C_buff db 30 dup(?)
  D_buff db 30 dup(?)
  E_buff db 30 dup(?)
  F_buff db 30 dup(?)

  _A_buff db 30 dup(?)
  _B_buff db 30 dup(?)
  _C_buff db 30 dup(?)
  _D_buff db 30 dup(?)
  _E_buff db 30 dup(?)
  _F_buff db 30 dup(?)
    
.code
  main:
    invoke wsprintf, addr A_buff, addr A_str, A_dd
    invoke wsprintf, addr _A_buff, addr _A_str, _A_dd
    invoke wsprintf, addr B_buff, addr B_str, B_dd
    invoke wsprintf, addr _B_buff, addr _B_str, _B_dd
    invoke wsprintf, addr C_buff, addr C_str, C_dd
    invoke wsprintf, addr _C_buff, addr _C_str, _C_dd
    invoke FpuFLtoA, addr D_dt, 3, addr D_buff, SRC1_REAL
    invoke FpuFLtoA, addr _D_dt, 3, addr _D_buff, SRC1_REAL
    invoke FloatToStr, E_dq, addr E_buff
    invoke FloatToStr, _E_dq, addr _E_buff
    invoke FpuFLtoA, addr F_dt, 3, addr F_buff, SRC1_REAL
    invoke FpuFLtoA, addr _F_dt, 3, addr _F_buff, SRC1_REAL

    invoke wsprintf, addr buffer, addr output_str,
                                  addr A_buff, addr _A_buff,
                                  addr B_buff, addr _B_buff,
                                  addr C_buff, addr _C_buff,
                                  addr D_buff, addr _D_buff,
                                  addr E_buff, addr _E_buff,
                                  addr F_buff, addr _F_buff

    invoke MessageBox, 0, addr buffer, addr header, 0
    invoke ExitProcess, 0
  end main
