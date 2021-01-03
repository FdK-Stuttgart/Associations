# AssociationMap

## Setup

1. Set up a mySQL database on your server. Current DB name of the database is `reaper93_associations`. Can be renamed.
2. Create user and grant permissions to database. Current user name is `reaper93`. Can be renamed.
3. Now, import the `.sql` file from the `database/db-export/` folder to your database. This will automatically create all necessary tables with some contents. 

    Depending on your MySQL environment, you can do this using the [phpMyAdmin](https://www.phpmyadmin.net/) GUI interface or via the command line. In phpMyAdmin, you just click on the newly created database and select `Import` from the top menu. Then you can upload the `.sql` file to your database.

3. In the `/database/api` folder open `database.php`. Edit user name, database name and password according to your changes in (1.), (2.) and (3.).
4. Upload the `/api` folder to a directory on your server.
5. Open the `/app` folder. In `/app/src/environments/` open `environments.prod.ts`. You will find the following:
    
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

6. Change the `serverBasePath` variable to the location on your server you uploaded the `/api` folder to.
7. Build the angular app by executing `npm install` and the `build:prod` script in `package.json`. 
    
    For further information on how to install and setup angular as well as on how to build an app, see here: [Angular Docs](https://angular.io/guide/setup-local)

8. The built app will appear inside the `app/dist` folder. Upload the `dist/AssociationMap` directory to a location on your server.

9. Open the app at `http(s)://[YOUR_SERVER]/[PATH_TO_CHOSEN_LOCATION]/AssociationMap`.

10. The edit form can be used at  `http(s)://[YOUR_SERVER]/[PATH_TO_CHOSEN_LOCATION]/AssociationMap/form`.