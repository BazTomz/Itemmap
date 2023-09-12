//
//  MapView.swift
//  Itemmap
//
//  Created by momoe goto on 2023/09/11.
//

import SwiftUI
import MapKit
import UIKit
import CoreLocation

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
        returnButton.backgroundColor = .white // 背景色を白に設定
        
        returnButton.frame = CGRect(x: Utils.screenWidth / 4, y: Utils.screenHeight / 4, width: 100, height: 100) // ボタンの幅と高さを設定
        returnButton.layer.cornerRadius = returnButton.frame.width / 2 // 丸い形状にするために角丸を設定
        returnButton.clipsToBounds = true // ボタンの枠外の部分をクリップ
        returnButton.setImage(UIImage(systemName: "location"), for: .normal)
        //returnButton.setTitle("現在地に戻る", for: .normal)
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
               
               // ユーザーの位置情報をクリア
               //parent.userLocation = nil
               
               // バインディングされたプロパティに変更があったことを通知
               //parent.$region.wrappedValue = parent.region
               
               parent.mapNeedsUpdate = true
               
               //uiView.setRegion(parent.region, animated: true)
           }
       }
    }
}

/*
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
*/
