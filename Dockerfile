FROM kurron/docker-jetbrains-base:latest

MAINTAINER Ron Kurr <kurr@kurron.org>

ADD https://services.gradle.org/distributions/gradle-2.10-bin.zip /tmp/gradle.zip

RUN apt-get --quiet update && \
    apt-get --quiet --yes install unzip && \
    apt-get clean && \
    unzip /tmp/gradle.zip -d /opt && \
    mkdir -p /opt/ecs-publication && \
    chown developer:developer /opt/ecs-publication && \
    rm /tmp/gradle.zip

ENV GRADLE_HOME=/opt/gradle-2.10
ENV PATH $PATH:$GRADLE_HOME/bin

VOLUME ["/templates"]

USER developer:developer
WORKDIR /opt/ecs-publication
COPY gradle.properties /opt/ecs-publication
COPY build.gradle /opt/ecs-publication
ENTRYPOINT ["gradle"]
