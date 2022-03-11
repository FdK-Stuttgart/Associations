import {Component} from '@angular/core';
import * as packageJson from '../../package.json';
import {LoginService} from './login/login.service';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'Stadtteilkarte - Daten eingeben';
  private packageInfo = packageJson;
  version = this.packageInfo.version;

  constructor(private loginService: LoginService) {
  }

  get loginStatus(): boolean {
    return this.loginService.loginStatus;
  }
}
