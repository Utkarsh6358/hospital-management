@echo off
echo === Cleaning old build ===
if exist target rmdir /s /q target

echo === Creating directory structure ===
mkdir target\HospitalManagmentSysteme-0.0.1-SNAPSHOT 2>nul

echo === Copying web resources (including envtest.jsp) ===
xcopy /E /I /Y src\main\webapp\* target\HospitalManagmentSysteme-0.0.1-SNAPSHOT\

echo === Creating WAR file ===
cd target\HospitalManagmentSysteme-0.0.1-SNAPSHOT
jar -cf ..\HospitalManagmentSysteme-0.0.1-SNAPSHOT.war *
cd ..\..

echo === Build Complete ===
echo New WAR file created with envtest.jsp included
dir target\*.war
