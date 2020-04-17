# Define PHP version
ARG TARGET_PHP_VERSION=7.3

# Define PHP docker image
FROM php:${TARGET_PHP_VERSION}-cli

################################
# CONTAINER REQUIRED ARGUMENTS #
################################

# Container default timezone
ARG APP_TZ=UTC

#############################
# CONTAINER INSTALL HELPERS #
#############################

# Copy helper scripts to docker image
COPY ./shared/scripts/ /tmp/scripts/
# Set access rights to this scripts
RUN chmod +x -R /tmp/scripts/

#################
# OS USER SETUP #
#################

# Add users
ARG APP_USER=www-data
ARG APP_GROUP=www-data
ARG APP_USER_ID=1000
ARG APP_GROUP_ID=1000

RUN /tmp/scripts/create_user.sh ${APP_USER} ${APP_GROUP} ${APP_USER_ID} ${APP_GROUP_ID}

#########################
# OS SETUP INSTALLATION #
#########################

# Set timezone
RUN /tmp/scripts/set_timezone.sh ${APP_TZ}

# Install additional software
RUN /tmp/scripts/install_software.sh

##############
# SSH SERVER #
##############

# Set up ssh
RUN apt-get update -yqq && apt-get install -yqq openssh-server \
 && mkdir /var/run/sshd \
;

# Add default public key to authorized_keys
USER ${APP_USER}

COPY ./.ssh/*.pub /tmp/

RUN cat /tmp/*.pub >> ~/.ssh/authorized_keys

# Switch back to root
USER root

#####################################
# FINISHING CONTAINER CONFIGURATION #
#####################################

# Configure entrypoint
RUN mkdir -p /bin/docker-entrypoint/ \
 && cp /tmp/scripts/docker-entrypoint/* /bin/docker-entrypoint/ \
 && chmod +x -R /bin/docker-entrypoint/ \
;

# Do some cleanup
RUN /tmp/scripts/cleanup.sh

# @see https://docs.docker.com/engine/examples/running_ssh_service/
CMD ["/usr/sbin/sshd", "-D"]

ENTRYPOINT ["/bin/docker-entrypoint/resolve-docker-host-ip.sh"]

# Ports
# 22    : Standard SSH port
EXPOSE 22
