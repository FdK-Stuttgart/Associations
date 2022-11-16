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

################################ Kit Framework ################################

# cmap

Start a [REPL](#repls) in your editor or terminal of choice.

Start the server with:

```clojure
(go)
```

The default API is available under http://localhost:3000/api

System configuration is available under `resources/system.edn`.

To reload changes:

```clojure
(reset)
```

## REPLs

### Cursive

Configure a [REPL following the Cursive documentation](https://cursive-ide.com/userguide/repl.html). Using the default "Run with IntelliJ project classpath" option will let you select an alias from the ["Clojure deps" aliases selection](https://cursive-ide.com/userguide/deps.html#refreshing-deps-dependencies).

### CIDER

Use the `cider` alias for CIDER nREPL support (run `clj -M:dev:cider`). See the [CIDER docs](https://docs.cider.mx/cider/basics/up_and_running.html) for more help.

Note that this alias runs nREPL during development. To run nREPL in production (typically when the system starts), use the kit-nrepl library through the +nrepl profile as described in [the documentation](https://kit-clj.github.io/docs/profiles.html#profiles).

### Command Line

Run `clj -M:dev:nrepl` or `make repl`.

Note that, just like with [CIDER](#cider), this alias runs nREPL during development. To run nREPL in production (typically when the system starts), use the kit-nrepl library through the +nrepl profile as described in [the documentation](https://kit-clj.github.io/docs/profiles.html#profiles).
