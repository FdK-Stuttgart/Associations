import * as o from './ods';
import {DropdownOption} from '../../model/dropdown-option';
import {
  Address,
  Association,
  Contact,
  Image,
  LatLng,
  Link,
  SocialMediaLink,
  SocialMediaPlatform,
  TextBlock
} from '../../model/association';
import {v4 as uuidv4} from 'uuid';

function keywords(thing, options): string[] {
  if (thing) {
    const clean = thing
      .replace(/\((.*?)\)/g, (match: string, token) => {
        return '';
      })
      .replace(/\./g, (match: string, token) => {
        return '';
      })
      .trim();
    const cleanSplit = clean.split(/, /);
    return getDistricts(cleanSplit, options);
  }
  return [];
}

function getDistricts(stringParts: string[], options: DropdownOption[]): string[] {
  return stringParts.map((stringPart: string) => {
    return options.find(option => {
      return stringPart === option.label || isSynonym(stringPart, option.label);
    });
  }).filter(op => !!op).map((opt: DropdownOption) => opt.value);
}

function isSynonym(stringPart: string, districtLabel: string): boolean {
  stringPart = stringPart.replace('Bad-Cannstatt', 'Bad Cannstatt').trim();
  if (stringPart === districtLabel) {
    return true;
  }
  if (districtLabel.startsWith('Stuttgart')) {
    let stringPartWithPrefix = stringPart;
    if (stringPartWithPrefix.startsWith('Stuttgart ')) {
      stringPartWithPrefix = stringPartWithPrefix.replace('Stuttgart ', 'Stuttgart-');
      if (stringPartWithPrefix === districtLabel) {
        return true;
      }
    }
    if (!stringPart.startsWith('Stuttgart-') && !stringPartWithPrefix.startsWith('Stuttgart')) {
      stringPartWithPrefix = 'Stuttgart-' + stringPart;
      if (stringPartWithPrefix === districtLabel) {
        return true;
      }
    }
  }
  if (stringPart === 'Stuttgart' && districtLabel === 'Stadt Stuttgart') {
    return true;
  }
  if ((stringPart === 'Baden-Württemberg' || stringPart === 'Baden Württemberg' || stringPart === 'Landesweit')
    && districtLabel === 'Landesweit (Baden-Württemberg)') {
    return true;
  }
  return districtLabel === 'Stuttgart und Region'
    && (stringPart.includes('Stuttgart und Umgebung') || stringPart.includes('und Region') || stringPart === 'Stuttgart Region');
}

