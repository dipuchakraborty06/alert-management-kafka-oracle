FROM openjdk:8-jdk-alpine
ARG JAR_FILE=../target/*.jar
COPY ${JAR_FILE} alert-management-kafka-oracle.jar
ENTRYPOINT ["java","-jar","/app.jar"]