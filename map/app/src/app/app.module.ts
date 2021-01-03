import {BrowserModule} from '@angular/platform-browser';
import {NgModule} from '@angular/core';
import {AppRoutingModule} from './app-routing.module';
import {AppComponent} from './app.component';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {OsmMapModule} from './osm-map/osm-map.module';
import {AssociationFormModule} from './association-form/association-form.module';
import {HttpClientModule} from '@angular/common/http';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    OsmMapModule,
    HttpClientModule,
    AssociationFormModule
  ],
  bootstrap: [AppComponent]
})
export class AppModule {
}
