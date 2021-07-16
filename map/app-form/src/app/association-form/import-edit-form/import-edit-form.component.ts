import {Component, EventEmitter, Output} from '@angular/core';
import {Association} from '../../model/association';
import {DropdownOption} from '../../model/dropdown-option';
import {MysqlPersistService} from '../../services/mysql-persist.service';
import {MessageService} from 'primeng/api';
import {MysqlQueryService} from '../../services/mysql-query.service';
import {LoginService} from '../../login/login.service';

import {getAssociations} from './../../services/ods-table/json'
import * as XLSX from 'xlsx'

@Component({
  selector: 'app-edit-import-form',
  templateUrl: './import-edit-form.component.html',
  styleUrls: ['./import-edit-form.component.scss'],
  providers: [
    MessageService
  ]
})
export class ImportEditFormComponent {

  districtOptions: DropdownOption[] = [];
  activitiesOptions: DropdownOption[] = [];

  uploadedFiles: any[] = [];

  @Output() blockUi: EventEmitter<{ block: boolean, message?: string }>
    = new EventEmitter<{ block: boolean, message?: string }>();

  private async initForm(): Promise<void> {
    this.districtOptions = (await this.mySqlQueryService.getDistrictOptions())?.data || [];
    this.activitiesOptions = (await this.mySqlQueryService.getActivitiesOptions())?.data || [];
    this.emitBlockUi(true);
  }

  constructor(
    private mySqlQueryService: MysqlQueryService,
    private mySqlPersistService: MysqlPersistService,
    private messageService: MessageService,
    private loginService: LoginService) {
  }

  async submit(): Promise<void> {
    this.emitBlockUi(true, 'Import der Vereinstabelle...');

    const loggedIn = await this.loginService.checkLoginStatus();
    if (!loggedIn) {
      this.messageService.add({
        severity: 'error',
        summary: 'Berechtigungsfehler',
        detail: 'Konnte nicht gespeichert werden. Bitte loggen Sie sich erneut ein.',
        key: 'editFormToast'
      });
      this.emitBlockUi(false);
      return;
    }
  }

  importTable(event) {
    for(let file of event.files) {
      this.uploadedFiles.push(file)
      const reader: FileReader = new FileReader()
      const bs = reader.readAsBinaryString(file)
      reader.onload = (e) => {
        const binaryResult = reader.result
        const wb: XLSX.WorkBook = XLSX.read(binaryResult, { type: 'binary' })

        const wsname: string = wb.SheetNames[0]
        const ws: XLSX.WorkSheet = wb.Sheets[wsname]

        // const data = XLSX.utils.sheet_to_json(ws) // to get 2d array pass 2nd parameter as object {header: 1}
        // console.log(data) // Data will be logged in array format containing objects
        const assocs : Association[] = getAssociations(
          this.districtOptions
          , this.activitiesOptions
          , ws)

        this.mySqlPersistService.deleteAllAssociations().toPromise()
          .then(() => {
            // console.log("deleteAllAssociations done")
            let importFailed = false
            for (let a of assocs) {
              this.mySqlPersistService.createOrUpdateAssociation(a).toPromise()
                .then(() => {
                  // console.log("Saved", a.name)
                })
                .catch((reason) => {
                  importFailed = true
                  this.emitBlockUi(false);
                  this.messageService.add({
                    severity: 'error',
                    summary: a.name + ' konnte nicht gespeichert werden.',
                    detail: JSON.stringify(reason),
                    key: 'editFormToast'
                  })
                })
              if (importFailed) {
                break
              }
            }
            if (!importFailed) {
              this.emitBlockUi(false);
              this.messageService.add({
                severity: 'success',
                summary: assocs.length + ' Vereine importiert.',
                key: 'editFormToast'
              })
            }
          })
          .catch((reason) => {
            this.emitBlockUi(false);
            this.messageService.add({
              severity: 'error',
              summary: 'Bestehende Vereine konnten nicht gelöscht werden.',
              detail: JSON.stringify(reason),
              key: 'editFormToast'
            })
          })
      }
    }
  }

  // TODO what is canDeactivate good for?
  async canDeactivate(): Promise<boolean> {
    return true;
  }

  /**
   * emits a event for the parent component to block the ui
   * @param block start blocking state (true) or not end blocking state (false)
   * @param message message to display in the ui blocker
   */
  emitBlockUi(block: boolean, message?: string): void {
    this.blockUi.emit({
      block,
      message
    });
  }

}
