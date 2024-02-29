# Flutter 一次性GPS多人共享程式
<img src="https://cdn.discordapp.com/attachments/917430039597965334/1212658297606512721/image.png?ex=65f2a30c&is=65e02e0c&hm=b22db36090779739dacac03a30d46d27179bc7adc43e09f98a1e34fa80c62957" height="686px" width="322px" /><img src="https://cdn.discordapp.com/attachments/917430039597965334/1212658833839620166/image.png?ex=65f2a38c&is=65e02e8c&hm=970745f0a3543780ec1e999bdf90ae111ebeed78be4cccc22a84cc28c3a70445&" height="686px" width="322px" />


使用Binance API 與 CoinMarketCap API獲取虛擬貨幣價格資訊並做成圖表

Binance api: https://binance-docs.github.io/apidocs/spot/en/#market-data-endpoints
CoinMarketCap: https://coinmarketcap.com/api/documentation/v1/#section/Authentication    

## 功能  
welcome page:
- 顯示項目價格。
- 無限制的添加自選項目。

login page:
- 帶有兩條均線的K線圖(SMA14, SMA28)。
- 可選K線圖表時間週期(1m, 15m, 1h, 4h, 1d)。

register page:
- 帶有兩條均線的K線圖(SMA14, SMA28)。
- 可選K線圖表時間週期(1m, 15m, 1h, 4h, 1d)。

map page:
- 帶有兩條均線的K線圖(SMA14, SMA28)。
- 可選K線圖表時間週期(1m, 15m, 1h, 4h, 1d)。
  
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
