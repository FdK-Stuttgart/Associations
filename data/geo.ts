import * as o from './ods'

var odsTable = o.calcReadTable()
// for (var y in t) {
//     console.log('y: ' +y+ '; _name: ' + t[y][o._name] + '; _address: ' + t[y][o._address]);
// }

function normalizeAddress(address) {
    var adr = o.replaceAll(address, '\n', ', ')
    var adrMatch = adr.match(/[0-9] [A-z],/)
    if (adrMatch) {
        var oldHouseNr = adrMatch.toString()
        // replace is replaceFirst
        var newHouseNr = o.replaceAll(oldHouseNr, " ", "")
        var newAdr = adr.replace(new RegExp(oldHouseNr, "g"), newHouseNr)
        return newAdr
    }
    else {
        return adr
    }
}

function formatLink(line, prefix) {
    var s1;

    if (line.endsWith("mig.madeingermany-stuttgart.de")
        ||
        line.startsWith(prefix+"www.")) {
        s1 = ""
    }
    else {
        s1 = "www."
    }

    var fmtLine
    if (line.endsWith("/")) {
        fmtLine = line.substring(0, line.length - 1)
    }
    else {
        fmtLine = line
    }
    var s2 = fmtLine.replace(new RegExp(prefix, "g"), "")
    var r = "[[${line}|${s1}${s2}]]"
    return r
}

// "2 kB"
const facebookLogo =
 "https://cdn.iconscout.com/icon/free/png-256/facebook-108-432507.png"

// "15 kB"
const instagramLogo =
 "https://cdn.iconscout.com/icon/free/png-256/instagram-188-498425.png"

// "3.3 kB"
const youtubeLogo =
 "https://cdn.iconscout.com/icon/free/png-256/youtube-82-189778.png"

function encodeLine(line) {
    var imgSize = 14
    var s
    if (line.startsWith("https://www.facebook.com/")) {
        s = "{{" +facebookLogo + "|" + imgSize + "}}" + " [[${line}|Facebook]]"
        return s
    }
    else if (line.startsWith("https://deDe.facebook.com/")) {
        s = "{{" +facebookLogo + "|" + imgSize + "}}" + " [[${line}|Facebook]]"
        return s
    }
    else if (line.startsWith("https://www.instagram.com/")) {
        s = "{{" +instagramLogo + "|" + imgSize + "}}" + " [[${line}|Instagram]]"
        return s
    }
    else if (line.startsWith("https://www.youtube.com/")) {
        s = "{{" +youtubeLogo + "|" + imgSize + "}}" + " [[${line}|YouTube]]"
        return s
    }
    else if (line.startsWith("https://")) {
        return formatLink(line, "https://")
    }
    else if (line.startsWith("http://")) {
        return formatLink(line, "http://")
    }
    else {
        return line
    }
}

function processTableRow(requestFormat, row) {
    const address      = row[o._address]
    const cityDistrict = row[o._cityDistrict]
    const name         = row[o._name]
    const desc         = row[o._desc]
    const goal         = row[o._goal]
    const activity     = row[o._activity]
    const coordinates  = row[o._coordinates]
    const logos        = row[o._logo]
    const normAddr     = normalizeAddress(address)
    const descMarkdown = desc.split(/\s+/).map(encodeLine)

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
        // console.log(": TODO talk to the Nominatim address resolver API")
    }

}

export const _umap = '_umap'
export const _geojson = '_geojson'
function calcGeoData(odsTable) {
    // (map (fn [tableRow] (processTableRow requestFormat tableRow)) )
    const format = _geojson
    return odsTable.map((tableRow, format) => {
        return processTableRow(format, tableRow)
    })
    // (reduce into [])
}

// console.log('normalizeAddress: ' + normalizeAddress('Senefstr 1 a,'))
// console.log('normalizeAddress: ' + normalizeAddress('Senefstr 1 a,'))
// console.log('calcGeoData(odsTable): '+calcGeoData(odsTable))

var fs = require("fs")
var jsonObject = calcGeoData(odsTable)
const fout = "./out.umap"
fs.writeFile(fout, JSON.stringify(jsonObject, null, 4), (err) => {
    if (err) {
        console.error(err)
        return
    }
    console.log(fout + " created")
})

