//
//  ContentView.swift
//  Itemmap
//
//  Created by momoe goto on 2023/08/15.
//


import SwiftUI
import MapKit
//import UIKit
import CoreLocation

//ContentViewという名前のViewを定義
struct ContentView: View {
    @Binding var itemImage: UIImage?
    @Binding var itemSpot: [ItemSpot]
    @Binding var userInput: String
    @Binding var postDate: String
    @Binding var locationAddress: String

    
    //画面遷移させるかさせないかの変数
    @State private var isShowNextView = false
    //ボタンの状態の変数
    @State private var isButtonPressed = false
    // カメラの起動状態を管理
    @State private var isCameraActive = false
    // 撮影した画像を保持
    //@State private var capturedImage: UIImage? = nil
    //位置情報の更新するかどうか（現在地に戻るかどうか）※バインディング
    @State private var mapNeedupdate = false
    // 初期現在地はとりあえず瀬田
    @State private var initialCoordinate = CLLocationCoordinate2D(latitude: 35.0239, longitude: 135.8748)
    //地図表示の中心と範囲
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.0239, longitude: 135.8748),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    /*
    @State private var region = MKCoordinateRegion(
            //Mapの中心の緯度経度
            center: CLLocationCoordinate2D(latitude: 37.334900,
                                           longitude: -122.009020),
            //緯度の表示領域(m)
            latitudinalMeters: 750,
            //経度の表示領域(m)
            longitudinalMeters: 750
        )
     */
    // ユーザの現在地
    @State private var userLocation: CLLocationCoordinate2D?
    // 位置情報マネージャーをオブザーバブルオブジェクトとして管理
    @ObservedObject var locationManager = LocationManager()
    //撮影日時
    //@State private var capturedDate: Date = Date()
    /*マップピンの場所指定
    let spotList = [
        ItemSpot(lat: 37.334900, long: -122.009020),
        ItemSpot(lat: 35.658674, long: 139.7462316),
        ItemSpot(lat: 35.658404, long: 139.744809)
    ]
    */
  //ユーザーの現在地追跡
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    //現在地領域を表示
    private func updateMapToUserLocation() {
        if let userLocation = locationManager.userLocation {
            region = MKCoordinateRegion(
                center: userLocation,
                latitudinalMeters: 750,
                longitudinalMeters: 750
            )
        }
    }
    //吹き出し
    @State private var showCallout = false
    
    var body: some View {
        //マップのとボタン類を重ねて表示
        ZStack {
            //全体の背景色
            //Color.white
            // セーフエリアを無視して背景色を設定
            //.edgesIgnoringSafeArea(.all)
            
            VStack{
                // スペースを追加して上部にスペースを設ける
                //Spacer()
                // 適切な高さに調整
                //   .frame(height: Utils.screenHeight * 0.01)
                ZStack{
                    Map(coordinateRegion: $region,
                        //Mapの操作の指定
                        //.pan: ドラッグ操作の許可
                        //.zoom: ピンチ操作の許可
                        //.all: 上記2つを許可
                        interactionModes: .all,
                        //現在地の表示
                        showsUserLocation: true,
                        //ユーザーの現在地追跡
                        userTrackingMode: $userTrackingMode,
                        //マーカの指定
                        annotationItems: itemSpot,
                        annotationContent: {spot in
                        MapAnnotation(coordinate: spot.location) {
                            ZStack{
                                Path { path in
                                    //円の半径
                                    let radius = Utils.annotationSize / 2
                                    let centerX = Utils.annotationImageSize / 2
                                    let arrowHeight = radius * 1.3
                                    let centerY = Utils.annotationImageSize / 2
                                    
                                    // 円を描画
                                    path.addArc(
                                        center: CGPoint(x: centerX, y: centerY),
                                        radius: radius,
                                        startAngle: Angle(degrees: 50),
                                        endAngle: Angle(degrees: -230),
                                        // 円形の描画方向(時計回りならtrue)
                                        clockwise: true
                                    )
                                    // 逆三角形を描画
                                    path.addLine(to: CGPoint(x: centerX, y: centerY + arrowHeight))
                                    path.closeSubpath()
                                }
                                .fill(Color.forthColor)
                                .shadow(radius: 5)
                                /*
                                Circle ()
                                    .frame (width: 45)
                                    .foregroundColor(Color.customKeyColor)
                                    .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                                 */
                                if let uiImage = itemImage {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                    //.scaledToFit()
                                    // 画像のサイズを調整
                                        .frame(width: Utils.annotationImageSize, height: Utils.annotationImageSize)
                                    // 円形にトリミング
                                        .clipShape(Circle())
                                    //.foregroundColor(Color(UIColor.systemBackground))
                                    //.padding()
                                    //.background(Color.orange.cornerRadius(90))
                                        .onTapGesture{
                                            //吹き出し処理
                                            showCallout = true
                                        }
                                    }
                                if showCallout {
                                    if let itemImage = itemImage{
                                        CalloutView(text: userInput, itemImage: itemImage, userLocation: locationManager.userLocation, postDate: postDate, itemAddress: locationAddress)
                                        //前面に表示
                                            .zIndex(1)
                                        //吹き出しの位置を調整
                                            .offset(y: -1 *  (Utils.calloutHeight) )
                                    }
                                }
                                }
                        }
                        })
                        .edgesIgnoringSafeArea(.all)
                    //onAppear: Viewが初めて描画されるタイミングで呼ばれるコールバックメソッド
                    //現在地の領域を表示
                    .onAppear{
                        updateMapToUserLocation()
                    }
                    /*
                    //マップを表示・初期表示位置の設定
                    MapView(
                        initialCoordinate: $initialCoordinate,
                        userLocation: $locationManager.userLocation,
                        region: $region,
                        mapNeedsUpdate: $mapNeedupdate
                    )
                    .edgesIgnoringSafeArea(.all)
                    
                    //.frame(width:Utils.screenWidth, height: Utils.screenHeight * 0.8)
                     */
                    HStack{
                        Spacer()
                        VStack{
                            Button(action: {
                                //ここにアクションを追加
                                //mapNeedsUpdateというバインディングを介してMapViewのupdateUIView関数を呼び出す
                                //mapNeedupdate = true
                                //ContentView()
                                updateMapToUserLocation()
                            }){
                                //ボタンの表示
                                ZStack {
                                    Circle()
                                    //塗りつぶし
                                        .fill(Color.firstColor)
                                    //ボタンサイズ
                                        .frame(width: Utils.buttonsize)
                                        .padding(10)
                                    Image(systemName:"location")
                                        .font(.system(size: Utils.screenWidth * 0.15 * 0.3, weight: .bold))
                                        .foregroundColor(Color.secondColor)
                                        .padding()
                                }
                            }
                            //ボタンに影をつける
                            //opacity: 透明度（0~1）
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                            
                            Spacer()
                        }
                    }
                    VStack{
                        Spacer()
                        // +ボタンの配置と押下時のアクション
                        Button(action: {
                            //bool値を反転（トグル）
                            isButtonPressed.toggle()
                            isShowNextView = true
                            isCameraActive = true
                        }) {
                            //ボタンの表示
                            ZStack {
                                Circle()
                                //塗りつぶし
                                    .fill(Color.forthColor)
                                //ボタンサイズ
                                    .frame(width: Utils.buttonsize * 1.1)
                                /*
                                 //円の外周の枠線
                                 .overlay(
                                 Circle()
                                 //枠線の色と幅を指定
                                 .strokeBorder(Color.thirdColor, lineWidth: Utils.screenWidth * 0.15 * 0.05)
                                 )
                                 */
                                //ボタンにSFSymbols画像の表示
                                Image(systemName:"plus")
                                    .font(.system(size: Utils.screenWidth * 0.15 * 0.3, weight: .bold))
                                    .foregroundColor(Color.secondColor)
                                    .padding()
                            }
                        }
                         //ボタンに影をつける
                         .shadow(color: Color.forthColor.opacity(0.2), radius: 5, x: 0, y: 5)
                         
                        //カメラを起動
                        //.sheetモディファイア:ビューのシート表示, 引数としてisPresentedを取る
                        //isShowNextViewの値が trueのとき、指定された CameraCaptureViewがシートとして表示される
                        //CameraCaptureViewにisActiveとcapturedImageという2つのバインディングを引数として渡す
                        //userLocation（撮影場所）, capturedData（撮影日時） という2つのバインディングも追加（投稿画面作成時に追加）
                        .fullScreenCover(isPresented: $isShowNextView) {
                            //CameraCaptureView(isActive: $isCameraActive, capturedImage: $capturedImage, userLocation: $locationManager.userLocation, capturedDate: capturedDate)
                            //CameraCaptureView(isActive: $isCameraActive, capturedImage: $capturedImage, userLocation: $locationManager.userLocation)
                            CameraCaptureView(isActive: $isCameraActive, userLocation: $locationManager.userLocation)
                                .edgesIgnoringSafeArea(.all)
                        }
                    }
                }
            }
        }
    }
                        
                    }
                    
//プレビュー用
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(itemImage: .constant(nil), itemSpot: .constant([]), userInput: .constant(""), postDate: .constant(""), locationAddress: .constant(""))
    }
}
