FROM openweb/oracle-tomcat:7-jre8
MAINTAINER Nigel Banks <nigel.g.banks@gmail.com>

LABEL "License"="GPLv3" \
      "Version"="0.0.1"

# Scripts to simplify the building process.
COPY rootfs/sbin /sbin

# Install essentials and the s6-overlay.
ARG S6_VERSION="1.19.1.1"
ARG CONFD_VERSION="0.11.0"
RUN apt-install \
      curl \
      ca-certificates \
    && \
    curl -L https://github.com/just-containers/s6-overlay/releases/download/v${S6_VERSION}/s6-overlay-amd64.tar.gz | \
    tar -xzf - -C / && \
    curl -L -o /usr/local/bin/confd https://github.com/kelseyhightower/confd/releases/download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 && \
    chmod a+x /usr/local/bin/confd && \
    cleanup


# Add Tomcat user.
RUN addgroup tomcat && \
    adduser --system --disabled-password --no-create-home --ingroup tomcat --shell /sbin/nologin --home ${CATALINA_HOME} tomcat

# Adore-Djatoka is installed by this copy.
COPY rootfs /

ENV KAKADU_HOME=/opt/adore-djatoka/bin/Linux-x86-64
RUN chown -R tomcat:tomcat ${CATALINA_HOME} ${KAKADU_HOME}

ENTRYPOINT [ "/init" ]
