import {Component, EventEmitter, Input, OnInit, Output} from '@angular/core';
import {Association} from '../../model/association';

@Component({
  selector: 'app-associations-list',
  templateUrl: './associations-list.component.html',
  styleUrls: ['./associations-list.component.scss']
})
export class AssociationsListComponent implements OnInit {
  @Input() noPubAddrAssocIds: string[] = [];
  @Input() associations: Association[] = [];
  @Input() identifiedByFieldName = 'name';
  @Input() selectedAssociationField: any = undefined;
  @Input() primeNgPubAddr           = 'pi pi-map-marker pubAddr';
  @Input() primeNgPubAddrSelected   = 'pi pi-map pubAddr';
  @Input() primeNgNoPubAddr         = 'pi pi-map-marker noPubAddr';
  @Input() primeNgNoPubAddrSelected = 'pi pi-map noPubAddr';

  @Output() selected: EventEmitter<Association> = new EventEmitter<Association>();
  @Output() mover: EventEmitter<Association> = new EventEmitter<Association>();
  @Output() mout: EventEmitter<Association> = new EventEmitter<Association>();

  constructor() {
  }

  ngOnInit(): void {
  }

  remove_eV(a : Association) {
    let s = a.name;
    if (s) {
      s = s.replace(/ e\. V\./g, ' e\.V\.');
      return s.replace(/ e\.V\./g, '');
    }
    else {
      return s;
    }
  }

  emitClick(a: Association): void {
    this.selected.emit(a);
  }

  emitMouseOver(a: Association): void {
    this.mover.emit(a);
  }

  emitMouseOut(a: Association): void {
    this.mout.emit(a);
  }
}
