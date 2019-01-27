pipeline {
    agent any 

    parameters {
        string(defaultValue: "0.0.1-SNAPSHOT", description: 'Application Version', name: 'appVersion')
    }

    stages {
        stage('Preparation') { 
            steps { 
                git 'https://github.com/ptkweller/dog_platform.git'
            }
        }
        stage('Build'){
            steps {
                sh "echo Download & Build"
            }
        }
        stage('Test'){
            steps {
                sh "echo Run Unit Tests"
            }
        }
        stage('Package'){
            steps {
                sh "echo Package - Upload to Nexus"
            }
        }
        stage('Deploy') {
            steps {
				sh "echo Deploying to server"
            }
        }
    }
}