set procDll=8-lab.dll
set main=8-lab

\masm32\bin\ml /c /coff %procDll%.asm
\masm32\bin\link /subsystem:windows /dll /NOENTRY /def:%procDll%.def %procDll%.obj
\masm32\bin\ml /c /coff %main%.asm
\masm32\bin\link /subsystem:windows %main%.obj
pause
start %main%.exe