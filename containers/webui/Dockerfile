# Define NodeJS version
ARG TARGET_NODE_VERSION=7.3

# Define NodeJS docker image
FROM node:${TARGET_NODE_VERSION}

################################
# CONTAINER REQUIRED ARGUMENTS #
################################

# Docker file path
ARG SERVICE_DIR="./containers/webui"
# Container document root
ARG APP_DOCUMENT_ROOT_PATH="/var/www/app/web"
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

# Change default user group/user id
RUN groupmod -g 1001 node \
 && usermod -u 1001 -g 1001 node \
;

RUN /tmp/scripts/create_user.sh ${APP_USER} ${APP_GROUP} ${APP_USER_ID} ${APP_GROUP_ID}

#########################
# OS SETUP INSTALLATION #
#########################

# Set timezone
RUN /tmp/scripts/set_timezone.sh ${APP_TZ}

###################
# SSH SERVER KEYS #
###################

# Copy server ssh key to container
COPY ./.ssh/id_rsa /home/${APP_USER}/.ssh/id_rsa

RUN chmod 600 /home/${APP_USER}/.ssh/id_rsa \
 && chown -R ${APP_USER}:${APP_GROUP} /home/${APP_USER}/.ssh/ \
;

# Activate container user
USER ${APP_USER}

RUN touch ~/.ssh/known_hosts \
 && ssh-keyscan bitbucket.org >> ~/.ssh/known_hosts \
 && ssh-keyscan github.com >> ~/.ssh/known_hosts \
;

#################################
# IO SERVER WEB UI INSTALLATION #
#################################

# Checkout & install webui
RUN git clone git@bitbucket.org:fastybird/io-server-ui.git ${APP_DOCUMENT_ROOT_PATH} \
 && cd ${APP_DOCUMENT_ROOT_PATH} \
 && yarn install \
 && yarn build \
;

# Switch back to root
USER root

#####################################
# FINISHING CONTAINER CONFIGURATION #
#####################################

# Configure workdir
WORKDIR "$APP_DOCUMENT_ROOT_PATH"

# Configure entrypoint
RUN mkdir -p /bin/docker-entrypoint/ \
 && cp /tmp/scripts/docker-entrypoint/* /bin/docker-entrypoint/ \
 && chmod +x -R /bin/docker-entrypoint/ \
;

# Do some cleanup
RUN /tmp/scripts/cleanup.sh

CMD ["yarn", "start"]

ENTRYPOINT ["/bin/docker-entrypoint/resolve-docker-host-ip.sh"]

# Ports
# 5000  : Node serving port
EXPOSE 5000
