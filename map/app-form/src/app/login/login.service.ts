import {Injectable} from '@angular/core';
import {WordpressAuthService} from '../services/wordpress-auth.service';
import {BehaviorSubject} from 'rxjs';
import {environment} from '../../environments/environment';

@Injectable({
  providedIn: 'root'
})
export class LoginService {
  loginStatusChange$: BehaviorSubject<boolean> = new BehaviorSubject(false);

  constructor(private wordpressAuthService: WordpressAuthService) {
    if (!environment.disableAuth) {
      setInterval(async () => {
        if (!!this.token) {
          const res = await this.checkLoginStatus();
          this.loginStatusChange$.next(res);
        }
      }, 30000);
      this.loginStatusChange$.next(this.loginStatus);
    }
  }

  // TODO proper isAdmin implementation: it looks like user specific the access
  // rights can't be received from Wordpress so it must persisted from the dbase
  isAdmin(): boolean {
    return true
    // return false
  }

  get loginStatus(): boolean {
    if (environment.disableAuth) {
      return true;
    }
    return !!this.token;
  }

  get token(): string | undefined {
    return localStorage.getItem('wordpress-jwt');
  }

  set token(token: string | undefined) {
    localStorage.setItem('wordpress-jwt', (token || ''));
  }

  async login(username: string, password: string): Promise<boolean> {
    if (environment.disableAuth) {
      return true;
    }
    const loginResult = await this.wordpressAuthService.getAuthenticate(username, password);
    // TODO see if loginResult contains access-rights information from Wordpress
    console.log(loginResult)

    if (loginResult && loginResult.success && loginResult.data?.token) {
      this.token = loginResult.data.token;
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
    this.loginStatusChange$.next(false);
  }
}
