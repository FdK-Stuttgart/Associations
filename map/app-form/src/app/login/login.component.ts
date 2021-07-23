import {Component, HostListener, OnInit} from '@angular/core';
import {FormControl, FormGroup, Validators} from '@angular/forms';
import {MessageService} from 'primeng/api';
import {LoginService} from './login.service';
import {environment} from '../../environments/environment';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss'],
  providers: [
    MessageService
  ]
})
export class LoginComponent implements OnInit {
  blocked = false;
  loadingText = 'Einloggen...';

  loginForm = new FormGroup({
    username: new FormControl('', [Validators.required]),
    password: new FormControl('', [Validators.required])
  });

  get loginStatus(): boolean {
    if (environment.disableAuth) {
      return true;
    }
    return this.loginService.loginStatus;
  }

  constructor(private loginService: LoginService,
              private messageService: MessageService) {
  }

  @HostListener('document:keydown.escape', ['$event'])
  async onKeydownHandler(event: KeyboardEvent): Promise<void> {
    if (!this.loginStatus && !this.loginForm.valid && event.key === 'Enter') {
      await this.login();
    }
  }

  ngOnInit(): void {
  }

  async login(): Promise<void> {
    this.blocked = true;
    const res = await this.loginService.login(
      this.loginForm.value.username,
      this.loginForm.value.password
    );
    this.loginForm.controls.password.setValue('');
    this.blocked = false;
    if (!!res) {
      this.messageService.add({
        severity: 'success',
        summary: this.loginForm.value.username + ' wurde eingeloggt.',
        key: 'loginToast'
      });
    } else {
      this.messageService.add({
        severity: 'error',
        summary: 'Login fehlgeschlagen.',
        key: 'loginToast'
      });
    }
  }
}
