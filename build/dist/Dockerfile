FROM jboss/base-jdk:8

ARG GIT_REPO=https://github.com/Apicurio/apicurio-keycloak-extensions.git
ARG GIT_BRANCH=master
ARG PROXY_SERVER_HOST
ARG PROXY_SERVER_PORT=80
ARG PROXY_SERVER_USER
ARG PROXY_SERVER_PASSWORD
ARG NO_PROXY_HOSTS

VOLUME /opt/jboss/out

USER root

RUN yum update -y && yum install -y epel-release git && yum clean all

ADD tools /opt/jboss/tools
RUN /opt/jboss/tools/build.sh

ENTRYPOINT [ "/opt/jboss/tools/docker-entrypoint.sh" ]

