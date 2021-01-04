import {Component, OnInit} from '@angular/core';
import {Association} from '../model/association';
import {MyHttpResponse} from '../model/http-response';
import {MessageService} from 'primeng/api';
import {MysqlQueryService} from '../services/mysql-query.service';

@Component({
  selector: 'app-association-form',
  templateUrl: './association-form.component.html',
  styleUrls: ['./association-form.component.scss'],
  providers: [
    MessageService
  ]
})
export class AssociationFormComponent implements OnInit {
  associations: Association[] = [];
  selectedAssociation?: Association;
  isNew = true;

  blocked = true;
  sidebarExpanded = true;

  constructor(private messageService: MessageService,
              private mySqlQueryService: MysqlQueryService) {
  }

  async ngOnInit(): Promise<void> {
    this.blocked = true;
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

    if (document.documentElement.clientWidth <= 768 && this.sidebarExpanded) {
      this.sidebarExpanded = false;
    }
    this.blocked = false;
  }

  /**
   * queries all associations, reselects the edited association and scrolls to the top of the page
   * @param id the selected association's id
   */
  async reload(id: string | undefined): Promise<void> {
    await this.ngOnInit();
    if (id) {
      const associationToSelect = this.associations.find((s: Association) => s.id === id);
      this.selectAssociation(associationToSelect, false);
    } else {
      this.selectedAssociation = undefined;
      this.isNew = false;
    }
    window.scroll(0, 0);
  }

  /**
   * selects an association to edit
   * @param association the association to edit
   * @param isNew wheter a new association is created or an existing is edited
   */
  selectAssociation(association: Association | undefined, isNew = false): void {
    this.selectedAssociation = association;
    this.isNew = isNew;
    if (document.documentElement.clientWidth <= 768 && this.sidebarExpanded) {
      this.sidebarExpanded = false;
    }
  }

  /**
   * toggles the visibility of the sidebar
   */
  toggleSidebar(): void {
    this.sidebarExpanded = !this.sidebarExpanded;
  }
}
