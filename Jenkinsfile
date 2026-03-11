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
                    call %TOMCAT_HOME%\\bin\\shutdown.bat
                    timeout /t 5 /nobreak
                    copy /Y target\\*.war %TOMCAT_HOME%\\webapps\\demo.war
                    call %TOMCAT_HOME%\\bin\\startup.bat
                '''
            }
        }
    }
}