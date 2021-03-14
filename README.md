# FdK

See also [OpenStreetMap uMap](https://wiki.openstreetmap.org/wiki/UMap)

# AssociationMap

## Setup

### Setting up the database

Depending on your MySQL environment, you can do this using the
[phpMyAdmin](https://www.phpmyadmin.net/) GUI interface or via the command line.

#### From command line

1. Install MySQL and make sure it's running. On Ubuntu:
   ```bash
   sudo apt install mysql-server
   systemctl status mysql.service
   ```

2. Set up a MySQL database on your server. Current DB name of the database is
   `associations`. Can be renamed.
   ```mysql
   DROP DATABASE IF EXISTS associations;
   CREATE DATABASE IF NOT EXISTS associations;
   ```

3. Create user and grant permissions to database.
   ```mysql
   CREATE USER 'user'@'localhost' IDENTIFIED BY 'REPLACE WITH SOME GOOD PASSWORD';
   GRANT ALL PRIVILEGES ON associations.* TO 'user'@'localhost' WITH GRANT OPTION;
   exit
   ```

4. Now, import the `.sql` file from the `map/database/db-export/` folder to your
   database. This will automatically create all necessary tables with some
   contents.
   ```bash
   mysql -uuser --table associations < map/database/db-export/associations.sql
   ```

5. Verify the import. Login to the dbase:
   ```bash
   mysql -uuser associations
   ```
   Now in MySQL:
   ```mysql
   SHOW TABLES;
   SHOW COLUMNS activities;
   SHOW COLUMNS associations;
   SHOW COLUMNS contacts;
   SHOW COLUMNS districts;
   SHOW COLUMNS images;
   SHOW COLUMNS links;
   SHOW COLUMNS socialmedia;
   ```

#### Using [phpMyAdmin](https://www.phpmyadmin.net/) GUI interface

Click on the newly created database and select `Import` from the top menu. Then
you can upload the `.sql` file to your database.


### Setting up the database scripts

1. In the `map/database/api` folder, copy the `_database.php` file and rename it to `database.php`. 
2. Edit `DB_HOST`, `DB_NAME`, `DB_USER` and `DB_PASS` according to your configuration made in the steps 
   (1.), (2.) and (3.) of the previous section. To stick with the example, change the lines from
   
   ```php
    define('DB_HOST', '');
	define('DB_NAME', '');
	define('DB_USER', '');
	define('DB_PASS', '');
   ```
   
   to
   
   ```php
    define('DB_HOST', 'your.mysql.host.com');
	define('DB_NAME', 'associations');
	define('DB_USER', 'user');
	define('DB_PASS', 'REPLACE WITH SOME GOOD PASSWORD');
   ```
   
Leave the `database.php` file in the `/database/api/` folder. This way, it will be copied to the right location when deploying the apps. 
**The file will NOT be committed to the Git repository.**   

### Angular

For further information on how to install and setup angular as well as on how to
build an app, see here: [Angular Docs](https://angular.io/guide/setup-local)
   
### Versioning

#### New map app version

1. Commit, stash or reset all changes made to any project.
2. Go into the `app-map` folder. 
3. Run `app-map:version` script in `package.json`. If you want to make a commit for the new version automatically, run `app-map:version:commit`.


#### New form app version

1. Commit, stash or reset all changes made to any project.
2. Go into the `app-form` folder. 
3. Run `app-form:version` script in `package.json`. If you want to make a commit for the new version automatically, run `app-form:version:commit`.

### Deploying

1. Make sure you have set up your `database.php` file described in the section above 
  ("Setting up the database scripts"). This only has to be done once when deploying the apps for the first time
   or if the database configuration has changed.
2. Go into the `app-map` folder. 
3. Run `app-map:build:prod` script in `package.json`. 
4. Go into the `app-form` folder. 
5. Run `app-form:build:prod` script in `package.json`.
6. Check your `map/dist/` folder. It should be structured as follows:

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

7. Upload the contents of `map/dist/AssociationMap/` onto the root path of your server.

### Changing paths

If you don't want to upload the app(s) to the server root path, but to a subdirectory 
on your server, you can achieve that following these steps:

1. In both apps (`app-map`, `app-form`), open and edit the `src/environments/environment.prod` file.
2. Change the `serverBasePath` variable to the location on your server you uploaded the `api` folder to.
3. Change the `rootPath` variable to the location on your server you uploaded the respective app directory to (folder containing the `index.html` and the assets folder).
4. Rebuild the apps and re-upload.

### Use the apps

If you uploaded the apps to the root path of the server and did not change the default paths, the apps'
content should appear at the following paths:

1. Open the app at `http(s)://[YOUR_SERVER_ADDRESS]/`.

2. The edit form can be used at `http(s)://[YOUR_SERVER_ADDRESS]/edit`.

3. The edit forms for the dropdown options can be used at `http(s)://[YOUR_SERVER_ADDRESS]/edit/options-form`.



# Data conversion ODS to JSON

## Usage

### Clojure

```bash
cd data
# generate pom.xml (or create it manually)
clojure -Spom

# build
clojure -X:uberjar

# run - two alternatives:

# 1. run unsing clojure
clojure -M -m fdk.geo Vereinsinformationen_öffentlich_Stadtteilkarte.ods out.umap

# 2. run from java
java -jar fdk.jar Vereinsinformationen_öffentlich_Stadtteilkarte.ods out.umap
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
