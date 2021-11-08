See also [OpenStreetMap uMap](https://wiki.openstreetmap.org/wiki/UMap)

## On GNU Guix
1. Execute `run.sh <shared_path> <public_path>` where `public_path` is a
   relative route within `shared_path`. E.g.:
```shell
./run.sh ~/dec fdk
# load the profile inside the container:
source /usr/etc/profile
# start the services:
start
sleep 3
php -c /usr/etc -f /usr/etc/db-connect-test.php
php -c /usr/etc -S localhost:4200 -t ~/dec/fdk/map/database/
```

1. In a new terminal
```shell
# test database access:
curl --request GET http://localhost:4200/api/associations/read-associations.php
```

1. In a new terminal start the app-map
```shell
./run.sh ~/dec fdk
# load the profile inside the container:
source /usr/etc/profile
cd dec/fdk/map/app-map/
ng serve --port 4201
```

1. In a new terminal start the app-map
```shell
./run.sh ~/dec fdk
# load the profile inside the container:
source /usr/etc/profile
cd dec/fdk/map/app-form/
ng serve --port 4202
```


## On Ubuntu

```shell
# install AngularJS:
npm install -g @angular/cli
# install Wordpress, PHP, MySQL phpMyAdmin:
sudo apt install wordpress php libapache2-mod-php php-mysql mysql-server mysql-client mysql-common phpmyadmin
# make sure MySQL is running:
systemctl status mysql.service
# set up the database:
userPasswd=<YOUR-PASSWORD>
sudo mysql -uroot << EOF
DROP DATABASE IF EXISTS associations;
CREATE DATABASE IF NOT EXISTS associations;
CREATE USER '$USER@'localhost' IDENTIFIED BY '$userPasswd';
GRANT ALL PRIVILEGES ON associations.* TO $USER'@'localhost' WITH GRANT OPTION;
FLUSH PRIVILEGES;
select '-- Loading test data ...' AS '';
SOURCE dec/fdk/map/database/db-export/associations.sql;
-- SHOW TABLES;
-- SHOW COLUMNS IN activities;
SELECT count(*) as 'count-of-activities (should be ~130)'
FROM associations.activities;
exit
EOF
```
## MySQL installation and setup

Depending on your MySQL environment, you can do this using the from the command
line or with [phpMyAdmin](https://www.phpmyadmin.net/) GUI.

### Database setup with [phpMyAdmin](localhost:80/phpmyadmin/index.php)

Click on the newly created database and select `Import` from the top menu and
upload the sql file.

## Setup PHP scripts for database access

1. Copy connection-template to a new file:
   ```shell
   cp map/database/api/_database.php map/database/api/database.php
   ```

1. Edit `DB_HOST`, `DB_NAME`, `DB_USER` and `DB_PASS` according to your
   configuration made in the previous section. I.e. change the:
   ```php
   define('DB_HOST', '');
   define('DB_NAME', '');
   define('DB_USER', '');
   define('DB_PASS', '');
   ```
   to:
   ```php
   define('DB_HOST', 'your.mysql.host.com');
   define('DB_NAME', 'associations');
   define('DB_USER', 'user');
   define('DB_PASS', '<YOUR-PASSWORD>');
   ```

   Leave the `database.php` file in the `/database/api/` directory. This way, it
   will be copied to the right location when deploying the apps. **The file will
   NOT be committed to the Git repository.**

1. Development on Ubuntu: a PHP server may need to be started:
   ```shell
   php -S localhost:4200 -t ./map/database/
   ```
   In this case, in the files:
   ```shell
   map/app-map/src/environments/environment.ts
   map/app-form/src/environments/environment.ts
   ```
   set:
   ```ts
   serverBasePath: 'http://localhost:4200/api'
   ```
   Also for the development, make sure the `map/database/api/database.php`
   contains:
   ```php
   header("Access-Control-Allow-Origin: *");
   ```

## Setup Wordpress Development Environment

See also how to [Install and configure WordPress](https://ubuntu.com/tutorials/install-and-configure-wordpress)
or
[How to set up a local development environment for WordPress from scratch](https://www.endpoint.com/blog/2019/08/set-up-local-development-environment-for-wordpress/)

1. In `/etc/phpmyadmin/config.inc.php` activate all lines with:
   ```php
   $cfg['Servers'][$i]['AllowNoPassword'] = TRUE;
   ```

1. Create new Wordpress user with [PhpMyAdmin](http://localhost:80/phpmyadmin/)
   or from the MySQL command line:
   ```sql
   CREATE DATABASE wordpress;
   CREATE USER 'wordpress'@'%' IDENTIFIED WITH caching_sha2_password BY '***';
   GRANT ALL PRIVILEGES ON *.* TO 'wordpress'@'%' WITH GRANT OPTION;
   GRANT ALL PRIVILEGES ON `wordpress\_%`.* TO 'wordpress'@'%';
   flush privileges;
   ```

1. Setup file ownership:
   ```shell
   sudo cp map/config-localhost.php /etc/wordpress/config-localhost.php
   sudo chown -R www-data:www-data /usr/share/wordpress /var/lib/wordpress /etc/wordpress
   ```
   Test links:
   [http://localhost/blog](http://localhost/blog)
   [http://localhost/blog/wp-admin/](http://localhost/blog/wp-admin/)

1. Download required Wordpress plugins:
   * [JWT Authentication for WP REST API](https://wordpress.org/plugins/jwt-authentication-for-wp-rest-api/)
   * [Code Snippets](https://wordpress.org/plugins/code-snippets/)
   ```shell
   wget https://downloads.wordpress.org/plugin/code-snippets.zip \
        https://downloads.wordpress.org/plugin/jwt-authentication-for-wp-rest-api.1.2.6.zip \
        --directory-prefix=~/Downloads/
   ```
   Install the plugins `Plugin -> Add New -> Upload Plugin -> Browse ...` and activate them.

1. In the `/usr/share/wordpress/wp-config.php` define:
   ```php
   define('JWT_AUTH_SECRET_KEY', '<...>');
   ```

   If you want to call Wordpress' JWT auth api from another domain, add to the `wp-config.php`:

   ```php
   define('JWT_AUTH_CORS_ENABLE', true);
   ```

   The test:
   ```shell
   curl -H 'Content-Type: application/json' \
        -d '{"username":"wordpress","password":"<password>"}' \
        http://localhost/blog/index.php/wp-json/jwt-auth/v1/token
   ```
   should return:
   ```json
   {"token":"...","user_email":"<some email>","user_nicename":"wordpress","user_display_name":"wordpress"}
   ```

   Add a new Code Snippet (in PHP):
   ```php
   // https://developer.wordpress.org/reference/functions/add_filter/
   // $priority = 10, int $accepted_args = 2
   add_filter('jwt_auth_token_before_dispatch', 'add_user_info_jwt', 10, 2);

   function add_user_info_jwt($data, $user) {
       // $data['user_roles'] = implode(',', $user->roles);  // returns a string
       $data['user_roles'] = $user->roles; // returns an Array
       return $data;
   }
   ```
   Save and activate the code snippet!

   The test:
   ```shell
   curl -H 'Content-Type: application/json' \
        -d '{"username":"wordpress","password":"<password>"}' \
        http://localhost/blog/index.php/wp-json/jwt-auth/v1/token
   ```
   should return:
   ```json
   {"token":"...","user_email":"<some email>","user_nicename":"wordpress","user_display_name":"wordpress","user_roles":["administrator"]}
   ```

1. In order to invalidate the JWT Token after 8 hours, add another Code Snippet:

```php
function jwt_auth_expire_8_hours() {
  return time() + (DAY_IN_SECONDS / 3);
  }
add_filter('jwt_auth_expire', 'jwt_auth_expire_8_hours');
```

   Save and activate the code snippet!

### Angular Apps

For the information on how to install and setup angular as well as on how to
build an app, see here: [Angular Docs](https://angular.io/guide/setup-local)

### Angular App Versioning

#### New map-app version

1. Commit, stash or reset all changes made to any project.
1. Run:
   ```shell
   cd app-map
   # npm run app-map:version # no autocommit
   npm run app-map:version:commit
   ```

#### New form-app version

1. Commit, stash or reset all changes made to any project.
1. Run
   ```shell
   cd app-form
   # npm run app-form:version # no autocommit
   npm run app-form:version:commit
   ```

### Deployment

1. Make sure you have set up your `database.php` file described in the section
  above ("Setting up the database scripts"). This only has to be done once when
  deploying the apps for the first time or if the database configuration has
  changed.

1. Run:
   ```shell
   cd app-map
   npm run app-map:build:prod
   # in a new terminal
   cd app-form
   npm run app-form:build:prod
   ```
1. Check the `map/dist/` directory. It should have following structure:

   ```
     - dist/
       - AssociationMap/
         - api/
           - database.php
           - ...
         - assets/
           - ...
         - edit/
           - assets/
             - ...
           - index.html
           - ...
         - index.html
         - ...
   ```
1. Upload the contents of `map/dist/AssociationMap/` onto the root path of your
   server.

### Changing paths

If you don't want to upload the app(s) to the server root path, but to a
subdirectory on your server, you can achieve that following these steps:

1. In both apps (`app-map`, `app-form`), open and edit the
   `src/environments/environment.prod` file.

1. Change the `serverBasePath` variable to the location on your server you
   uploaded the `api` directory to.

1. Change the `rootPath` variable to the location on your server you uploaded
   the respective app directory to (directory containing the `index.html` and
   the assets directory).

1. Rebuild and redeploy the apps.

### Angular App Usage

If you uploaded the apps to the root path of the server and did not change the
default paths, the apps' content should appear at the following paths:

1. Open the app at
   `http(s)://[YOUR_SERVER_ADDRESS]/`.

1. The edit form can be used at
   `http(s)://[YOUR_SERVER_ADDRESS]/edit`.

1. The edit forms for the dropdown options can be used at
   `http(s)://[YOUR_SERVER_ADDRESS]/edit/options-form`.

### Commands useful to remove / reinstall Wordpress:
```shell
sudo rm -rf /var/lib/wordpress /usr/share/wordpress /etc/wordpress/
sudo mysql -uroot
```
```sql
DROP DATABASE wordpress;
```


# Data conversion ODS to JSON

By the convention the main color of uMap-test and uMap-prod versions are different.
Also the associations without public address have different color.

## Usage

### Clojure

```shell
cd data
# generate pom.xml (or create it manually)
clojure -Spom

# build
clojure -X:depstar uberjar :jar fdk.jar

# run - two alternatives:

# 1. run unsing clojure
clojure -M -m fdk.geo Vereinsinformationen_öffentlich_Stadtteilkarte.ods out.umap

# 2. run from java
java -jar fdk.jar Vereinsinformationen_öffentlich_Stadtteilkarte.ods out.umap
```

Both alternatives have an optional parameter specifying colors. E.g. for the
test version (using clojure):

```
clojure -M -m fdk.geo Vereinsinformationen_öffentlich_Stadtteilkarte.ods out.umap \
        '{:colors {:main "DarkBlue" :no-addr "DeepSkyBlue"}}'
```
### Typescript

```shell
# install nodejs
sudo npm install -g typescript
npm install --save-dev @types/node
npm install xlsx
```
Compile the typescript source code files as they change:
```shell
tsc *.ts --watch
```
Open a new console and run the data conversion:
```shell
node json.js
```

## License

Copyright © 2020, 2021

This program and the accompanying materials are made available under the
terms of the Eclipse Public License 2.0 which is available at
http://www.eclipse.org/legal/epl-2.0.

This Source Code may also be made available under the following Secondary
Licenses when the conditions for such availability set forth in the Eclipse
Public License, v. 2.0 are satisfied: GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or (at your
option) any later version, with the GNU Classpath Exception which is available
at https://www.gnu.org/software/classpath/license.html.
