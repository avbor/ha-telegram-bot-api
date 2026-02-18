## Home Assistant App: Telegram Bot API - Docker Image

Based on [hanwg](https://github.com/hanwg/telegram-bot-api) and [Seed680](https://github.com/Seed680/telegram-bot-api) work.
Thanks, guys!

This is a community supported Docker image for Home Assistant App: [Telegram Bot API](https://github.com/tdlib/telegram-bot-api).\
Telegram Bot API is an app from the Telegram developers that allows you to replace the `api.telegram.org` resource with a local version.

**In addition, this build allows you to use proxy server (MTProto, SOCKS5 or HTTP) to connect to the Telegram infrastructure.**

```
SOCKS5
./telegram-bot-api --api-id=YOUR_API_ID --api-hash=YOUR_API_HASH
--proxy-server=127.0.0.1 --proxy-port=1080 --tdlib-proxy-type=socks5
--proxy-login=username --proxy-password=password

HTTP
./telegram-bot-api --api-id=YOUR_API_ID --api-hash=YOUR_API_HASH
--proxy-server=127.0.0.1 --proxy-port=8080 --tdlib-proxy-type=http
--proxy-login=username --proxy-password=password

MTProto
./telegram-bot-api --api-id=YOUR_API_ID --api-hash=YOUR_API_HASH
--proxy-server=127.0.0.1 --proxy-port=443 --tdlib-proxy-type=mtproto
--proxy-secret=secret_here
```

The container was built from the Home Assistant base [image](https://github.com/home-assistant/docker-base).\
Telegram Bot API server built from the [official source](https://github.com/tdlib/telegram-bot-api) with some additions from [Seed680](https://github.com/Seed680/telegram-bot-api) for easy proxy setup.

For more information, please refer to the official documentation at: \
https://core.telegram.org/bots/api#using-a-local-bot-api-server. \
And Home Assistant App docs here: \
https://github.com/avbor/hassio-apps/blob/main/telegram-bot-api/DOCS.md