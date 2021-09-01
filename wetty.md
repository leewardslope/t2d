```
sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git

dokku apps:create wetty-test
docker pull wettyoss/wetty
docker tag wettyoss/wetty:latest dokku/wetty-test:latest

dokku domains:set wetty-test wetty-test.leewardslope.com
dokku proxy:ports-remove wetty-test http:80:5000 https:443:5000 http:3000:3000
dokku proxy:ports-add wetty-test http:80:4444 https:443:4444
dokku config:set --no-restart wetty-test DOKKU_LETSENCRYPT_EMAIL=kaparapu.akhilnaidu@gmail.com SSHHOST=206.189.134.76 SSHUSER=t2d SSHPASS=password TITLE=wetty-test PORT=4444 BASE=/ 
dokku letsencrypt:enable wetty-test
dokku tags:deploy wetty-test latest
```

---

### Do this As early as possible

or you need to rebuild

need to add publick to authorized key and change permissions
```
chmod 700 ~/.ssh
chmod 644 ~/.ssh/authorized_keys
chmod 600 ~/.ssh/wetty
```

### Another important point
Also, you need to add the above keys in docker.

These command might come in handy
```
docker exec -it ID COMMAND
docker cp .ssh/id_rsa a772596238a5:/usr/src/app/id_rsa
dokku config:set wetty-test SSHKEY=/usr/src/app/id_rsa
```
