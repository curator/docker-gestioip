FROM centos

# Install the prereqs
RUN yum -y install httpd mod_perl make net-snmp net-snmp-utils; yum clean all

# Expose some ports
EXPOSE 80

#Borrowed from fedora/apache but it's docker build was broken
#https://github.com/fedora-cloud/Fedora-Dockerfiles/blob/master/apache/Dockerfile
# Simple startup script to avoid some issues observed with container restart
ADD run-apache.sh /run-apache.sh
RUN chmod -v +x /run-apache.sh

CMD ["/run-apache.sh"]
