set execFile=7-lab
\masm32\bin\ml /c /coff %execFile%.asm demoninator.asm
\masm32\bin\link /subsystem:windows %execFile%.obj demoninator.obj
\masm32\bin\ml.exe /c /Fl"\S.D.T\%execFile%.lst" "\S.D.T\%execFile%.asm"
pause
start %execFile%.exe
