FROM centos

# Install the prereqs
RUN yum -y install sudo httpd mod_perl make net-snmp net-snmp-utils tar wget which; yum clean all

# Because there are RPMs for more perl modules here
RUN rpm -Uvh http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm

# Because GD is gd everywhere
RUN rpm -Uvh gd gd-devel

# Install perl bits because... sigh
RUN yum -y install perl-Net-IP perl-DBI perl-DBD-mysql perl-DateManip net-snmp-perl perl-Date-Calc perl-TimeDate perl-MailTools perl-Net-DNS perl-Time-HiRes perl-CGI perl-GDGraph perl-Text-Diff perl-OLE-Storage_Lite perl-Spreadsheet-ParseExcel perl-Parallel-ForkManager perl-Net-Ping-External perl-SNMP-Info; yum clean all

# Setup httpd users
RUN if [ ! -f /usr/httpd/users-gestioip ]; then /usr/bin/htpasswd -b -c /etc/httpd/users-gestioip gipoper gipoper; fi
RUN if [ ! -f /usr/httpd/users-gestioip ]; then /usr/bin/htpasswd -b /etc/httpd/users-gestioip gipadmin gipadmin; fi

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
