#!/bin/bash -e

###########################
# Build/download Extension #
###########################

if [ "$GIT_REPO" != "" ]; then
    if [ "$GIT_BRANCH" == "" ]; then
        GIT_BRANCH="master"
    fi

    # Install Maven
    cd /opt/jboss
    curl -s https://apache.uib.no/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz | tar xz
    mv apache-maven-3.5.4 /opt/jboss/maven
    export M2_HOME=/opt/jboss/maven
    if [ "$PROXY_SERVER_HOST" != "" ]; then
        mv /opt/jboss/maven/conf/settings.xml /opt/jboss/maven/conf/settings.xml.bak
        cp /opt/jboss/tools/maven_settings.xml.template /opt/jboss/maven/conf/settings.xml
        sed -i -e "s/PROXY_SERVER_HOST/${PROXY_SERVER_HOST}/g" /opt/jboss/maven/conf/settings.xml
        sed -i -e "s/PROXY_SERVER_PORT/${PROXY_SERVER_PORT}/g" /opt/jboss/maven/conf/settings.xml
        sed -i -e "s/NO_PROXY_HOSTS/${NO_PROXY_HOSTS}/g" /opt/jboss/maven/conf/settings.xml
        sed -i -e "s/PROXY_SERVER_USER/${PROXY_SERVER_USER}/g" /opt/jboss/maven/conf/settings.xml
        sed -i -e "s/PROXY_SERVER_PASSWORD/${PROXY_SERVER_PASSWORD}/g" /opt/jboss/maven/conf/settings.xml
    fi

    # Clone repository
    git clone --depth 1 $GIT_REPO -b $GIT_BRANCH /opt/jboss/apicurio-keycloak-extensions

    # Build
    cd /opt/jboss/apicurio-keycloak-extensions

    MASTER_HEAD=`git log -n1 --format="%H"`
    echo "Keycloak extension from [build]: $GIT_REPO/$GIT_BRANCH/commit/$MASTER_HEAD"

    $M2_HOME/bin/mvn package
fi

