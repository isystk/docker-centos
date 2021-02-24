# CentOS8
FROM centos:8

MAINTAINER isystk

# 日本語化および日本時間設定
RUN rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial && \
    dnf -y upgrade && \
    dnf -y install glibc-locale-source && \
    dnf clean all && \
    localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 && \
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
ENV LANG="ja_JP UTF-8" \
    LANGUAGE="ja_JP:ja" \
    LC_ALL="ja_JP.UTF-8" \
    TZ="Asia/Tokyo"

WORKDIR /usr/local/src/

# よく使うもの
RUN yum groupinstall -y -q "Development Tools" && yum clean all
RUN yum install -y gmp-devel mpfr-devel ncurses-devel which wget zlib-devel sudo net-tools hostname zsh vim

# Python
RUN dnf -y install python38

# golang
RUN dnf -y install golang

# ccat
RUN git clone https://github.com/jhawthorn/fzy.git
WORKDIR /usr/local/src/fzy
RUN make && sudo make install
RUN go get -u github.com/jingweno/ccat

# MySQL client
RUN dnf localinstall -y https://dev.mysql.com/get/mysql80-community-release-el8-1.noarch.rpm && \
    dnf -y module disable mysql && \
    dnf -y install mysql-community-client

# yumでOpenSSHをインストールする
RUN yum -y install openssh-server
RUN yum -y install openssh-clients

# sshd起動時に公開鍵が必要なため、作成
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
RUN ssh-keygen -f /etc/ssh/ssh_host_ecdsa_key -N '' -t ecdsa

# rootでログインできるようにする
RUN sed -ri 's/^#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config

# rootのパスワードを指定
RUN echo "root:password" | chpasswd

# 接続ユーザーの追加
ARG USER
RUN useradd -m $USER
RUN echo $USER':' | chpasswd
RUN usermod -aG wheel $USER
RUN echo 'Defaults visiblepw'             >> /etc/sudoers
RUN echo $USER' ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers

EXPOSE 22

# sshdを起動
CMD ["/usr/sbin/sshd", "-D"]
