import {BrowserModule} from '@angular/platform-browser';
import {NgModule} from '@angular/core';
import {AppRoutingModule} from './app-routing.module';
import {AppComponent} from './app.component';
import {BrowserAnimationsModule} from '@angular/platform-browser/animations';
import {AssociationFormModule} from './association-form/association-form.module';
import {HttpClientModule} from '@angular/common/http';
import {ButtonModule} from 'primeng/button';
import {NgbModule} from '@ng-bootstrap/ng-bootstrap';
import {AssociationFormDeactivateGuard} from './association-form/guard';

@NgModule({
  declarations: [
    AppComponent
  ],
  imports: [
    BrowserModule,
    BrowserAnimationsModule,
    AppRoutingModule,
    HttpClientModule,
    AssociationFormModule,
    ButtonModule,
    NgbModule
  ],
  bootstrap: [AppComponent],
  providers: [
    AssociationFormDeactivateGuard
  ]
})
export class AppModule {
}
