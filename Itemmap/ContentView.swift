//
//  ContentView.swift
//  Itemmap
//
//  Created by momoe goto on 2023/08/15.
//

import SwiftUI
import MapKit
import UIKit

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
    
    var body: some View {
        //マップのとボタン類を重ねて表示
        ZStack {
            //マップを表示・初期表示位置の設定
            MapView(initialCoordinate: CLLocationCoordinate2D(latitude: 35.0239, longitude: 135.8748))
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
    
    var initialCoordinate: CLLocationCoordinate2D
    
    //UIViewRepresentable プロトコルを準拠するために必要なメソッド①
    //UIViewを作成して返す
    func makeUIView(context: Context) -> MKMapView {
        // MKMapViewのインスタンスを作成
        let mapView = MKMapView()
        
        //MKCoordinateRegionを使用して地図の初期表示領域を設定
        let region = MKCoordinateRegion(center: initialCoordinate, latitudinalMeters: 5000, longitudinalMeters: 5000)
        mapView.setRegion(region, animated: true)
        
        // 作成したMKMapViewを返す
        return mapView
    }
    
    //UIViewRepresentable プロトコルを準拠するために必要なメソッド②
    //MKMapView（地図ビュー）が更新されるたびに実行される処理を記述する
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // ピンや線などのカスタマイズを行うこともできます
        //例えば、地図ビューにピンを追加する場合、このメソッド内でピンを追加するコードを記述します。また、地図の状態に変更があった場合に、それに応じて表示を更新する処理もここで行います。
    }
}

//プレビュー用
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
