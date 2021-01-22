import {Component, OnDestroy, OnInit} from '@angular/core';
import {DropdownOption} from '../../model/dropdown-option';
import {MysqlQueryService} from '../../services/mysql-query.service';
import {AbstractControl, FormArray, FormBuilder, FormControl, FormGroup, Validators} from '@angular/forms';
import {MysqlPersistService} from '../../services/mysql-persist.service';
import {ConfirmationService, MessageService} from 'primeng/api';
import {Subscription} from 'rxjs';
import {ActivatedRoute, Router} from '@angular/router';
import {environment} from '../../../environments/environment';

function findDuplicates(arr: any[]): any[] {
  const sortedArr = arr.sort();
  const results = [];
  for (let i = 0; i < sortedArr.length - 1; i++) {
    if (sortedArr[i + 1] === sortedArr[i]) {
      results.push(sortedArr[i]);
    }
  }
  return results.sort();
}

@Component({
  selector: 'app-edit-options-form',
  templateUrl: './options-edit-form.component.html',
  styleUrls: ['./options-edit-form.component.scss'],
  providers: [
    MessageService,
    ConfirmationService,
  ]
})
export class OptionsEditFormComponent implements OnInit, OnDestroy {
  optionType: 'activities' | 'districts' = 'activities';

  options: DropdownOption[] = [];

  optionsForm: FormGroup = new FormGroup({});

  addedIndex: number | undefined;

  blocked = false;
  loadingText = 'Optionen werden abgerufen...';

  sub: Subscription | undefined;

  get duplicateValues(): any[] {
    if (!this.optionsForm?.value?.options?.length) {
      return [];
    }
    const options = this.optionsForm.value.options;
    const values = options.map((o: any) => o.value);
    return findDuplicates(values);
  }

  get doAllOptionsHaveAnUpperCategory(): any[] {
    if (!this.optionsForm?.value?.options?.length) {
      return [];
    }
    const options = this.optionsForm.value.options;
    const values: any[] = options.map((o: any) => o.value);
    const missing: any[] = [];
    values.forEach((v: number) => {
      const floor100 = Math.floor(v / 100) * 100;
      if (!values.includes(floor100) && !missing.includes(floor100)) {
        missing.push(floor100);
      }
    });
    return missing.sort();
  }

  constructor(private mySqlQueryService: MysqlQueryService,
              private mySqlPersistService: MysqlPersistService,
              private messageService: MessageService,
              private confirmationService: ConfirmationService,
              private formBuilder: FormBuilder,
              private router: Router,
              private route: ActivatedRoute) {
  }

  async ngOnInit(): Promise<void> {
    this.sub = this.route.params.subscribe(async params => {
      if (params.optionType) {
        if (params.optionType !== this.optionType) {
          await this.reset(params.optionType);
        }
      }
    });

    window.history.replaceState({}, '', `${environment.rootPath}/options-form/${this.optionType}`);
    await this.reinitForm();
  }

  /**
   * queries options from database and reinits the form
   */
  async reinitForm(): Promise<void> {
    this.loadingText = 'Optionen werden abgerufen...';
    this.blocked = true;
    this.addedIndex = undefined;

    if (this.optionType === 'activities') {
      this.options = (await this.mySqlQueryService.getActivitiesOptions())?.data || [];
    } else if (this.optionType === 'districts') {
      this.options = (await this.mySqlQueryService.getDistrictOptions())?.data || [];
    }

    this.optionsForm = new FormGroup({
      options: new FormArray([])
    });

    if (this.options?.length) {
      const optionControl = (this.optionsForm.controls.options as FormArray);

      this.options.forEach((option: DropdownOption) => {
        optionControl.push(this.formBuilder.group({
          value: new FormControl(option.value, [Validators.required, Validators.min(0)]),
          _oldValue: new FormControl(option.value),
          label: new FormControl(option.label, Validators.required)
        }));
      });
    }

    this.optionsForm.updateValueAndValidity();

    this.blocked = false;
  }

  /**
   * returns all form groups from a form array
   * @param control the form array control
   */
  getFormGroupsFromFormArray(control: AbstractControl): FormGroup[] | undefined {
    try {
      const fa: FormArray = control as FormArray;

      if (fa) {
        return fa.controls.map((c: AbstractControl) => c as FormGroup);
      }
    } catch {
    }
    return undefined;
  }

  /**
   * get a specific form group from a form array
   * @param array the form array
   * @param index the index of the form group to return
   */
  getFormArrayFormGroup(array: string, index: number): FormGroup | undefined {
    try {
      return ((this.optionsForm.controls[array] as FormArray).at(index) as FormGroup);
    } catch {
      return undefined;
    }
  }

