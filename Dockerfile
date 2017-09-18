FROM centos:centos7
LABEL capabilities='--cap-drop=all'

RUN yum -y update \
 && yum -y install epel-release \
 && yum -y install curl git ip lsof make net-tools openssl unzip which xmlstarlet \
 && yum -y install xmlsec1
 && yum -y install java-1.8.0-openjdk-devel.x86_64 \
 && yum -y clean all

#RUN curl -O https://www-eu.apache.org/dist/xalan/xalan-j/binaries/xalan-j_2_7_2-bin-2jars.tar.gz \
# && tar -xzf xalan-j_2_7_2-bin-2jars.tar.gz \
# && rm xalan-j_2_7_2-bin-2jars.tar.gz

COPY install/opt/xmlsectool /opt/xmlsectool
ENV XMLSECTOOL=/opt/xmlsectool/xmlsectool.sh

# Application will run as a non-root user/group that must map to the docker host
ARG USERNAME=sigver
RUN adduser $USERNAME

COPY install/scripts/*.sh /opt/bin
RUN chmod +x /start.sh /*.sh \
 && chown -R $USERNAME:$USERNAME /opt/

VOLUME /pwd
USER $USERNAME
CMD ["/opt/bin/xmldsigver.sh"]
