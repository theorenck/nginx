@echo off
echo.
echo.
echo             _                      _
echo            ^| ^|                    (_)
echo     _______^| ^|_ __ _   _ __   __ _ _ _ __ __  __
echo    ^|_  / _ \ __/ _^` ^| ^| ^'_ \ / _^` ^| ^| ^'_ \\ \/ /
echo     / /  __/ ^|^| (_^| ^| ^| ^| ^| ^| (_^| ^| ^| ^| ^| ^|^>  ^<
echo    /___\___^|\__\__,_^| ^|_^| ^|_^|\__, ^|_^|_^| ^|_/_/\_\
echo                               __/ ^|
echo                              ^|___/
echo.
echo    v1.0.0
echo.
@echo off
net session >nul 2>&1
if not %errorLevel% == 0 (
    echo.
    echo.
    echo ERRO: O usuario atual nao possui permissoes de administrador
    goto :exit
)
:configuration
set name=zeta_nginx
echo.
choice /m "1. O servico tem um nome customizado (diferente de %name%) ? [s/n]" /c sn /n
if %errorlevel% == 1 (
  :custom_name
  echo.
  set /p name="Qual o nome do servico? "
)
sc query %name% | findstr /i "RUNNING" > nul 2>&1
if not %errorlevel% == 0 (
  echo.
  echo.
  echo ERRO: Nao existe um servico com o nome %name%, o processo de remocao sera abortado.
  goto :exit
)
sc stop %name% >nul 2>&1
if not %errorlevel% == 0 (
  echo.
  echo.
  echo ERRO: Nao foi possivel parar o servico.
)
sc delete %name% >nul 2>&1
if not %errorlevel% == 0 (
  echo.
  echo.
  echo ERRO: Nao foi possivel remover o servico.
  goto :exit
)
echo.
echo.
echo INFO: O servico %name% foi removido com exito.
:exit
echo.
echo.
pause