  /**
   * remove a element form a form array by its index
   * @param formArray the form array
   * @param i index
   */
  remove(formArray: AbstractControl, i: number): void {
    this.confirmationService.confirm({
      header: 'Löschen?',
      message: `Möchten Sie diese Option wirklich löschen?<br><br>Wenn Sie die Werte der Optionen verändern oder `
        + `löschen,<br>kann dies zu fehlerhaften Zuordnungen von Vereinen zu <br>`
        + `${this.optionType === 'activities' ? 'Tätigkeitsfeldern' : (this.optionType === 'districts' ? 'Aktivitätsgebieten' : 'Optionen')}`
        + ` führen!`,
      acceptLabel: 'OK',
      rejectLabel: 'Abbrechen',
      closeOnEscape: true,
      accept: async () => {
        this.addedIndex = undefined;
        if (formArray as FormArray) {
          (formArray as FormArray).removeAt(i);
        }
      }
    });
  }

  /**
   * checks if a value is an upper category value
   * @param value given option value
   */
  isUpperCategory(value: number): boolean {
    return value % 100 === 0;
  }

  /**
   * checks if an upper category has sub-options
   * @param value the upper category value
   */
  hasSubOptions(value: number): boolean {
    if (!this.isUpperCategory(value)) {
      return false;
    }

    const options = this.optionsForm.controls.options.value;
    const optionValues = options.map((o: any) => o.value);
    const ceil100 = value + 100;

    return optionValues.some((v: number) => v > value && v < ceil100);
  }

  /**
   * checks if the given value is the last sub-option in an upper category
   * @param value given sub-option value
   */
  isLastSubcategory(value: number): boolean {
    if (this.isUpperCategory(value)) {
      return false;
    }

    const options = this.optionsForm.controls.options.value;
    const optionValues = options.map((o: any) => o.value);
    const ceil100 = Math.ceil(value / 100) * 100;

    return !optionValues.some((v: number) => v > value && v < ceil100);
  }

  /**
   * returns the next available non-used upper category value
   */
  getNextAvailableUpperCategoryValue(): number {
    const options = this.optionsForm.controls.options.value;
    const upperCategories = options.filter((o: any) => o.value % 100 === 0).map((o: any) => o.value);
    let i = 100;
    while (upperCategories.includes(i)) {
      i += 100;
    }
    return i;
  }

  /**
   * returns the next available non-used sub option value (or undefined, if all values are already used)
   * @param value value of the current sub-option
   */
  getNextAvailableSubOptionValue(value: number): number | undefined {
    const floor100 = Math.floor(value / 100) * 100;
    let ceil100 = Math.ceil(value / 100) * 100;
    if (ceil100 === floor100) {
      ceil100 += 100;
    }
    const options = this.optionsForm.controls.options.value;
    const optionValues = options.map((o: any) => o.value).filter((v: number) => v > floor100 && v < ceil100);
    let i = floor100;
    do {
      i++;
    } while (optionValues.includes(i) && i < ceil100);
    if (optionValues.includes(i)) {
      return undefined;
    }
    return i;
  }

  /**
   * adds a sub-option to the form array
   * @param value value of the option to add
   */
  addOption(value: number): void {
    this.addedIndex = undefined;

    const formArray: FormArray = this.optionsForm.controls.options as FormArray;

    if (formArray) {
      const formGroup: FormGroup = this.formBuilder.group({
        value: new FormControl(value, [Validators.required, Validators.min(0)]),
        _oldValue: new FormControl(value),
        label: new FormControl('', Validators.required)
      });

      formArray.push(formGroup);
      formArray.controls = this.sortFormArray(this.optionsForm.controls.options as FormArray);

      const added = formArray.controls.find((fc: AbstractControl) => fc === formGroup) as FormGroup;
      if (added) {
        this.addedIndex = formArray.controls.indexOf(added);

        this.optionsForm.updateValueAndValidity();

        setTimeout(() => {
          const elem = document.getElementsByClassName('added')?.item(0) as Element;
          if (elem) {
            const labelInput = elem.querySelector('.label-input');
            if (labelInput) {
              (labelInput as HTMLInputElement)?.focus();
            }
          }
        });
      }
    }
  }

  /**
   * adds an upper category to the form array
   */
  addUpperCategory(): void {
    this.addedIndex = undefined;

    const formArray: FormArray = this.optionsForm.controls.options as FormArray;

    if (formArray) {
      const value = this.getNextAvailableUpperCategoryValue();
      const formGroup: FormGroup = this.formBuilder.group({
        value: new FormControl(value, [Validators.required, Validators.min(0)]),
        _oldValue: new FormControl(value),
        label: new FormControl('', Validators.required)
      });

      formArray.push(formGroup);
      formArray.controls = this.sortFormArray(this.optionsForm.controls.options as FormArray);

      const added = formArray.controls.find((fc: AbstractControl) => fc === formGroup) as FormGroup;
      if (added) {
        this.addedIndex = formArray.controls.indexOf(added);

        this.optionsForm.updateValueAndValidity();

        setTimeout(() => {
          const elem = document.getElementsByClassName('added')?.item(0) as Element;
          if (elem) {
            const labelInput = elem.querySelector('.label-input');
            if (labelInput) {
              (labelInput as HTMLInputElement)?.focus();
            }
          }
        });
      }
    }
  }

