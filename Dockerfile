#base image
FROM norman/centos6

#author
MAINTAINER Norman 332535694@qq.com

WORKDIR /
ENV NODE_PATH /opt/iojs/lib/node_modules
ENV PATH $PATH:/opt/iojs/bin
ADD https://iojs.org/dist/latest/iojs-v3.3.1-linux-x64.tar.xz iojs-v3.3.1-linux-x64.tar.xz
ADD set_root_pw.sh /set_root_pw.sh
ADD run-ssh.sh /run-ssh.sh
ADD supervisor.sh /supervisor.sh
RUN yum -y install postgresql && \
    chmod +x /*.sh && \
    unxz iojs-v3.3.1-linux-x64.tar.xz && tar -xf iojs-v3.3.1-linux-x64.tar && \
    mv iojs-v3.3.1-linux-x64 /opt/iojs && \
    ln -s /opt/iojs/bin/iojs /usr/bin/iojs && \
    ln -s /opt/iojs/bin/node /usr/bin/node && \
    ln -s /opt/iojs/bin/npm /usr/bin/npm && \
    yum install -y mysql mysql-devel && \
    npm install -g cnpm --registry=https://registry.npm.taobao.org && \
    cnpm install -g pm2 && \
    rm -f iojs-v3.3.1-linux-x64.tar.xz && rm -f iojs-v3.3.1-linux-x64.tar && \
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