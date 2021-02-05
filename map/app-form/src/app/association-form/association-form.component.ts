import {Component, HostListener, OnInit, ViewChild} from '@angular/core';
import {Association} from '../model/association';
import {MyHttpResponse} from '../model/http-response';
import {ConfirmationService, MessageService} from 'primeng/api';
import {MysqlQueryService} from '../services/mysql-query.service';
import {AssociationEditFormComponent} from './association-edit-form/association-edit-form.component';
import {Router} from '@angular/router';

@Component({
  selector: 'app-association-form',
  templateUrl: './association-form.component.html',
  styleUrls: ['./association-form.component.scss'],
  providers: [
    MessageService,
    ConfirmationService
  ]
})
export class AssociationFormComponent implements OnInit {
  associations: Association[] = [];
  selectedAssociation?: Association;
  isNew = true;

  blocked = true;
  loadingText = 'Vereine werden abgerufen...';
  sidebarExpanded = true;

  districtOptions = [];
  activitiesOptions = [];

  @ViewChild('editForm', {static: true}) editForm!: AssociationEditFormComponent;

  constructor(private messageService: MessageService,
              private mySqlQueryService: MysqlQueryService,
              private confirmationService: ConfirmationService,
              private router: Router) {
  }

  @HostListener('window:beforeunload', ['$event']) unloadHandler(event: Event): void {
    event.returnValue = false;
  }

  async ngOnInit(): Promise<void> {
    this.blockUi({block: true, message: 'Vereine werden abgerufen...'});
    const httpResponse: MyHttpResponse<Association[]> = (await this.mySqlQueryService.getAssociations());
    this.associations = httpResponse?.data?.sort(
      (a: Association, b: Association) =>
        a.name.toLowerCase() > b.name.toLowerCase() ? 1 : (a.name.toLowerCase() < b.name.toLowerCase() ? -1 : 0)
    ) || [];
    if (!this.associations.length) {
      this.messageService.add({
        severity: 'error',
        summary: 'Fehler beim Abrufen der Vereine',
        detail: httpResponse?.errorMessage || '',
        key: 'formToast'
      });
    }

    this.districtOptions = (await this.mySqlQueryService.getDistrictOptions())?.data || [];
    this.activitiesOptions = (await this.mySqlQueryService.getActivitiesOptions())?.data || [];

    if (document.documentElement.clientWidth <= 768 && this.sidebarExpanded) {
      this.sidebarExpanded = false;
    }
    this.blockUi({block: false});
  }

  /**
   * queries all associations, reselects the edited association and scrolls to the top of the page
   */
  async reload(event: { id: string | undefined, showDialog: boolean | undefined }): Promise<void> {
    await this.ngOnInit();
    if (!event.showDialog || await this.leavePage()) {
      if (event.id) {
        const associationToSelect = this.associations.find((s: Association) => s.id === event.id);
        this.selectAssociation(associationToSelect, false, false);
      } else {
        this.selectAssociation(undefined, true, false);
      }
      window.scroll(0, 0);
    }
  }

  /**
   * selects an association to edit
   * @param association the association to edit
   * @param isNew wheter a new association is created or an existing is edited
   * @param showDialog show confirm dialog (discard changes)
   */
  async selectAssociation(association: Association | undefined, isNew = false, showDialog = true): Promise<void> {
    if (!showDialog || await this.leavePage()) {
      this.selectedAssociation = association;
      this.isNew = isNew;
      this.reset(false);
      if (document.documentElement.clientWidth <= 768 && this.sidebarExpanded) {
        this.sidebarExpanded = false;
      }
    }
  }

  /**
   * toggles the visibility of the sidebar
   */
  toggleSidebar(): void {
    this.sidebarExpanded = !this.sidebarExpanded;
  }

  async submit(): Promise<void> {
    await this.editForm.submit();
  }

  async reset(showDialog = true): Promise<void> {
    if (!showDialog || await this.leavePage()) {
      await this.editForm.reset(this.selectedAssociation?.id);
    }
  }

  async deleteAssociation(): Promise<void> {
    await this.editForm.deleteAssociation(this.selectedAssociation?.id);
  }

  blockUi($event: { block: boolean; message?: string }): void {
    this.blocked = $event.block;
    this.loadingText = $event.message;
  }

  async editOptions(): Promise<void> {
    if (await this.leavePage()) {
      await this.router.navigate(['/options-form']);
    }
  }

  /**
   * deactivate guard
   */
  async canDeactivate(): Promise<boolean> {
    return await this.leavePage();
  }

  /**
   * show dialog on page-leave if something changed in the form
   */
  async leavePage(): Promise<boolean> {
    if (this.editForm.hasFormValueChanged) {
      return new Promise((resolve) => {
        this.confirmationService.confirm({
          header: 'Änderungen verwerfen?',
          message: `Wenn Sie die Seite verlassen, gehen nicht gespeicherte Änderungen verloren.`,
          acceptLabel: 'OK',
          rejectLabel: 'Abbrechen',
          closeOnEscape: true,
          accept: () => {
            resolve(true);
          },
          reject: () => {
            resolve(false);
          }
        });
      });
    } else {
      return true;
    }
  }
}
