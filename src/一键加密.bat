@echo off
setlocal

REM ���� SketchUpRubyScrambler ��·��
REM set SCRAMBLER_PATH="SketchUpRubyScrambler.exe"

REM ������ǰ�ļ��м����ļ����е����� .rb �ļ�
for /r %%F in (*.rb) do (
  REM ���ܵ�ǰ�ļ�
  SketchUpRubyScramblerWindows "%%F"
)

echo ������ɣ�
pause