# Flutter 一次性GPS多人共享程式

<img src="https://cdn.discordapp.com/attachments/917430039597965334/1212823811544715294/image.png?ex=65f33d31&is=65e0c831&hm=ea2d7009e3b73f9703edfa6f7c2e78957a45f2cf389629b9ab0f3cce384d9200&" height="536px" width="250px" /><img src="https://cdn.discordapp.com/attachments/917430039597965334/1212823853248811029/image.png?ex=65f33d3b&is=65e0c83b&hm=83273f879d798420c02cb2f2e54fd0eb528182579397761fdb999de1f31e93f3&" height="536px" width="250px" /><img src="https://media.discordapp.net/attachments/917430039597965334/1212824291582677002/image.png?ex=65f33da4&is=65e0c8a4&hm=a6e0eb7a69b0ffefebc8610414a791e18a9cb8895e8f90991ec296b97ddab9ad&=&format=webp&quality=lossless&width=284&height=611" height="536px" width="250px" /><img src="https://cdn.discordapp.com/attachments/917430039597965334/1212839931509215293/image.png?ex=65f34c35&is=65e0d735&hm=1c98cac6874f54e452f5e9d105bbf5d064832e5ece5b89385d4393c72dd3070d&" height="536px" width="250px" />









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
- 登出：回到login page

map page:
- google map 視圖
  - 顯示房內每個人的位置。
  - 切換並鎖定視角在選擇的人。
  - 123
 
- 即時聊天室窗
  - 即時顯示該房內聊天訊息。
  
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




## Demo
