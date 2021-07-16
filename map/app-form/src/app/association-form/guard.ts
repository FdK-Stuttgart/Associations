import {CanDeactivate} from '@angular/router';
import {AssociationFormComponent} from './association-form.component';
import {OptionsEditFormComponent} from './options-edit-form/options-edit-form.component';
import {ImportEditFormComponent} from './import-edit-form/import-edit-form.component';

export class AssociationFormDeactivateGuard implements CanDeactivate<AssociationFormComponent> {

  async canDeactivate(component: AssociationFormComponent): Promise<boolean> {
    return await component.canDeactivate();
  }
}

export class OptionsEditFormDeactivateGuard implements CanDeactivate<OptionsEditFormComponent> {
  async canDeactivate(component: OptionsEditFormComponent): Promise<boolean> {
    return await component.canDeactivate();
  }
}

export class ImportEditFormDeactivateGuard implements CanDeactivate<ImportEditFormComponent> {
    async canDeactivate(component: ImportEditFormComponent): Promise<boolean> {
        return await component.canDeactivate();
    }
}
