import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserData{

  
    UserData({required this.id,required this.latitude,required this.longitude,required this.uid,required this.name,this.distance,this.displayDistance});
    
    BitmapDescriptor icon = BitmapDescriptor.defaultMarker;
    int id;
    String uid;
    String name;
    //緯度
    double latitude;
    //經度
    double longitude;
    //雙方距離多遠(公尺)
    double? distance;
    //顯示文字(公尺、公里等等)
    String? displayDistance;
    

}