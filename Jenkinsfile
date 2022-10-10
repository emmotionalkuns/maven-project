pipeline {
    agent any

    stages {
        stage('compile') {
            steps {
                // checkout([$class: 'GitSCM', branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: 'https://github.com/bloomytech/maven-project.git']]])
                sh '/opt/maven/bin/mvn compile '
            }
        }
        stage('code-review') {
            steps {
                sh '/opt/maven/bin/mvn -P metrics pmd:pmd  '
            }
            post {
                success{
                    recordIssues(tools: [pmdParser(pattern: '**/pmd.xml')])
                }
            }
        }
        
        stage('Sonar Code Analysis') {
            environment {
            scannerHome = tool 'sonarqube-scanner'
        }
        steps {
            withSonarQubeEnv('sonarqube') { 
                sh "${scannerHome}/bin/sonar-scanner"
            }
            timeout(time: 3, unit: 'MINUTES') {
                waitForQualityGate abortPipeline: true
            }
        }
    }
        
        stage('package') {
            steps {
                sh '/opt/maven/bin/mvn package'
            }
        }
        stage('publish to jfrog') {
            steps {
                rtUpload (
                    serverId: 'jfrog-dev',
                    spec: '''{
                          "files": [
                            {
                              "pattern": "target/kitchensink.war",
                              "target": "non-prod-repo/"
                            }
                         ]
                    }'''
                )
            }
        }
        stage('Deploy') {
            steps {
                ansiblePlaybook credentialsId: 'ansible-token', installation: 'ansible', inventory: 'inventory', playbook: 'playbook.yml'
            }
        }    
    }
}
