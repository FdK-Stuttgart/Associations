import {Injectable} from '@angular/core';
import {WordpressAuthService} from '../services/wordpress-auth.service';
import {BehaviorSubject} from 'rxjs';

@Injectable({
  providedIn: 'root'
})
export class LoginService {
  loginStatusChange$: BehaviorSubject<boolean> = new BehaviorSubject(false);

  constructor(private wordpressAuthService: WordpressAuthService) {
    setInterval(async () => {
      if (!!this.token) {
        const res = await this.checkLoginStatus();
        this.loginStatusChange$.next(res);
      }
    }, 30000);
    this.loginStatusChange$.next(this.loginStatus);
  }

  get loginStatus(): boolean {
    return !!this.token;
  }

  get token(): string | undefined {
    return localStorage.getItem('wordpress-jwt');
  }

  set token(token: string | undefined) {
    localStorage.setItem('wordpress-jwt', (token || ''));
  }

  async login(username: string, password: string): Promise<boolean> {
    const loginResult = await this.wordpressAuthService.getAuthenticate(username, password);

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
