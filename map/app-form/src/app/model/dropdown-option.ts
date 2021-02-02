export interface DropdownOption {
  label: string;
  value: any;
  category?: string;
  categoryLabel?: string;
  orderIndex: number;
}

export interface InternalGroupedDropdownOption {
  label: string;
  value: any;
  category?: string;
  categoryLabel: string;
  isSubOption: boolean;
  orderIndex: number;
}

export function getInternalGroupedDropdownOptions(options: DropdownOption[]): InternalGroupedDropdownOption[] {
  return options.map((o: DropdownOption) => {
    return {
      value: o.value,
      label: o.label,
      category: o.category,
      categoryLabel: o.categoryLabel || o.label,
      isSubOption: !!o.category,
      orderIndex: o.orderIndex
    };
  }).sort((a: InternalGroupedDropdownOption, b: InternalGroupedDropdownOption) => sortOptions(a, b));
}

export function sortOptions(a: InternalGroupedDropdownOption, b: InternalGroupedDropdownOption): number {
  return a.orderIndex < b.orderIndex ? -1 :
    (a.orderIndex > b.orderIndex ? 1 :
        (!!a.isSubOption && !b.isSubOption ? 1 :
            (!a.isSubOption && !!b.isSubOption ? -1 :
                (a.label < b.label ? -1 :
                    (a.label > b.label ? 1 : 0)
                )
            )
        )
    );
}

export function getAllOptions(arr: any[], ids?: number[]): any[] {
  return ids ? arr.filter((o: any) => ids.includes(o.value)) : arr;
}

export function getSubOptions(arr: any[], ids?: number[]): any[] {
  return ids
    ? arr.filter((o: any) => !!o.category && ids.includes(o.value))
    : arr.filter((o: any) => !!o.category);
}

export function getTopOptions(arr: any[], ids?: number[]): any[] {
  return ids
    ? arr.filter((o: any) => !o.category && ids.includes(o.value))
    : arr.filter((o: any) => !o.category);
}
