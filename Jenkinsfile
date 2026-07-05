pipeline {
    agent any
    environment {
		DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
	    IMAGE_NAME = "vai007/greetapp"   // your Docker Hub repo name
	    IMAGE_TAG  = "v1"          // or use BUILD_NUMBER / GIT_COMMIT
	}
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
        stage('Deploy') {
		    steps {
		        powershell '''
		            docker build -t "$env:IMAGE_NAME:$env:IMAGE_TAG" .
		            Write-Output $env:DOCKERHUB_CREDENTIALS_PSW | docker login -u $env:DOCKERHUB_CREDENTIALS_USR --password-stdin
		            docker push "$env:IMAGE_NAME:$env:IMAGE_TAG"
		            docker run -d --name myapp-container -p 7070:9090 "$env:IMAGE_NAME:$env:IMAGE_TAG"
		        '''
		    }
		}
    }
    
    post {
        success {
            echo 'Pipeline completed successfully!'
        }
        failure {
            echo 'Pipeline failed. Check logs.'
        }
        always {
            cleanWs()
        }
    }  
}