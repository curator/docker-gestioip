FROM centos

# Install the prereqs
RUN yum -y install httpd mod_perl make net-snmp net-snmp-utils tar wget; yum clean all

# Install perl bits because... sigh
RUN yum -y install perl-Net-IP perl-DBI perl-DBD-mysql perl-DateManip net-snmp-perl perl-Date-Calc perl-TimeDate perl-MailTools perl-Net-DNS perl-GDGraph; yum clean all

RUN curl -L -o gestioip_3.0.tar.gz 'http://downloads.sourceforge.net/project/gestioip/gestioip_3.0.tar.gz?r=http%3A%2F%2Fwww.gestioip.net%2F&ts=1403922795&use_mirror=hivelocity'

RUN tar xzvf gestioip_3.0.tar.gz

# Expose some ports
EXPOSE 80

#Borrowed from fedora/apache but it's docker build was broken
#https://github.com/fedora-cloud/Fedora-Dockerfiles/blob/master/apache/Dockerfile
# Simple startup script to avoid some issues observed with container restart
ADD run-apache.sh /run-apache.sh
RUN chmod -v +x /run-apache.sh

CMD ["/run-apache.sh"]
