FROM maven:3.9.9-sapmachine-11 AS base

WORKDIR /app

COPY . .

RUN mvn clean package

FROM tomcat:8.5.82-jre8-openjdk-slim-buster

COPY --from=base /app/target/webapp-*.war /usr/local/tomcat/webapps/webapp.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
