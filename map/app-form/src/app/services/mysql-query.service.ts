import {Injectable} from '@angular/core';
import {Observable, throwError} from 'rxjs';
import {Association} from '../model/association';
import {HttpClient, HttpErrorResponse, HttpHeaders} from '@angular/common/http';
import {catchError, timeout} from 'rxjs/operators';
import {MyHttpResponse} from '../model/http-response';
import {environment} from '../../environments/environment';
import {DropdownOption} from '../model/dropdown-option';

@Injectable({
  providedIn: 'root'
})
export class MysqlQueryService {
  PHP_API_SERVER_PATH = environment.phpApi.serverBasePath;
  CONNECTION_TIMEOUT = 10000;
  HEADERS = new HttpHeaders()
    .set('Content-Type', 'application/json')
    .set('Access-Control-Allow-Origin', '*');

  constructor(private httpClient: HttpClient) {
  }

  private readAssociations(): Observable<Association[] | null> {
    return this.httpClient.get<Association[]>(`${this.PHP_API_SERVER_PATH}/associations/read-associations.php`,
      {headers: this.HEADERS})
      .pipe(
        timeout(this.CONNECTION_TIMEOUT),
        catchError(err => {
          console.log(('Vereine konnten nicht abgerufen werden.'), err);
          return throwError(err);
        })
      );
  }

  async getAssociations(): Promise<MyHttpResponse<Association[]>> {
    return await this.readAssociations().toPromise().then(
      (res) => {
        if (!res || !res.length) {
          return {
            success: false,
            errorMessage: 'Keine Vereine gefunden.'
          };
        }
        try {
          const associations = res.map((s: any) => {
            return {
              ...s,
              activityList: s.activityList ? JSON.parse(s.activityList) : [],
              districtList: s.districtList ? JSON.parse(s.districtList) : []
            };
          });
          return {
            data: associations,
            success: true
          };
        } catch {
          return {
            success: false,
            errorMessage: 'Vereine konnten nicht verarbeitet werden. Unerwartetes Datenformat.'
          };
        }
      },
      (rej: HttpErrorResponse) => {
        return {
          success: false,
          errorMessage: rej.message
        };
      });
  }


  private readDistrictOptions(): Observable<DropdownOption[] | null> {
    return this.httpClient.get<DropdownOption[]>(`${this.PHP_API_SERVER_PATH}/districts-options/read-districts-options.php`,
      {headers: this.HEADERS})
      .pipe(
        timeout(this.CONNECTION_TIMEOUT),
        catchError(err => {
          console.log(('Dropdown-Optionen für Aktivitätsgebiete konnten nicht abgerufen werden.'), err);
          return throwError(err);
        })
      );
  }

  private readActivitiesOptions(): Observable<DropdownOption[] | null> {
    return this.httpClient.get<DropdownOption[]>(`${this.PHP_API_SERVER_PATH}/activities-options/read-activities-options.php`,
      {headers: this.HEADERS})
      .pipe(
        timeout(this.CONNECTION_TIMEOUT),
        catchError(err => {
          console.log(('Dropdown-Optionen für Tätigkeitsfelder konnten nicht abgerufen werden.'), err);
          return throwError(err);
        })
      );
  }

  async getDistrictOptions(): Promise<MyHttpResponse<DropdownOption[]>> {
    return await this.readDistrictOptions().toPromise().then(
      (res) => {
        if (!res || !res.length) {
          return {
            success: false,
            errorMessage: 'Keine Dropdown-Optionen für Aktivitätsgebiete gefunden.'
          };
        } else {
          return {
            data: res,
            success: true
          };
        }
      },
      (rej: HttpErrorResponse) => {
        return {
          success: false,
          errorMessage: rej.message
        };
      });
  }

  async getActivitiesOptions(): Promise<MyHttpResponse<DropdownOption[]>> {
    return await this.readActivitiesOptions().toPromise().then(
      (res) => {
        if (!res || !res.length) {
          return {
            success: false,
            errorMessage: 'Keine Dropdown-Optionen für Tätigkeitsfelder gefunden.'
          };
        } else {
          return {
            data: res,
            success: true
          };
        }
      },
      (rej: HttpErrorResponse) => {
        return {
          success: false,
          errorMessage: rej.message
        };
      });
  }
}
