pipeline {
    agent { node { label 'docker-agent-python' } }
    triggers { pollSCM '* * * * *' }

    stages {
        stage('Build') {
            steps {
                echo "Building.."
                sh '''
                cd app
                pip install -r requirements.txt
                '''
            }
        }

        stage('Test') {
            steps {
                echo "Testing.."
                sh '''
                set -e
                cd app
                mkdir -p reports
                # JUnit + Cobertura (coverage.xml)
                python3 -m pytest unit/ \
                  --junitxml=reports/junit.xml \
                  --cov=. \
                  --cov-report=xml:reports/coverage.xml \
                  --cov-report=term
                '''
            }
        }

        stage('Deliver') {
            steps {
                echo 'Deliver...'
                // Publica relatórios no Jenkins
                junit 'app/reports/junit.xml'
                publishCoverage adapters: [coberturaAdapter('app/reports/coverage.xml')],
                                 sourceFileResolver: sourceFiles('STORE_LAST_BUILD')

                // "Release" apenas dentro do Jenkins (artefato versionado pelo build)
                sh '''
                cd app
                mkdir -p dist
                tar -czf dist/app-${BUILD_NUMBER}.tar.gz .
                '''
                archiveArtifacts artifacts: 'app/dist/app-*.tar.gz', fingerprint: true
            }
        }
    }
}
