import * as o from './ods'
import * as g from './geo'

function processTableRowUmap(requestFormat, row) {
    const address      = row[o._address]
    const cityDistrict = row[o._cityDistrict]
    const name         = row[o._name]
    const desc         = row[o._desc]
    const goal         = row[o._goal]
    const activity     = row[o._activity]
    const coordinates  = row[o._coordinates]
    const logos        = row[o._logo]
    const normAddr     = g.normalizeAddress(address)
    const descMarkdown = desc.split(/\s+/).map(g.encodeLine)

    var logosMarkdown = ""
    if (logos) {
        var arrMarkdown = logos.split(/\s+/).map((s) => {
            return "{{" + s + "}}\n"
        })
        logosMarkdown = arrMarkdown.concat()
        // console.log("arrMarkdown.concat(): " + arrMarkdown.concat())
    }
    else {
        console.log("logos " + logos + "; " + name)
    }
    // var allFeatures
    if (coordinates) {
        // console.log('coordinates : '+ coordinates)
        var obj: any =
            [{
                "type": "Feature",
                "properties": {
                    "geocoding": { "name": "" },
                    "description": logosMarkdown +
                        address + "\n\n" +
                        descMarkdown + "\n\n" +
                        "Aktiv in Stadtteil(en): " + cityDistrict + "\n\n"+
                        "Ziele des Vereins: " + goal + "\n\n"+
                        "Aktivitätsbereiche: " + activity,

                    "search_address": normAddr,
                    "search_district": cityDistrict,
                    "search_desc": desc,
                    "search_goal": goal,
                    "search_activity": activity,
                    "name" : name
                },
                "geometry": {
                    "type": "Point",
                    "coordinates": coordinates.split(/\s+/)
                    // (read-string (format "[%s]" coordinates))
                }}]
        var allFeatures: JSON = <JSON> obj
        return allFeatures
    }
    else {
        console.log(name + ": TODO talk to the Nominatim address resolver API")
    }
}

function processTableRowAngular(requestFormat, row) {
    const address      = row[o._address]
    const cityDistrict = row[o._cityDistrict]
    const name         = row[o._name]
    const desc         = row[o._desc]
    const goal         = row[o._goal]
    const activity     = row[o._activity]
    const coordinates  = row[o._coordinates]
    const logos        = row[o._logo]
    const normAddr     = g.normalizeAddress(address)
    const descMarkdown = desc.split(/\s+/).map(g.encodeLine)

    var logosMarkdown = ""
    if (logos) {
        var arrMarkdown = logos.split(/\s+/).map((s) => {
            return "{{" + s + "}}\n"
        })
        logosMarkdown = arrMarkdown.concat()
        // console.log("arrMarkdown.concat(): " + arrMarkdown.concat())
    }
    else {
        console.log("logos " + logos + "; " + name)
    }

    // TODO send HTTP request with this json-obj to an API service. This service
    // inserts the data in the dbase

    if (coordinates) {
        // console.log('coordinates : '+ coordinates)
        var obj: any
        obj = {
            "addressLine1?": "",
            "addressLine2?": "",
            "addressLine3?": "",
            "street?": "",
            "postcode?": "",
            "city?": "",
            "country?": "",
        }
        var Address : JSON = <JSON> obj

        obj = {
            "lat": 0,
            "lng": 0,
        }
        var LatLng : JSON = <JSON> obj

        obj = {
            "id?": "",
            "name?": "",
            "mail?": "",
            "phone?": "",
            "fax?": "",
            "associationId?": "",
        }
        var Contact : JSON = <JSON> obj

        obj = {
            "id?": "",
            "linkText?": "",
            "url": "",
            "associationId?": "",
        }
        var Link : JSON = <JSON> obj

        // export enum SocialMediaPlatform {
        //     FACEBOOK = 'Facebook',
        //     INSTAGRAM = 'Instagram',
        //     TWITTER = 'Twitter',
        //     PINTEREST = 'Pinterest',
        //     SNAPCHAT = 'Snapchat',
        //     LINKEDIN = 'LinkedIn',
        //     WHATSAPP = 'WhatsApp',
        //     YOUTUBE = 'YouTube',
        //     OTHER = 'Other'
        // }
        var SocialMediaPlatform = 'Facebook'

        obj = {
            "platform?": SocialMediaPlatform,
        }
        var SocialMediaLinkBase : JSON = <JSON> obj

        // extends Link
        var SocialMediaLink = { ...Link, ...SocialMediaLinkBase}

        obj = {
            "format?": 'plain', // 'plain' | 'html'
            "text": "",
        }
        var TextBlock : JSON = <JSON> obj

        obj = {
            "id?": "",
            "url": "",
            "altText?": "",
            "associationId?": "",
        }
        var Image : JSON = <JSON> obj

        obj = {
            "id": "",
            "name": "",
            "shortName?": "",
            "goals?": TextBlock,
            "activities?": TextBlock,
            "contacts?": [Contact],
            "links?": [Link],
            "socialMedia?": [SocialMediaLink],
            "images?": [Image],
            "activityList?": [],
            "districtList?": [],
        }
        // extends Address, LatLng
        var Association : JSON = <JSON> obj

        return { ...Association, ...Address, ...LatLng }
        // return {...LatLng}
    }
    else {
        console.log(name + ": TODO talk to the Nominatim address resolver API")
        return {}
    }
}

export const _umap = '_umap'
export const _geojson = '_geojson'
function calcGeoData(odsTable) {
    const format = _geojson
    // odsTable = odsTable.slice(odsTable.length - 1, odsTable.length - 0)
    // console.log(odsTable)
    return odsTable.map((tableRow, format) => {
        // return processTableRowUmap(format, tableRow)
        return processTableRowAngular(format, tableRow)
    })
}

function isNotEmpty(value) {
    return Object.keys(value).length !== 0
}

var fs = require("fs")
var odsTable = o.calcReadTable()
var jsonObjectFull = calcGeoData(odsTable)
// remove empty elements
var jsonObject = jsonObjectFull.filter(isNotEmpty)

const fout = "./out.umap"
fs.writeFile(fout, JSON.stringify(jsonObject, null, 4), (err) => {
    if (err) {
        console.error(err)
        return
    }
    console.log(fout + " containing "+ jsonObject.length + " elements created")
})
