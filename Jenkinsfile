pipeline {
    agent any

    triggers {
        githubPush()
    }

    environment {
        TOMCAT_HOME = 'C:\\tomcat10.1'
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

                    REM 1. Shutdown Tomcat
                    call %TOMCAT_HOME%\\bin\\shutdown.bat

                    REM 2. Force kill if still running after 10s
                    timeout /t 10 /nobreak
                    taskkill /F /IM tomcat*.exe /T 2>nul
                    taskkill /F /FI "WINDOWTITLE eq Tomcat*" /T 2>nul

                    REM 3. Extra wait to release file locks
                    timeout /t 3 /nobreak

                    REM 4. Delete old WAR and exploded folder
                    del /F /Q "%TOMCAT_HOME%\\webapps\\demo.war" 2>nul
                    rmdir /S /Q "%TOMCAT_HOME%\\webapps\\demo" 2>nul
                    del /F /Q "%TOMCAT_HOME%\\webapps\\demo-0.0.1-SNAPSHOT.war" 2>nul
                    rmdir /S /Q "%TOMCAT_HOME%\\webapps\\demo-0.0.1-SNAPSHOT" 2>nul

                    REM 5. Copy new WAR
                    copy /Y target\\*.war "%TOMCAT_HOME%\\webapps\\demo.war"

                    REM 6. Verify file size is not tiny
                    for %%A in ("%TOMCAT_HOME%\\webapps\\demo.war") do (
                        echo WAR size: %%~zA bytes
                        if %%~zA LSS 1000000 (
                            echo ERROR: WAR file too small, copy failed!
                            exit /b 1
                        )
                    )

                    REM 7. Start Tomcat
                    call %TOMCAT_HOME%\\bin\\startup.bat
                '''
            }
        }
    }
}