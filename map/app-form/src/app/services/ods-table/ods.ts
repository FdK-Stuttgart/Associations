import * as XLSX from 'xlsx'

function columnIdx (rowLetter) {
    // {:pre [(char? rowLetter)]} // TODO define contract
    return rowLetter
}

function getRowCount(sheet) {
    return XLSX.utils.sheet_to_json(sheet).length
}

function identity(arg: any): any {
    return arg;
}

function range(n) {
    return Array.from(Array(n).keys())
}

function sheetRowIndexes(sheet) {
  const rowCount = getRowCount(sheet)
  const arrSheetRange = range(rowCount)
  // sheet line numbers start from 1 and we need to skip the header
  const shiftedArr = arrSheetRange.map((v:number) => v + 2)
  return shiftedArr
}

function textAtPosition(sheet, p, row) {
    const cellAddr = p+row
    const cell = sheet[cellAddr];
    return (cell ? cell.v : undefined);
}

function address(sheet, row) {
    return textAtPosition(sheet, columnIdx('C'), row)
}

function address_receiver(sheet, row) {
    return textAtPosition(sheet, columnIdx('B'), row)
}

function rowNr(idx) {
    return idx + 2
}

export function replaceAll(s: string, match: string, replacement: string): string {
    // https://www.designcise.com/web/tutorial/how-to-replace-all-occurrences-of-a-word-in-a-javascript-string
    if (s) {
        return s.replace(new RegExp(match, 'g'), replacement)
    }
    else {
        return s
    }
}

// function composition
// https://dev.to/ascorbic/creating-a-typed-compose-function-in-typescript-3-351i
export const pipe = <T extends any[], R>(
    fn1: (...args: T) => R,
    ...fns: Array<(a: R) => R>
) => {
    const piped = fns.reduce(
        (prevFn, nextFn) => (value: R) => nextFn(prevFn(value)),
        value => value
    );
    return (...args: T) => piped(fn1(...args));
};

export const compose = <R>(fn1: (a: R) => R, ...fns: Array<(a: R) => R>) =>
    fns.reduce((prevFn, nextFn) => value => prevFn(nextFn(value)), fn1);

function cleanup(a) {
    const f1 = (a: string) => replaceAll(a, ' ', ' ')
    const f2 = (a: string) => replaceAll(a, '  ', ' ')
    const f3 = (a: string) => replaceAll(a, '  ', ' ')
    // repeating twice should be enough; simple and dirty
    const f4 = (a: string) => replaceAll(a, ' \n', '\n')
    const f5 = (a: string) => replaceAll(a, ' \n', '\n')
    const f6 = (a: string) => a.trim()
    // e.V. without space is incorrect
    // const f7 = (a: string) =>replaceAll(a, 'e. V.', 'e.V.')
    const pipedFunction = pipe(f1, f2, f3, f4, f5, f6);
    if (typeof a !== 'undefined') {
        return pipedFunction(a)
    }
    // else {
    //     return s
    // }
    return null
}

export interface IHash {
    [details: string] : string;
}


// hashmap keywords start with '_'
export const _idx = '_idx'
export const _address ='_address'

function calcAddresses(sheet, rows) {
    const f1 = (a: string) => replaceAll(a, '\n', ', ')
    const f2 = cleanup
    const f3 = (row: number) => address(sheet, row)
    const pipedFunction = pipe(f3, f2, f1)

    const vals = rows.map(pipedFunction)
    return vals.map((s, i) => {
        let hm: IHash = {};
        hm[_idx] = rowNr(i)
        hm[_address] = s
        return hm
    })
}

export const _addr_recv ='_addr_recv'
function calcAddressReceiver(sheet, rows) {
    const f1 = (a: string) => replaceAll(a, '\n', ', ')
    const f2 = cleanup
    const f3 = (row: number) => address_receiver(sheet, row)
    const pipedFunction = pipe(f3, f2, f1)

    const vals = rows.map(pipedFunction)
    return vals.map((s, i) => {
        let hm: IHash = {};
        hm[_idx] = rowNr(i)
        hm[_addr_recv] = s
        return hm
    })
}

function association(sheet, row) {
    return textAtPosition(sheet, columnIdx('A'), row)
}

export const _name = '_name'
function calcAssociations(sheet, rows) {
    const f1 = (a: string) => replaceAll(a, '\n', ' ')
    const f2 = cleanup
    const f3 = (row: number) => association(sheet, row)
    const pipedFunction = pipe(f3, f2, f1)

    const vals = rows.map(pipedFunction)
    return vals.map((s, i) => {
        let hm: IHash = {};
        hm[_idx] = rowNr(i)
        hm[_name] = s
        return hm
    })
}

function cityDistrict(sheet, row) {
    return textAtPosition(sheet, columnIdx('D'), row)
}

export const _cityDistrict = '_cityDistrict'
function calcDistricts(sheet, rows) {
    const f1 = identity
    const f2 = cleanup
    const f3 = (row: number) => cityDistrict(sheet, row)
    const pipedFunction = pipe(f3, f2, f1)

    const vals = rows.map(pipedFunction)
    return vals.map((s, i) => {
        let hm: IHash = {};
        hm[_idx] = rowNr(i)
        hm[_cityDistrict] = s
        return hm
    })
}

