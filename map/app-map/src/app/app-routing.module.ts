import {NgModule} from '@angular/core';
import {Routes, RouterModule} from '@angular/router';
import {OsmMapComponent} from './osm-map/osm-map.component';

export const routes: Routes = [
  {
    path: '**',
    component: OsmMapComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {
}
