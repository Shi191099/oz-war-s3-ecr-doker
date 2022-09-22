FROM tomcat:8.0.20-jre8
COPY target/maven*.war /usr/local/tomcat/webapps/maven-0.0.1.war
