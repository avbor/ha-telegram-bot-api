#!/usr/bin/with-contenv bashio
set -e

WORK_DIR="/data/telegram-bot-api"

if [ ! -d "$WORK_DIR" ]; then
    bashio::log.info "Create workdir in /data"
    mkdir -p "$WORK_DIR/temp"
fi

rm -rf "$WORK_DIR/temp/*"

chown -R telegram-bot-api:telegram-bot-api "$WORK_DIR"

API_ID="$(bashio::config 'api_id')"

if [ -z "$API_ID" ]
then
  bashio::log.fatal "api_id is not set. Please set it in the app configuration."
  exit 1
fi

API_HASH="$(bashio::config 'api_hash')"

if [ -z "$API_HASH" ]
then
  bashio::log.fatal "api_hash is not set. Please set it in the app configuration."
  exit 1
fi

LOG_LEVEL="$(bashio::config 'log_level')"

declare -a ARGS=(
  "--api-id=$API_ID"
  "--api-hash=$API_HASH"
  "--local"
  "--dir=$WORK_DIR"
  "--temp-dir=$WORK_DIR/temp"
  "--verbosity=$LOG_LEVEL"
)

PRX_TYPE=$(bashio::config 'proxy.prx_type')

if [ "$PRX_TYPE" != "none" ]; then
    bashio::log.info "Selected proxy type: $PRX_TYPE"
    ARGS+=("--tdlib-proxy-type=${PRX_TYPE}")

    if bashio::config.has_value 'proxy.prx_server'; then
        SERVER=$(bashio::config 'proxy.prx_server')
        PORT=$(bashio::config 'proxy.prx_port')
        ARGS+=("--proxy-server=${SERVER}")
        ARGS+=("--proxy-port=${PORT}")
        
        if bashio::config.has_value 'proxy.prx_username'; then
            USER=$(bashio::config 'proxy.prx_username')
            PASS=$(bashio::config 'proxy.prx_password')
            ARGS+=("--proxy-login=${USER}")
            ARGS+=("--proxy-password=${PASS}")
        fi

        if [ "$PRX_TYPE" == "mtproto" ] && bashio::config.has_value 'proxy.prx_secret'; then
            SECRET=$(bashio::config 'proxy.prx_secret')
            ARGS+=("--proxy-secret=${SECRET}")
        fi
    else
        bashio::log.error "Proxy server address not specified (prx_server)"
    fi
fi

SAFE_ARGS=$(echo "${ARGS[*]}" | sed -E 's/(--api-hash|--proxy-password|--proxy-secret|--proxy-login)=[^ ]+/\1=**********/g')

bashio::log.info "Launch Telegram Bot API with args:"
bashio::log.info /usr/local/bin/telegram-bot-api "$SAFE_ARGS"

exec s6-setuidgid telegram-bot-api /usr/local/bin/telegram-bot-api "${ARGS[@]}"