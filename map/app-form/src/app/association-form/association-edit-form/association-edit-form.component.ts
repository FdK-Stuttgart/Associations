import {Component, EventEmitter, Input, OnChanges, Output, SimpleChanges} from '@angular/core';
import {SocialMediaPlatform, Association} from '../../model/association';
import {AbstractControl, FormArray, FormBuilder, FormControl, FormGroup, Validators} from '@angular/forms';
import {DropdownOption} from '../../model/dropdown-option';
import {v4 as uuidv4} from 'uuid';
import {MysqlPersistService} from '../../services/mysql-persist.service';
import {ConfirmationService, MessageService} from 'primeng/api';
import {MyHttpResponse} from '../../model/http-response';
import {MysqlQueryService} from '../../services/mysql-query.service';

function getEmptyFormArrayElement(type: 'contact' | 'link' | 'socialMedia' | 'image', associationId: string): FormGroup {
  switch (type) {
    case 'contact':
      return new FormGroup({
        id: new FormControl(uuidv4()),
        name: new FormControl(''),
        phone: new FormControl(''),
        fax: new FormControl(''),
        mail: new FormControl(''),
        associationId: new FormControl(associationId)
      });
    case 'link':
      return new FormGroup({
        id: new FormControl(uuidv4()),
        url: new FormControl('', Validators.required),
        linkText: new FormControl(''),
        associationId: new FormControl(associationId)
      });
    case 'socialMedia':
      return new FormGroup({
        id: new FormControl(uuidv4()),
        url: new FormControl('', Validators.required),
        linkText: new FormControl(''),
        platform: new FormControl('Other'),
        associationId: new FormControl(associationId)
      });
    case 'image':
      return new FormGroup({
        id: new FormControl(uuidv4()),
        url: new FormControl('', Validators.required),
        altText: new FormControl(''),
        associationId: new FormControl(associationId)
      });
  }
  return new FormGroup({});
}

@Component({
  selector: 'app-association-edit-form',
  templateUrl: './association-edit-form.component.html',
  styleUrls: ['./association-edit-form.component.scss'],
  providers: [
    MessageService,
    ConfirmationService
  ]
})
export class AssociationEditFormComponent implements OnChanges {

  blocked = false;
  loadingText = 'Verein wird gespeichert...';

  jsonCollapsed = true;

  associations: Association[] = [];
  association?: Association;

  @Output() reload: EventEmitter<string> = new EventEmitter<string>();

  // @ts-ignore
  @Input() selectedAssociationId: string = [];

  @Input() isNew = true;

  // @ts-ignore
  associationForm: FormGroup;
  // @ts-ignore
  goalsForm: FormGroup;
  // @ts-ignore
  activityForm: FormGroup;

  districtOptions: DropdownOption[] = [];
  activitiesOptions: DropdownOption[] = [];

  /*  readonly textBlockOptions = [
      {
        label: 'Plain Text',
        value: 'plain'
      },
      {
        label: 'HTML',
        value: 'html'
      }
    ];*/

  readonly socialMediaOptions = Object.keys(SocialMediaPlatform)
    // @ts-ignore
    .map(key => SocialMediaPlatform[key] as string)
    .map((s: string) => {
      return {
        value: s,
        label: s
      };
    });

  constructor(private formBuilder: FormBuilder,
              private mySqlQueryService: MysqlQueryService,
              private mySqlPersistService: MysqlPersistService,
              private confirmationService: ConfirmationService,
              private messageService: MessageService) {
    this.initForm();
  }

  /**
   * when the id of the selected association changes, re-init the form and the form values
   * @param changes SimpleChanges
   */
  async ngOnChanges(changes: SimpleChanges): Promise<void> {
    if (
      (changes.selectedAssociationId && changes.selectedAssociationId.previousValue !== changes.selectedAssociationId.currentValue)
      || changes.isNew) {
      await this.initForm();
    }
  }

