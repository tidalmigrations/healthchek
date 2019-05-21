FROM zenika/kotlin:alpine AS builder
WORKDIR /app
COPY src /app/src
RUN ls -la
RUN kotlinc src/* -include-runtime -d healthchek.jar

FROM openjdk:jre-alpine
WORKDIR /app
COPY --from=builder /app/healthchek.jar .
ENTRYPOINT ["java", "-jar", "healthchek.jar"]