  /**
   * sorts the form array by option values
   * @param options all form array options
   */
  private sortFormArray(options: FormArray): AbstractControl[] {
    if (!options?.length) {
      return [];
    }

    return options.controls.sort((a: AbstractControl, b: AbstractControl) =>
      a.value.value < b.value.value ? -1 : a.value.value > b.value.value ? 1 : 0
    );
  }

  /**
   * checks if a specific form control in a specific form array has a specific error
   * @param array the form array to check
   * @param index the index of the form group to check
   * @param control the control's name to check
   * @param error the error to check for
   */
  public errorHandlingForFormArray(array: string, index: number, control: string, error: string): boolean {
    try {
      return ((this.optionsForm.controls[array] as FormArray).at(index) as FormGroup).controls[control].hasError(error);
    } catch {
      return false;
    }
  }

  /**
   * resets the form
   * @param optionType optional option type to change the currently edited options type
   */
  async reset(optionType?: 'activities' | 'districts'): Promise<void> {
    if (this.hasFormValueChanged()) {
      this.confirmationService.confirm({
        header: 'Änderungen zurücksetzen?',
        message: 'Möchten Sie Ihre Änderungen wirklich zurücksetzen?',
        acceptLabel: 'OK',
        rejectLabel: 'Abbrechen',
        closeOnEscape: true,
        accept: async () => {
          if (optionType && optionType !== this.optionType) {
            this.optionType = optionType;
          }
          await this.reinitForm();
          window.history.replaceState({}, '', `${environment.rootPath}/options-form/${this.optionType}`);
        }
      });
    } else {
      if (optionType && optionType !== this.optionType) {
        this.optionType = optionType;
      }
      await this.reinitForm();
      window.history.replaceState({}, '', `${environment.rootPath}/options-form/${this.optionType}`);
    }
  }

  /**
   * submits the form data, and creates or updates the edited options
   */
  async submit(): Promise<void> {
    this.blocked = true;
    this.loadingText = 'Optionen werden gespeichert...';
    const options = this.optionsForm.value.options.map((o: any) => {
      return {
        label: o.label,
        value: o.value
      };
    });
    if (this.optionType === 'activities') {
      await this.mySqlPersistService.createActivityOptions(options).toPromise()
        .then(async () => {
          this.blocked = false;
          this.messageService.add({
            severity: 'success',
            summary: 'Optionen wurden gespeichert.',
            key: 'editFormToast'
          });
          await this.reinitForm();
        })
        .catch((reason) => {
          this.blocked = false;
          this.messageService.add({
            severity: 'error',
            summary: 'Optionen konnte nicht gespeichert werden.',
            detail: JSON.stringify(reason),
            key: 'editFormToast'
          });
        });
    } else if (this.optionType === 'districts') {
      await this.mySqlPersistService.createDistrictOptions(options).toPromise()
        .then(async () => {
          this.blocked = false;
          this.messageService.add({
            severity: 'success',
            summary: 'Optionen wurden gespeichert.',
            key: 'editFormToast'
          });
          await this.reinitForm();
        })
        .catch((reason) => {
          this.blocked = false;
          this.messageService.add({
            severity: 'error',
            summary: 'Optionen konnten nicht gespeichert werden.',
            detail: JSON.stringify(reason),
            key: 'editFormToast'
          });
        });
    }
  }

  /**
   * checks if any changes were made in the form
   */
  private hasFormValueChanged(): boolean {
    const oldOptions = this.options.map((o: DropdownOption) => {
      return {
        label: o.label,
        value: o.value
      };
    }).sort((option1: DropdownOption, option2: DropdownOption) =>
      option1.value < option2.value ? -1 : (option1.value > option2.value ? 1 : (option1.label < option2.value ? -1 : 1))
    );
    const newOptions = this.optionsForm.value.options.map((o: any) => {
      return {
        label: o.label,
        value: o.value
      };
    }).sort((option1: DropdownOption, option2: DropdownOption) =>
      option1.value < option2.value ? -1 : (option1.value > option2.value ? 1 : (option1.label < option2.value ? -1 : 1))
    );

    return JSON.stringify(oldOptions) !== JSON.stringify(newOptions);
  }

  ngOnDestroy(): void {
    this.sub?.unsubscribe();
  }
}
