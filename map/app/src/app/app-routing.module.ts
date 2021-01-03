import {NgModule} from '@angular/core';
import {Routes, RouterModule} from '@angular/router';
import {OsmMapComponent} from './osm-map/osm-map.component';
import {AssociationFormComponent} from './association-form/association-form.component';

export const routes: Routes = [
  {
    path: '',
    redirectTo: '/osm',
    pathMatch: 'full'
  },
  {
    path: 'osm',
    component: OsmMapComponent
  },
  {
    path: 'form',
    component: AssociationFormComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {
}
