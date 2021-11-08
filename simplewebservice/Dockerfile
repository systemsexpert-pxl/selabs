FROM openjdk:17-jdk-alpine
EXPOSE 8080
ADD /target/simplewebservice*.jar simplewebservice.jar
ENTRYPOINT ["java", "-jar", "simplewebservice.jar"]
