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
                sh 'mvn clean package -DskipTests'
            }
        }

        stage('Test') {
            steps {
                sh 'mvn test'
            }

            post {
                always {
                    junit 'target/surefire-reports/*.xml'
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
                script {
                    try {
                        timeout(time: 5, unit: 'MINUTES') {
                            input message: 'Approve production deployment?',
                                  ok: 'Deploy'
                        }
                    } catch (err) {
                        currentBuild.result = 'ABORTED'
                        error('Production deployment rejected')
                    }
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
                    sh '''
                        echo "Deploying approved artifact..."
                        ./deploy.sh target/payment-2.7.jar
                    '''
                }
            }
        }
    }

    post {

        always {
            echo "Pipeline execution completed."
            cleanWs()
        }

        success {
            echo "SUCCESS: Production deployment completed successfully."
        }

        failure {
            echo "FAILURE: Build, test, or deployment failed."
        }

        aborted {
            echo "ABORTED: Production deployment was rejected or cancelled."
        }
    }
}