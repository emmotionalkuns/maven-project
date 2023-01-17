pipeline {
    agent any

    stages {
        
        stage('Ansible Deploy to httpd') {
            steps {
                ansiblePlaybook becomeUser: null, credentialsId: 'ansible-token', disableHostKeyChecking: true, installation: 'ansible', inventory: 'inventory', playbook: 'playbook.yml', sudoUser: null
            }
        }

    }
}
