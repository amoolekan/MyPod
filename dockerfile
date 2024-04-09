FROM tomcat
COPY /target/*.war /usr/local/tomcat/webapps/test.war
EXPOSE 8080
