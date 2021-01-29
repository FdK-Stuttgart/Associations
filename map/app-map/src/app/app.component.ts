import {Component} from '@angular/core';
import { version } from '../../package.json';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'Stadtteilkarte';
  version = version;

  isInFullscreen = false;

  get fullscreenEnabled(): boolean {
    return document.fullscreenEnabled;
  }

  get showCloseIcon(): boolean {
    return this.isInFullscreen && !!document.fullscreenElement;
  }

  async toggleFullscreen(): Promise<void> {
    this.isInFullscreen = !this.showCloseIcon;

    if (this.isInFullscreen) {
      await this.requestFullscreen(document.getElementById('fullscreen-content') || undefined);
    } else {
      await this.exitFullscreen();
    }
  }

  async requestFullscreen(element?: HTMLElement): Promise<void> {
    if (element) {
      await element.requestFullscreen();
    }
  }

  async exitFullscreen(): Promise<void> {
    if (document.fullscreenEnabled) {
      await document.exitFullscreen();
    }
  }
}
