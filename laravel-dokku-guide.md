## Local Machine.
### Update config/database.php file
```
'mysql' => [
    'driver' => 'mysql',
    'url' => env('DATABASE_URL'),
    'host' => parse_url(getenv("DATABASE_URL"))["host"],
    'database' => substr(parse_url(getenv("DATABASE_URL"))["path"], 1),
    'username' => parse_url(getenv("DATABASE_URL"))["user"],
    'password' => parse_url(getenv("DATABASE_URL"))["pass"],
    'port' => parse_url(getenv("DATABASE_URL"))["port"],
    'unix_socket' => env('DB_SOCKET', ''),
    'charset' => 'utf8mb4',
    'collation' => 'utf8mb4_unicode_ci',
    'prefix' => '',
    'strict' => true,
    'engine' => null,
],
```
### Create the Procfile
```
echo 'web: vendor/bin/heroku-php-apache2 public/' >> Procfile
```

## Dokku Machine
### Intial Setup
```
sudo dokku plugin:install https://github.com/dokku/dokku-mysql.git mysql
dokku apps:create site
dokku mysql:create sitedb
dokku mysql:link sitedb site
dokku buildpacks:add site https://github.com/heroku/heroku-buildpack-php
dokku config:set site APP_NAME=Leewardslope APP_ENV=prodcution APP_KEY=base64:8dQ7xw/kM9EYMV4cUkzKgET8jF4P0M0TOmmqN05RN2w= APP_DEBUG=true APP_URL=http://test.leewardslope.com JWT_SECRET=Jrsweag3Mf0srOqDizRkhjWm5CEFcrBy WAVE_DOCS=false WAVE_DEMO=false WAVE_BAR=true
dokku domains:set site test.leewardslope.com
dokku config:set site DOKKU_LETSENCRYPT_EMAIL=kaparapu.akhilnaidu@gmail.com
dokku letsencrypt:enable site
dokku git:initialize
dokku git:set site deploy-branch dokku
dokku git:sync --build site https://github.com/akhil-naidu/wave
```

