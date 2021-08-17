## About
Simple [uMap](https://umap.openstreetmap.fr/en/) replacement with an enhanced
search and filter capability. Custom-tailored.

![Screenshot](/map/app-map/src/assets/screenshot.png)

Import location and street address information by uploading an OpenDocument
spreadsheet (ods-table) into a WordPress-PostgreSQL database and display its
content on an OpenStreetMap layer.

To respect data privacy, providing street address information is optional. In
such a case a corresponding map-marker is placed on a nearby public place (park,
lake, etc.)

See the ods-table format
[description](/map/app-form/src/app/services/ods-table/ods.ts).

User authentication for the ods-table file upload is provided by a WordPress
installation using the [JWT Authentication for WP REST
API](https://wordpress.org/plugins/jwt-authentication-for-wp-rest-api/) plugin.

<!-- WIP: app-form -->
<!-- ![Screenshot](/map/app-form/src/assets/screenshot.png) -->

See also:
* [Live
environment](https://house-of-resources-stuttgart.de/stadtteilkarte-kontakt-zu-vereinen/)
* [uMap](https://umap.openstreetmap.fr/en/) and its [source
  code](https://github.com/umap-project/umap).
* [uMap Alternatives](https://alternativeto.net/software/umap/)
* [Masterportal](https://www.masterportal.org/references.html) and its [source
  code](https://bitbucket.org/geowerkstatt-hamburg/masterportalapi.git).
* Search DuckDuckGo for [uMap
  alternatives](https://duckduckgo.com/?q=umap+alternatives).
* Search Google for [uMap
  alternatives](https://www.google.com/search?q=umap+alternatives).

## Installation, configuration and development
See [developer documentation](install.md).

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

   When developing, in case of "mysqli_connect(): (HY000/2002): No such file or
   directory" use `127.0.0.1` instead of `localhost`:
   ```php
   define('DB_HOST', '127.0.0.1');
   ```

1. Development on Ubuntu: a PHP server may need to be started:
   ```bash
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
   Test database access:
   ```bash
   curl http://localhost:4201/api/districts-options/read-districts-options.php
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

See also [Angular - Setting up the local environment and workspace](https://angular.io/guide/setup-local).
* If on Ubuntu install Angular:
   ```bash
   sudo npm install -g @angular/cli
   ```
* else if on a virtualized file-system (GNU Guix) run
  [npm-g_nosudo](https://github.com/glenpike/npm-g_nosudo). Then install
  Angular:
   ```bash
   npm install -g @angular/cli
   ```

### Angular App versioning, build and deployment

Make sure you have set up your `database.php` file described in the section
above ("Setting up the database scripts"). This only has to be done once when
deploying the apps for the first time or if the database configuration has
changed.

Versioning & Build:
Run the `build` function from the `etc/profile`. After the build the `map/dist/`
should have this structure:
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

Deployment:
Run the `deploy_test` and/or `deploy_prod` function from the `etc/profile`.

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

### License

Copyright © 2020 - 2022

This program and the accompanying materials are made available under the
terms of the Eclipse Public License 2.0 which is available at
http://www.eclipse.org/legal/epl-2.0.

This Source Code may also be made available under the following Secondary
Licenses when the conditions for such availability set forth in the Eclipse
Public License, v. 2.0 are satisfied: GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or (at your
option) any later version, with the GNU Classpath Exception which is available
at https://www.gnu.org/software/classpath/license.html.
