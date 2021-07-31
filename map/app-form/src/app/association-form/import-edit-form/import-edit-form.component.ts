import {Component, EventEmitter, Output, OnInit} from '@angular/core';
import {Association} from '../../model/association';
import {DropdownOption} from '../../model/dropdown-option';
import {MysqlPersistService} from '../../services/mysql-persist.service';
import {ConfirmationService, MenuItem, MessageService} from 'primeng/api';
import {MysqlQueryService} from '../../services/mysql-query.service';
import {getAssociations} from '../../services/ods-table/json';
import * as XLSX from 'xlsx';
import {ActivatedRoute, Router} from '@angular/router';

@Component({
  selector: 'app-edit-import-form',
  templateUrl: './import-edit-form.component.html',
  styleUrls: ['./import-edit-form.component.scss'],
  providers: [
    MessageService,
    ConfirmationService,
  ]
})

export class ImportEditFormComponent implements OnInit {
  backMenuItems: MenuItem[] = [
    {
      label: 'Zurück',
      icon: 'pi pi-arrow-left',
      command: async () => {
        await this.router.navigate(['/associations']);
      },
    }
  ];

  districtOptions: DropdownOption[] = [];

  uploadedFiles: any[] = [];

  @Output() blockUi: EventEmitter<{ block: boolean, message?: string }>
    = new EventEmitter<{ block: boolean, message?: string }>();

  constructor(
    private mySqlQueryService: MysqlQueryService,
    private mySqlPersistService: MysqlPersistService,
    private messageService: MessageService,
    private router: Router,
    private route: ActivatedRoute) {
  }

  async ngOnInit(): Promise<void> {
    this.districtOptions = (await this.mySqlQueryService.getDistrictOptions())?.data || [];
  }

  async importTable(event): Promise<void> {
    for (const file of event.files) {
      this.uploadedFiles.push(file);
      const reader: FileReader = new FileReader();
      const bs = reader.readAsBinaryString(file);
      reader.onload = (e) => {
        const binaryResult = reader.result;
        const wb: XLSX.WorkBook = XLSX.read(binaryResult, {type: 'binary'});

        const wsname: string = wb.SheetNames[0];
        const ws: XLSX.WorkSheet = wb.Sheets[wsname];

        const assocs: Association[] = getAssociations(
          this.districtOptions,
          ws
        );

        this.mySqlPersistService.deleteAllAssociations().toPromise()
          .then(() => {
            // console.log("deleteAllAssociations done")
            let importFailed = false;
            for (const a of assocs) {
              this.mySqlPersistService.createOrUpdateAssociation(a).toPromise()
                .then(() => {
                  // console.log("Saved", a.name)
                })
                .catch((reason) => {
                  importFailed = true;
                  this.emitBlockUi(false);
                  this.messageService.add({
                    severity: 'error',
                    summary: a.name + ' konnte nicht gespeichert werden.',
                    detail: JSON.stringify(reason),
                    key: 'editFormToast'
                  });
                });
              if (importFailed) {
                break;
              }
            }
            if (!importFailed) {
              this.emitBlockUi(false);
              this.messageService.add({
                severity: 'success',
                summary: assocs.length + ' Vereine importiert.',
                key: 'editFormToast'
              });
            }
          })
          .catch((reason) => {
            this.emitBlockUi(false);
            this.messageService.add({
              severity: 'error',
              summary: 'Bestehende Vereine konnten nicht gelöscht werden.',
              detail: JSON.stringify(reason),
              key: 'editFormToast'
            });
          });
      };
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
