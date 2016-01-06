FROM kurron/docker-oracle-jdk-8:latest

MAINTAINER Ron Kurr <kurr@kurron.org>

ADD https://services.gradle.org/distributions/gradle-2.10-bin.zip /tmp/gradle.zip

RUN apt-get --quiet update && \
    apt-get --quiet --yes install unzip && \
    apt-get clean && \
    unzip /tmp/gradle.zip -d /opt && \
    rm /tmp/gradle.zip

ENV GRADLE_HOME=/opt/gradle-2.10
ENV GRADLE_USER_HOME=/tmp
ENV GRADLE_OPTS=-Dorg.gradle.native=false -Duser.name=root -Duser.home=/tmp -Duser.dir=/tmp
ENV PATH $PATH:$GRADLE_HOME/bin

COPY gradle.properties /tmp
COPY build.gradle /tmp

VOLUME ["/templates"]

#WORKDIR /opt/ecs-publication
WORKDIR /tmp

ENV HOME=/tmp
ENV USER=root
USER root:root

ENTRYPOINT ["gradle", "--info", "--stacktrace", "--build-file", "/tmp/build.gradle", "--project-dir", "/tmp", "--project-cache-dir", "/tmp"]
