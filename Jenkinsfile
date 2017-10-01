pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh '''
                echo 'Building..'
                ln -sf conf.sh.default conf.sh
                ./dscripts/build.sh
                '''
            }
        }
        stage('Test') {
            steps {
                sh '''
                echo 'Testing pyFF signature'
                ./dscripts/run.sh -Ip /tests/test_pyff_signature.sh
                '''
            }
        }
    }
}
