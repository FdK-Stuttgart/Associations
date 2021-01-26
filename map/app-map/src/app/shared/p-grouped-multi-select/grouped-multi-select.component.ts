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
  @Input() selectUpperCategories = true;

  @ViewChild('multiSelect', {static: true}) multiSelect!: MultiSelect;

  internalGroupedOptions: InternalGroupedDropdownOption[] = [];

  // tslint:disable-next-line:variable-name
  private _value: number[] = [];

  get value(): number[] {
    return this._value;
  }

  set value(val: number[]) {
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

  writeValue(val: number[]): void {
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
      .filter((o: any) => o.value % 100 !== 0)
      .map((o: InternalGroupedDropdownOption) => o.label) : [];

    if (!selectedLabels.length) {
      return this.placeholder;
    } else if (this.value.length === this.internalGroupedOptions.length) {
      return 'Alle ' + this.labelPlural + ' ausgewählt';
    } else if (selectedLabels.length > 0 && selectedLabels.length < 4) {
      return selectedLabels.join(', ');
    } else {
      return selectedLabels.length + ' ' + this.labelPlural + ' ausgewählt';
    }
  }

  changeSelectedOptions(event: any): void {
    let selectedItems = this.value;
    const itemChecked = event.value.length > this.value.length;
    const groupHeader = event.itemValue % 100 === 0;

    if (itemChecked) {
      selectedItems.push(event.itemValue);
      if (groupHeader) {
        const subOptionsToAdd = this.internalGroupedOptions.filter(
          (o: InternalGroupedDropdownOption) => o.value > event.itemValue && o.value < (event.itemValue + 100)
        );
        if (subOptionsToAdd.length) {
          subOptionsToAdd.forEach((optionToAdd: InternalGroupedDropdownOption) => {
            selectedItems.push(optionToAdd.value);
          });
        }
      }
    } else {
      selectedItems = selectedItems.filter((v: any) => v !== event.itemValue);
      if (groupHeader) {
        selectedItems = selectedItems.filter(
          (v: any) => v < event.itemValue || v >= (event.itemValue + 100)
        );
      }
    }


    if (this.selectUpperCategories) {
      selectedItems = this.selectAllUpperCategories(selectedItems);
    }
    this.writeValue(selectedItems);
  }

  private isSubOption(option: InternalGroupedDropdownOption): boolean {
    return option.isSubOption;
  }

  private selectAllUpperCategories(tempSelectedOptions: number[]): number[] {
    tempSelectedOptions.forEach((val: number) => {
      const floored = Math.floor(val / 100) * 100;
      if (!tempSelectedOptions.includes(floored)) {
        tempSelectedOptions.push(floored);
      }
    });
    return tempSelectedOptions.sort();
  }
}
