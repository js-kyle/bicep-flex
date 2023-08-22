rm app.zip
rm node_modules
yarn install --production
zip -r app.zip node_modules src/** package.json host.json

az functionapp deployment source config-zip -g bicep-flex -n bicepflex-ordersfunction --src app.zip
