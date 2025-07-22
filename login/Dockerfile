FROM openjdk:21-jdk
VOLUME /tmp
ARG JAR_FILE=target/login-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} app.jar

COPY src/main/resources/ src/main/resources/

ENTRYPOINT ["java", "-jar", "/app.jar"]
