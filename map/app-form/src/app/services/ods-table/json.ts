import * as o from './ods'
import * as g from './geo'
import {DropdownOption} from '../../model/dropdown-option';
import {Address, LatLng, Association, Contact, Link, SocialMediaLink, TextBlock, SocialMediaPlatform, Image}
       from '../../model/association'
import {v4 as uuidv4} from 'uuid'

function keywords(thing, options, name, isActivity) : any[] {
    let list : any[] = new Array()
    if (thing) {
        var clean =
            thing
                .replace(/\((.*?)\)/g, function(match, token) { return "" })
                .replace(/\./g, function(match, token) { return "" })
                .trim()
        const cleanSplit = clean.split(/, /)
        // console.log(table)
        for (let es of cleanSplit) {
            var found = false
            for (let eo of options) {
                if (es == eo.label) {
                    list.push(eo.value)
                    // if (
                    //     isActivity
                    //     && true
                    //     // name.startsWith("...")
                    // ) {
                    //     console.log(name, es, eo)
                    // }
                    found = true
                    break
                }
            }
            if (!found) {
                // console.log("Not found: "+es)
            }
        }
    }
    list = list.filter((e) => { return e }) // remove null elements
    // console.log(list)
    // return '["' + list.join('","') + '"]'
    return list.map((e) => { return e + '' })
}

// Thanks to https://stackoverflow.com/a/6234804
function escapeHtml(unsafe) {
    return unsafe
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;")
    // TODO clarify newlines in the goals and activities. Also TextBlock format
    // can be 'plain' or 'html'
        .replace(/\n/g, "<br/>")
}

function escapeHtmlWithNull(unsafe) {
    return unsafe ? escapeHtml(unsafe) : ""
}

function getSocialMediaPlatform(url) {
    if (url.startsWith("https://www.facebook.com/")) {
        return SocialMediaPlatform.FACEBOOK
    }
    else if (url.startsWith("https://deDe.facebook.com/")) {
        return SocialMediaPlatform.FACEBOOK
    }
    else if (url.startsWith("https://www.instagram.com/")) {
        return SocialMediaPlatform.INSTAGRAM
    }
    else if (url.startsWith("https://www.youtube.com/")) {
        return SocialMediaPlatform.YOUTUBE
    }
    else if (url.startsWith("https://")) {
        return SocialMediaPlatform.OTHER
    }
    else if (url.startsWith("http://")) {
        return SocialMediaPlatform.OTHER
    }
    else {
        return SocialMediaPlatform.OTHER
    }
}

function processTableRowAngular(
      districts : DropdownOption[]
    , activities : DropdownOption[]
    , row) : Association {
    const address      = row[o._address]
    const addr_recv    = row[o._addr_recv]
    const contact      = row[o._contact]
    const cityDistrict = row[o._cityDistrict]
    const name         = row[o._name]
    const desc         = row[o._desc]
    const activity     = escapeHtmlWithNull(row[o._activity])
    const goal         = escapeHtmlWithNull(row[o._goal])
    const coordinates  = row[o._coordinates]
    const logos        = row[o._logo]
    const links        = row[o._webPage]
    const normAddr     = g.normalizeAddress(address)
    const descMarkdown = desc.split(/\s+/).map(g.encodeLine)

    let _address : Address
    {
        let postcode : string
        let city : string
        let street : string
        let postcode_city : string
        let addrLines = []
        if (normAddr == "keine öffentliche Anschrift") {
            addrLines.push(normAddr)
        }
        else {
            addrLines = normAddr.split(/, /)
            street = addrLines[0]
            let postcode_city = addrLines[1]
            if (postcode_city) {
                let postcode_city_split = postcode_city.split(/\s+/)
                postcode = postcode_city_split[0]
                city = postcode_city_split[1]
            }
            addrLines[0] = addrLines[1] = addrLines[2] = undefined
        }

        _address = {
            // TODO clarify usage of addressLine[] vs street, postcode, etc.
            addressLine1 : addrLines[0],
            addressLine2 : addrLines[1],
            addressLine3 : addrLines[2],
            street : street,
            postcode : postcode,
            city : city,
            country : '',
        }
    }
    // console.log("_address:" + _address)

    const lat_lon = coordinates.split(/\s+/).map(parseFloat)
    const _latlng : LatLng = {
        lat : lat_lon[1],
        lng : lat_lon[0],
    }

    const associationId : string = uuidv4()
    const contactId : string = uuidv4()
    let arrContact : Contact[] = new Array()
    if (contact) {
        let contactDetails = contact.split(/\r?\n/)
        var emails = new Array()
        var phoneNumbers = new Array()
        for (let cdi of contactDetails) {
            if (cdi.match(/@/)) {
                emails.push(cdi)
            }
            else {
                phoneNumbers.push(cdi)
            }
        }

        // TODO Contact.mail, Contact.phone should be type of TextBlock in case
        // there are multiple of them
        const _contact : Contact = {
            id : contactId,
            name : '',
            mail : emails.join(', '),
            phone : phoneNumbers.join(', '),
            fax : '',
            associationId : associationId,
        }
        arrContact.push(_contact)
    }

    let arrSocialMediaLink : SocialMediaLink[] = new Array()
    let arrLink : Link[] = new Array()
    if (links) {
        let linkList = links.split(/\s+/)
        for (let url of linkList) {
            const _link : Link = {
                id : uuidv4(),
                linkText : '',
                url : url,
                associationId : associationId,
            }
            arrLink.push(_link)

            const _socialMediaLink : SocialMediaLink = {
                platform : getSocialMediaPlatform(url),
                id : uuidv4(),
                linkText : '',
                url : url,
                associationId : associationId,
            }
            arrSocialMediaLink.push(_socialMediaLink)
        }
    }

    const _activities : TextBlock = {
        format : 'plain', // 'plain' | 'html'
        text : activity,
    }

    const _goals : TextBlock = {
        format : 'plain', // 'plain' | 'html'
        text : goal,
    }

    let arrImages : Image[] = new Array()
    if (logos) {
        let logoList = logos.split(/\s+/)
        for (let url of logoList) {
            const _image : Image = {
                id : uuidv4(),
                url : url,
                altText : '',
                associationId : associationId,
            }
            arrImages.push(_image)
        }
    }

    let activityList = keywords(activity, activities, name, true)
    let districtList = keywords(cityDistrict, districts, name, false)

    const _association : Association = {
        id: associationId,
        name : name,
        // shortName : addr_recv,
        goals : _goals,
        activities : _activities,
        contacts : arrContact,
        links : arrLink,
        socialMedia : arrSocialMediaLink,
        images : arrImages,
        activityList : activityList,
        districtList : districtList,

        addressLine1 : _address.addressLine1,
        addressLine2 : _address.addressLine2,
        addressLine3 : _address.addressLine3,
        street : _address.street,
        postcode : _address.postcode,
        city : _address.city,
        country : _address.country,

        lat : _latlng.lat,
        lng : _latlng.lng,
    }
    return _association
}

export function getAssociations(
      districts : DropdownOption[]
    , activities : DropdownOption[]
    , fname) : Association[] {
    const odsTable = o.calcReadTable(fname)
    return odsTable
        .filter((row) => { return row[o._coordinates] })
        .map((row) => {
            // TODO partial function application
            return processTableRowAngular(districts, activities, row)
        })
}
