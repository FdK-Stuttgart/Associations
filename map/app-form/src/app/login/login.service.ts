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

  set hasadmin(v: string | undefined) {
    localStorage.setItem('hasadmin', (v || 'false'));
  }

  get hasadmin(): string | undefined {
    return localStorage.getItem('hasadmin')
  }

  get isAdmin(): boolean {
    return (this.hasadmin === 'true')
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
      this.token = loginResult.data.token;
      this.hasadmin = loginResult.data.user_roles.includes('administrator').toString()
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
    this.hasadmin = 'false';
    this.loginStatusChange$.next(false);
  }
}
