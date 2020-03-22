FROM centos:centos7

ARG JAVA_VERSION=12.0.1
ARG JAVA_BUILD=12

# Update CentOS
RUN yum update -y && \
    yum clean all
RUN yum install -y wget git nano glibc-langpack-en
ENV LANG en_US.UTF-8

RUN \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-7                 && \
    yum -y updateinfo                                                  && \
    yum -y install \
    yum-utils \
    epel-release \
    http://yumrepo.eea.europa.eu/centos/eea-release-1-0.1.noarch.rpm && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-7                 && \
    rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EEA                    && \
    yum clean all

# Install java
RUN curl -sOL https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.1%2B${JAVA_BUILD}/OpenJDK12U-jdk_x64_linux_hotspot_${JAVA_VERSION}_${JAVA_BUILD}.tar.gz && \
    mkdir /usr/share/java && \
    tar zxf OpenJDK12U-jdk_x64_linux_hotspot_${JAVA_VERSION}_${JAVA_BUILD}.tar.gz -C /usr/share/java && \
    rm -rf OpenJDK12U-jdk_x64_linux_hotspot_${JAVA_VERSION}_${JAVA_BUILD}.tar.gz
# Set Java home
ENV JAVA_HOME /usr/share/java/jdk-${JAVA_VERSION}+${JAVA_BUILD}
ENV PATH $PATH:$JAVA_HOME/bin
# Install Maven
RUN yum install -y wget && \
    wget --no-verbose -O /tmp/apache-maven-3.3.9.tar.gz http://archive.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
    echo "516923b3955b6035ba6b0a5b031fbd8b /tmp/apache-maven-3.3.9.tar.gz" | md5sum -c && \
    tar xzf /tmp/apache-maven-3.3.9.tar.gz -C /opt/ && \
    ln -s /opt/apache-maven-3.3.9 /opt/maven && \
    ln -s /opt/maven/bin/mvn /usr/local/bin && \
    rm -f /tmp/apache-maven-3.3.9.tar.gz && \
    yum clean all
ENV MAVEN_HOME=/opt/maven M2_HOME=/opt/maven
# Install Oracle tools
# RUN yum install https://download.oracle.com/otn_software/linux/instantclient/193000/oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm -y
# RUN yum install https://download.oracle.com/otn_software/linux/instantclient/193000/oracle-instantclient19.3-sqlplus-19.3.0.0.0-1.x86_64.rpm -y
# RUN yum install https://download.oracle.com/otn_software/linux/instantclient/193000/oracle-instantclient19.3-tools-19.3.0.0.0-1.x86_64.rpm -y
# RUN yum install https://download.oracle.com/otn_software/linux/instantclient/193000/oracle-instantclient19.3-jdbc-19.3.0.0.0-1.x86_64.rpm -y
RUN curl -sSfL https://rpm.octopus.com/octopuscli.repo -o /etc/yum.repos.d/octopuscli.repo && \
    yum install octopuscli

ENV PATH="/usr/lib/oracle/19.3/client64/bin:${PATH}"
# Set Timezone
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

COPY ./pom.xml /var/temp/pom.xml
COPY ./settings.xml /var/temp/settings.xml
CMD ["jshell"]