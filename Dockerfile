# Stage 1: Build the application with Maven
FROM maven:3.9.6-eclipse-temurin-17-alpine AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Lightweight JRE 17 runtime
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY --from=build /app/target/*.jar app.jar
COPY --from=build /app/src/main/webapp ./src/main/webapp

ENV PORT=8080
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar", "--server.port=8080"]
