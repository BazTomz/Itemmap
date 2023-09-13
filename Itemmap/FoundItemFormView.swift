//
//  FoundItemFormView.swift
//  Itemmap
//
//  Created by momoe goto on 2023/08/22.
//

import SwiftUI
import MapKit
import CoreLocation

struct FoundItemFormView: View {
    @Binding var capturedImage: UIImage?
    @Binding var capturedLocation: CLLocationCoordinate2D?
    @Binding var capturedDate: String
    @State private var userInput: String = ""
    @State private var isMapViewActive = false
    
    // MapView に渡すプロパティ
    @State private var region: MKCoordinateRegion
    @State private var mapNeedupdate: Bool
    
    // イニシャライザで region と mapNeedsUpdate を初期化
    init(capturedImage: Binding<UIImage?>, capturedLocation: Binding<CLLocationCoordinate2D?>, capturedDate: Binding<String>) {
        // 他の初期化
        self._capturedImage = capturedImage
        self._capturedLocation = capturedLocation
        self._capturedDate = capturedDate
        
        // region と mapNeedsUpdate を初期化
        _region = State(initialValue: MKCoordinateRegion(
            center: capturedLocation.wrappedValue ?? CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
        _mapNeedupdate = State(initialValue: false)
    }
    // 画像、撮影場所、撮影日時、入力欄、「投稿」ボタンを縦に配置
    var body: some View {
        VStack {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("No Image Selected")
            }
            if let location = capturedLocation {
                Text("Location: \(location.latitude), \(location.longitude)")
            } else {
                Text("Location: Unknown")
            }
            Text("Date: \(capturedDate)")
            
            // 自由入力欄
            TextField("Enter your comments here", text: $userInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            // 投稿ボタン
            Button(action: {
                // ここでデータを投稿する処理を実行
                // 例: データを送信し、MapViewに遷移する
                isMapViewActive = true
            }) {
                Text("投稿する")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .fullScreenCover(isPresented: $isMapViewActive) {
                /* MapViewに遷移する処理を記述
                 if let capturedLocation = capturedLocation{
                 MapView(
                 //initialCoordinate: $initialCoordinate,
                 userLocation: $capturedLocation,
                 region: $region,
                 mapNeedsUpdate: $mapNeedupdate
                 )
                 .edgesIgnoringSafeArea(.all)
                 }*/
                ContentView()
                //.edgesIgnoringSafeArea(.all)
            }
            Spacer()
        }
        .padding()
    }
}
/*
struct FoundItemFormView: View {
    @Binding var capturedImage: UIImage?
    
    var body: some View {
        VStack {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Text("No Image Selected")
            }
            
            // その他のフォーム要素などをここに追加
        }
    }
}
*/
/*
struct FoundItemFormView_Previews: PreviewProvider {
    static var previews: some View {
        FoundItemFormView()
    }
}
*/