  /**
   * queries all associations, fill in the edited association data into the form
   */
  private async initForm(): Promise<void> {
    this.blocked = true;

    this.districtOptions = (await this.mySqlQueryService.getDistrictOptions())?.data || [];
    this.activitiesOptions = (await this.mySqlQueryService.getActivitiesOptions())?.data || [];

    if (!this.isNew) {
      const httpResponse: MyHttpResponse<Association[]> = (await this.mySqlQueryService.getAssociations());
      this.associations = httpResponse?.data?.sort(
        (a: Association, b: Association) =>
          a.name.toLowerCase() > b.name.toLowerCase() ? 1 : (a.name.toLowerCase() < b.name.toLowerCase() ? -1 : 0)
      ) || [];
      if (!this.associations.length) {
        this.messageService.add({
          severity: 'error',
          summary: 'Fehler beim Abrufen der Vereine',
          detail: httpResponse?.errorMessage || '',
          key: 'formToast'
        });
        this.blocked = false;
        return;
      } else {
        this.association = this.associations.find((s: Association) => s.id === this.selectedAssociationId);
        if (!this.association) {
          this.messageService.add({
            severity: 'error',
            summary: 'Fehler beim Abrufen des Vereins',
            detail: `Der Verein mit der id ${this.selectedAssociationId}} konnte nicht in der Datenbank gefunden werden.`,
            key: 'formToast'
          });
          this.blocked = false;
          return;
        }
      }
    } else {
      this.association = {
        id: uuidv4(),
        name: '',
        lat: 48.77860400126555,
        lng: 9.179747886339912,
      };
    }

    const id = this.association.id || uuidv4();

    this.goalsForm = new FormGroup({
      format: new FormControl(this.association?.goals?.format || 'plain'),
      text: new FormControl(this.association?.goals?.text || '')
    });

    this.activityForm = new FormGroup({
      format: new FormControl(this.association?.activities?.format || 'plain'),
      text: new FormControl(this.association?.activities?.text || '')
    });

    this.associationForm = new FormGroup({
      id: new FormControl(id),
      name: new FormControl(this.association?.name || '', Validators.required),
      lat: new FormControl(this.association?.lat || 0, [Validators.required, Validators.min(-90), Validators.max(90)]),
      lng: new FormControl(this.association?.lng || 0, [Validators.required, Validators.min(-180), Validators.max(180)]),
      addressLine1: new FormControl(this.association?.addressLine1 || ''),
      addressLine2: new FormControl(this.association?.addressLine2 || ''),
      addressLine3: new FormControl(this.association?.addressLine3 || ''),
      street: new FormControl(this.association?.street || ''),
      postcode: new FormControl(this.association?.postcode || ''),
      city: new FormControl(this.association?.city || ''),
      country: new FormControl(this.association?.country || 'Deutschland'),
      contacts: new FormArray([]),
      images: new FormArray([]),
      links: new FormArray([]),
      socialMedia: new FormArray([]),
      goals: this.goalsForm,
      activities: this.activityForm,
      districtIds: new FormControl(this.association?.districtIds || []),
      activityIds: new FormControl(this.association?.activityIds || [])
    });

    if (this.association?.contacts?.length) {
      const contactControl = (this.associationForm.controls.contacts as FormArray);

      this.association.contacts.forEach(contact => {
        contactControl.push(this.formBuilder.group({
          id: new FormControl(contact.id || uuidv4()),
          name: new FormControl(contact.name || ''),
          phone: new FormControl(contact.phone || ''),
          fax: new FormControl(contact.fax || ''),
          mail: new FormControl(contact.mail || '')
        }));
      });
    }

    if (this.association?.links?.length) {
      const linkControl = (this.associationForm.controls.links as FormArray);

      this.association.links.forEach(link => {
        linkControl.push(this.formBuilder.group({
          id: new FormControl(link.id || uuidv4()),
          url: new FormControl(link.url, Validators.required),
          linkText: new FormControl(link.linkText)
        }));
      });
    }

    if (this.association?.socialMedia?.length) {
      const socialMediaControl = (this.associationForm.controls.socialMedia as FormArray);

      this.association?.socialMedia.forEach(link => {
        socialMediaControl.push(this.formBuilder.group({
          id: new FormControl(link.id || uuidv4()),
          url: new FormControl(link.url, Validators.required),
          linkText: new FormControl(link.linkText),
          platform: new FormControl(link.platform || 'Other')
        }));
      });
    }

    if (this.association?.images?.length) {
      const imageControl = (this.associationForm.controls.images as FormArray);

      this.association?.images.forEach(image => {
        imageControl.push(this.formBuilder.group({
          id: new FormControl(image.id || uuidv4()),
          url: new FormControl(image.url, Validators.required),
          altText: new FormControl(image.altText)
        }));
      });
    }

    // update the forms validation
    setTimeout(() => {
      this.associationForm.updateValueAndValidity();
    });

    this.blocked = false;
  }

