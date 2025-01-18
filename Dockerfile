FROM openjdk:19-jdk-slim

WORKDIR /app

COPY helloworldapi/target/helloworldapi-0.0.1-SNAPSHOT.jar /app/helloworldapi.jar


EXPOSE 8080


ENTRYPOINT ["java", "-jar", "/app/helloworldapi.jar"]

