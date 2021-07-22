## Local Machine.
### Update config/database.php file
```
'pgsql' => [
            'driver' => 'pgsql',
            'url' => env('DATABASE_URL'),
            'host' => $DATABASE_URL["host"],
            'port' => $DATABASE_URL["port"],
            'database' => ltrim($DATABASE_URL["path"], "/"),
            'username' => $DATABASE_URL["user"],
            'password' => $DATABASE_URL["pass"],
            'charset' => 'utf8',
            'prefix' => '',
            'prefix_indexes' => true,
            'schema' => 'public',
            'sslmode' => 'prefer',
        ],

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
dokku postgres:create sitedb
dokku postgres:link sitedb site
dokku buildpacks:add site https://github.com/heroku/heroku-buildpack-php
dokku config:set site APP_NAME=Leewardslope APP_ENV=prodcution APP_KEY=base64:8dQ7xw/kM9EYMV4cUkzKgET8jF4P0M0TOmmqN05RN2w= APP_DEBUG=true APP_URL=http://test.leewardslope.com JWT_SECRET=Jrsweag3Mf0srOqDizRkhjWm5CEFcrBy WAVE_DOCS=false WAVE_DEMO=false WAVE_BAR=true
dokku domains:set site test.leewardslope.com
dokku config:set site DOKKU_LETSENCRYPT_EMAIL=kaparapu.akhilnaidu@gmail.com
dokku letsencrypt:enable site
dokku git:initialize
dokku git:set site deploy-branch dokku
dokku git:sync --build site https://github.com/akhil-naidu/wave
dokku run site php artisan migrate
dokku run site php artisan db:seed
```

