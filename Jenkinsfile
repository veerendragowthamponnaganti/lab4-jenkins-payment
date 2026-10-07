
pipeline {
    agent any

    stages {

        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build') {
            steps {
                withMaven(maven: 'Maven-3.9.16') {
                    bat 'mvn clean package -DskipTests'
                }
            }
        }

        stage('Test') {
            steps {
                withMaven(maven: 'Maven-3.9.16') {
                    bat 'mvn test'
                }
            }

            post {
                always {
                    junit allowEmptyResults: true,
                          testResults: 'target/surefire-reports/*.xml'
                }
            }
        }

        stage('Archive') {
            steps {
                archiveArtifacts artifacts: 'target/payment-2.7.jar',
                                 fingerprint: true
            }
        }

        stage('Approval') {
            when {
                branch 'main'
            }

            steps {
                timeout(time: 5, unit: 'MINUTES') {
                    input message: 'Approve production deployment?',
                          ok: 'Deploy'
                }
            }
        }

        stage('Deploy') {
            when {
                branch 'main'
            }

            steps {
                withCredentials([
                    usernamePassword(
                        credentialsId: 'production-credentials',
                        usernameVariable: 'DEPLOY_USER',
                        passwordVariable: 'DEPLOY_PASSWORD'
                    )
                ]) {
                    bat '''
                        @echo off
                        echo Deploying approved artifact...
                        echo Deployment user: %DEPLOY_USER%

                        if "%DEPLOY_PASSWORD%"=="" (
                            echo ERROR: Deployment credentials are missing
                            exit /b 1
                        )

                        deploy.bat "%WORKSPACE%\\target\\payment-2.7.jar"
                    '''
                }
            }
        }
    }

    post {

        always {
            echo 'Pipeline execution completed.'
            cleanWs()
        }

        success {
            echo 'SUCCESS: Production deployment completed successfully.'
        }

        failure {
            echo 'FAILURE: Build, test, or deployment failed.'
        }

        aborted {
            echo 'ABORTED: Production deployment was rejected or cancelled.'
        }
    }
}