function tableCoordinates(sheet, row) {
    return textAtPosition(sheet, columnIdx('E'), row)
}

export const _coordinates = '_coordinates'
function calcCoordinates(sheet, rows) {
    const f1 = identity
    const f2 = cleanup
    const f3 = (row: number) => tableCoordinates(sheet, row)
    const pipedFunction = pipe(f3, f2, f1)

    const vals = rows.map(pipedFunction)
    return vals.map((s, i) => {
        let hm: IHash = {};
        hm[_idx] = rowNr(i)
        hm[_coordinates] = s
        return hm
    })
}

function contact(sheet, row) {
    return textAtPosition(sheet, columnIdx('F'), row)
}

export const _contact = '_contact'
function calcContacts(sheet, rows) {
    const f1 = identity
    const f2 = cleanup
    const f3 = (row: number) => contact(sheet, row)
    const pipedFunction = pipe(f3, f2, f1)

    const vals = rows.map(pipedFunction)
    return vals.map((s, i) => {
        let hm: IHash = {};
        hm[_idx] = rowNr(i)
        hm[_contact] = s
        return hm
    })
}

function logo(sheet, row) {
    return textAtPosition(sheet, columnIdx('G'), row)
}

export const _logo = '_logo'
function calcLogos(sheet, rows) {
    const f1 = identity
    const f2 = cleanup
    const f3 = (row: number) => logo(sheet, row)
    const pipedFunction = pipe(f3, f2, f1)

    const vals = rows.map(pipedFunction)
    return vals.map((s, i) => {
        let hm: IHash = {};
        hm[_idx] = rowNr(i)
        hm[_logo] = s
        return hm
    })
}

function webPage(sheet, row) {
    return textAtPosition(sheet, columnIdx('H'), row)
}

export const _webPage = '_webPage'
function calcWebPages(sheet, rows) {
    const f1 = identity
    const f2 = cleanup
    const f3 = (row: number) => webPage(sheet, row)
    const pipedFunction = pipe(f3, f2, f1)

    const vals = rows.map(pipedFunction)
    return vals.map((s, i) => {
        let hm: IHash = {};
        hm[_idx] = rowNr(i)
        hm[_webPage] = s
        return hm
    })
}

function goal(sheet, row) {
    return textAtPosition(sheet, columnIdx('I'), row)
}

export const _goal = '_goal'
function calcGoals(sheet, rows) {
    const f1 = identity
    const f2 = cleanup
    const f3 = (row: number) => goal(sheet, row)
    const pipedFunction = pipe(f3, f2, f1)

    const vals = rows.map(pipedFunction)
    return vals.map((s, i) => {
        let hm: IHash = {};
        hm[_idx] = rowNr(i)
        hm[_goal] = s
        return hm
    })
}

function activity(sheet, row) {
    return textAtPosition(sheet, columnIdx('J'), row)
}

export const _activity = '_activity'
function calcActivities(sheet, rows) {
    const f1 = identity
    const f2 = cleanup
    const f3 = (row: number) => activity(sheet, row)
    const pipedFunction = pipe(f3, f2, f1)

    const vals = rows.map(pipedFunction)
    return vals.map((s, i) => {
        let hm: IHash = {};
        hm[_idx] = rowNr(i)
        hm[_activity] = s
        return hm
    })
}

export const _desc = 'desc'
export function calcReadTable(sheet) {
  const rowIndexes   = sheetRowIndexes(sheet)
  const associations = calcAssociations(sheet, rowIndexes)
  const addresses    = calcAddresses(sheet, rowIndexes)
  const addr_recv    = calcAddressReceiver(sheet, rowIndexes)
  const districts    = calcDistricts(sheet, rowIndexes)
  const contacts     = calcContacts(sheet, rowIndexes)
  const webPages     = calcWebPages(sheet, rowIndexes)
  const goals        = calcGoals(sheet, rowIndexes)
  const activities   = calcActivities(sheet, rowIndexes)
  const coordinates  = calcCoordinates(sheet, rowIndexes)
  const logos        = calcLogos(sheet, rowIndexes)

  let mm = new Array()

  // poor man's merge
  for (let y in associations) {
    // console.log(
    //         'y: ' + y +
    //         '; _idx: ' + associations[y][_idx] +
    //         '; _name: ' + associations[y][_name] +
    //         '; _address: '+addresses[y][_address]
    // )

    let m: IHash = {};
    m[y]             = y
    m[_idx]          = associations[y][_idx]
    m[_name]         = associations[y][_name]
    m[_address]      = addresses[y][_address]
    m[_addr_recv]    = addr_recv[y][_addr_recv]
    m[_cityDistrict] = districts[y][_cityDistrict]
    m[_desc]         = (contacts[y][_contact] + "\n\n" + webPages[y][_webPage]).trim()
    m[_coordinates]  = coordinates[y][_coordinates]
    m[_contact]      = contacts[y][_contact]
    m[_logo]         = logos[y][_logo]
    m[_webPage]      = webPages[y][_webPage]
    m[_goal]         = goals[y][_goal]
    m[_activity]     = activities[y][_activity]
    mm.push(m)
  }
  return mm
}
