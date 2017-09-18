FROM centos:centos7
LABEL capabilities='--cap-drop=all'

RUN yum -y update \
 && yum -y install epel-release \
 && yum -y install curl git ip lsof make net-tools openssl unzip which xmlstarlet \
 && yum -y install xmlsec1 \
 && yum -y install java-1.8.0-openjdk-devel.x86_64 \
 && yum -y clean all

COPY install/opt/xmlsectool /opt/xmlsectool
ENV XMLSECTOOL=/opt/xmlsectool/xmlsectool.sh

# Application will run as a non-root user/group that must map to the docker host
ARG USERNAME=sigver
RUN adduser $USERNAME

COPY install/scripts/*.sh /opt/bin/
RUN chmod -R +x /opt/bin/ \
 && mkdir /pwd \
 && chown -R $USERNAME:$USERNAME /opt /pwd

VOLUME /pwd
USER $USERNAME
CMD ["/opt/bin/xmldsigver.sh"]
