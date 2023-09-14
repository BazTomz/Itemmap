//
//  LocationManager.swift
//  Itemmap
//
//  Created by momoe goto on 2023/09/11.
//

import SwiftUI
import MapKit
import CoreLocation

// 位置情報を管理する独自のクラス
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    //CLLocationManager: デバイスの位置情報を管理するためのクラス
    private var locationManager = CLLocationManager()
    
    // 監視したいプロパティ、ユーザーの現在の位置情報を格納するためのプロパティ
    //@Published: プロパティの変更が発生すると、SwiftUIのビューに自動的に通知、ビューが更新
    @Published var userLocation: CLLocationCoordinate2D?
    
    //クラスのイニシャライザ（初期化メソッド）、クラスがインスタンス化されるときに呼び出される
    override init() {
        super.init()
        //CLLocationManagerのデリゲート(あるオブジェクトが別のオブジェクトに特定のタスクやイベントの処理を委譲)をLocationManagerクラス自体に設定
        locationManager.delegate = self
        //ユーザーに位置情報の使用許可をリクエストするためのメソッド
        locationManager.requestWhenInUseAuthorization()
        //位置情報の更新を開始するためのメソッド
        //デバイスの位置情報が定期的に更新され、locationManager(_:didUpdateLocations:)メソッドが呼び出される
        locationManager.startUpdatingLocation()
    }
    
    //新しい位置情報が得られた場合に、それをuserLocationプロパティに格納してUIの更新をトリガー（引き金）するメソッド
    //manager: CLLocationManagerのインスタンスで、位置情報の更新を管理
    //locations: CLLocationオブジェクトの配列で、最新の位置情報がこの配列に含まれる、最新の位置情報は一般的に最初の要素（locations.first）に格納
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //locations配列から最初の位置情報（locations.first）を取得し、それをlocationという定数に代入
        //locations.firstがnilの場合、coordinateプロパティにアクセスする前にオプショナルチェーンを使用して安全に処理
        //もし最新の位置情報がない場合、メソッドの実行を中断し、何もせずに終了
        guard let location = locations.first?.coordinate else { return }
        //
        userLocation = location
    }
}

