```
dokku apps:create forem

sudo dokku plugin:install https://github.com/dokku/dokku-postgres.git
sudo dokku plugin:install https://github.com/dokku/dokku-redis.git
sudo dokku plugin:install https://github.com/dokku/dokku-letsencrypt.git

dokku buildpacks:add forem https://github.com/heroku/heroku-buildpack-nodejs.git
dokku buildpacks:add forem https://github.com/gaffneyc/heroku-buildpack-jemalloc
dokku buildpacks:add forem https://github.com/heroku/heroku-buildpack-pgbouncer.git
dokku buildpacks:add forem https://github.com/heroku/heroku-buildpack-ruby.git

dokku postgres:create foremdb
dokku redis:create redisdb

dokku postgres:link foremdb forem
dokku redis:link redisdb forem

dokku ps:scale forem web=1 sidekiq_worker=1
dokku resource:limit --memory 750m --process-type web forem
dokku resource:limit --memory 750m --process-type sidekiq_worker forem
dokku config:set forem --no-restart MALLOC_ARENA_MAX=2 JEMALLOC_ENABLED=true WEB_CONCURRENCY=2 RUBY_GC_HEAP_GROWTH_FACTOR=1.03 PGBOUNCER_PREPARED_STATEMENTS=false DATABASE_POOL_SIZE=5 RAILS_MAX_THREADS=5 
dokku config:set forem --no-restart NODE_ENV=production RACK_ENV=production RACK_ENV=production

---

dokku git:initialize forem
dokku config:set forem --no-restart SECRET_KEY_BASE APP_DOMAIN APP_PROTOCOL COMMUNITY_NAME FOREM_OWNER_SECRET HONEYBADGER_API_KEY HONEYBADGER_JS_API_KEY AWS_ID AWS_SECRET AWS_BUCKET_NAME AWS_UPLOAD_REGION

dokku domains:set forem $DOMAIN
dokku config:set forem DOKKU_LETSENCRYPT_EMAIL=$EMAIL
dokku letsencrypt:enable forem

dokku git:allow-host github.com
dokku git:set forem deploy-branch main
dokku git:sync --build forem https://github.com/akhil-naidu/forem.git
```
