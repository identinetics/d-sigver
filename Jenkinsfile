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
                echo 'Create pyFF signature and validate with xmlsectool and xmlsec1'
                mkdir -p ./work && chmod 777 ./work
                ./dscripts/run.sh -Ip /tests/test_pyff_signature.sh
                '''
            }
        }
    }
}
