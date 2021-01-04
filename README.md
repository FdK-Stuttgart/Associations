# FdK

See also [OpenStreetMap uMap](https://wiki.openstreetmap.org/wiki/UMap)

# AssociationMap

## Setup

1. Set up a mySQL database on your server. Current DB name of the database is
   `reaper93_associations`. Can be renamed.
2. Create user and grant permissions to database. Current user name is
   `reaper93`. Can be renamed.
3. Now, import the `.sql` file from the `map/database/db-export/` folder to your
   database. This will automatically create all necessary tables with some
   contents.

Depending on your MySQL environment, you can do this using the
[phpMyAdmin](https://www.phpmyadmin.net/) GUI interface or via the command line.
In phpMyAdmin, you just click on the newly created database and select `Import`
from the top menu. Then you can upload the `.sql` file to your database.

3. In the `map/database/api` folder open `database.php`. Edit user name,
   database name and password according to your changes in (1.), (2.) and (3.).
4. Upload the `map/api` folder to a directory on your server.
5. Open the `map/app` folder. In `map/app/src/environments/` open
   `environments.prod.ts`. You will find the following:

```typescript
export const environment = {
  production: true,
  ...
  phpApi: {
    serverBasePath: '/AssociationMap/api'
  }
  ...
};
```

6. Change the `serverBasePath` variable to the location on your server you
   uploaded the `map/api` folder to.
7. Build the angular app by executing `npm install` and the `build:prod` script
   in `package.json`.

For further information on how to install and setup angular as well as on how to
build an app, see here: [Angular Docs](https://angular.io/guide/setup-local)

8. The built app will appear inside the `map/app/dist` folder. Upload the
   `map/dist/AssociationMap` directory to a location on your server.

9. Open the app at
   `http(s)://[YOUR_SERVER]/[PATH_TO_CHOSEN_LOCATION]/AssociationMap`.

10. The edit form can be used at
    `http(s)://[YOUR_SERVER]/[PATH_TO_CHOSEN_LOCATION]/AssociationMap/form`.

# Data conversion ods -> json

## Usage

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

## License

Copyright © 2020

This program and the accompanying materials are made available under the
terms of the Eclipse Public License 2.0 which is available at
http://www.eclipse.org/legal/epl-2.0.

This Source Code may also be made available under the following Secondary
Licenses when the conditions for such availability set forth in the Eclipse
Public License, v. 2.0 are satisfied: GNU General Public License as published by
the Free Software Foundation, either version 2 of the License, or (at your
option) any later version, with the GNU Classpath Exception which is available
at https://www.gnu.org/software/classpath/license.html.
