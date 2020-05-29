# Define PHP version
ARG TARGET_NGINX_VERSION=latest

# Define Nginx docker image
FROM nginx:${TARGET_NGINX_VERSION}

################################
# CONTAINER REQUIRED ARGUMENTS #
################################

# Docker file path
ARG SERVICE_DIR="./containers/request-proxy"
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
RUN chmod -R 777 /tmp/scripts/

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

#######################
# NGINX CONFIGURATION #
#######################

# Nginx config
COPY ${SERVICE_DIR}/nginx.conf /etc/nginx/

RUN /tmp/scripts/modify_config.sh /etc/nginx/nginx.conf \
    "__APP_USER" \
    "${APP_USER}" \
 && /tmp/scripts/modify_config.sh /etc/nginx/nginx.conf \
    "__APP_GROUP" \
    "${APP_GROUP}" \
;

# Nginx app config
COPY ${SERVICE_DIR}/sites-available/* /etc/nginx/sites-available/

RUN /tmp/scripts/modify_config.sh /etc/nginx/sites-available/default.conf \
    "__NGINX_ROOT" \
    "${APP_DOCUMENT_ROOT_PATH}" \
;

#####################################
# FINISHING CONTAINER CONFIGURATION #
#####################################

# Configure workdir
WORKDIR /etc/nginx/

# Do some cleanup
RUN /tmp/scripts/cleanup.sh

CMD ["nginx"]

HEALTHCHECK CMD service nginx status || exit 1

# Ports
EXPOSE 80