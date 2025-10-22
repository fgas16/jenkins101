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

                // 1) Publicar testes JUnit (permite vazio para não quebrar o job)
                junit allowEmptyResults: true, testResults: 'app/reports/junit.xml'

                // 2) Publicar cobertura (forma simplificada)
                script {
                try {
                    // Caminho deve existir e o XML estar válido (Cobertura)
                    publishCoverage adapters: [coberturaAdapter('app/reports/coverage.xml')]
                } catch (err) {
                    // Se o plugin não estiver instalado ou o XML faltar, não quebre o pipeline
                    echo "Coverage publish skipped/failure: ${err}"
                }
                }

                // 3) Gerar “release” apenas no Jenkins
                sh '''
                cd app
                mkdir -p dist
                tar -czf dist/app-${BUILD_NUMBER}.tar.gz .
                ls -la dist
                '''
                archiveArtifacts artifacts: 'app/dist/app-*.tar.gz', fingerprint: true
            }
        }
    }
}
