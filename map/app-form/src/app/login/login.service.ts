import {Injectable} from '@angular/core';
import {WordpressAuthService} from '../services/wordpress-auth.service';
import {BehaviorSubject} from 'rxjs';
import {environment} from '../../environments/environment';
import {CookieService} from 'ngx-cookie-service';

@Injectable({
  providedIn: 'root'
})
export class LoginService {
  loginStatusChange$: BehaviorSubject<boolean> = new BehaviorSubject(false);
  username: string | undefined;
  password: string | undefined;

  constructor(private wordpressAuthService: WordpressAuthService,
              private cookieService: CookieService) {
    if (!environment.disableAuth) {
      setInterval(async () => {
        if (!!this.token) {
          const res = await this.checkLoginStatus();
          this.loginStatusChange$.next(res);
        }
      }, 30000); // time_in_milliseconds = 30 seconds
      this.loginStatusChange$.next(this.loginStatus);
    }
  }

  get loginStatus(): boolean {
    if (environment.disableAuth) {
      return true;
    }
    return !!this.token;
  }

  get token(): string | undefined {
    return this.cookieService.get('wordpress-jwt');
  }

  set token(token: string | undefined) {
    // Attention: Cookies can be modified using Browser DevTools. Be careful
    // when using as a storage for security-relevant information.

    // TODO info about cookies for the user? (it's just an internal tool)
    this.cookieService.set(
      'wordpress-jwt',
      (token || ''),
      1,
      undefined,
      undefined,
      true,
      'Strict'
    );
  }

  async login(username: string, password: string): Promise<boolean> {
    if (environment.disableAuth) {
      return true;
    }
    const loginResult = await this.wordpressAuthService.getAuthenticate(username, password);

    if (loginResult && loginResult.success
      && loginResult.data?.token
      && loginResult.data?.user_roles
    ) {
      if (
           loginResult.data.user_roles.includes('administrator')
        || loginResult.data.user_roles.includes('editor')
         ) {
        this.token = loginResult.data.token;
        this.username = username;
        this.password = password;
      } else {
        this.removeToken();
      }
      const loginStatus = await this.checkLoginStatus();
      this.loginStatusChange$.next(loginStatus);
      return loginStatus;
    } else {
      this.removeToken();
      return false;
    }
  }

  async checkLoginStatus(): Promise<boolean> {
    if (environment.disableAuth) {
      return true;
    }
    const validatingResult = await this.wordpressAuthService.getValidateAuthToken(this.token);
    if (!validatingResult?.success) {
      this.removeToken();
    }
    return !!validatingResult?.success;
  }

  removeToken(): void {
    this.token = '';
    this.username = '';
    this.password = '';
    this.loginStatusChange$.next(false);
  }
}
