#!/bin/bash

read -p "Enter container ID or name: " container
plugin="jwt-claim-to-header-kong"

docker exec -it --user root $container mkdir -p /usr/local/share/lua/5.1/kong/plugins/$plugin
echo "Directory created or verified"

docker cp . $container:/usr/local/share/lua/5.1/kong/plugins/$plugin
echo "Copied plugin files to /usr/local/share/lua/5.1/kong/plugins/$plugin"

docker exec --user root -e KONG_PLUGINS="bundled,$plugin" $container kong reload -vv
echo "Kong reloaded with $plugin enabled"
