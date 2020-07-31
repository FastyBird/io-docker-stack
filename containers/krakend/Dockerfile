# Define KrakenD version
ARG TARGET_COUCHDB_VERSION=latest

# Define KrakenD docker image
FROM devopsfaith/krakend:${TARGET_COUCHDB_VERSION}

################################
# CONTAINER REQUIRED ARGUMENTS #
################################

# Docker file path
ARG SERVICE_DIR="./containers/krakend"

#########################
# KRAKEND CONFIGURATION #
#########################

# KrakenD configuration
COPY ${SERVICE_DIR}/krakend.json /etc/krakend/krakend.json
