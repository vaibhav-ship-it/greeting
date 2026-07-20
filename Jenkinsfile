pipeline {
    agent any
    
	environment {
		DOCKERHUB_CREDENTIALS = credentials('dockerhub-creds')
	    IMAGE_NAME = "vai007/greeting"   // your Docker Hub repo name
	    IMAGE_TAG  = "v1"          // or use BUILD_NUMBER / GIT_COMMIT
	    CONTAINER_NAME = "greet-container"
	}
    
    triggers { githubPush() }
    stages {
		stage('Checkout') {
		    steps {
		        git branch: 'main',
		            url: 'https://github.com/vaibhav-ship-it/greeting.git'
		    }
		}

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
        stage('Stop old container')	{
			steps	{
				powershell '''
					$containerId = docker ps -q -f "name=$env:CONTAINER_NAME"
                    if ($containerId) {
                        docker stop $env:CONTAINER_NAME
                        docker rm $env:CONTAINER_NAME
                    }
                '''                
			}
		}
        stage('Deploy') {
		    steps {
		        withCredentials([usernamePassword(credentialsId: 'dockerhub-creds', usernameVariable: 'DOCKER_USER', passwordVariable: 'DOCKER_PASS')]) {
		            powershell '''
		                docker build -t "$env:IMAGE_NAME:$env:IMAGE_TAG" .
		                echo $env:DOCKER_USER
		                echo $env:DOCKER_PASS
		                [Console]::Out.Write($env:DOCKER_PASS) | docker login -u $env:DOCKER_USER --password-stdin
		                
		                docker push "$env:IMAGE_NAME:$env:IMAGE_TAG"
		                docker run -d --name $env:CONTAINER_NAME -p 7070:9090 "$env:IMAGE_NAME:$env:IMAGE_TAG"
		            '''
		        }
		    }
		}
		stage('Cleanup')	{
			steps	{
				cleanWs()
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
    }
}