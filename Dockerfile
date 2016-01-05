FROM kurron/docker-jetbrains-base:latest

MAINTAINER Ron Kurr <kurr@kurron.org>

ADD https://services.gradle.org/distributions/gradle-2.10-bin.zip /tmp/gradle.zip

RUN apt-get --quiet update && \
    apt-get --quiet --yes install unzip && \
    apt-get clean && \
    unzip /tmp/gradle.zip -d /opt && \
    rm /tmp/gradle.zip

ENV GRADLE_HOME=/opt/gradle-2.10
ENV PATH $PATH:$GRADLE_HOME/bin

USER developer:developer
WORKDIR /home/developer
ENTRYPOINT ["gradle", "--version"]
