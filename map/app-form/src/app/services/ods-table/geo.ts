import * as o from './ods'

export function normalizeAddress(address) {
    if (address) {
        // console.log("address: "+address)
        const adr = o.replaceAll(address, '\n', ', ')
        // console.log("adr: "+adr)
        const adrMatch = adr.match(/[0-9] [A-z],/)
        if (adrMatch) {
            const oldHouseNr = adrMatch.toString()
            // replace is replaceFirst
            const newHouseNr = o.replaceAll(oldHouseNr, " ", "")
            return adr.replace(new RegExp(oldHouseNr, "g"), newHouseNr)
        }
        else {
            return adr
        }
    }
    else {
        return address
    }
}

function formatLink(line, prefix) {
    let s1
    if (line.endsWith("mig.madeingermany-stuttgart.de")
        ||
        line.startsWith(prefix+"www.")) {
        s1 = ""
    }
    else {
        s1 = "www."
    }

    let fmtLine
    if (line.endsWith("/")) {
        fmtLine = line.substring(0, line.length - 1)
    }
    else {
        fmtLine = line
    }
    const s2 = fmtLine.replace(new RegExp(prefix, "g"), "")
    return "[[${line}|${s1}${s2}]]"
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

export function encodeLine(line) {
    const imgSize = 14
    if (line.startsWith("https://www.facebook.com/")) {
        return "{{" +facebookLogo + "|" + imgSize + "}}" + " [[${line}|Facebook]]"
    }
    else if (line.startsWith("https://deDe.facebook.com/")) {
        return "{{" +facebookLogo + "|" + imgSize + "}}" + " [[${line}|Facebook]]"
    }
    else if (line.startsWith("https://www.instagram.com/")) {
        return "{{" +instagramLogo + "|" + imgSize + "}}" + " [[${line}|Instagram]]"
    }
    else if (line.startsWith("https://www.youtube.com/")) {
        return "{{" +youtubeLogo + "|" + imgSize + "}}" + " [[${line}|YouTube]]"
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
