import {Component, forwardRef, Input, OnChanges, OnInit, SimpleChanges, ViewChild} from '@angular/core';
import {DropdownOption, getInternalGroupedDropdownOptions, InternalGroupedDropdownOption} from '../../model/dropdown-option';
import {MultiSelect} from 'primeng/multiselect';
import {ControlValueAccessor, NG_VALUE_ACCESSOR} from '@angular/forms';

@Component({
  selector: 'app-grouped-multi-select',
  templateUrl: './grouped-multi-select.component.html',
  styleUrls: ['./grouped-multi-select.component.scss'],
  providers: [
    {
      provide: NG_VALUE_ACCESSOR,
      useExisting: forwardRef(() => GroupedMultiSelectComponent),
      multi: true
    }
  ]
})
export class GroupedMultiSelectComponent implements OnInit, OnChanges, ControlValueAccessor {
  @Input() options: DropdownOption[] = [];
  @Input() styleClass = '';
  @Input() placeholder = '';
  @Input() labelPlural = 'Elemente';
  @Input() selectTopOptions = true;

  @ViewChild('multiSelect', {static: true}) multiSelect!: MultiSelect;

  internalGroupedOptions: InternalGroupedDropdownOption[] = [];

  // tslint:disable-next-line:variable-name
  private _value: any[] = [];

  get value(): any[] {
    return this._value;
  }

  set value(val: any[]) {
    this._value = val;
    this.onChange(val);
    this.onTouch(val);
  }

  onChange: any = () => {
  };
  onTouch: any = () => {
  };

  registerOnChange(fn: any): void {
    this.onChange = fn;
  }

  registerOnTouched(fn: any): void {
    this.onTouch = fn;
  }

  writeValue(val: any[]): void {
    this.value = val;
    this.multiSelect.writeValue(val);
  }

  ngOnInit(): void {
    this.internalGroupedOptions = this.mapOptions(this.options ?? []);
  }

  ngOnChanges(changes: SimpleChanges): void {
    if (changes.options) {
      this.internalGroupedOptions = this.mapOptions(this.options ?? []);
    }
  }

  private mapOptions(options: DropdownOption[]): any {
    return getInternalGroupedDropdownOptions(options);
  }

  public getSelectedItemsLabel(): string {
    const selectedOptions = this.internalGroupedOptions
      .filter((o: InternalGroupedDropdownOption) => {
        if (this.value?.length && !!o) {
          return this.value.includes(o.value);
        }
        return false;
      });

    const selectedLabels = selectedOptions?.length > 0 ? selectedOptions
      .filter((o: any) => !!o.category)
      .map((o: InternalGroupedDropdownOption) => o.label) : [];

    if (!selectedLabels.length) {
      return this.placeholder;
    } else if (this.value.length === this.internalGroupedOptions.length) {
      return 'Alle ' + this.labelPlural + ' ausgewählt';
    } else if (selectedLabels.length > 0 && selectedLabels.length < 4) {
      return selectedLabels.join(', ');
    } else if (this.value.length === this.internalGroupedOptions.length) {
      return 'Alle ' + this.labelPlural + ' ausgewählt';
    } else {
      return selectedLabels.length + ' ' + this.labelPlural + ' ausgewählt';
    }
  }

  changeSelectedOptions(event: any): void {
    let selectedItems = this.value;
    const isItemChecked = event.value.length > this.value.length;
    const checkedItem = this.internalGroupedOptions.find((o: InternalGroupedDropdownOption) => o.value === event.itemValue);
    const checkedItemCategory = checkedItem?.category || checkedItem?.value;
    const isGroupHeader = !checkedItem?.isSubOption;

    if (isItemChecked) {
      selectedItems.push(event.itemValue);
      if (isGroupHeader) {
        const subOptionsToAdd = this.internalGroupedOptions.filter(
          (o: InternalGroupedDropdownOption) => o.category === checkedItemCategory
        );
        if (subOptionsToAdd.length) {
          subOptionsToAdd.forEach((optionToAdd: InternalGroupedDropdownOption) => {
            if (!selectedItems.includes(optionToAdd.value)) {
              selectedItems.push(optionToAdd.value);
            }
          });
        }
      }
    } else {
      selectedItems = selectedItems.filter((v: any) => v !== event.itemValue);
      if (isGroupHeader) {
        selectedItems = selectedItems.filter(
          (v: any) => {
            const option = this.internalGroupedOptions.find((o: InternalGroupedDropdownOption) => o.value === v);
            return !!option && option.category !== checkedItemCategory;
          }
        );
      }
    }

    if (this.selectTopOptions) {
      selectedItems = this.selectAllTopCategories(selectedItems);
    }

    // make sure only available options are left in the array
    selectedItems = selectedItems.filter((value: any) => {
      return !!value && this.internalGroupedOptions.map(o => o.value).includes(value);
    });

    this.writeValue(selectedItems);
  }

  private isSubOption(option: InternalGroupedDropdownOption): boolean {
    return option.isSubOption;
  }

  private selectAllTopCategories(tempSelectedOptions: any[]): any[] {
    tempSelectedOptions.forEach((val: any) => {
      const option = this.internalGroupedOptions.find((o: InternalGroupedDropdownOption) => o.value === val);
      const topOption = this.internalGroupedOptions.find(
        (o: InternalGroupedDropdownOption) => option && !o.isSubOption && o.value === option?.category
      );
      if (topOption && !tempSelectedOptions.includes(topOption.value)) {
        tempSelectedOptions.push(topOption.value);
      }
    });
    return tempSelectedOptions.sort();
  }
}
