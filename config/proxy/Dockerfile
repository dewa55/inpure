FROM wodby/apache:latest
RUN rm /etc/apache2/sites-enabled/*
COPY default.conf /etc/apache2/sites-enabled/
CMD apachectl -D FOREGROUND
