import {Injectable} from '@angular/core';
import {HttpClient, HttpErrorResponse, HttpHeaders, HttpResponse} from '@angular/common/http';
import {Association} from '../model/association';
import {Observable, throwError} from 'rxjs';
import {MyHttpResponse} from '../model/http-response';
import {catchError} from 'rxjs/operators';
import {environment} from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class MysqlPersistService {
  PHP_API_SERVER_PATH = environment.phpApi.serverBasePath;

  constructor(private httpClient: HttpClient) {
  }

  httpOptions(username: string, password: string): { headers: HttpHeaders } {
    return {
      headers: new HttpHeaders({
        'Content-Type':  'application/json',
        // base64 encoding
        'Authorization': 'Basic '+ btoa(username+':'+password)})
    };
  }

  createOrUpdateAssociation(
    association: Association, username: string, password: string):
  Observable<MyHttpResponse<any>> {
    return this.httpClient.post<MyHttpResponse<any>>
      (`${this.PHP_API_SERVER_PATH}/associations/create-association.php`
       , association
       , this.httpOptions(username, password)
      ).pipe(catchError(this.handleError));
  }

  deleteAssociation(id: string, username: string, password: string): Observable<HttpResponse<any>> {
    return this.httpClient.get<HttpResponse<any>>(
      `${this.PHP_API_SERVER_PATH}/associations/delete-association.php?id=${id}`
      , this.httpOptions(username, password)
    ).pipe(catchError(this.handleError));
  }

  deleteAllAssociations(username: string, password: string): Observable<HttpResponse<any>> {
    return this.httpClient.get<HttpResponse<any>>(
      `${this.PHP_API_SERVER_PATH}/associations/delete-all-associations.php`
      , this.httpOptions(username, password)
    ).pipe(catchError(this.handleError));
  }

  createDistrictOptions(postdata: any, username: string, password: string): Observable<HttpResponse<any>> {
    return this.httpClient.post<HttpResponse<any>>(
      `${this.PHP_API_SERVER_PATH}/districts-options/create-district-options.php`
      , postdata
      , this.httpOptions(username, password)
    ).pipe(catchError(this.handleError));
  }

  private handleError(error: HttpErrorResponse): Observable<never> {
    if (error.error instanceof ErrorEvent) {
      // A client-side or network error occurred. Handle it accordingly.
      const msg = 'Fehler: ' + error.error.message;
      console.error(msg);
      return throwError(msg);
    } else {
      // The backend returned an unsuccessful response code.
      // The response body may contain clues as to what went wrong.
      const obj = error.error;
      const jsonText = obj?.text;
      const msg =
        `HTTP Status Code ${error.status}, ` +
        `Nachricht: ${jsonText ? extractTextualContent(jsonText) : JSON.stringify(error.error)}`;
      console.error(msg);
      return throwError(msg);
    }
  }
}

function extractTextualContent(s: string): string {
  const span = document.createElement('span');
  span.innerHTML = s;
  const res = span.textContent || span.innerText;
  return res.replace(/(\r\n|\n|\r)/gm, ' ');
}
