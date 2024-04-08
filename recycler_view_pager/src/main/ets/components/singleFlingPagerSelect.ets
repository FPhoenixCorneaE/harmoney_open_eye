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

import { ItemData } from './singleFlingPager';

@Component
export struct singleFlingPagerSelect {
  private arr: number[]= [];
  @Link offsetX: number
  @State offsetY: number= 0
  @Link index: number;
  private marginLeft: number= 1
  private marginRight: number= 1
  private Containderwidth: number= 0
  private ContainderHeight: number|string= '100%'
  private offsetIndex: number= 100
  private leftFlag: boolean= false
  private TargetPositionFlag: boolean= false
  @BuilderParam content: (item : any, index : any, offsetX : any) => any;

  build() {

      Row() {
        ForEach(this.arr.map((item1 : number, index1 : number) : ItemData=> {
          return new ItemData(index1, item1);
        }),
          (item : ItemData, index) => {
            this.content(item, this.index, this.offsetX)
          },
          (item : ItemData) => {
            return JSON.stringify(item.i);
          })
      }
      .offset({
        x: this.offsetX == 0 || this.TargetPositionFlag == true ? this.leftFlag == true ?
           ((-this.Containderwidth * this.index) - this.index * (this.marginLeft+this.marginRight))
           : ((-this.Containderwidth * this.index) - this.index * (this.marginLeft+this.marginRight))
           : ((-this.Containderwidth * this.index) - this.index * (this.marginLeft+this.marginRight) + this.offsetX)
      ,
        y: 0
      })
      .gesture(
      PanGesture({})
        .onActionStart((event: GestureEvent) => {
        })
        .onActionUpdate((event: GestureEvent) => {
          if (this.index == (this.arr.length - 1) && this.offsetX < 0) {
            return;
          }
          this.offsetX = event.offsetX
          this.offsetY = event.offsetY
        })
        .onActionEnd((event: GestureEvent) => {
          if (this.index == (this.arr.length - 1) && event.offsetX < 0) {
            this.leftFlag = false
            this.offsetX = 0
            return;
          }

          if (this.offsetX < -this.offsetIndex && this.offsetX < 0) {
            this.leftFlag = false
            this.offsetX = 0
            this.index++
          } else if (this.offsetX > this.offsetIndex && this.offsetX > 0) {
            this.offsetX = 0
            this.leftFlag = false
            if (this.index == 0) {
              this.index = 0
            } else {
              this.index--
            }
          } else if (this.offsetX > -this.offsetIndex && this.offsetX < 0) {
            this.leftFlag = true
            this.offsetX = 0
          } else if (this.offsetX < this.offsetIndex && this.offsetX > 0) {
            this.leftFlag = true
            this.offsetX = 0
          }
          console.info("this.index=" + this.index + "       this.offsetX=" + this.offsetX)
          console.info('Pan end')
        })
      )
      .width(this.Containderwidth * this.arr.length )
      .height(this.ContainderHeight )
  }
}