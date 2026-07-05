FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY target/greeting-0.0.1-SNAPSHOT.jar greet.jar
ENTRYPOINT ["java","-jar","greet.jar"]
