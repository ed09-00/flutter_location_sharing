// 使用 Haversine 公式計算兩個經緯度之間的直線距離
import 'dart:math';

double haversineDistance(double lat1, double lon1, double lat2, double lon2) {
  const double earthRadius = 6371000; // 地球半徑，單位米

  // 將經緯度轉換為弧度
  double lat1Rad = degreesToRadians(lat1);
  double lon1Rad = degreesToRadians(lon1);
  double lat2Rad = degreesToRadians(lat2);
  double lon2Rad = degreesToRadians(lon2);

  // 計算經緯度差值
  double deltaLat = lat2Rad - lat1Rad;
  double deltaLon = lon2Rad - lon1Rad;

  // 使用 Haversine 公式計算距離
  double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
      cos(lat1Rad) * cos(lat2Rad) * sin(deltaLon / 2) * sin(deltaLon / 2);
  double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // 計算距離並返回
  double distance = earthRadius * c;
  return distance;
}

// 將角度轉換為弧度
double degreesToRadians(double degrees) {
  return degrees * (pi / 180);
}