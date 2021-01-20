import {NgModule} from '@angular/core';
import {Routes, RouterModule} from '@angular/router';
import {OsmMapComponent} from './osm-map/osm-map.component';
import {AssociationFormComponent} from './association-form/association-form.component';
import {OptionsEditFormComponent} from './association-form/options-edit-form/options-edit-form.component';

export const routes: Routes = [
  {
    path: '',
    redirectTo: '/',
    pathMatch: 'full'
  },
  {
    path: '',
    component: OsmMapComponent
  },
  {
    path: 'form',
    component: AssociationFormComponent
  },
  {
    path: 'options-form',
    component: OptionsEditFormComponent
  },
  {
    path: 'options-form/:optionType',
    component: OptionsEditFormComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {
}
