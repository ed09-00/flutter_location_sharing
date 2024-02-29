import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_location_sharing/widgets/chat_widget.dart';
import 'package:flutter_location_sharing/config/index.dart';
import 'package:flutter_location_sharing/main.dart';
import 'package:flutter_location_sharing/pages/connect_page.dart';
import 'package:flutter_location_sharing/utils/firebase_service_util.dart';
import 'package:flutter_location_sharing/model/user_data_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../utils/math_function_util.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key});

  @override
  State<MapPage> createState() => MapPageState();
}

class MapPageState extends State<MapPage> {
  StreamController? _streamController;
  UserData? _myUserData;
  List<Marker> _listOfMarkers = [];
  Set<Marker> _markers = {};

  //dropdownbutton的value
  int? _value;

  //從firebase realtime database實時取得使用者資料
  List<UserData> _usersDatas = [];

  //目前選擇的是第I位使用者
  UserData? _selectedUserData;

  //取得使用者資料
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //使用firebase CRUD服務
  late FirebaseService _firebaseService;

  //房間號碼
  final String _roomId = prefs.getString("roomId") ?? "123";

  //輸入框控制器
  final TextEditingController _msgTextFieldController = TextEditingController();

  //google map controller
  late GoogleMapController _googleMapController;

  //縮放倍率
  double _zoom = 18.0;

