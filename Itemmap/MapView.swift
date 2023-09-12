//
//  MapView.swift
//  Itemmap
//
//  Created by momoe goto on 2023/09/11.
//

// commit仮

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
        // 作成したMKMapViewを返す
        return mapView
    }
    
    //UIViewRepresentable プロトコルを準拠するために必要なメソッド②
    //MKMapView（地図ビュー）が更新されるたびに実行される処理を記述する
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // ピンや線などのカスタマイズを行うこともできます
        //例えば、地図ビューにピンを追加する場合、このメソッド内でピンを追加するコードを記述します。また、地図の状態に変更があった場合に、それに応じて表示を更新する処理もここで行います。
        
        if mapNeedsUpdate {
            // ユーザーの現在地を中心にした表示領域を設定
            if let userLocation = userLocation {
                let newRegion = MKCoordinateRegion(
                    center: userLocation,
                    span: MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
                )
                uiView.setRegion(newRegion, animated: true)
            }
            // 地図の更新が完了したらmapNeedsUpdateをfalseにリセット
            //DispatchQueue.main.async: メインスレッド（UIスレッド）で非同期に実行（→利点はGPTが教えてくれる）
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
       
       init(_ parent: MapView) {
           self.parent = parent
       }
       // 他の地図関連のイベントハンドリングを追加できます
    }
}
/*
struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView()
    }
}
*/
