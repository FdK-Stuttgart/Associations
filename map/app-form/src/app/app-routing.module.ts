import {NgModule} from '@angular/core';
import {Routes, RouterModule} from '@angular/router';
import {AssociationFormComponent} from './association-form/association-form.component';
import {OptionsEditFormComponent} from './association-form/options-edit-form/options-edit-form.component';
import {AssociationFormDeactivateGuard, OptionsEditFormDeactivateGuard} from './association-form/guard';
import {NotFoundComponent} from './not-found/not-found.component';

export const routes: Routes = [
  {
    path: '',
    component: AssociationFormComponent
  },
  {
    path: ':associationId',
    component: AssociationFormComponent
  },
  {
    path: 'options-form',
    component: OptionsEditFormComponent,
    canDeactivate: [OptionsEditFormDeactivateGuard]
  },
  {
    path: 'options-form/:optionType',
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
