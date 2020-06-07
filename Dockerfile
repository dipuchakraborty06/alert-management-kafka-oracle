FROM openjdk:8-jdk-alpine
RUN mkdir app
RUN cd /app
WORKDIR /app
ADD target/*.jar app/alert-management-kafka-oracle.jar
ENTRYPOINT ["java","-jar","app/alert-management-kafka-oracle.jar"]
