import {Component} from '@angular/core';
import * as packageJson from '../../package.json';

@Component({
  selector: 'app-root',
  templateUrl: './app.component.html',
  styleUrls: ['./app.component.scss']
})
export class AppComponent {
  title = 'Stadtteilkarte';
  private packageInfo = packageJson;
  version = this.packageInfo.version;

  get fullscreenEnabled(): boolean {
    return document.fullscreenEnabled
      || (document as any).webkitFullscreenEnabled
      || (document as any).mozFullScreenEnabled
      || (document as any).msFullscreenEnabled;
  }

  get fullscreenElement(): any {
    return document.fullscreenElement
      || (document as any).webkitFullscreenElement
      || (document as any).mozFullScreenElement
      || (document as any).msFullscreenElement;
  }

  get isInFullscreen(): boolean {
    return !!this.fullscreenElement;
  }

  get showCloseIcon(): boolean {
    return this.isInFullscreen && !!this.fullscreenElement;
  }

  async toggleFullscreen(): Promise<void> {
    if (!this.isInFullscreen) {
      await this.requestFullscreen(
        document.documentElement
          || document.getElementById('fullscreen-content')
          || undefined);
    } else {
      await this.exitFullscreen();
    }
  }

  async requestFullscreen(element?: HTMLElement): Promise<void> {
    if (element) {
      if (element.requestFullscreen) {
        await element.requestFullscreen();
      } else if ((element as any).webkitRequestFullscreen) {
        await (element as any).webkitRequestFullscreen();
      } else if ((element as any).mozRequestFullScreen) {
        await (element as any).mozRequestFullScreen();
      } else if ((element as any).msRequestFullscreen) {
        await (element as any).msRequestFullscreen();
      }
    }
  }

  async exitFullscreen(): Promise<void> {
    if (this.fullscreenEnabled) {
      if (document.exitFullscreen) {
        await document.exitFullscreen();
      } else if ((document as any).mozCancelFullScreen) {
        await (document as any).mozCancelFullScreen();
      } else if ((document as any).webkitCancelFullScreen) {
        await (document as any).webkitCancelFullScreen();
      } else if ((document as any).msExitFullscreen) {
        await (document as any).msExitFullscreen();
      }
    }
  }
}
