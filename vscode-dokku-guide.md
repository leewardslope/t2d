```
## Geeting Ready
dokku apps:create vscode
dokku config:set vscode PASSWORD=password
dokku domains:set vscode vscode.leewardslope.com

## Getting SSL Ready
### via let's encrypt
dokku config:set vscode DOKKU_LETSENCRYPT_EMAIL=kaparapu.akhilnaidu@gmail.com
dokku letsencrypt:enable site
<!-- dokku proxy:build-config vscode -->

### via certs
tar -cvf leewardslope.com.tar leewardslope.com.crt leewardslope.com.key
dokku certs:add vscode < leewardslope.com.tar
<!-- dokku proxy:build-config vscode -->

## Final Steps
dokku git:initialize
dokku git:set vscode deploy-branch main
dokku git:sync --build site https://github.com/leewardslope/vscode

## Adding Persistance
mkdir -p /var/lib/dokku/data/storage/vscode

<!-- dokku storage:mount vscode /var/lib/dokku/data/storage/vscode-projects:/root/.(...)
dokku storage:mount ghost /root/ghost/content:/var/lib/ghost/content -->
```
