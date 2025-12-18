@echo off
chcp 65001 >nul
setlocal enabledelayedexpansion

echo ============================================
echo   STM32F103 标准外设库项目创建工具
echo ============================================
echo.

:: 模板路径 (自动获取脚本所在目录)
set TEMPLATE_DIR=%~dp0
set TEMPLATE_DIR=%TEMPLATE_DIR:~0,-1%

:: 检查模板是否存在
if not exist "%TEMPLATE_DIR%" (
    echo 错误: 模板目录不存在!
    echo 请检查路径: %TEMPLATE_DIR%
    pause
    exit /b 1
)

:: 获取项目名称
if "%~1"=="" (
    set /p PROJECT_NAME="请输入项目名称: "
) else (
    set PROJECT_NAME=%~1
)

if "%PROJECT_NAME%"=="" (
    echo 错误: 项目名称不能为空!
    pause
    exit /b 1
)

:: 获取目标目录 (默认使用当前工作目录)
if "%~2"=="" (
    set /p TARGET_DIR="请输入目标目录 (直接回车使用当前目录): "
) else (
    set TARGET_DIR=%~2
)

if "%TARGET_DIR%"=="" (
    set TARGET_DIR=%CD%
)

:: 创建完整路径
set PROJECT_PATH=%TARGET_DIR%\%PROJECT_NAME%

echo.
echo 模板路径: %TEMPLATE_DIR%
echo 将创建项目: %PROJECT_PATH%
echo.

:: 检查目录是否已存在
if exist "%PROJECT_PATH%" (
    echo 错误: 目录已存在!
    pause
    exit /b 1
)

:: 复制模板
echo 正在复制模板文件...
xcopy /E /I /Q "%TEMPLATE_DIR%\Start" "%PROJECT_PATH%\Start"
xcopy /E /I /Q "%TEMPLATE_DIR%\Library" "%PROJECT_PATH%\Library"
xcopy /E /I /Q "%TEMPLATE_DIR%\User" "%PROJECT_PATH%\User"
xcopy /E /I /Q "%TEMPLATE_DIR%\.vscode" "%PROJECT_PATH%\.vscode"
copy /Y "%TEMPLATE_DIR%\stm32f103c8t6.ld" "%PROJECT_PATH%\" >nul
copy /Y "%TEMPLATE_DIR%\CMakeLists.txt" "%PROJECT_PATH%\" >nul

:: 创建 build 目录并配置 CMake
echo.
echo 正在配置 CMake...
mkdir "%PROJECT_PATH%\build"
cd /d "%PROJECT_PATH%\build"
cmake .. -G Ninja

echo.
echo ============================================
echo   项目创建成功!
echo ============================================
echo.
echo 项目路径: %PROJECT_PATH%
echo.
echo 下一步:
echo   1. 用 VS Code 打开项目文件夹
echo   2. 按 Ctrl+Shift+B 编译
echo   3. 按 F5 调试
echo.
pause
