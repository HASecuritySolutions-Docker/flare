FROM centos:latest

MAINTAINER Justin Henderson justin@hasecuritysolutions.com

RUN yum update -y \
    && yum install -y python2 python2-devel git gcc python2-lxml \
    && curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py \
    && python2 get-pip.py \
    && cd /opt && git clone https://github.com/austin-taylor/flare.git \
    && cd /opt/flare && pip install -r requirements.txt \
    && useradd -ms /bin/bash flare \
    && mkdir /var/log/flare \
    && chown flare: /var/log/flare \
    && mkdir /opt/flare/output/ \
    && ln -sf /dev/stderr /var/log/flare/flare.log \
    && chown -R flare: /opt/flare
RUN cd /opt/flare && python2 /opt/flare/setup.py install || true
USER flare
STOPSIGNAL SIGTERM

CMD  flare_beacon -c /opt/flare/configs/elasticsearch.ini -who -json=/opt/flare/output/output.json
