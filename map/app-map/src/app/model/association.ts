export interface Address {
  addressLine1?: string;
  addressLine2?: string;
  addressLine3?: string;
  street?: string;
  markedStreet?: string;
  postcode?: string;
  markedPostcode?: string;
  city?: string;
  markedCity?: string;
  country?: string;
  markedCountry?: string;
}

export interface LatLng {
  lat: number;
  lng: number;
}

export interface Association extends Address, LatLng {
  id: string;
  name: string;
  markedName: string;
  shortName?: string;
  goals?: TextBlock;
  activities?: TextBlock;
  contacts?: Contact[];
  links?: Link[];
  socialMedia?: SocialMediaLink[];
  images?: Image[];
  districtList?: any[];
}

export interface Contact {
  id?: string;
  name?: string;
  markedName?: string;
  mail?: string;
  markedMail?: string;
  phone?: string;
  markedPhone?: string;
  fax?: string;
  markedFax?: string;
  associationId?: string;
}

export interface Link {
  id?: string;
  linkText?: string;
  markedLink?: string;
  url: string;
  associationId?: string;
}

export interface SocialMediaLink extends Link {
  platform?: SocialMediaPlatform;
}

export interface TextBlock {
  format?: 'plain' | 'html';
  text: string;
  markedText: string;
}

export enum SocialMediaPlatform {
  FACEBOOK = 'Facebook',
  INSTAGRAM = 'Instagram',
  TWITTER = 'Twitter',
  PINTEREST = 'Pinterest',
  SNAPCHAT = 'Snapchat',
  LINKEDIN = 'LinkedIn',
  WHATSAPP = 'WhatsApp',
  YOUTUBE = 'YouTube',
  OTHER = 'Other'
}

export interface Image {
  id?: string;
  url: string;
  altText?: string;
  associationId?: string;
}
