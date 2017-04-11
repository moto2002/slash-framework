@echo off

REM Setup
REM Install perl on your system, if not already existent: https://www.perl.org/get.html
REM Set environment variables:
REM NET40_HOME is the path to your local .NET Framework installation (e.g. C:\Windows\Microsoft.NET\Framework\v4.0.30319)
REM UNITY_PATH is the path to your Unity3D installation (e.g. C:\Program Files\Unity)

set UNITY_PATH=%~1
set CONFIG=%~2
set PACKAGE=%~3

if ["%UNITY_PATH%"] == [""] (
	echo UNITY_PATH not set
	goto :EOF
)

echo Build libraries...

REM Clean and build solution
"%NET40_HOME%\MSBuild.exe" ../../Source/Slash.Framework.sln /verbosity:minimal /property:Configuration="%CONFIG%" /p:Platform="Any CPU" /t:Clean;Build > BuildLibraries.log

set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 (
  echo ...success
)
if not %BUILD_STATUS%==0 (
  echo ...failed with error code %BUILD_STATUS%
  goto :EOF
)

REM Clear output path
rmdir /s /q Slash.Framework

REM Remove Slash.Unity.Common.dll
DEL /Q "..\..\Bin\Slash.Unity.Common\AnyCPU\%CONFIG%\Slash.Unity.Common.*"

echo Copy dlls to package...

REM Copy dlls from Unity.Common
perl BuildUnityPackage.pl "../../Bin/Slash.Unity.Common/AnyCPU/%CONFIG%" "Slash.Framework/Assets/Slash Framework/Plugins" > CopyDlls.log

echo Copy source files to package...

REM Copy non-DLL files
xcopy /h /s /q /i /y "../../Source/Slash.Unity.Common/Source" "Slash.Framework/Assets/Slash Framework/Slash.Unity.Common" > nul
xcopy /h /s /q /i /y "../../Source/Slash.Unity.Editor.Common/Source" "Slash.Framework/Assets/Slash Framework/Editor/Slash.Unity.Editor.Common" > nul
xcopy /h /s /q /i /y "../../Ext/StrangeIoC/Source" "Slash.Framework/Assets/StrangeIoC" > nul
xcopy /h /s /q /i /y "../../Source/Slash.Unity.StrangeIoC/Source" "Slash.Framework/Assets/Slash Framework/Slash.Unity.StrangeIoC" > nul
xcopy /h /s /q /i /y "../../Source/Slash.Unity.StrangeIoC.Video/Source" "Slash.Framework/Assets/Slash Framework/Slash.Unity.StrangeIoC.Video" > nul
xcopy /h /s /q /y "../../Source/Slash.Unity.Export/Source/Assets" "Slash.Framework/Assets" > nul

echo Build addon unity packages...

REM Build addons
mkdir "%~dp0Slash.Framework/Assets/Slash Framework/Addons"
"%UNITY_PATH%\Editor\Unity.exe" -batchmode -projectPath "%~dp0Slash.Framework" -exportPackage "Assets/Slash Framework/Slash.Unity.StrangeIoC" "Assets/Slash Framework/Slash.Unity.StrangeIoC.Video" "%~dp0Slash.Framework/Assets/Slash Framework/Addons/Slash.Unity.StrangeIoC.unitypackage" -logFile AddonStrangeIoC.log -quit

set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 (
  echo ...success
)
if not %BUILD_STATUS%==0 (
  echo ...failed with error code %BUILD_STATUS%
  goto :EOF
)

REM Remove addons
rmdir /s /q "Slash.Framework/Assets/Slash Framework/Slash.Unity.StrangeIoC"
rmdir /s /q "Slash.Framework/Assets/Slash Framework/Slash.Unity.StrangeIoC.Video"

echo Build main unity package...

REM Build package
"%UNITY_PATH%\Editor\Unity.exe" -batchmode -projectPath "%~dp0Slash.Framework" -exportPackage "Assets/Slash Framework" "%~dp0%PACKAGE%.unitypackage" -logFile MainPackage.log -quit

set BUILD_STATUS=%ERRORLEVEL%
if %BUILD_STATUS%==0 (
  echo ...success
)
if not %BUILD_STATUS%==0 (
  echo ...failed with error code %BUILD_STATUS%
  goto :EOF
)