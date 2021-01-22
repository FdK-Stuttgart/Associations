export interface Address {
  addressLine1?: string;
  addressLine2?: string;
  addressLine3?: string;
  street?: string;
  postcode?: string;
  city?: string;
  country?: string;
}

export interface LatLng {
  lat: number;
  lng: number;
}

export interface Association extends Address, LatLng {
  id: string;
  name: string;
  goals?: TextBlock;
  activities?: TextBlock;
  contacts?: Contact[];
  links?: Link[];
  socialMedia?: SocialMediaLink[];
  images?: Image[];
  activityIds?: number[];
  districtIds?: number[];
}

export interface Contact {
  id?: string;
  name?: string;
  mail?: string;
  phone?: string;
  fax?: string;
  associationId?: string;
}

export interface Link {
  id?: string;
  linkText?: string;
  url: string;
  associationId?: string;
}

export interface SocialMediaLink extends Link {
  platform?: SocialMediaPlatform;
}

export interface TextBlock {
  format?: 'plain' | 'html';
  text: string;
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
