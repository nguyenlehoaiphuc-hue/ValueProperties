@echo off
cd /d "%~dp0"
echo ======================================
echo   BDS Scraper - Cai dat lan dau
echo ======================================
echo.

if exist "venv\Scripts\python.exe" (
    echo Da cai dat roi! Chay run.bat de su dung.
    pause
    exit /b 0
)

REM ---------------------------------------------------------------
REM BAT BUOC Python 64-bit: pandas / pyarrow / playwright khong co
REM ban dung san (wheel) cho Windows 32-bit, se loi build tu source.
REM ---------------------------------------------------------------

REM Uu tien dung Python da cai san tren may (neu la 64-bit)
python --version >nul 2>&1
if %errorlevel% == 0 (
    python -c "import struct,sys; sys.exit(0 if struct.calcsize('P')==8 else 1)" >nul 2>&1
    if not errorlevel 1 (
        echo Tim thay Python 64-bit tren may, dang tao moi truong...
        python -m venv venv
        goto :install_packages
    )
    echo Python tren may la ban 32-bit - khong dung duoc.
    echo Dang tai Python 64-bit...
    goto :download_python
)

python3 --version >nul 2>&1
if %errorlevel% == 0 (
    python3 -c "import struct,sys; sys.exit(0 if struct.calcsize('P')==8 else 1)" >nul 2>&1
    if not errorlevel 1 (
        echo Tim thay Python3 64-bit tren may, dang tao moi truong...
        python3 -m venv venv
        goto :install_packages
    )
    echo Python3 tren may la ban 32-bit - khong dung duoc.
    echo Dang tai Python 64-bit...
    goto :download_python
)

echo Chua co Python, dang tai Python 64-bit (~25MB)...

:download_python
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.9/python-3.11.9-amd64.exe' -OutFile 'python-installer.exe'"
if not exist python-installer.exe (
    echo LOI: Khong tai duoc Python. Kiem tra ket noi mang.
    pause
    exit /b 1
)
echo Dang cai Python...
python-installer.exe /quiet InstallAllUsers=0 PrependPath=1 Include_test=0 Include_launcher=1
del python-installer.exe

REM Duong dan mac dinh khi cai per-user, dung truc tiep de khong phai mo lai CMD
set "PY64=%LOCALAPPDATA%\Programs\Python\Python311\python.exe"
if not exist "%PY64%" (
    echo LOI: Cai Python that bai. Hay cai tay tu python.org ^(nho chon ban 64-bit^).
    pause
    exit /b 1
)
"%PY64%" -m venv venv

:install_packages
if not exist "venv\Scripts\python.exe" (
    echo LOI: Khong tao duoc moi truong ao.
    pause
    exit /b 1
)

echo Dang cai dat thu vien (mat 3-5 phut)...
venv\Scripts\python.exe -m pip install --upgrade pip -q
venv\Scripts\python.exe -m pip install -r requirements.txt -q
if errorlevel 1 (
    echo LOI: Cai thu vien that bai. Xem thong bao loi o tren.
    pause
    exit /b 1
)

echo Dang cai trinh duyet...
venv\Scripts\python.exe -m playwright install chromium
if errorlevel 1 (
    echo LOI: Cai trinh duyet that bai.
    pause
    exit /b 1
)

echo.
echo ======================================
echo   Cai dat hoan tat!
echo   Chay run.bat de su dung.
echo ======================================
echo.
pause
