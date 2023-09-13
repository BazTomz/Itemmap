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
    // 住所情報を格納するプロパティ
    @State private var locationAddress: String = ""
    
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
        NavigationView {
            VStack {
                if let image = capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("No Image Selected")
                }
                
                if !locationAddress.isEmpty {
                    Text("Location: \(locationAddress)")
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
                    ContentView()
                }
                Spacer()
            }
            .padding()
            .onAppear {
                if let location = capturedLocation {
                    reverseGeocodeLocation(location)
                }
            }
            .navigationBarTitle("Item Details", displayMode: .inline)
        }
    }
    // 緯度経度を住所に変換する関数
    func reverseGeocodeLocation(_ location: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error reverse geocoding: \(error.localizedDescription)")
                locationAddress = "Error: \(error.localizedDescription)"
            } else if let placemark = placemarks?.first {
                // 住所情報を取得して表示
                
                print(placemark)
                if let city = placemark.locality {
                    if let name = placemark.name {
                        locationAddress = city + name
                    }
                } else {
                    locationAddress = "Address not found"
                }
            }
        }
    }
}
/*
struct FoundItemFormView_Previews: PreviewProvider {
    static var previews: some View {
        FoundItemFormView()
    }
}
*/
