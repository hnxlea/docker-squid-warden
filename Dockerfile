FROM ubuntu/squid

# Update and upgrade sources and packages
RUN apt-get update && apt-get upgrade -y
# Install apache2-utils for htpasswd
# https://docs.docker.com/registry/configuration/#htpasswd
RUN apt-get install -y apache2-utils

# Run a conditional checking if /etc/squid/passwords file exists.
# If it does, then backup this file.
ENV PASS_FILE="/etc/squid/passwords"
RUN if [ -e "$PASS_FILE" ]; then \
        mv /etc/squid/passwords /etc/squid/passwords.bak; \
    fi

# Run htpasswd command to generate a password for user
#RUN htpasswd -c /etc/squid/passwords user
RUN echo password | htpasswd -ci "$PASS_FILE" user

# verify Squid configuration file using the -k parse option
# https://wiki.squid-cache.org/SquidFaq/InstallingSquid#How_do_I_start_Squid.3F
#RUN /usr/local/squid/sbin/squid -k parse

# Run a conditional checking if /usr/local/squid/etc/squid.conf file exists.
# If it does, then backup this file.
ENV SQUID_CONF="/usr/local/squid/etc/squid.conf"
RUN if [ -e "$SQUID_CONF" ]; then \
        mv /usr/local/squid/etc/squid.conf /usr/local/squid/etc/squid.conf.bak; \
    fi

# Copy configuration file
COPY squid.conf "$SQUID_CONF"

# Since running Squid as root, first create /usr/local/squid/var/logs and if applicable the cache_dir directories and assign ownership of these to the cache_effective_user configured in your squid.conf (current config has no cache)
#RUN mkdir -p /usr/local/squid/var/logs

# Create Squid swap directories by running Squid with the -z option
#RUN /usr/local/squid/sbin/squid -z

# Start Squid and try it out, and watch the debugging output.
# Proper response should end in: 
#   >   Ready to serve requests.
EXPOSE 3128

#CMD ["sudo -c /usr/local/squid/sbin/squid -NCd1"]
CMD ["squid-container /bin/bash"]

# Saved for later, in case not exposed through firewall
# --enable-linux-netfilter
