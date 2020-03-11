FROM centos:7.7.1908
LABEL MAINTAINER="jonascavalcantineto@gmail.com"

RUN yum update -y
RUN yum install -y \
		telnet \
		vim \
		bind \
		bind-utils \
		bind-chroot \
		epel-release

RUN yum update -y 
RUN yum install -y \
		supervisor

RUN set -ex \
	&& rndc-confgen -a \
	&& chown named:named /etc/rndc.key \
	&& touch /var/log/query.log \
	&& chown named:named /var/log/query.log

ENV NAMEDCONF="/etc/named.conf"
ENV File="-/etc/sysconfig/named"
ENV KRB5_KTNAME="/etc/named.keytab"
ENV PIDFile="/run/named/named.pid"

ADD conf/named.conf /etc/named.conf
ADD conf/named.rfc1912.zones /etc/named.rfc1912.zones
COPY conf/zones/* /var/named/
ADD conf/supervisord.conf /etc/supervisord.conf

ADD conf/start-dns-server.sh /start-dns-server.sh
RUN chmod +x /start-dns-server.sh

ADD conf/start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]