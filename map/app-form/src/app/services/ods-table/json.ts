import * as o from './ods';
import * as g from './geo';
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

function keywords(thing, options): any[] {
  let list: any[] = [];
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
    for (const es of cleanSplit) {
      let found = false;
      for (const eo of options) {
        if (es === eo.label) {
          list.push(eo.value);
          found = true;
          break;
        }
      }
    }
  }
  list = list.filter((e) => {
    return e;
  });
  return list.map((e) => {
    return e + '';
  });
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

function isSocialMediaLink(url: string): boolean {
  return url.includes('facebook.com')
    || url.includes('facebook.de')
    || url.includes('instagram.com')
    || url.includes('instagram.de')
    || url.includes('youtube.com')
    || url.includes('youtube.de')
    || url.includes('pinterest.com')
    || url.includes('pinterest.de')
    || url.includes('twitter.com')
    || url.includes('twitter.de')
    || url.includes('linkedin.com')
    || url.includes('linked.de')
    || url.includes('whatsapp.com')
    || url.includes('snapchat.com');
}

function getSocialMediaPlatform(url: string): SocialMediaPlatform {
  if (url.includes('facebook.com') || url.includes('facebook.de')) {
    return SocialMediaPlatform.FACEBOOK;
  } else if (url.includes('instagram.com') || url.includes('instagram.de')) {
    return SocialMediaPlatform.INSTAGRAM;
  } else if (url.includes('youtube.com') || url.includes('youtube.de')) {
    return SocialMediaPlatform.YOUTUBE;
  } else if (url.includes('pinterest.com') || url.includes('pinterest.de')) {
    return SocialMediaPlatform.PINTEREST;
  } else if (url.includes('twitter.com') || url.includes('twitter.de')) {
    return SocialMediaPlatform.TWITTER;
  } else if (url.includes('linkedin.com') || url.includes('linkedin.de')) {
    return SocialMediaPlatform.LINKEDIN;
  } else if (url.includes('whatsapp.com')) {
    return SocialMediaPlatform.WHATSAPP;
  } else if (url.includes('snapchat.com')) {
    return SocialMediaPlatform.SNAPCHAT;
  } else {
    return SocialMediaPlatform.OTHER;
  }
}

export function noPublicAddress(normAddr: string): boolean {
  return !!normAddr.match(/.*keine|Postfach.*/i);
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
  const normAddr = g.normalizeAddress(address);

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

  const latLngSplit = coordinates.split(/\s+/).map(parseFloat);
  const latLng: LatLng = {
    lat: latLngSplit[1],
    lng: latLngSplit[0],
  };

  const associationId: string = uuidv4();
  const contactId: string = uuidv4();
  const arrContact: Contact[] = [];
  if (contact) {
    const contactDetails = contact.split(/\r?\n/);
    const emails = [];
    const phoneNumbers = [];
    for (const cdi of contactDetails) {
      if (cdi.match(/@/)) {
        emails.push(cdi);
      } else {
        phoneNumbers.push(cdi);
      }
    }

    // TODO Contact.mail, Contact.phone should be type of TextBlock in case
    // there are multiple of them
    const contactOutput: Contact = {
      id: contactId,
      name: '',
      mail: emails.join(', '),
      phone: phoneNumbers.join(', '),
      fax: '',
      associationId
    };
    arrContact.push(contactOutput);
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
