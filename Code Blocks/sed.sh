#!/bin/bash

# Used to replace a certain line in with different words.


read -r -p "Enter the APP_DOMAIN: " NEW_APP_DOMAIN
sed  "/APP_DOMAIN/s/$APP_DOMAIN/$NEW_APP_DOMAIN/" test.txt > env.txt
$APP_DOMAIN = $NEW_APP_DOMAIN