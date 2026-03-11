pipeline {
    agent any

    triggers {
        githubPush()
    }

    environment {
        TOMCAT_HOME   = 'C:\\tomcat10.1'
        CATALINA_HOME = 'C:\\tomcat10.1'
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

                // Verify WAR was built correctly
                bat '''
                    echo === Built WAR files ===
                    dir target\\*.war
                '''
            }
        }

        stage('Deploy to Tomcat') {
            steps {
                bat '''
                    @echo off

                    REM 1. Shutdown Tomcat
                    set CATALINA_HOME=C:\\tomcat10.1
                    call %TOMCAT_HOME%\\bin\\shutdown.bat
                    timeout /t 10 /nobreak

                    REM 2. Force kill java process running Tomcat
                    for /f "tokens=5" %%a in ('netstat -aon ^| find ":8080" ^| find "LISTENING"') do (
                        echo Killing PID %%a on port 8080
                        taskkill /F /PID %%a 2>nul
                    )
                    timeout /t 3 /nobreak

                    REM 3. Clean old deployments
                    del /F /Q "%TOMCAT_HOME%\\webapps\\demo.war" 2>nul
                    rmdir /S /Q "%TOMCAT_HOME%\\webapps\\demo" 2>nul
                    del /F /Q "%TOMCAT_HOME%\\webapps\\demo-0.0.1-SNAPSHOT.war" 2>nul
                    rmdir /S /Q "%TOMCAT_HOME%\\webapps\\demo-0.0.1-SNAPSHOT" 2>nul

                    REM 4. Copy WAR - explicit filename
                    copy /Y "target\\demo-0.0.1-SNAPSHOT.war" "%TOMCAT_HOME%\\webapps\\demo.war"

                    REM 5. Verify size
                    for %%A in ("%TOMCAT_HOME%\\webapps\\demo.war") do (
                        echo Copied WAR size: %%~zA bytes
                        if %%~zA LSS 1000000 (
                            echo ERROR: WAR file too small!
                            exit /b 1
                        )
                    )

                    REM 6. Start Tomcat
                    call %TOMCAT_HOME%\\bin\\startup.bat
                    echo Tomcat started!
                '''
            }
        }
    }
}