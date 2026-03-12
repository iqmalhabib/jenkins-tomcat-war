pipeline {
    agent any
    triggers {
        githubPush()
    }
    environment {
        TOMCAT_HOME  = 'C:\\tomcat10.1'
        WAR_NAME     = 'demo-0.0.1-SNAPSHOT.war'
        DEPLOY_NAME  = 'demo.war'
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
                    echo === Debug Info ===
                    echo WORKSPACE:    %WORKSPACE%
                    echo TOMCAT_HOME:  %TOMCAT_HOME%
                    echo WAR_NAME:     %WAR_NAME%
                    echo DEPLOY_NAME:  %DEPLOY_NAME%

                    REM Verify WAR was built
                    if not exist "%WORKSPACE%\\target\\%WAR_NAME%" (
                        echo ERROR: WAR not found at %WORKSPACE%\\target\\%WAR_NAME%
                        dir "%WORKSPACE%\\target\\"
                        exit /b 1
                    )

                    REM Clean old deployment
                    if exist "%TOMCAT_HOME%\\webapps\\%DEPLOY_NAME%"          del /F /Q "%TOMCAT_HOME%\\webapps\\%DEPLOY_NAME%"
                    if exist "%TOMCAT_HOME%\\webapps\\demo"                   rmdir /S /Q "%TOMCAT_HOME%\\webapps\\demo"
                    if exist "%TOMCAT_HOME%\\webapps\\demo-0.0.1-SNAPSHOT.war" del /F /Q "%TOMCAT_HOME%\\webapps\\demo-0.0.1-SNAPSHOT.war"
                    if exist "%TOMCAT_HOME%\\webapps\\demo-0.0.1-SNAPSHOT"    rmdir /S /Q "%TOMCAT_HOME%\\webapps\\demo-0.0.1-SNAPSHOT"

                    REM Copy WAR to Tomcat
                    copy /Y "%WORKSPACE%\\target\\%WAR_NAME%" "%TOMCAT_HOME%\\webapps\\%DEPLOY_NAME%"

                    REM Verify WAR size
                    for %%A in ("%TOMCAT_HOME%\\webapps\\%DEPLOY_NAME%") do (
                        echo WAR size: %%~zA bytes
                        if %%~zA LSS 1000000 (
                            echo ERROR: WAR file too small!
                            exit /b 1
                        )
                    )
                    echo Deploy successful!
                '''
            }
        }
    }
}
