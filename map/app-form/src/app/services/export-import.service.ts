import {Injectable} from '@angular/core';
import {Association} from '../model/association';
import {saveAs} from 'file-saver';
import {DropdownOption} from '../model/dropdown-option';

@Injectable({
  providedIn: 'root'
})
export class ExportImportService {

  constructor() {
  }

  async exportAssociations(
    associations: Association[],
    districts: DropdownOption[] = [],
    activities: DropdownOption[] = []): Promise<void> {
    let flatAssociations: { [key: string]: number | string }[]
      = associations.map((a: Association) => {
      const contacts = this.flatten(a.contacts, 'contact');
      const links = this.flatten(a.links, 'link');
      const socialMedia = this.flatten(a.socialMedia, 'socialMedia');
      const images = this.flatten(a.images, 'image');
      const flatAssociation = {
        id: a.id || '',
        name: a.name || '',
        shortName: a.shortName || '',
        street: a.street || '',
        postcode: a.postcode || '',
        city: a.city || '',
        addressLine1: a.addressLine1 || '',
        addressLine2: a.addressLine2 || '',
        lat: a.lat,
        lng: a.lng,
        goals: a.goals.text || '',
        activities: a.activities.text || '',
        ...contacts,
        ...links,
        ...socialMedia,
        ...images,
        districtList: this.extractOptions(a.districtList, districts)
      };
      if (typeof flatAssociation.lat === 'string') {
        flatAssociation.lat = parseFloat(flatAssociation.lat);
      }
      if (typeof flatAssociation.lng === 'string') {
        flatAssociation.lng = parseFloat(flatAssociation.lng);
      }
      delete flatAssociation.contacts;
      delete flatAssociation.links;
      delete flatAssociation.socialMedia;
      return flatAssociation;
    });

    let outputKeys = [];

    flatAssociations.forEach((flat: { [key: string]: string | number }) => {
      for (const key of Object.keys(flat)) {
        if (!outputKeys.includes(key)) {
          outputKeys.push(key);
        }
      }
    });

    flatAssociations = flatAssociations.map(
      (flat: { [key: string]: string | number }) => {
      outputKeys.forEach((key: string) => {
        if (!flat[key]) {
          flat[key] = '';
        }
      });
      return flat;
    });

    outputKeys = outputKeys.sort((a: string, b: string) => {
      const orderIndex = {
        id: 0,
        name: 1,
        shortName: 2,
        street: 3,
        postcode: 4,
        city: 5,
        addressLine1: 6,
        addressLine2: 7,
        lat: 8,
        lng: 9,
        goals: 10,
        activities: 11,
        contacts: 12,
        links: 13,
        socialMedia: 14,
        districtList: 15
      };

      const aKey = a.startsWith('contact') ? 'contacts'
        : a.startsWith('link') ? 'links'
          : a.startsWith('socialMedia') ? 'socialMedia'
            : a.startsWith('image') ? 'images' : a;

      const bKey = b.startsWith('contact') ? 'contacts'
        : b.startsWith('link') ? 'links'
          : b.startsWith('socialMedia') ? 'socialMedia'
            : b.startsWith('image') ? 'images' : b;

      return orderIndex[aKey] < orderIndex[bKey] ? -1
        : orderIndex[aKey] > orderIndex[bKey] ? 1
          : a < b ? -1
            : a > b ? 1 : 0;
    });

    const headerRow = outputKeys.join(';') + ';';
    let rows = '';
    flatAssociations.forEach((fl: any) => {
      for (const key of outputKeys) {
        let val = fl[key];
        if (!val) {
          val = '';
        }
        if (typeof val === 'string') {
          val = '"' + val + '"';
        } else if (typeof val === 'number') {
          val = '"' + val.toLocaleString(
            'de-DE',
            {maximumFractionDigits: 20}) + '"';
        }

        rows += val || '';
        rows += ';';
      }
      rows += '\n';
    });

    const BOM = '\uFEFF';
    const output = BOM + headerRow + '\n' + rows;
    const blob = new Blob([output], {type: 'text/plain;charset=utf-8'});
    saveAs(blob, 'Stadtteilkarte-Vereine.csv');
  }

  private flatten(inputArray: any[], prefix: string): any {
    const outputObject: any = {};
    const sortedInputArray = inputArray.sort((a, b) => !a.orderIndex
      ? 1 : !b.orderIndex ? -1 : a.orderIndex < b.orderIndex ? -1 : 1);

    if (sortedInputArray.length) {
      for (let i = 0; i < sortedInputArray.length; i++) {
        const j = i + 1;
        for (const key of Object.keys(sortedInputArray[i])) {
          if (key !== 'id' && key !== 'associationId' && key !== 'orderIndex') {
            const capitalizedKey = key.length > 1
              ? key.charAt(0).toUpperCase() + key.slice(1) : key.toUpperCase();
            const outputObjectKey: string = prefix + j + capitalizedKey;
            outputObject[outputObjectKey] = sortedInputArray[i][key] || '';
          }
        }
      }
    }
    return outputObject;
  }

  private extractOptions(optionList: string[],
                         options: DropdownOption[]): string {
    let output = '';

    optionList.forEach((id: string) => {
      const option = options.find(activity => activity.value === id);
      if (option?.label) {
        output += option.label;
        output += '; ';
      }
    });

    return output;
  }
}
