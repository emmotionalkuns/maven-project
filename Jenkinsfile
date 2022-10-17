pipeline {
    agent any

    stages {
        stage('compile code') {
            steps {
              sh '/opt/maven/bin/mvn compile '
            }
        }
        stage('PMD code-review') {
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
        
        stage('package app') {
            steps {
                sh '/opt/maven/bin/mvn package'
            }
        }
        stage('publish app to jfrog') {
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
        stage('Ansible Deploy to httpd') {
            steps {
                ansiblePlaybook becomeUser: null, credentialsId: 'ansible-token', disableHostKeyChecking: true, installation: 'ansible', inventory: 'inventory', playbook: 'playbook.yml', sudoUser: null
            }
        }
        stage('Build Docker Image'){
            steps{
                sh 'docker build -t bloomy/myapp:$BUILD_NUMBER .'
            }
        }	
    }
}
