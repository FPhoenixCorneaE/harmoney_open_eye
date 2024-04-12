export interface HomeModel {
  itemList: ItemList[];
  count: number;
  total: number;
  nextPageUrl?: string;
  adExist: boolean;
}


export interface ItemList {
  type?: string;
  data?: Data;
  trackingData?: any;
  tag?: any;
  id?: number;
  adIndex?: number;
}


export interface Data {
  dataType?: string;
  type?: string;
  header?: Header;
  itemList?: ItemList[];
  count?: number;
  adTrack?: any;
  footer?: any;
  text?: string;
  follow?: Follow;
  rightText?: string;
}


export interface Header {
  id: number;
  title: string;
  font: string;
  subTitle: string;
  subTitleFont: string;
  textAlign: string;
  cover: any;
  label: any;
  actionUrl: string;
  labelList: any;
  rightText: string;
  icon: string;
  iconType: string;
  description: any;
  time: number;
  showHateVideo: boolean;
}


export interface Content {
  type: string;
  data: Data;
  trackingData: any;
  tag: any;
  id: number;
  adIndex: number;
}


export interface Follow {
  followed?: boolean; // false
  itemId?: number; // 2003
  itemType?: string; // author
}


