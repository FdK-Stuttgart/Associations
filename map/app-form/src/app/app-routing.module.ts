import {NgModule} from '@angular/core';
import {Routes, RouterModule} from '@angular/router';
import {AssociationFormComponent} from './association-form/association-form.component';
import {OptionsEditFormComponent} from './association-form/options-edit-form/options-edit-form.component';
import {AssociationFormDeactivateGuard, OptionsEditFormDeactivateGuard} from './association-form/guard';

export const routes: Routes = [
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
