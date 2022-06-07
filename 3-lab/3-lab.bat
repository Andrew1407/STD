set execFile=3-lab
F:\masm32\bin\ml /c /coff %execFile%.asm
F:\masm32\bin\link /subsystem:windows %execFile%.obj
F:\masm32\bin\ml.exe /c /Fl"\S.D.T\%execFile%.lst" "\S.D.T\%execFile%.asm"
pause
start %execFile%.exe
