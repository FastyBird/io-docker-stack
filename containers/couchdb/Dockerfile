# Define CouchDB version
ARG TARGET_COUCHDB_VERSION=latest

# Define CouchDB docker image
FROM couchdb:${TARGET_COUCHDB_VERSION}

################################
# CONTAINER REQUIRED ARGUMENTS #
################################

# Docker file path
ARG SERVICE_DIR="./containers/couchdb"

#########################
# COUCHDB CONFIGURATION #
#########################

# CouchDB configuration
COPY ${SERVICE_DIR}/local.ini /opt/couchdb/etc/local.d/local.ini
