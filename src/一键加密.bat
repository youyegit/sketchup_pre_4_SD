@echo off
setlocal

REM 定义 SketchUpRubyScrambler 的路径
REM set SCRAMBLER_PATH="SketchUpRubyScrambler.exe"

REM 遍历当前文件夹及子文件夹中的所有 .rb 文件
for /r %%F in (*.rb) do (
  REM 加密当前文件
  SketchUpRubyScramblerWindows "%%F"
)

echo 加密完成！
pause