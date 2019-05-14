FROM ubuntu:latest

MAINTAINER Ravi kumar G <ravikumar@oncam.com>

#Install Git Curl Wget tar vim 

RUN apt-get update \
    && apt-get install -y wget \
    && apt-get install -y tar \
    && apt-get install -y curl \
    && apt-get install -y git \
    && apt-get install -y vim \
    && apt-get install -y unzip

# Install Python & Ansible

ARG ANSIBLE_VERSION=${ANSIBLE_VERSION}

RUN apt-get update && \
    apt-get install -y python && \
    apt-get install -y python3.6-dev libmysqlclient-dev && \
    apt-get install -y python3-numpy && \
    apt-get install -y python3-pip && \
    echo " Installing ansible " && \
    pip3 install ansible==${ANSIBLE_VERSION} && \
    cd /etc && \
    mkdir ansible && \
    cd  /etc/ansible && \
    wget https://raw.githubusercontent.com/ansible/ansible/devel/examples/ansible.cfg && \
    touch hosts


# Install Terraform

ARG TERRAFORM_VERSION=${TERRAFORM_VERSION}
RUN wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip \
    && mv terraform /usr/bin \
    && rm terraform_${TERRAFORM_VERSION}_linux_amd64.zip


# Filemgr-linux

RUN wget http://tools.ufile.ucloud.com.cn/filemgr-linux64.tar.gz \
    && tar xvzf filemgr-linux64.tar.gz \
    && cd filemgr-linux64 \
    && mv filemgr-linux64 filemgr \
    && mv filemgr /usr/local/bin



ENV WGET_HOME=/usr/bin/wget
ENV TAR_HOME=/bin/tar
ENV CURL_HOME=/usr/bin/curl
ENV GIT_HOME=/usr/bin/git
ENV VIM_HOME=/usr/bin/vim
ENV UNZIP_HOME=/usr/bin/unzip
ENV ANSIBLE_HOME=/etc/ansible
ENV PYTHON_HOME=/usr/bin/python
ENV TERRAFORM_HOME=/usr/bin/terraform
ENV FILEMGR_HOME=/usr/bin/filemgr-linux64