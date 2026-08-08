@echo off
cd /d "%~dp0"
echo ======================================
echo   BDS Scraper
echo ======================================
echo.

if not exist "venv\Scripts\python.exe" (
    echo Chua cai dat! Hay chay install.bat truoc.
    pause
    exit /b 1
)

echo Dang khoi dong... Trinh duyet se tu dong mo.
echo De tat chuong trinh: dong cua so nay hoac bam Ctrl+C
echo.
venv\Scripts\python.exe -m streamlit run app.py --server.port 8501 --browser.gatherUsageStats false
