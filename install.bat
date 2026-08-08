@echo off
cd /d "%~dp0"

echo ======================================
echo   BDS Scraper - Cai dat lan dau
echo ======================================
echo.

if exist "python-embed\python.exe" (
    echo Da cai dat roi! Chay run.bat de su dung.
    pause
    exit /b 0
)

echo [1/4] Dang tai Python portable...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://www.python.org/ftp/python/3.11.9/python-3.11.9-embed-amd64.zip' -OutFile 'py.zip'"
if not exist py.zip (
    echo LOI: Khong tai duoc Python. Kiem tra ket noi mang roi thu lai.
    pause
    exit /b 1
)

echo [2/4] Giai nen Python...
powershell -Command "Expand-Archive -Path 'py.zip' -DestinationPath 'python-embed' -Force"
del py.zip

for /f %%i in ('dir /b "python-embed\*.pth" 2^>nul') do (
    powershell -Command "(Get-Content 'python-embed\%%i') -replace '#import site','import site' | Set-Content 'python-embed\%%i'"
)

echo [3/4] Cai dat pip...
powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri 'https://bootstrap.pypa.io/get-pip.py' -OutFile 'get-pip.py'"
python-embed\python.exe get-pip.py --no-warn-script-location -q
del get-pip.py

echo [4/4] Cai dat thu vien va trinh duyet (mat 3-5 phut)...
python-embed\python.exe -m pip install streamlit playwright beautifulsoup4 pandas openpyxl streamlit-authenticator pyyaml bcrypt --no-warn-script-location -q
python-embed\python.exe -m playwright install chromium

echo.
echo ======================================
echo   Cai dat hoan tat!
echo   Chay run.bat de su dung.
echo ======================================
echo.
pause
