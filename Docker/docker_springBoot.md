# Docker Spring Boot

- <https://spring.io/guides/gs/spring-boot-docker/>

- <https://start.spring.io/>
  - Choose these options: Project: Maven / Language: Java / Dependencies: Spring Web
  - get zip and unzip.
- ./gradlew build && java -jar build/libs/complete-0.0.1-SNAPSHOT.jar

- https://spring.io/guides/gs/spring-boot-docker/

```dockerfile
FROM openjdk:8-jdk-alpine
ARG JAR_FILE=build/libs/complete-0.0.1-SNAPSHOT.jar
COPY ${JAR_FILE} app.jar
ENTRYPOINT ["java","-jar","/app.jar"]
```

1. go to: https://start.spring.io/
   1. Choose these options: Project: Maven / Language: Java / Dependencies: Spring Web
2. unzip and cd into it.
3. `./gradlew build && java -jar build/libs/complete-0.0.1-SNAPSHOT.jar`
4. create docker file:

```dockerfile
FROM openjdk:8-jdk-alpine
ARG JAR_FILE=build/libs/complete-0.0.1-SNAPSHOT.jar
COPY \${JAR_FILE} app.jar
ENTRYPOINT \["java","-jar","/app.jar"\]
```

**Gradle**

- gradle project //install gradle to cmd line. gradle //should tell you what version you have.
- gradle build //outputs a build folder.
- runs on port 8080
- /var/lib/jenkins/workspace/devopTestLab-multi-branch_bryon/build/reports/jacoco/test/jacocoTestReport.xml
  - ./gradlew build jacocoTestReport output
