import {NgModule} from '@angular/core';
import {Routes, RouterModule} from '@angular/router';
import {AssociationFormComponent} from './association-form/association-form.component';
import {OptionsEditFormComponent} from './association-form/options-edit-form/options-edit-form.component';
import {AssociationFormDeactivateGuard} from './association-form/guard';

export const routes: Routes = [
  {
    path: 'options-form',
    component: OptionsEditFormComponent,
    canDeactivate: [AssociationFormDeactivateGuard]
  },
  {
    path: 'options-form/:optionType',
    component: OptionsEditFormComponent,
    canDeactivate: [AssociationFormDeactivateGuard]
  },
  {
    path: '**',
    component: AssociationFormComponent,
    canDeactivate: [AssociationFormDeactivateGuard]
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {
}
