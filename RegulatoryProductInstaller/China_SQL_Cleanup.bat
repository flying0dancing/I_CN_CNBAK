@taskkill /IM STB* /F /T 1>nul
set temp_testset=%~n0
set temp_testset=%temp_testset:_Cleanup=%
start cmd /k "%~dp0Product_Installation.bat" %temp_testset% /cleanup