FROM maven:3.9.11-eclipse-temurin-17-alpine as build

WORKDIR /usr/src/mymaven

ARG repo=https://github.com/sakaiproject/sakai.git
ARG branch=master

RUN apk add git \
  && git clone ${repo} . \
  && git checkout ${branch}

RUN mkdir /deploy && mvn clean install --no-transfer-progress -T 1C sakai:deploy-exploded -Dmaven.tomcat.home=/deploy -Dmaven.test.skip=true

FROM tomcat:9-jdk17-temurin

ENV JAVA_OPTS "-Dsakai.demo=false"

WORKDIR /usr/local/tomcat

COPY resources/tomcat/sakai ./sakai
COPY resources/tomcat/conf/* ./conf/
COPY resources/tomcat/bin/setenv.sh ./bin/

COPY --from=build /deploy/webapps/ ./webapps/
COPY --from=build /deploy/lib/ ./lib/
COPY --from=build /deploy/components ./components

COPY resources/tomcat/bin/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
