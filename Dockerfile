#base image
FROM registry.aliyuncs.com/norman/centos6:0.1.0

#author
MAINTAINER Norman 332535694@qq.com

WORKDIR /
ENV NODE_PATH /opt/node/lib/node_modules
ENV PATH $PATH:/opt/node/bin
ADD https://nodejs.org/dist/v4.4.0/node-v4.4.0-linux-x64.tar.xz node-v4.4.0-linux-x64.tar.xz
ADD set_root_pw.sh /set_root_pw.sh
ADD run-ssh.sh /run-ssh.sh
ADD supervisor.sh /supervisor.sh
RUN yum clean rpmdb && yum -y install postgresql && \
    chmod +x /*.sh && \
    unxz node-v4.4.0-linux-x64.tar.xz && tar -xf node-v4.4.0-linux-x64.tar && \
    mv node-v4.4.0-linux-x64 /opt/node && \
    ln -s /opt/node/bin/node /usr/bin/node && \
    ln -s /opt/node/bin/npm /usr/bin/npm && \
    yum install -y mysql mysql-devel && \
    npm install -g pm2 inotify && \
    rm -f node-v4.4.0-linux-x64.tar.xz && rm -f node-v4.4.0-linux-x64.tar && \
    yum install -y tar openssl openssl-devel zlib-devel bzip2 bzip2-devel readline readline-devel && \
    yum -y install openssh-server epel-release pwgen && \
    rm -f /etc/ssh/ssh_host_ecdsa_key /etc/ssh/ssh_host_rsa_key && \
    ssh-keygen -q -N "" -t dsa -f /etc/ssh/ssh_host_ecdsa_key && \
    ssh-keygen -q -N "" -t rsa -f /etc/ssh/ssh_host_rsa_key && \
    sed -i "s/#UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config
ENV AUTHORIZED_KEYS **None**

VOLUME ["/web", "/home/log"]

EXPOSE 9001 8100 22
CMD ["/bin/bash", "/supervisor.sh"]