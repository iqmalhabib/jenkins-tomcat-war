pipeline {
    agent any

    triggers {
        githubPush()
    }

    environment {
        TOMCAT_HOME = 'C:\\tomcat10.1'
        WAR_NAME    = 'demo-0.0.1-SNAPSHOT.war'
        DEPLOY_NAME = 'demo.war'
    }

    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/iqmalhabib/jenkins-tomcat-war.git'
            }
        }

        stage('Build') {
            steps {
                bat 'mvn clean package -DskipTests'
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                bat '''
                    @echo off

                    REM 1. Kill Tomcat on port 8080
                    netstat -ano > "%TEMP%\\netstat_out.txt"
                    findstr "0.0.0.0:8080" "%TEMP%\\netstat_out.txt" > "%TEMP%\\port8080.txt"
                    for /f "tokens=5" %%a in (%TEMP%\\port8080.txt) do (
                        echo Killing PID %%a
                        taskkill /F /PID %%a 2>nul
                    )
                    del /Q "%TEMP%\\netstat_out.txt" 2>nul
                    del /Q "%TEMP%\\port8080.txt" 2>nul
                    timeout /t 5 /nobreak

                    REM 2. Clean old WAR and exploded folders
                    del /F /Q "%TOMCAT_HOME%\\webapps\\%DEPLOY_NAME%" 2>nul
                    rmdir /S /Q "%TOMCAT_HOME%\\webapps\\demo" 2>nul
                    del /F /Q "%TOMCAT_HOME%\\webapps\\demo-0.0.1-SNAPSHOT.war" 2>nul
                    rmdir /S /Q "%TOMCAT_HOME%\\webapps\\demo-0.0.1-SNAPSHOT" 2>nul

                    REM 3. Copy exact WAR file
                    copy /Y "target\\%WAR_NAME%" "%TOMCAT_HOME%\\webapps\\%DEPLOY_NAME%"

                    REM 4. Verify WAR size
                    for %%A in ("%TOMCAT_HOME%\\webapps\\%DEPLOY_NAME%") do (
                        echo WAR size: %%~zA bytes
                        if %%~zA LSS 1000000 (
                            echo ERROR: WAR file too small!
                            exit /b 1
                        )
                    )

                    REM 5. Start Tomcat detached — explicitly set CATALINA_HOME
                    set CATALINA_HOME=%TOMCAT_HOME%
                    set CATALINA_BASE=%TOMCAT_HOME%
                    start "" /B cmd /c "set CATALINA_HOME=%TOMCAT_HOME% && set CATALINA_BASE=%TOMCAT_HOME% && %TOMCAT_HOME%\\bin\\startup.bat"

                    echo Deploy successful!
                '''
            }
        }
    }
}