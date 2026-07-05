pipeline {
    agent any
    triggers { githubPush() }
    stages {
        stage('Build') {
            steps {
                powershell """
                    dir
                    java -version
                    mvn -version
                    mvn clean package
                    dir
                """    
            }
        }
    }  
}