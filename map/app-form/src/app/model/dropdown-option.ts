export interface DropdownOption {
  label: string;
  value: any;
}

export interface InternalGroupedDropdownOption {
  label: string;
  value: any;
  isSubOption: boolean;
}

export function getInternalGroupedDropdownOptions(options: DropdownOption[]): InternalGroupedDropdownOption[] {
  return options.map((o: DropdownOption) => {
    return {
      value: o.value,
      label: o.label,
      isSubOption: o.value % 100 !== 0
    };
  });
}

export function getAllOptions(arr: any[], ids: number[] = []): any[] {
  return arr.filter((o: any) => ids.includes(o.value));
}

export function getSubOptions(arr: any[], ids: number[] = []): any[] {
  return arr.filter((o: any) => o.value % 100 !== 0 && ids.includes(o.value));
}
