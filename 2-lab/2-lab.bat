@echo off
cls
set _dir=F
set fname=2-lab
set masm32Path=\masm32\bin
set DOS_Path=\Programs\DOSBox-0.74-3\DOSBox.exe

for /f "tokens=*" %%a in (
  'DIR %_dir%:\ %fname%.asm') Do set foundPath=%%~dpa

cd %foundPath%
%masm32Path%\ml /c %fname%.asm
%masm32Path%\link16 /TINY %fname%.obj

F:\masm32\bin\ml.exe /c /Fl"\S.D.T\%fname%.lst" "\S.D.T\%fname%.asm"

start %DOS_Path% -c "mount d %foundPath% " -c d:-c %fname%.com
