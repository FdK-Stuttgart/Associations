# FdK

See also [OpenStreetMap uMap](https://wiki.openstreetmap.org/wiki/UMap)

# AssociationMap

## MySQL Database installation and setup

Depending on your MySQL environment, you can do this using the from the command
line or with [phpMyAdmin](https://www.phpmyadmin.net/) GUI.

### From the Ubuntu command line

1. Install Wordpress, PHP, MySQL phpMyAdmin:
   ```bash
   sudo apt install wordpress php libapache2-mod-php php-mysql mysql-server mysql-client mysql-common phpmyadmin
   ```
   Make sure MySQL is running:
   ```bash
   systemctl status mysql.service
   ```
1. Set up a MySQL database on your server. (The name of the database is
   `associations`, however it can be renamed.):
   ```shell
   sudo mysql -uroot
   ```
   Then on the MySQL command line:
   ```sql
   DROP DATABASE IF EXISTS associations;
   CREATE DATABASE IF NOT EXISTS associations;
   ```

1. Create user and grant permissions to database:
   ```sql
   CREATE USER 'user'@'localhost' IDENTIFIED BY '<YOUR-PASSWORD>';
   GRANT ALL PRIVILEGES ON associations.* TO 'user'@'localhost' WITH GRANT OPTION;
   flush privileges;
   exit
   ```

1. Import the data. Attention! The script drops existing `associations`
   database. Any existing data will be lost.
   ```
   mysql -uuser --table --password associations < map/database/db-export/associations.sql
   ```
1. Verify the import. Login to MySQL and connect to the `associations` database:
   ```bash
   mysql -uuser --table --password associations
   ```
   And from the MySQL command line:
   ```sql
   SHOW TABLES;
   SHOW COLUMNS IN activities;
   SHOW COLUMNS IN associations;
   SHOW COLUMNS IN contacts;
   SHOW COLUMNS IN districts;
   SHOW COLUMNS IN images;
   SHOW COLUMNS IN links;
   SHOW COLUMNS IN socialmedia;
   ```

### Database setup with [phpMyAdmin](localhost:80/phpmyadmin/index.php) GUI

Click on the newly created database and select `Import` from the top menu. Then
you can upload the `.sql` file to your database.


## Setup PHP scripts for database access

1. Copy connection-template to a new file:
   ```bash
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

## Setup Wordpress Development Environment

See also how to [Install and configure WordPress](https://ubuntu.com/tutorials/install-and-configure-wordpress)

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
   ```bash
   sudo cp map/config-localhost.php /etc/wordpress/config-localhost.php
   sudo chown -R www-data:www-data /usr/share/wordpress /var/lib/wordpress /etc/wordpress
   ```
   Test links:
   [http://localhost/blog](http://localhost/blog)
   [http://localhost/blog/wp-admin/](http://localhost/blog/wp-admin/)

1. Download required Wordpress plugins:
   * [JWT Authentication for WP REST API](https://wordpress.org/plugins/jwt-authentication-for-wp-rest-api/)
   * [Code Snippets](https://wordpress.org/plugins/code-snippets/)
   ```bash
   wget https://downloads.wordpress.org/plugin/code-snippets.zip \
        https://downloads.wordpress.org/plugin/jwt-authentication-for-wp-rest-api.1.2.6.zip \
        --directory-prefix=~/Downloads/
   ```
   Install the plugins `Plugin -> Add New -> Upload Plugin -> Browse ...` and activate them.

1. In the `/usr/share/wordpress/wp-config.php` define:
   ```php
   define('JWT_AUTH_SECRET_KEY', '<...>');
   ```
   
   If you want to call Wordpress' JWT auth api from another domain, you have to add the following line to the `wp-config.php` as well:
   
   ```php
   define('JWT_AUTH_CORS_ENABLE', true);
   ```
   
   The test:
   ```bash
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
   ```bash
   curl -H 'Content-Type: application/json' \
        -d '{"username":"wordpress","password":"<password>"}' \
        http://localhost/blog/index.php/wp-json/jwt-auth/v1/token
   ```
   should return:
   ```json
   {"token":"...","user_email":"<some email>","user_nicename":"wordpress","user_display_name":"wordpress","user_roles":["administrator"]}
   ```

1. In order to invalidate the JWT Token after 8 hours, add the following filter to the Wordpress Theme's `functions.php` (located in `wp-content/themes/{your-theme-name}/functions.php`):

```php 
function jwt_auth_expire_8_hours() {
  return time() + (DAY_IN_SECONDS / 3);
  }
add_filter('jwt_auth_expire', 'jwt_auth_expire_8_hours');
```


### Angular Apps

For the information on how to install and setup angular as well as on how to
build an app, see here: [Angular Docs](https://angular.io/guide/setup-local)

### Angular App Versioning

#### New map-app version

1. Commit, stash or reset all changes made to any project.
1. Run:
   ```bash
   cd app-map
   npm run app-map:version
   ```
   or if you want to make a commit for the new version automatically, run `npm
   run app-form:version:commit`.

#### New form-app version

1. Commit, stash or reset all changes made to any project.
1. Run
   ```bash
   cd app-form
   npm run app-form:version
   ```
   or if you want to make a commit for the new version automatically, run `npm
   run app-form:version:commit`.

### Deployment

1. Make sure you have set up your `database.php` file described in the section
  above ("Setting up the database scripts"). This only has to be done once when
  deploying the apps for the first time or if the database configuration has
  changed.

1. Run:
   ```bash
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
```bash
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

```bash
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

```bash
# install nodejs
sudo npm install -g typescript
npm install --save-dev @types/node
npm install xlsx
```
Compile the typescript source code files as they change:
```bash
tsc *.ts --watch
```
Open a new console and run the data conversion:
```bash
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
