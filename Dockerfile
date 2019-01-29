FROM ubuntu

MAINTAINER Vinicius Braz Pereira <vinicius.braz@anvy.com.br>

RUN apt-get -y update
RUN apt-get upgrade -y
RUN apt-get install nginx git fcgiwrap apache2-utils -y
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN mkdir /var/www/html/git
RUN chown -R www-data:www-data /var/www/html/git
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

RUN mkdir /var/www/html/git/admin.git
RUN cd /var/www/html/git/admin.git
RUN git --bare init 
RUN git update-server-info
RUN chown -R www-data:www-data /var/www/html/git/admin.git
RUN chmod -R 755 /var/www/html/git/admin.git

RUN mkdir /var/www/html/git/api.git
RUN cd /var/www/html/git/api.git
RUN git --bare init 
RUN git update-server-info
RUN chown -R www-data:www-data /var/www/html/git/api.git
RUN chmod -R 755 /var/www/html/git/api.git

# Define mountable directories.
VOLUME ["/etc/nginx/sites-available", "/etc/nginx/certs", "/var/log/nginx", "/var/www/html/git"]

# add scripts
COPY nginx/default /etc/nginx/sites-available/default
COPY htpasswd /var/www/html/git
#COPY index.html /var/www/html/git;

RUN service nginx reload
RUN cat /var/www/html/git/htpasswd

# Define working directory.
WORKDIR /etc/nginx

# Expose ports.
EXPOSE 80

# Define default command.
CMD ["nginx"]

