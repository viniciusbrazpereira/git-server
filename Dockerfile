FROM ubuntu

MAINTAINER Vinicius Braz Pereira <vinicius.braz@anvy.com.br>

USER root

RUN apt-get -y update && \
apt-get upgrade -y  && \
apt-get install nginx git fcgiwrap apache2-utils -y  && \
echo "\ndaemon off;" >> /etc/nginx/nginx.conf  && \
mkdir /var/www/html/git  && \
chown -R www-data:www-data /var/www/html/git  && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*  && \
mkdir /var/www/html/git/admin.git  && \
cd /var/www/html/git/admin.git  && \
git --bare init   && \
git update-server-info  && \
chown -R www-data:www-data /var/www/html/git/admin.git  && \
chmod -R 755 /var/www/html/git/admin.git  && \
mkdir /var/www/html/git/api.git  && \
cd /var/www/html/git/api.git  && \
git --bare init   && \
git update-server-info  && \
chown -R www-data:www-data /var/www/html/git/api.git  && \
chmod -R 755 /var/www/html/git/api.git

# Define mountable directories.
#VOLUME ["/etc/nginx/sites-available", "/etc/nginx/certs", "/var/log/nginx", "/var/www/html/git"]

# add scripts
COPY nginx/default /etc/nginx/sites-available/default
COPY htpasswd /var/www/html/git
#COPY index.html /var/www/html/git;

RUN service nginx reload

# Define working directory.
WORKDIR /etc/nginx

# Expose ports.
EXPOSE 80

# Define default command.
CMD ["nginx"]

