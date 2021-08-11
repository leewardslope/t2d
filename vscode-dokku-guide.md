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
dokku git:sync --build vscode https://github.com/leewardslope/vscode
dokku proxy:ports-remove vscode http:80:5000 https:443:5000
dokku proxy:ports-add vscode http:80:8080 https:443:8080

## Adding Persistance
mkdir /var/lib/dokku/data/storage/vscode
chown dokku:dokku /var/lib/dokku/data/storage/vscode
dokku storage:mount vscode /var/lib/dokku/data/storage/vscode/:/home/coder/
dokku ps:rebuild vscode
```
