//
//  ContentView.swift
//  Itemmap
//
//  Created by momoe goto on 2023/08/15.
//

import SwiftUI
import MapKit
import UIKit
import CoreLocation

//ContentViewという名前のViewを定義
struct ContentView: View {
    //画面遷移させるかさせないかの変数
    @State private var isShowNextView = false
    //ボタンの状態の変数
    @State private var isButtonPressed = false
    // カメラの起動状態を管理
    @State private var isCameraActive = false
    // 撮影した画像を保持
    @State private var capturedImage: UIImage? = nil
    
    //位置情報関連
    @State private var mapNeedupdate = false
    // 初期現在地はとりあえず瀬田
    @State private var initialCoordinate = CLLocationCoordinate2D(latitude: 35.0239, longitude: 135.8748)
    //地図表示の中心と範囲
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 35.0239, longitude: 135.8748),
        span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
    )
    // ユーザの現在地
    @State private var userLocation: CLLocationCoordinate2D?
    // 位置情報マネージャーをオブザーバブルオブジェクトとして管理
    @ObservedObject var locationManager = LocationManager()
    
    var body: some View {
        //マップのとボタン類を重ねて表示
        ZStack {
            //マップを表示・初期表示位置の設定
            MapView(
                initialCoordinate: $initialCoordinate,
                userLocation: $locationManager.userLocation,
                region: $region,
                mapNeedsUpdate: $mapNeedupdate
            )
                .edgesIgnoringSafeArea(.all)
            
            //ボタンを下部に配置
            VStack {
                // 700ポイントの高さのスペース
                Spacer()
                    .frame(height:700)
                
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
                            .fill(Color.pink)
                        //円の外周の枠線
                            .overlay(
                                Circle()
                                //枠線の色と幅を指定
                                    .strokeBorder(Color.white, lineWidth: 3)
                            )
                        //ボタンにSFSymbols画像の表示
                        Image(systemName:"mappin")
                            .font(.system(size: 30))
                            .foregroundColor(.white)
                            .padding()
                    }
                }
                //ボタンに影をつける
                .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 5)
                
                //カメラを起動
                //.sheetモディファイア:ビューのシート表示, 引数としてisPresentedを取る
                //isShowNextViewの値が trueのとき、指定された CameraCaptureViewがシートとして表示される
                //CameraCaptureViewにisActiveとcapturedImageという2つのバインディングを引数として渡す
                .sheet(isPresented: $isShowNextView) {
                    CameraCaptureView(isActive: $isCameraActive, capturedImage: $capturedImage)
                }
            }
        }
    }
}
//UIViewRepresentable プロトコル
//SwiftUIにおいてUIKitのUIViewをラップし、SwiftUI内で利用できるようにするためのプロトコル
//MapViewはSwiftUI内でUIKitのUIViewをラップするためのカスタムView
struct MapView: UIViewRepresentable{
    /*
    var initialCoordinate: CLLocationCoordinate2D
     */
    @Binding var initialCoordinate: CLLocationCoordinate2D
    // 現在のユーザーの位置をバインディング
    @Binding var userLocation: CLLocationCoordinate2D?
    // 地図の表示領域をバインディング
    @Binding var region: MKCoordinateRegion
    // 地図の更新をトリガーするためのプロパティ
    @Binding var mapNeedsUpdate: Bool
    
    //UIViewRepresentable プロトコルを準拠するために必要なメソッド①
    //UIViewを作成して返す
    //func 関数名(引数名:引数の型)　->　関数が返す値の型　{処理}
    func makeUIView(context: Context) -> MKMapView {
        print("map is made")
        print(userLocation)
        // MKMapViewのインスタンスを作成
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        // ユーザーの現在位置を表示
        mapView.showsUserLocation = true
        
        if let userLocation = userLocation {
            // 現在地を中心とした表示領域を設定
            let region = MKCoordinateRegion(
                center: userLocation,
                span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
            )
            mapView.setRegion(region, animated: true)
        }
        
        // 「現在地に戻る」ボタンを作成
        let returnButton = UIButton(type: .system)
        returnButton.setTitle("現在地に戻る", for: .normal)
        returnButton.addTarget(context.coordinator, action: #selector(Coordinator.returnToUserLocation), for: .touchDown)
        
        // ボタンをマップビューの上に配置
        mapView.addSubview(returnButton)
        returnButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            returnButton.topAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.topAnchor, constant: 16),
            returnButton.trailingAnchor.constraint(equalTo: mapView.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])

        /*
        //MKCoordinateRegionを使用して地図の初期表示領域を設定
        let region = MKCoordinateRegion(center: initialCoordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
        */
        // 作成したMKMapViewを返す
        return mapView
    }
    
    //UIViewRepresentable プロトコルを準拠するために必要なメソッド②
    //MKMapView（地図ビュー）が更新されるたびに実行される処理を記述する
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // ピンや線などのカスタマイズを行うこともできます
        //例えば、地図ビューにピンを追加する場合、このメソッド内でピンを追加するコードを記述します。また、地図の状態に変更があった場合に、それに応じて表示を更新する処理もここで行います。
        print("updated")
        print(region)
        print(mapNeedsUpdate)
        print("userlocation is, ", userLocation)
        print("initial coordinate is, ", initialCoordinate)
        
        if mapNeedsUpdate {
            // 現在地を中心にした表示領域を設定
            if let userLocation = userLocation {
                let newRegion = MKCoordinateRegion(
                    center: userLocation,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )
                uiView.setRegion(newRegion, animated: true)
            }
            // 地図の更新が完了したらmapNeedsUpdateをリセット
            DispatchQueue.main.async {
                mapNeedsUpdate = false
            }
        }
    }
    func makeCoordinator() -> Coordinator {
           Coordinator(self)
    }
}


class Coordinator: NSObject, MKMapViewDelegate {
   var parent: MapView
   
   var previousUserLocation: CLLocationCoordinate2D? // 以前のユーザーの位置を保持
   
   init(_ parent: MapView) {
       self.parent = parent
   }

   // 他の地図関連のイベントハンドリングを追加できます

   // 「現在地に戻る」ボタンのアクションを処理
   @objc func returnToUserLocation() {
       print("touched")
       if let userLocation = parent.userLocation {
           print("yes")
           print(userLocation)
           parent.region.center = userLocation
           parent.region.span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
           
           print(parent.region)
           
           
           //parent.userLocation = nil // ユーザーの位置情報をクリア
           
           // バインディングされたプロパティに変更があったことを通知
           //parent.$region.wrappedValue = parent.region
           
           parent.mapNeedsUpdate = true
           
           //uiView.setRegion(parent.region, animated: true)
       }
   }
}


//プレビュー用
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
