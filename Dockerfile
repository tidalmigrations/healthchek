FROM --platform=$BUILDPLATFORM openjdk:8-jdk-slim AS builder
COPY . /
RUN ./gradlew --no-daemon distTar

FROM openjdk:8-jre-alpine
COPY --from=builder /app/build/distributions/healthchek.tar .
RUN tar -xf healthchek.tar
ENTRYPOINT ["/healthchek/bin/healthchek"]
