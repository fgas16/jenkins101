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
                echo "Testing (coverage only).."
                sh '''
                  set -e
                  cd app
                  mkdir -p reports
                  # Gera cobertura em HTML e também o XML (opcional para arquivar)
                  python3 -m pytest unit/ \
                    --cov=. \
                    --cov-report=html:reports/htmlcov \
                    --cov-report=xml:reports/coverage.xml \
                    --cov-report=term
                '''
            }
        }

        stage('Deliver') {
            steps {
                echo 'Publicando coverage HTML...'
                // Publica o HTML (requer plugin HTML Publisher)
                publishHTML(target: [
                  reportDir: 'app/reports/htmlcov',
                  reportFiles: 'index.html',
                  reportName: 'Test Coverage',
                  allowMissing: true,
                  keepAll: true,
                  alwaysLinkToLastBuild: true
                ])

                // Opcional: também arquiva o XML de cobertura
                archiveArtifacts artifacts: 'app/reports/coverage.xml', fingerprint: true
            }
        }
    }
}
