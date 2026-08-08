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

REM Uu tien dung Python da cai san tren may
python --version >nul 2>&1
if %errorlevel% == 0 (
    echo Tim thay Python tren may, dang tao moi truong...
    python -m venv venv
    goto :install_packages
)

python3 --version >nul 2>&1
if %errorlevel% == 0 (
    echo Tim thay Python3 tren may, dang tao moi truong...
    python3 -m venv venv
    goto :install_packages
)

REM Khong co Python, tai portable
echo Chua co Python, dang tai Python portable (~25MB)...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.9/python-3.11.9.exe' -OutFile 'python-installer.exe'"
if not exist python-installer.exe (
    echo LOI: Khong tai duoc Python. Kiem tra ket noi mang.
    pause
    exit /b 1
)
echo Dang cai Python (can quyen admin)...
python-installer.exe /quiet InstallAllUsers=0 PrependPath=1 Include_test=0
del python-installer.exe
python -m venv venv

:install_packages
echo Dang cai dat thu vien (mat 3-5 phut)...
venv\Scripts\python.exe -m pip install streamlit playwright beautifulsoup4 pandas openpyxl streamlit-authenticator pyyaml bcrypt -q
echo Dang cai trinh duyet...
venv\Scripts\python.exe -m playwright install chromium

echo.
echo ======================================
echo   Cai dat hoan tat!
echo   Chay run.bat de su dung.
echo ======================================
echo.
pause
