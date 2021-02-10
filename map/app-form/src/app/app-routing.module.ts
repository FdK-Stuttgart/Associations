import {NgModule} from '@angular/core';
import {Routes, RouterModule} from '@angular/router';
import {AssociationFormComponent} from './association-form/association-form.component';
import {OptionsEditFormComponent} from './association-form/options-edit-form/options-edit-form.component';
import {AssociationFormDeactivateGuard, OptionsEditFormDeactivateGuard} from './association-form/guard';
import {NotFoundComponent} from './not-found/not-found.component';

export const routes: Routes = [
  {
    path: '',
    redirectTo: '/edit',
    pathMatch: 'full'
  },
  {
    path: 'edit',
    component: AssociationFormComponent,
    canDeactivate: [AssociationFormDeactivateGuard]
  },
  {
    path: 'edit/:associationId',
    component: AssociationFormComponent,
    canDeactivate: [AssociationFormDeactivateGuard]
  },
  {
    path: 'edit-options',
    component: OptionsEditFormComponent,
    canDeactivate: [OptionsEditFormDeactivateGuard]
  },
  {
    path: 'edit-options/:optionType',
    component: OptionsEditFormComponent,
    canDeactivate: [OptionsEditFormDeactivateGuard]
  },
  {
    path: '**',
    component: NotFoundComponent,
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {
}
