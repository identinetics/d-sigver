FROM centos:centos7
LABEL capabilities='--cap-drop=all'

RUN yum -y update \
 && yum -y install epel-release \
 && yum -y install curl git ip lsof make net-tools openssl unzip which xmlstarlet \
 && yum -y install xmlsec1 xmlsec1-openssl \
 && yum -y install java-1.8.0-openjdk-devel.x86_64 \
 && yum -y clean all

# xmlsectool (shibboleth)
ENV version='2.0.0'
RUN mkdir -p /opt && cd /opt \
 && wget "https://shibboleth.net/downloads/tools/xmlsectool/${version}/xmlsectool-${version}-bin.zip" \
 && unzip "xmlsectool-${version}-bin.zip" \
 && ln -s "xmlsectool-${version}" 'xmlsectool' \
 && rm "xmlsectool-${version}-bin.zip"
ENV XMLSECTOOL=/opt/xmlsectool/xmlsectool.sh

# pyFF (uses pyXmlSecurity)
RUN yum -y install python-pip python-devel libxslt-devel \
 && yum clean all
RUN pip install --upgrade pip \
 && pip install six

# use easy_install, solves install bug
# InsecurePlatformWarning can be ignored - this system does not use TLS
RUN easy_install --upgrade six \
 && pip install importlib
#using iso8601 0.1.9 because of str/int compare bug in pyff
RUN pip install future iso8601==0.1.9 \
 && pip install lxml \
 && pip install pykcs11
ENV repodir='/opt/source/pyff'
ENV repourl='https://github.com/leifj/pyFF'
RUN mkdir -p $repodir \
 && cd $repodir \
 && git clone $repourl . \
 && git checkout master \
 && python setup.py install \
COPY install/testdata /opt/testdata
COPY install/scripts/* /
COPY install/tests/* /tests/



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
ENV JAVA_HOME=/etc/alternatives/java_sdk_1.8.0