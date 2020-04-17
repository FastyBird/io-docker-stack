# Define RabbitMQ version
ARG TARGET_RABBIT_MQ_VERSION=3

# Define RabbitMQ docker image
FROM rabbitmq:${TARGET_RABBIT_MQ_VERSION}-management-alpine

################################
# CONTAINER REQUIRED ARGUMENTS #
################################

# Docker file path
ARG SERVICE_DIR="./containers/rabbitmq"
# API service host
ARG APP_HOST=io-fastybird.local
# Default rabbit user
ARG RABBIT_MQ_USER=admin
ARG RABBIT_MQ_PASSWORD=admin

#############################
# CONTAINER INSTALL HELPERS #
#############################

# Copy helper scripts to docker image
COPY ./shared/scripts/ /tmp/scripts/
# Set access rights to this scripts
RUN chmod +x -R /tmp/scripts/

# Enable management plugin
RUN rabbitmq-plugins enable rabbitmq_auth_backend_http

###########################
# RABBIT MQ CONFIGURATION #
###########################

# RabbitMQ configuration
COPY ${SERVICE_DIR}/rabbitmq.config /etc/rabbitmq/rabbitmq.config

# Set access rights to config files
RUN chown rabbitmq:rabbitmq /etc/rabbitmq/rabbitmq.config

# Define environment variables.
ENV RABBITMQ_USER ${RABBIT_MQ_USER}
ENV RABBITMQ_PASSWORD ${RABBIT_MQ_PASSWORD}
ENV RABBITMQ_PID_FILE /var/lib/rabbitmq/mnesia/rabbitmq

#####################################
# FINISHING CONTAINER CONFIGURATION #
#####################################

ADD ${SERVICE_DIR}/start.sh /start.sh
RUN chmod +x /start.sh

CMD ["/start.sh"]

# Ports
# 15672 : Management plugin
# 5672  : AMQP access
EXPOSE 15672 5672
