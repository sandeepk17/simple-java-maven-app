pipeline {
    agent {
        // Set Build Agent as Docker file 
        dockerfile true
    }
    environment {
        // Set env variables for Pipeline
        IMAGE = readMavenPom().getArtifactId()
        VERSION = readMavenPom().getVersion()
        ARTIFACTORY_SERVER_ID = "Artifactory1"
        ARTIFACTORY_URL = "http://192.168.0.104:8081/artifactory"
        ARTIFACTORY_CREDENTIALS = "admin.jfrog"
        CURRENT_BUILD_NO = "${currentBuild.number}"
        RELEASE_TAG = "${currentBuild.number}-${VERSION}"
        CURRENT_BRANCH = "${env.BRANCH_NAME}"
    }
    options {
        // Set Jenkins Pipeline options
        buildDiscarder(logRotator(numToKeepStr: '30', artifactNumToKeepStr: '30'))
        timestamps()
        disableConcurrentBuilds()
    }

    stages {
        stage('Build') {
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                    echo "M2_HOME = ${M2_HOME}"
                    echo "OCTO_HOME = ${OCTO_HOME}"
                    mvn --version 
                '''
                echo "${VERSION}"
                echo "${IMAGE}"
                echo "${CURRENT_BRANCH}"
                echo "$WORKSPACE"
                sh 'mvn -B -DskipTests clean package'
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
        
        stage('Octopus Deploy') {
            steps{        
                echo "Test stage"
            }
        }

        stage('Smoke test') {
            steps{        
                echo "Smoke Test stage"
            }
        }

        stage('Integration Test') {
            steps{        
                echo " Deploy to artifactory"
            }
        }

        stage('Deploy') {
            steps{        
                echo " Deploy to artifactory"
            }
        }
        stage('Deliver') { 
            steps {
                sh './jenkins/scripts/deliver.sh' 
            }
        }
    }
    // Cleanup Workspace
    post { 
        always {
            echo 'One way or another, I have finished'
            deleteDir()
        }
        success {
            echo 'I succeeeded!'
        }
        unstable {
            echo 'I am unstable :/'
        }
        failure {
            echo 'I failed :('
        }
    }
}