  /**
   * returns a form element from a nested form group
   * @param nestedFormGroup the nested form group
   * @param nestedFormControl the control's name
   */
  getNestedFormGroupControl(nestedFormGroup: AbstractControl, nestedFormControl: string): FormControl | undefined {
    try {
      const fg: FormGroup = nestedFormGroup as FormGroup;

      if (fg) {
        return fg.controls[nestedFormControl] as FormControl;
      }
    } catch {
    }
    return undefined;
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
      return ((this.associationForm.controls[array] as FormArray).at(index) as FormGroup);
    } catch {
      return undefined;
    }
  }

  /**
   * remove a element form a form array by its index
   * @param formArray the form array
   * @param i index
   */
  formArrayRemoveAt(formArray: AbstractControl, i: number): void {
    if (formArray as FormArray) {
      (formArray as FormArray).removeAt(i);
    }
  }

  /**
   * adds a form group to a form array
   * @param formArray the form array to add to
   * @param type the type of form group which should be added
   * @param associationId the currently edited association id
   */
  formArrayAdd(formArray: AbstractControl, type: 'contact' | 'link' | 'socialMedia' | 'image', associationId: string): void {
    if (formArray as FormArray) {
      (formArray as FormArray).push(getEmptyFormArrayElement(type, associationId));
    }
  }

  /**
   * checks if a specific form control has a specific error
   * @param control the control to check
   * @param error the error to check for
   */
  public errorHandling(control: string, error: string): boolean {
    return this.associationForm.controls[control].hasError(error);
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
      return ((this.associationForm.controls[array] as FormArray).at(index) as FormGroup).controls[control].hasError(error);
    } catch {
      return false;
    }
  }

  /**
   * returns the html element containing social media links (including icon)
   * @param platform the social media platform
   * @param alt whether to add an alt attribute to the image
   */
  getSocialMediaIcon(platform?: SocialMediaPlatform | string, alt = true): string {
    if (!platform || platform === '' || platform === SocialMediaPlatform.OTHER || platform === 'Other') {
      return '';
    }
    return `<div class="social-media-icon mini-icon"><img src="assets/${platform.toLowerCase()}.png" alt="${alt ? platform : ''}"/></div>`;
  }

  /**
   * sets the coordinate form values according to the map click event's coordinates
   * @param event contains the clicked latitude and longitude positions
   */
  mapClick(event: { lat: number, lng: number }): void {
    this.associationForm.controls.lat.setValue(event.lat);
    this.associationForm.controls.lng.setValue(event.lng);
  }

  /**
   * returns a valid coordinate (latitude or longitude). Prevents OpenLayers map from crashing due to latitude or longitude overflow.
   * @param coordinate the coordinate (latitude or longitude)
   * @param max allowed range; e.g. 90 => (-90, 90), 180 => (-180, 180)
   */
  getCoordinate(coordinate: number, max: number): number {
    if (coordinate < (max * -1) || coordinate > max) {
      return 0;
    }
    return coordinate;
  }

  /**
   * resets the form's value and queries the association's data from the database
   * @param id the selected association's id
   */
  async reset(id: string): Promise<void> {
    if (this.associationForm.dirty) {
      this.confirmationService.confirm({
        header: 'Änderungen zurücksetzen?',
        message: 'Möchten Sie Ihre Änderungen am Verein wirklich zurücksetzen?',
        acceptLabel: 'OK',
        rejectLabel: 'Abbrechen',
        closeOnEscape: true,
        accept: async () => {
          this.selectedAssociationId = id;
          await this.initForm();
        }
      });
    } else {
      this.selectedAssociationId = id;
      await this.initForm();
    }
  }

  /**
   * submits form data, creates or updated the edited association
   */
  async submit(): Promise<void> {
    this.blocked = true;
    this.loadingText = 'Verein wird gespeichert...';
    await this.mySqlPersistService.createOrUpdateAssociation(this.associationForm.value).toPromise()
      .then(() => {
        this.blocked = false;
        this.messageService.add({
          severity: 'success',
          summary: 'Verein wurde gespeichert.',
          key: 'editFormToast'
        });
        this.reload.emit(this.associationForm.value.id);
      })
      .catch((reason) => {
        this.blocked = false;
        this.messageService.add({
          severity: 'error',
          summary: 'Verein konnte nicht gespeichert werden.',
          detail: JSON.stringify(reason),
          key: 'editFormToast'
        });
      });
  }

  /**
   * deletes the selected association from the database
   * @param id the selected association's id
   */
  deleteAssociation(id: string): void {
    this.confirmationService.confirm({
      header: 'Löschen?',
      message: 'Möchten Sie den ausgewählten Verein wirklich löschen?',
      acceptLabel: 'OK',
      rejectLabel: 'Abbrechen',
      closeOnEscape: true,
      accept: async () => {
        this.blocked = true;
        this.loadingText = 'Verein wird gelöscht...';
        await this.mySqlPersistService.deleteAssociation(id).toPromise()
          .then(() => {
            this.blocked = false;
            this.messageService.add({
              severity: 'success',
              summary: 'Verein wurde gelöscht.',
              key: 'editFormToast'
            });
            this.reload.emit(undefined);
          })
          .catch((reason) => {
            this.blocked = false;
            this.messageService.add({
              severity: 'error',
              summary: 'Verein konnte nicht gelöscht werden.',
              detail: JSON.stringify(reason),
              key: 'editFormToast'
            });
          });
      }
    });
  }

  /**
   * checks if a form value is a string starting with http:// or https://
   * @param value the form value to check
   */
  isExternalLink(value: any): boolean {
    return !!value && typeof value === 'string' && (value.startsWith('http://') || value.startsWith('https://'));
  }

  telephoneLink(input: string): string {
    let output = 'tel:';
    const num = input.match(/\d/g);
    if (!num) {
      return '';
    }
    let processedNum: string = num.join('');
    if (processedNum.startsWith('0049')) {
      processedNum = processedNum.replace('0049', '+49');
    } else if (processedNum.startsWith('0')) {
      processedNum = processedNum.replace('0', '+49');
    }
    output += processedNum;
    return output;
  }
}
