# Use an official Alpine as a parent image
FROM alpine:latest

# Install dependencies
RUN apk update && apk add --no-cache \
    apache2 \
    apache2-utils \
    apache2-dev \
    g++ \
    make \
    cmake

# Enable CGI module and configure Apache
RUN mkdir -p /run/apache2 && \
    sed -i 's/#LoadModule cgid_module/LoadModule cgid_module/' /etc/apache2/httpd.conf && \
    echo "ScriptAlias /cgi-bin/ \"/var/www/cgi-bin/\"" >> /etc/apache2/httpd.conf && \
    echo "<Directory \"/var/www/cgi-bin\">" >> /etc/apache2/httpd.conf && \
    echo "    AllowOverride None" >> /etc/apache2/httpd.conf && \
    echo "    Options +ExecCGI" >> /etc/apache2/httpd.conf && \
    echo "    Require all granted" >> /etc/apache2/httpd.conf && \
    echo "</Directory>" >> /etc/apache2/httpd.conf

# Copy your C++ CGI script to the container
COPY main.cpp /var/www/cgi-bin/main.cpp

# Change working directory to the CGI-bin directory
WORKDIR /var/www/cgi-bin

# Compile your C++ CGI script
RUN g++ -o main.cgi main.cpp

# Make sure the CGI script is executable
RUN chmod +x main.cgi

# Expose the port Apache runs on
EXPOSE 80

# Start Apache in the foreground
CMD ["/usr/sbin/httpd", "-D", "FOREGROUND"]
