FROM gradle:6-jdk8 AS build
ARG VERSION
ENV VERSION ${VERSION:-1.8.2}

COPY . /home/gradle

RUN chown -R gradle:gradle /home/gradle


WORKDIR /home/gradle
RUN gradle build --no-daemon 

FROM openjdk:8-jre-slim
ARG VERSION
ENV VERSION ${VERSION:-1.8.2}

RUN mkdir /app
WORKDIR /app

COPY --from=build /home/gradle/build/libs/xml-avro-all-${VERSION}.jar /app/xml-avro.jar

CMD ["java", "-XX:+UnlockExperimentalVMOptions", "-XX:+UseCGroupMemoryLimitForHeap", "-Djava.security.egd=file:/dev/./urandom","-jar","/app/xml-avro.jar", "-c", "config.yml"]
