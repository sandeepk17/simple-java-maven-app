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
        ARTIFACTORY_URL = "http://192.168.0.101:8081/artifactory"
        ARTIFACTORY_CREDENTIALS = "admin.jfrog"
        CURRENT_BUILD_NO = "${currentBuild.number}"
        RELEASE_TAG = "${currentBuild.number}-${VERSION}"
        CURRENT_BRANCH = "${env.BRANCH_NAME}"
        OCTOHOME = "${OCTO_HOME}"
    }

    stages {
        stage ('Environmental Variables') {
            steps {
                sh '''
                    echo "PATH = ${PATH}"
                    echo "${OCTOHOME}"
                    echo "M2_HOME = ${M2_HOME}"
                    echo "OCTO_HOME = ${OCTO_HOME}"
                '''
            }
        }
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
                //sh 'mvn -B -DskipTests clean package -s settings.xml'
            }
        }
        stage('Test') {
            steps {
                //sh 'mvn test'
                echo "Test stage"
            }
            //post {
            //    always {
            //        junit 'target/surefire-reports/*.xml'
            //    }
            //}
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

        stage('Deploy') {
            steps{        
                echo " Deploy to artifactory"
            }
        }

        stage ('Deploy to Octopus') {
            steps {
                echo " Deploy to artifactory"
                withCredentials([string(credentialsId: 'OctopusAPIkey', variable: 'APIKey')]) {
                    sh 'octo help'
                    sh 'octo pack --id="DK" --version="1.0.0" --basePath="$WORKSPACE/distDK" --outFolder="$WORKSPACE"'
                    sh 'octo pack --id="UK" --version="1.0.0" --basePath="$WORKSPACE/distUK" --outFolder="$WORKSPACE"'
                }
            }
        }
    }
}