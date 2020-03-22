FROM centos:centos7

# install java version
#ARG JAVA_VERSION=12.0.1
#ARG JAVA_BUILD=12

# Update CentOS
RUN yum update -y && \
    yum clean all
RUN yum install -y wget git nano glibc-langpack-en
ENV LANG en_US.UTF-8

ENV JAVA_HOME="/usr/lib/jvm/java-1.8.0-openjdk" \
    JAVA="/usr/lib/java-1.8.0-openjdk/bin/java" \
    TIME_ZONE="Europe/Paris"

 RUN set -x \
     && yum update -y \
     && yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel wget iputils nc vim libcurl\
     && ln -snf /usr/share/zoneinfo/$TIME_ZONE /etc/localtime && echo '$TIME_ZONE' > /etc/timezone \
     && yum clean all

## Install java
#RUN curl -sOL https://github.com/AdoptOpenJDK/openjdk12-binaries/releases/download/jdk-12.0.1%2B${JAVA_BUILD}/OpenJDK12U-jdk_x64_linux_hotspot_${JAVA_VERSION}_${JAVA_BUILD}.tar.gz && \
#    mkdir /usr/share/java && \
#    tar zxf OpenJDK12U-jdk_x64_linux_hotspot_${JAVA_VERSION}_${JAVA_BUILD}.tar.gz -C /usr/share/java && \
#    rm -rf OpenJDK12U-jdk_x64_linux_hotspot_${JAVA_VERSION}_${JAVA_BUILD}.tar.gz
## Set Java home
#ENV JAVA_HOME /usr/share/java/jdk-${JAVA_VERSION}+${JAVA_BUILD}
#ENV PATH $PATH:$JAVA_HOME/bin

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

RUN  wget --no-verbose -O /tmp/OctopusTools.7.3.0.linux-x64.tar.gz  https://download.octopusdeploy.com/octopus-tools/7.3.0/OctopusTools.7.3.0.linux-x64.tar.gz && \
    echo "E054882DBB2A314FF5694072DD7452BC /tmp/OctopusTools.7.3.0.linux-x64.tar.gz" | md5sum -c && \
    chmod +x /tmp/OctopusTools.7.3.0.linux-x64.tar.gz && \
    tar xzf /tmp/OctopusTools.7.3.0.linux-x64.tar.gz -C /opt/ && \
    ln -s /opt/Octo /usr/local/bin
ENV OCTO_HOME=/opt/octo
ENV PATH="$OCTO_HOME:$PATH"
ENV PATH="/usr/lib/oracle/19.3/client64/bin:${PATH}"
# Set Timezone
ENV TZ=Europe/Paris
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

CMD [ "/bin/bash" ]