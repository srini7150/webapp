FROM tomcat:8.5.82-jre8-openjdk-slim-buster
COPY target/*.war /usr/local/tomcat/webapps/webapp.war