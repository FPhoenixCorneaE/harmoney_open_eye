/*
 * Copyright (C) 2022 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

@Component
export struct materialContainderTop {
  @Link model: materialContainderTop.Model
  @State titles: string[] = []
  @Link @Watch("itemIndexChange") index: number

  itemIndexChange(): void {
    this.model.controller.changeIndex(this.index)
    if (this.model.indexChange) {
      this.model.indexChange(this.index)
    }
    this.scroller.scrollTo({
      xOffset: (-px2vp(this.model.viewWidth) / 2) + (this.index + 0.5) * (this.model.textWidth + (this.model.hasIcon ? this.model.iconSize : 0)),
      yOffset: 0,
    })
  }

  scroller: Scroller = new Scroller()

  build() {
    Column() {
      Scroll(this.scroller) {
        Column() {
          Row() {
            ForEach(this.titles.map((item1: string, index1: number): TitleData => {
              return new TitleData(index1, item1);
            }),
              (item: TitleData, index) => {
                Row() {
                  if (this.model.hasIcon) {
                    Image((item.i == this.index) ? this.model.icons[item.i].selected : this.model.icons[item.i].normal)
                      .width(this.model.iconSize)
                      .height(this.model.iconSize)
                  }

                  Text(item.data)
                    .fontSize((`${item.i}` == (this.index) + "") ? this.model.selectedTextSize : this.model.UnselectedTextSize)
                    .width(this.model.textWidth)
                    .height(this.model.textHeight)
                    .fontColor((`${item.i}` == (this.index) + "") ? this.model.fontColor : this.model.UnselectedTextColor)
                    .textAlign(TextAlign.Center)
                }.onClick(() => {
                  this.index = item.i
                  if (this.model.clickListener) {
                    this.model.clickListener(this.index)
                  }
                })
              },
              (item: TitleData) => {
                return item.data
              })
          }.backgroundColor(this.model.background)

          Row({}) {
            Rect()
              .height(this.model.cursorHeight)
              .width(this.model.cursorWidth + ((this.model.hasIcon == true ? this.model.iconSize : 0)))
              .fill(this.model.cursorColor)
              .radius(this.model.cursorRadius)
          }
          .offset({
            x: (px2vp(this.model.viewWidth) - this.model.textWidth * this.titles.length) / 2
            + (this.model.textWidth - this.model.cursorWidth) / 2
            + this.model.textWidth * this.index
            - (this.model.snap ? (this.model.offset / this.model.viewWidth) * this.model.textWidth : 0),
            y: 0 })
          .alignSelf(ItemAlign.Start)

          Stack().width("100%").height(this.model.dividerHeight).backgroundColor(this.model.dividerColor)
        }
      }.scrollable(ScrollDirection.Horizontal).scrollBar(BarState.On)

    }.height(this.model.height + this.model.dividerHeight).width(this.model.width)

  }

  aboutToAppear() {
    this.model.onPageTouch = (event: TouchEvent, currentIndex: number) => {
      return this.onTouchEvent(event, currentIndex);
    };
  }

  private x0: number = 0;
  private offsetX: number = 0;

  onTouchEvent(event: TouchEvent, index: number): number {
    let x0 = this.x0
    let offset: number;
    if (event.type === TouchType.Down) {
      this.x0 = event.touches[0].x
    }
    if (event.type === TouchType.Move) {
      offset = event.touches[0].x - x0
      if ((offset >= 0 && index > 0) || (offset <= 0 && index < this.titles.length - 1)) {
        this.offsetX = offset
      }
    }
    if (event.type === TouchType.Up) {
      this.model.controller.changeIndex(index)
      offset = 0
      animateTo(
        { duration: 100, curve: Curve.Smooth },
        () => {
          this.offsetX = 0
        })
    }
    this.model.offset = this.offsetX
    this.index = index
    return index;
  }
}

export namespace materialContainderTop {

  export class Model {
    controller: TabsController = new TabsController();
    snap: boolean = true
    arr: Array<string> = []
    icons: IconData[] = []
    viewWidth: number = lpx2px(720)
    offset: number = 0
    cursorColor: string = "#e76909"
    background: string = "#f1f5f3"
    fontColor: string = "#ffffff"
    hasIcon: boolean = false
    cursorHeight: number = 3
    textHeight: number = 45
    dividerHeight: number = 2
    cursorWidth: number = 80
    cursorRadius: number = this.cursorHeight
    textWidth: number = 80
    height: number = this.dividerHeight + this.cursorHeight + this.textHeight
    width: string = '100%'
    dividerColor: string = "#cb798d"
    selectedTextSize: number = 16
    iconSize: number = 25
    UnselectedTextColor: string = "#c5c8c8"
    UnselectedTextSize: number = 16
    indexChange: (index: number) => void = () => {
    }
    clickListener: (index: number) => void = () => {
    }
    onPageTouch: (event: TouchEvent, currentIndex: number) => number = () => {
      return 0
    }

    constructor(controller?: TabsController) {
      if (controller != undefined) {
        this.controller = controller;
      }
    }

    public notifyTouch(event: TouchEvent, index: number) {
      this.onPageTouch(event, index)
    }

    public getUnselectedTextSize(): number {
      return this.UnselectedTextSize
    }

    public setUnselectedTextSize(UnselectedTextSize: number): Model {
      this.UnselectedTextSize = UnselectedTextSize
      return this
    }

    public getUnselectedTextColor(): string {
      return this.UnselectedTextColor
    }

    public setUnselectedTextColor(UnselectedTextColor: string): Model {
      this.UnselectedTextColor = UnselectedTextColor
      return this
    }

    public getIcons(): IconData[] {
      return this.icons
    }

    public setIcons(icons: IconData[]): Model {
      this.icons = icons
      this.hasIcon = true
      return this
    }

    public getSize(): number {
      return this.iconSize
    }

    public setSize(iconSize: number): Model {
      this.iconSize = iconSize
      return this
    }

    public setSelectTextSize(selectedTextSize: number): Model {
      this.selectedTextSize = selectedTextSize;
      return this
    }

    public setDividerColor(dividerColor: string): Model {
      this.dividerColor = dividerColor;
      return this
    }

    public setViewWidth(width: number): Model {
      this.viewWidth = width;
      return this
    }

    public setWidth(width: string): Model {
      this.width = width;
      return this
    }

    public setCursorWidth(cursorWidth: number): Model {
      this.cursorWidth = cursorWidth;
      return this
    }

    public setTextWidth(textWidth: number): Model {
      this.textWidth = textWidth;
      return this
    }

    public setHeight(height: number): Model {
      this.height = height + this.dividerHeight + this.cursorHeight + this.textHeight;
      return this
    }

    public setDividerHeight(dividerHeight: number): Model {
      this.dividerHeight = dividerHeight;
      return this
    }

    public setCursorHeight(cursorHeight: number): Model {
      this.cursorHeight = cursorHeight;
      return this
    }

    public setCursorRadius(radius: number): Model {
      this.cursorRadius = radius;
      return this
    }

    public setTextHeight(textHeight: number): Model {
      this.textHeight = textHeight;
      return this
    }

    public setSelectTextColor(fontColor: string): Model {
      this.fontColor = fontColor;
      return this
    }

    public setBackgroundColor(background: string): Model {
      this.background = background;
      return this
    }

    public setCursorColor(color: string): Model {
      this.cursorColor = color;
      return this
    }

    public setSnap(snap: boolean): Model {
      this.snap = snap
      return this
    }

    public setOffset(offset: number): Model {
      this.offset = offset
      return this
    }

    public setArr(arr: Array<string> = []): Model {
      this.arr = arr
      return this
    }

    public setChangeListener(callback: (index: number) => void): Model {
      this.indexChange = callback
      return this
    }

    public setClickListener(callback: (index: number) => void): Model {
      this.clickListener = callback
      return this
    }
  }
}

export default materialContainderTop;

class TitleData {
  i: number;
  data: string;

  constructor(i: number, data: string) {
    this.i = i;
    this.data = data;
  }
}

class IconData {
  selected?: string | Resource;
  normal?: string | Resource;

  constructor(selected: string | Resource, normal: string | Resource) {
    this.selected = selected;
    this.normal = normal;
  }
}