import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {GroupedMultiSelectComponent} from './p-grouped-multi-select/grouped-multi-select.component';
import {MultiSelectModule} from 'primeng/multiselect';
import {CheckboxModule} from 'primeng/checkbox';
import {FormsModule} from '@angular/forms';
import {TruncatePipe} from './truncate/truncate.pipe';
import {ToastModule} from 'primeng/toast';
import {AssociationsListComponent} from './associations-list/associations-list.component';


@NgModule({
  declarations: [
    GroupedMultiSelectComponent,
    TruncatePipe,
    AssociationsListComponent
  ],
  exports: [
    GroupedMultiSelectComponent,
    TruncatePipe,
    ToastModule,
    AssociationsListComponent
  ],
  imports: [
    CommonModule,
    MultiSelectModule,
    CheckboxModule,
    FormsModule,
    ToastModule
  ]
})
export class SharedModule {
}