  // var _myIcon;
  //滑動視窗控制器
 ScrollController _scrollController =  ScrollController();
  void _onPauseHandler() {
    print('on Pause');
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  CameraPosition _myPosition = const CameraPosition(
    target: LatLng(0, 0),
    zoom: 18,
  );

  //主視圖
  Widget _mainView(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    double chatHeight = height/3;
    double mapHeight = height/11*6;
    return SizedBox(
      //取得設備寬度、長度
      width: width,
      height: height,
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              width: width,
              height: mapHeight,
              child: GoogleMap(
                //我的位置按鈕
                myLocationEnabled: true,
          
                //地圖手勢，當在地圖上滑動手勢優先移動google map而非父widget的SingleChildScrollView
                gestureRecognizers: {
                  Factory<OneSequenceGestureRecognizer>(
                      () => EagerGestureRecognizer())
                },
                mapType: googleMapType,
          
                //地圖上標柱為一個set，可標註多個點
                markers: _markers,
          
                //畫面初始位置
                initialCameraPosition: _myPosition,
          
                //地圖可用時回傳一個controller
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                  _googleMapController = controller;
                },
              ),
            ),
            //聊天室與輸入框
            ChatWidget(
              height: chatHeight,
              firebaseService: _firebaseService,
              senderName: _auth.currentUser!.displayName ?? "name",
              textEditingController: _msgTextFieldController,
              scrollController: _scrollController,
            ),
          ],
        ),
      ),
    );
  }

  //下拉選單，顯示目前房間內共享位置的所有人
  Widget _buildDropDownButton() {
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        focusColor: Color.fromARGB(255, 218, 190, 202),
        dropdownColor: Color.fromARGB(255, 227, 216, 241),
        style: GoogleFonts.poppins(
          color: Colors.white,
        ),
        icon: const Icon(
          Icons.location_on_rounded,
          size: 50,
          color: Colors.white,
        ),
        value: _value,
        elevation: 10,

        //設定DropdownMenuItem的屬性
        items: _usersDatas
            .map(
              (user) => DropdownMenuItem(
                value: user.id,
                child: Text(
                  user.name,
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
            .toList(),

        //改變dropdownbutton選擇的物件
        onChanged: (value) {
          setState(() {
            //value是index
            _value = value;

            //選擇_usersDatas中第幾個人
            _selectedUserData = _usersDatas[_value!];

            //改變視角
            _screenFollowUser(
                _selectedUserData!.latitude, _selectedUserData!.longitude);

            //顯示位於標註點正上方的info視窗
            _googleMapController
                .showMarkerInfoWindow(MarkerId(_usersDatas[_value!].name));
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 227, 216, 241),
      appBar: AppBar(
        title: const Text('地圖'),
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: (context),
              builder: (_) => AlertDialog(
                title: const Text('確定要離開？'),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ConnectPage()),
                          (route) => false);
                    },
                    child: const Text('確定'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('取消'),
                  )
                ],
              ),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        //在Appbar裡面的widget
        actions: [
          _buildDropDownButton(),
        ],
      ),
      body: _mainView(context),
    );
  }

  Future<void> _screenFollowUser(double latitude, double longitude) async {
    //將視角移動到所選人的位置
    await _googleMapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          bearing: 192.8334901395799,
          target: LatLng(
            latitude,
            longitude,
          ),
          tilt: 0,
          zoom: _zoom,
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (_streamController != null) {
      _streamController!.close();
    }
    _googleMapController.dispose();
    _msgTextFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
     super.initState();
    _streamController = StreamController(
      onPause: _onPauseHandler,
    );

    //初始化資料、啟動監聽程式
    _initFirebaseService().then(
      (value) => _initMyData().then(
        (value) => _updateMyPosition().then(
          (value) => Future.delayed(Duration(seconds: 1)).then((value) =>  _getAndUpdateAllUsersDataInTheRoom()),
        ),
      ),
    );

   
  }
  //上傳自己的位置
  Future _updateMyPosition() async {
    // bool serviceEnabled;
    // LocationPermission permission;
    // //檢查GPS是否開啟，若未開啟會有彈窗詢問是否要使用GPS
    // serviceEnabled = await Geolocator.isLocationServiceEnabled();
    // if (!serviceEnabled) {
    //   return Future.error('Location services are disabled.');
    // }

    // permission = await Geolocator.checkPermission();
    // if (permission == LocationPermission.denied) {
    //   permission = await Geolocator.requestPermission();
    //   if (permission == LocationPermission.denied) {
    //     return Future.error('Location permissions are denied');
    //   }
    // }

    // if (permission == LocationPermission.deniedForever) {
    //   return Future.error(
    //       'Location permissions are permanently denied, we cannot request permissions.');
    // }

    //訂閱本機經緯度改變狀態
    Geolocator.getPositionStream(locationSettings: locationSettings)
        .listen((Position? position) {
      if (mounted) {
        _myUserData?.latitude = position!.latitude;
        _myUserData?.longitude = position!.longitude;

        //將自己的位置先加到List

        setState(() {
          if (_myUserData != null) {
            _listOfMarkers.add(
              Marker(
                markerId: MarkerId(_myUserData!.uid),
                position: LatLng(_myUserData!.latitude, _myUserData!.longitude),
                //icon: _myIcon,
              ),
            );
          }
        });

        //將自己的位置上傳到firebase
        if (_myUserData != null) {
          String myUid = _auth.currentUser!.uid;
          double myLatitude = _myUserData!.latitude;
          double myLongitude = _myUserData!.longitude;
          _firebaseService.updatePosition(myUid, myLatitude, myLongitude);

          setState(() {
            //更新位置
            _myPosition = CameraPosition(
              target: LatLng(myLatitude, myLongitude),
              zoom: _zoom,
            );

            //更新標記，'將List轉乘Set
            _markers = Set<Marker>.from(_listOfMarkers);

            //將畫面跟著所選人的位置移動
            _screenFollowUser(
                _selectedUserData!.latitude, _selectedUserData!.longitude);
          });
        }
      }
    });
  }

  Future<void> _initFirebaseService() async {
    _firebaseService = FirebaseService(_roomId);
  }

  //初始化使用者初始位置
  Future<void> _initMyData() async {
    //檢查GPS是否開啟，若未開啟會有彈窗詢問是否要使用GPS
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    //取得使用者名字、uid。id暫時寫上去
    final String name = _auth.currentUser!.displayName??"None";
    final String uid = _auth.currentUser!.uid;
    const int id = 0;

    Geolocator.getCurrentPosition().then((position) {
      _myUserData = UserData(
          id: id,
          latitude: position.latitude,
          longitude: position.longitude,
          uid: uid,
          name: name );

      //預設dropdownbutton選擇的人為自己
      _selectedUserData = _myUserData;
      if (_myUserData != null) {
        String myUid = _auth.currentUser!.uid;
        double myLatitude = _myUserData!.latitude;
        double myLongitude = _myUserData!.longitude;
        _firebaseService.updatePosition(myUid, myLatitude, myLongitude);

        setState(() {
          //更新位置
          _myPosition = CameraPosition(
            target: LatLng(myLatitude, myLongitude),
            zoom: _zoom,
          );

          //更新標記，'將List轉乘Set
          _markers = Set<Marker>.from(_listOfMarkers);

          //將畫面移到自己的位置
          _screenFollowUser(
              _selectedUserData!.latitude, _selectedUserData!.longitude);
        });
      }
    });
  }

  //取得當前房間的所有使用者資訊
  void _getAndUpdateAllUsersDataInTheRoom() {
    Firebase.initializeApp().whenComplete(() {
      //從資料庫取的當前房間的使用者資訊
      FirebaseDatabase.instance
          .ref('rooms')
          .child(_roomId)
          .child('users')
          .onValue
          .listen((event) async {
        //將取得的使用者資料轉成Map
        Map data = event.snapshot.value as Map;

        //記錄前一個使用者資料
        String preSelectedUid = _selectedUserData?.uid ?? "t";
        _value != null ? preSelectedUid = _usersDatas[_value!].uid : null;

        //清除目前使用者資料
        _usersDatas.clear();

        //重新編號
        int id = 0;

        //更新目前使用者資料
        if (_myUserData != null) {
          data.forEach((key, value) {
            //計算與我的距離
            double distance = haversineDistance(
                _myUserData!.latitude ,
                _myUserData!.longitude ,
                value['latitude'] + 0.0, //轉成double
                value['longitude'] + 0.0); //轉成double

            //將距離轉換成要顯示的格式，公尺m或者公里km
            String displayDistance = "";
            if (distance > 1000.0) {
              double distanceKm = distance / 1000;
              displayDistance = "${distanceKm.toStringAsFixed(0).toString()}km";
            } else {
              displayDistance = "${distance.toStringAsFixed(1).toString()}m";
            }

            //更新使用者資料
            _usersDatas.add(
              UserData(
                //測試中uid還沒更改
                uid: value['name'],
                name: value['name'],
                id: id,
                latitude: value['latitude'] + 0.0, //+0.0: 將int 轉為double
                longitude: value['longitude'] + 0.0, //+0.0: 將int 轉為double
                distance: distance + 0.0,
                displayDistance: displayDistance,
              ),
            );

            //新增marker
            double distanceKm = distance / 1000;
            double distanceM = distance;

            _listOfMarkers.add(
              Marker(
                markerId: MarkerId(value['name']),
                position:
                    LatLng(value['latitude'] + 0.0, value['longitude'] + 0.0),

                //info視窗設定
                infoWindow: InfoWindow(
                  title: "${value['name']}",
                  snippet: distance > 1000
                      ? "${distanceKm.toStringAsFixed(2).toString()}km"
                      : "${distanceM.toStringAsFixed(1).toString()}m",
                ),
              ),
            );
            setState(() {});
            id++;
          });
        }

        if (mounted) {
          //如果有人離開或加入房間時造成下拉選單顯示順序改變，處理index順序
          for (int i = 0; i < _usersDatas.length; i++) {
            //原本選的人沒有離開，找到原本選的項目更新index
            if (_usersDatas[i].uid == preSelectedUid) {
              _value = i;
              _selectedUserData = _usersDatas[i];
              break;
            }

            //原本選擇的人離開了, 重置選擇的人
            else if (i == _usersDatas.length - 1) {
              _value = 0;
              _selectedUserData = _myUserData;
              break;
            }
          }
        }
        setState(() {
          //更新markers
          _markers = Set<Marker>.from(_listOfMarkers);
          if (_selectedUserData != null) {
            _screenFollowUser(
                _selectedUserData!.latitude, _selectedUserData!.longitude);
          }
        });
      });
    });
  }
}
