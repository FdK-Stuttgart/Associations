import {NgModule} from '@angular/core';
import {Routes, RouterModule} from '@angular/router';
import {OsmMapComponent} from './osm-map/osm-map.component';
import {NotFoundComponent} from './not-found/not-found.component';

export const routes: Routes = [
  {
    path: '',
    component: OsmMapComponent
  },
  {
    path: '**',
    component: NotFoundComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {
}
