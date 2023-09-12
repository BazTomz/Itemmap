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
            //全体の背景色
            Color.white
            // セーフエリアを無視して背景色を設定
            .edgesIgnoringSafeArea(.all)
                
            VStack{
                // スペースを追加して上部にスペースを設ける
                Spacer()
                    .frame(height: 20) // 適切な高さに調整
                //マップを表示・初期表示位置の設定
                MapView(
                    initialCoordinate: $initialCoordinate,
                    userLocation: $locationManager.userLocation,
                    region: $region,
                    mapNeedsUpdate: $mapNeedupdate
                )
                //.edgesIgnoringSafeArea(.all)
                
                ZStack{
                    // 下部のスペース
                    Rectangle()
                        .fill(Color.clear) // 赤い背景色を設定
                        .frame(height: 50) // 適切な高さに調整
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
                                .fill(Color.black)
                            //ボタンサイズ
                                .frame(width: 70, height: 70)
                            //円の外周の枠線
                                .overlay(
                                    Circle()
                                    //枠線の色と幅を指定
                                        .strokeBorder(Color.white, lineWidth: 3)
                                )
                            //ボタンにSFSymbols画像の表示
                            Image(systemName:"plus")
                                .font(.system(size: 20))
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
}

//プレビュー用
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
