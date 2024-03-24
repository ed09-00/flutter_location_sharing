# Flutter 一次性多人GPS資訊共享程式
## Demo
[<img src="https://i.imgur.com/CONrg2F.png">](https://www.youtube.com/watch?v=_5lr5tKQb8I&ab_channel=Edward)

## 介面
<img src="https://i.imgur.com/wzDBEQo.png" height="536px" width="250px" /><img src="https://i.imgur.com/nijewwd.png" height="536px" width="250px" /><img src="https://i.imgur.com/RrZzYj6.png" height="536px" width="250px" /><img src="https://i.imgur.com/D9raRM1.png" height="536px" width="250px" />









## 功能  
welcome page:
- 判斷登入狀態來決定要去login / connect page，

login page:
- 提供信箱登入 / google登入。

register page:
- 信箱與密碼創建帳號。

connect page:
- 創建房間: 創建成功返回房間號碼 。
- 加入房間: 輸入創房者給你的號碼。
- 登出：回到login page。

map page:
- google map 視圖
  - 顯示房內每個人的位置。
  - 切換視角到選擇的人。
  - 標籤顯示與對方的距離。
>[!NOTE]
>道路黑黑的是因為渲染器的問題：https://stackoverflow.com/questions/77641340/path-roads-are-black-in-google-maps-flutter

- Chat
  - Listview的方式即時顯示該房內聊天訊息。

## 未來規劃
- 使用[Directions API](https://developers.google.com/maps/documentation/directions/overview?hl=zh-tw)在地圖上顯示路線
- 使用[Place API](https://developers.google.com/maps/documentation/places/web-service?hl=zh-tw)新增地點詳細資料搜尋功能

## plugins
| plugin名稱  | 官方文件說明 | 使用場景 |
| ------------- | ------------- | ------------- |
| [geolocator](https://pub.dev/packages/geolocator "geolocator") | 一個 Flutter 定位插件，它提供了對平台特定定位服務的輕鬆訪問（在 Android 上使用 FusedLocationProviderClient，如果不可用則使用 LocationManager，在 iOS 上使用 CLLocationManager）。 | 獲得本機GPS資訊。 |
|[google_maps_flutter](https://pub.dev/packages/google_maps_flutter "google_maps_flutter") | 一個提供 Google 地圖 widget 的 Flutter 插件。 | 顯示建立的會話中多個參與者的位置。 |
|[firebase_database](https://pub.dev/packages/firebase_database "Firebase_Database") | 一個用於使用 [Firebase Database API](https://firebase.google.com/docs/database/ "Firebase_Database_API") 的 Flutter 插件。 | 儲存參與者的資訊、對話內容。 |
| [firebase_core](https://pub.dev/packages/firebase_core "firebase_core") | 一個 Flutter 插件，用於使用 Firebase Core API，使得可以連接到多個 Firebase 應用程式。|  |
| [firebase_auth](https://pub.dev/packages/firebase_auth "firebase_auth") | 使用[Firebase 驗證 API](https://firebase.google.com/products/auth?hl=zh-cn "Firebase驗證 API") 的Flutter 外掛程式。 | 做信箱登入、第三方登入。 |
| [shared_preferences](https://pub.dev/packages/shared_preferences "shared_preferences") | 封裝了特定平台的持久性存儲功能，用於簡單數據（在 iOS 和 macOS 上使用 NSUserDefaults，在 Android 上使用 SharedPreferences 等）。 | 操作本地儲存資料。  |
| [uuid](https://pub.dev/packages/uuid "uuid") | 快速生成符合 RFC4122 標準的 UUID。 | 產生會話號碼。 |
| [google_fonts](https://pub.dev/packages/google_fonts "google_fonts") | 一個 Flutter 套件，用於使用 [fonts.google.com](fonts.google.com "font.google.com") 上的字體。  |  |





