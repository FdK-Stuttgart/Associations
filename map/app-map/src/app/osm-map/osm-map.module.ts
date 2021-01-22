import {NgModule} from '@angular/core';
import {CommonModule} from '@angular/common';
import {OsmMapComponent} from './osm-map.component';
import {AutoCompleteModule} from 'primeng/autocomplete';
import {SidebarModule} from 'primeng/sidebar';
import {ButtonModule} from 'primeng/button';
import {DropdownModule} from 'primeng/dropdown';
import {SharedModule} from '../shared/shared.module';
import {FormsModule} from '@angular/forms';
import {BlockUIModule} from 'primeng/blockui';
import {ProgressSpinnerModule} from 'primeng/progressspinner';

@NgModule({
  declarations: [OsmMapComponent],
  imports: [
    CommonModule,
    AutoCompleteModule,
    SidebarModule,
    ButtonModule,
    DropdownModule,
    SharedModule,
    FormsModule,
    BlockUIModule,
    ProgressSpinnerModule
  ]
})
export class OsmMapModule {
}
