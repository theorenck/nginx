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
set base_dir=%cd%
net session >nul 2>&1
if not %errorLevel% == 0 (
    echo.
    echo.
    echo ERRO: O usuario atual nao possui permissoes de administrador
    goto :exit
)
if not exist bin\srvany.exe (
  echo.
  echo.
  echo ERRO: O utilitario srvany.exe nao foi encontrado em %base_dir%bin.
  goto :exit
)
if not exist nginx.exe (
  echo.
  echo.
  echo ERRO: O executavel do NGINX não foi encontrado em %base_dir%.
  goto :exit
)
:configuration
set name=zeta_nginx
set port=3000
set bind=0.0.0.0
echo.
echo.
choice /m "1. Deseja customizar o nome do servico [%name%]? [s/n]" /c sn /n
if %errorlevel% == 1 (
  :custom_name
  echo.
  set /p name="Que nome voce gostaria de usar? "
)
sc query %name% | findstr "1060" > nul 2>&1
if not %errorlevel% == 0 (
  echo.
  echo.
  echo INFO: Ja existe um servico com o nome %name%, escolha outro nome.
  echo.
  goto :custom_name
)
echo.
echo.
echo INFO: O nome do servico sera %name%.
echo.
echo INFO: O servico sera executado em:
echo.
echo       %base_dir%
echo.
echo.
echo       %ruby%
echo.
echo.
choice /m "4. Isto esta correto? [s/n]" /c sn /n
if %errorlevel% == 2 (
  goto :configuration
)
echo.
echo.
echo INFO: Aguarde enquando criamos o novo servico. . .
sc create %name% binPath= "%base_dir%\srvany.exe" DisplayName= "%name%" start= auto > nul 2>&1
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\%name%\Parameters /v AppDirectory /t REG_SZ /d "%base_dir%" >nul 2>&1
REG ADD HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\services\%name%\Parameters /v Application /t REG_SZ /d "nginx.exe" >nul 2>&1
echo.
echo.
echo INFO: Iniciando o servico. . .
sc start %name% > nul 2>&1
if %errorlevel% == 1 (
  echo.
  echo.
  echo ERRO: Houve um erro ao iniciar o servico.
  goto :exit
)
echo.
echo.
echo INFO: O servico foi criado e iniciado com sucesso.
echo.
sc query %name%
:exit
echo.
echo.
pause
