FROM ubuntu:22.04

ENV JUDGE_NAME='judger'
ENV JUDGE_KEY='The_key_you_set_in_admin_paneL'
ENV JUDGE_SITE='site'

RUN useradd -m -U judge && \
    sed -i 's/archive.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list && \
    apt-get dist-upgrade -y && \
    apt-get -y update && \
    apt-get install -y --no-install-recommends python3-dev python3 gcc g++ wget file nano vim git ca-certificates python3-pip build-essential libseccomp-dev python3-setuptools

RUN apt-get update
RUN apt-get install -y openjdk-18-jdk-headless openjdk-18-jre-headless
RUN apt-get autoremove -y && apt-get clean

WORKDIR /judge
RUN git clone https://github.com/phxoj/judge /judge --depth=1
RUN pip3 config set global.index-url https://opentuna.cn/pypi/web/simple
RUN pip3 install wheel && \
    pip3 install -r requirements.txt -i https://mirrors.ustc.edu.cn/pypi/web/simple
RUN python3 setup.py develop && \
    mkdir /problems

ADD startup.sh /

CMD sh /startup.sh
