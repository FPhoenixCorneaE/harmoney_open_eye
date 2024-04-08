/*
  * Copyright (c) 2022 Huawei Device Co., Ltd.
  * Licensed under the Apache License, Version 2.0 (the "License");
  * you may not use this file except in compliance with the License.
  * You may obtain a copy of the License at
  *
  * http://www.apache.org/licenses/LICENSE-2.0
  *
  * Unless required by applicable law or agreed to in writing, software
  * distributed under the License is distributed on an "AS IS" BASIS,
  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
  * See the License for the specific language governing permissions and
  * limitations under the License.
  */

import { ItemData } from './singleFlingPager';

@Component
export struct verticalViewPager {
  @State arr: number[]= [];
  @Link offsetY: number
  @Link index: number
  marginTop: number= 0
  marginBottom: number=0
  public ContainderWidth: number|string= 0;
  public ContainderHeight: number= 0;
  private offsetFlag: number= 100
  private pageFlag: boolean= false
  @BuilderParam content: (item : any) => any;

  build() {
      Column() {
        ForEach(this.arr.map((item1 : number, index1 : number) : ItemData=> {
          return new ItemData(index1, item1);
        }),
          (item : ItemData, index) => {
            this.content(item)
          },
          (item : ItemData) => {
            return JSON.stringify(item.i);
          })
      }
      .offset({
        x: 0,
        y: ((-this.ContainderHeight * this.index) - this.index * (this.marginBottom+this.marginTop) + this.offsetY)
      })
      .gesture(
      PanGesture({})
        .onActionStart((event: GestureEvent) => {
          console.info('Pan start')
        })
        .onActionUpdate((event: GestureEvent) => {
          if(this.index == (this.arr.length -1) && this.offsetY< 0){
            return;
          }
          this.offsetY = event.offsetY
          console.info('Pan Update=' + this.offsetY)
        })
        .onActionEnd((event: GestureEvent) => {
          if(this.index == (this.arr.length -1) && this.offsetY< 0){
            this.pageFlag = false
            this.offsetY = 0
            return;
          }
          if (this.offsetY < -this.offsetFlag && this.offsetY < 0) {
            this.pageFlag = false
            this.offsetY = 0
            this.index++
          } else if (this.offsetY > this.offsetFlag && this.offsetY > 0) {
            this.offsetY = 0
            this.pageFlag = false
            if (this.index == 0) {
              this.index = 0
            } else {
              this.index--
            }
          } else if (this.offsetY > -this.offsetFlag && this.offsetY < 0) {
            this.pageFlag = true
            this.offsetY = 0
          } else if (this.offsetY < this.offsetFlag && this.offsetY > 0) {
            this.pageFlag = true
            this.offsetY = 0
          }
        })
      )
      .width(this.ContainderWidth)
      .height((this.ContainderHeight +this.marginBottom+this.marginTop)* this.arr.length)
    }
}