import { ItemList } from '../../model/HomeModel'
import { ColumnCardList } from './ColumnCardList'
import { HorizontalScrollCard } from './HorizontalScrollCard'
import { SpecialSquareCardCollection } from './SpecialSquareCardCollection'
import { TagBriefCard } from './TagBriefCard'
import { TextCardFooter2 } from './TextCardFooter2'
import { TextCardFooter3 } from './TextCardFooter3'
import { TextCardHeader5 } from './TextCardHeader5'
import { TextCardHeader7 } from './TextCardHeader7'
import { TopicBriefCard } from './TopicBriefCard'
import { VideoSmallCard } from './VideoSmallCard'

@Component
export struct HomeItem {
  item: ItemList = {}

  build() {
    Stack() {
      if (this.item.type == "textCard") {
        if (this.item.data.type == "header5") {
          TextCardHeader5({ data: this.item })
        } else if (this.item.data.type == "header7" || this.item.data.type == "header8") {
          TextCardHeader7({ data: this.item })
        } else if (this.item.data.type == "footer2") {
          TextCardFooter2({ data: this.item })
        } else if (this.item.data.type == "footer3") {
          TextCardFooter3({ data: this.item })
        }
      } else if (this.item.type == "specialSquareCardCollection") {
        if (this.item.data.dataType == "ItemCollection") {
          SpecialSquareCardCollection({ data: this.item })
        }
      } else if (this.item.type == "columnCardList") {
        if (this.item.data.dataType == "ItemCollection") {
          ColumnCardList({ data: this.item })
        }
      } else if (this.item.type == "horizontalScrollCard") {
        if (this.item.data.dataType == "HorizontalScrollCard") {
          HorizontalScrollCard({ data: this.item })
        }
      } else if (this.item.type == "videoSmallCard") {
        if (this.item.data.dataType == "VideoBeanForClient") {
          VideoSmallCard({ data: this.item })
        }
      } else if (this.item.type == "briefCard") {
        if (this.item.data.dataType == "TagBriefCard") {
          TagBriefCard({ data: this.item })
        } else if (this.item.data.dataType == "TopicBriefCard") {
          TopicBriefCard({ data: this.item })
        }
      }
    }
  }
}