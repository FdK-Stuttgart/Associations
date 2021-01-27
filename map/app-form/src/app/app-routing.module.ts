import {NgModule} from '@angular/core';
import {Routes, RouterModule} from '@angular/router';
import {AssociationFormComponent} from './association-form/association-form.component';
import {OptionsEditFormComponent} from './association-form/options-edit-form/options-edit-form.component';

export const routes: Routes = [
  {
    path: 'options-form',
    component: OptionsEditFormComponent
  },
  {
    path: 'options-form/:optionType',
    component: OptionsEditFormComponent
  },
  {
    path: '**',
    component: AssociationFormComponent
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule {
}