// Thanks to https://stackoverflow.com/a/6234804
function escapeHtml(unsafe: string): string {
  return unsafe
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/"/g, '&quot;')
    .replace(/'/g, '&#039;')
    // TODO clarify newlines in the goals and activities. Also TextBlock format
    // can be 'plain' or 'html'
    .replace(/\n/g, '<br/>');
}

function escapeHtmlWithNull(unsafe: string): string {
  return unsafe ? escapeHtml(unsafe) : '';
}

function domainRegex(domain: string): RegExp {
  return new RegExp('.*' + domain + '\\..*', 'i');
}

function getSocialMediaPlatform(url: string): SocialMediaPlatform {
  if (url.match(domainRegex('facebook'))) {
    return SocialMediaPlatform.FACEBOOK;
  } else if (url.match(domainRegex('instagram'))) {
    return SocialMediaPlatform.INSTAGRAM;
  } else if (url.match(domainRegex('youtube'))) {
    return SocialMediaPlatform.YOUTUBE;
  } else if (url.match(domainRegex('pinterest'))) {
    return SocialMediaPlatform.PINTEREST;
  } else if (url.match(domainRegex('twitter'))) {
    return SocialMediaPlatform.TWITTER;
  } else if (url.match(domainRegex('linkedin'))) {
    return SocialMediaPlatform.LINKEDIN;
  } else if (url.match(domainRegex('whatsapp'))) {
    return SocialMediaPlatform.WHATSAPP;
  } else if (url.match(domainRegex('snapchat'))) {
    return SocialMediaPlatform.SNAPCHAT;
  } else {
    return SocialMediaPlatform.OTHER;
  }
}

function isSocialMediaLink(url: string): boolean {
  return getSocialMediaPlatform(url) !== SocialMediaPlatform.OTHER;
}

export function noPublicAddress(normAddr: string): boolean {
  return !!normAddr.match(/.*keine|Postfach.*/i);
}

function normalizeAddress(address: string): string {
  if (address) {
    // console.log("address: "+address)
    const adr = o.replaceAll(address, '\n', ', ');
    // console.log("adr: "+adr)
    const adrMatch = adr.match(/[0-9] [A-z],/);
    if (adrMatch) {
      const oldHouseNr = adrMatch.toString();
      // replace is replaceFirst
      const newHouseNr = o.replaceAll(oldHouseNr, ' ', '');
      return adr.replace(new RegExp(oldHouseNr, 'g'), newHouseNr);
    } else {
      return adr;
    }
  } else {
    return address;
  }
}

function processTableRowAngular(
  districts: DropdownOption[],
  row: any
): Association {
  const address = row[o._address];
  // const addr_recv = row[o._addr_recv];
  const contact = row[o._contact];
  const cityDistrict = row[o._cityDistrict];
  const name = row[o._name];
  // const desc = row[o._desc];
  const activity = escapeHtmlWithNull(row[o._activity]);
  const goal = escapeHtmlWithNull(row[o._goal]);
  const coordinates = row[o._coordinates];
  const logos = row[o._logo];
  const links = row[o._webPage];
  const normAddr = normalizeAddress(address);

  let outputAddress: Address;
  {
    let postcode: string;
    let city: string;
    let street: string;
    let addrLines = [];
    if (noPublicAddress(normAddr)) {
      addrLines.push(normAddr);
    } else {
      addrLines = normAddr.split(/, /);
      street = addrLines[0];
      const postcodeCity = addrLines[1];
      if (postcodeCity) {
        const postcodeCitySplit = postcodeCity.split(/\s+/);
        postcode = postcodeCitySplit[0];
        city = postcodeCitySplit[1];
      }
      addrLines[0] = addrLines[1] = addrLines[2] = undefined;
    }

    outputAddress = {
      // TODO clarify usage of addressLine[] vs street, postcode, etc.
      addressLine1: addrLines[0],
      addressLine2: addrLines[1],
      addressLine3: addrLines[2],
      street,
      postcode,
      city,
      country: ''
    };
  }
  // console.log("_address:" + _address)

  let latIdx : number;
  let lngIdx : number;
  const latLngSplit = coordinates.split(/\s+/).map(parseFloat);
  const fstVal = latLngSplit[0];
  const sndVal = latLngSplit[1];
  const minLat : number = 47.2;
  const maxLat : number = 55.0;

  const minLng : number = 5.7;
  const maxLng : number = 15.1;

  if (  fstVal > minLat && fstVal < maxLat
     && sndVal > minLng && sndVal < maxLng) {
    latIdx = 0;
    lngIdx = 1;
  } else if (    sndVal > minLat && sndVal < maxLat
              && fstVal > minLng && fstVal < maxLng) {
    latIdx = 1;
    lngIdx = 0;
  }
  else {
    console.error(
    "Coordinates out of range range: ", coordinates,
    "Latitude <"+minLat+", "+maxLat+">; Longitute <"+minLng+", "+maxLng+">");
  }
  const latLng: LatLng = {
    lat: latLngSplit[latIdx],
    lng: latLngSplit[lngIdx],
  };

  const associationId: string = uuidv4();
  const arrContact: Contact[] = [];
  if (contact) {
    const contactDetails = contact.split(/\r?\n/);
    const emails = [];
    const phoneNumbers = [];
    const faxNumbers = [];
    const poBoxes = [];
    for (const cdi of contactDetails) {
      if (cdi.match(/@/)) {
        emails.push(cdi);
      } else if (cdi.toLowerCase().includes('postfach')) {
        poBoxes.push(cdi);
      } else {
        if (cdi.match(new RegExp(/.*fax.*/, 'i'))) {
          const faxNo = cdi
            .replace('Fax:', '')
            .replace('fax:', '')
            .replace('Fax', '')
            .replace('fax', '')
            .trim();
          faxNumbers.push(faxNo);
        } else {
          const phoneNumber = cdi
            .replace('Tel:', '')
            .replace('tel:', '')
            .replace('Tel.', '')
            .replace('tel.', '')
            .replace('Tel', '')
            .replace('tel', '')
            .trim();
          phoneNumbers.push(phoneNumber);
        }
      }
    }

    const maxLength = Math.max(phoneNumbers.length, faxNumbers.length, emails.length);
    for (let i = 0; i < maxLength; i++) {
      const contactId: string = uuidv4();
      arrContact.push({
        id: contactId,
        name: '',
        mail: emails[i] || '',
        phone: phoneNumbers[i] || '',
        fax: faxNumbers[i] || '',
        poBox: poBoxes[i] || '',
        associationId
      });
    }
  }

  const arrSocialMediaLink: SocialMediaLink[] = [];
  const arrLink: Link[] = [];
  if (links) {
    const linkList = links.split(/\s+/);
    for (const url of linkList) {
      if (!isSocialMediaLink(url)) {
        const link: Link = {
          id: uuidv4(),
          linkText: '',
          url,
          associationId
        };
        arrLink.push(link);
      } else {
        const socialMediaLink: SocialMediaLink = {
          platform: getSocialMediaPlatform(url),
          id: uuidv4(),
          linkText: '',
          url,
          associationId,
        };
        arrSocialMediaLink.push(socialMediaLink);
      }
    }
  }

  const activitiesTextBlock: TextBlock = {
    format: 'plain', // 'plain' | 'html'
    text: activity,
  };

  const goalsTextBlock: TextBlock = {
    format: 'plain', // 'plain' | 'html'
    text: goal,
  };

  const arrImages: Image[] = [];
  if (logos) {
    const logoList = logos.split(/\s+/);
    for (const url of logoList) {
      const imageObj: Image = {
        id: uuidv4(),
        url,
        altText: '',
        associationId
      };
      arrImages.push(imageObj);
    }
  }

  const districtList = keywords(cityDistrict, districts);

  return {
    id: associationId,
    name,
    // shortName : addr_recv,
    goals: goalsTextBlock,
    activities: activitiesTextBlock,
    contacts: arrContact,
    links: arrLink,
    socialMedia: arrSocialMediaLink,
    images: arrImages,
    districtList,
    addressLine1: outputAddress.addressLine1,
    addressLine2: outputAddress.addressLine2,
    addressLine3: outputAddress.addressLine3,
    street: outputAddress.street,
    postcode: outputAddress.postcode,
    city: outputAddress.city,
    country: outputAddress.country,
    lat: latLng.lat,
    lng: latLng.lng,
  };
}

export function getAssociations(
  districts: DropdownOption[],
  fname
): Association[] {
  const odsTable = o.calcReadTable(fname);
  return odsTable
    .filter((row) => {
      return row[o._coordinates];
    })
    .map((row) => {
      // TODO partial function application
      return processTableRowAngular(districts, row);
    });
}
