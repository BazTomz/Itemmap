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
    //@Binding var capturedDate: String
    //@Binding var capturedDate: Date
    @State var capturedDate: Date = Date()
    @State private var userInput: String = ""
    @State private var isMapViewActive = false
    // 住所情報を格納するプロパティ
    @State private var locationAddress: String = ""
    //日時を格納するプロパティ
    @State private var postDate: String = ""
    
    // MapView に渡すプロパティ
    @State private var region: MKCoordinateRegion
    @State private var mapNeedupdate: Bool
    
    @State private var itemSpot: [ItemSpot] = []
    
    // イニシャライザで region と mapNeedsUpdate を初期化
    //init(capturedImage: Binding<UIImage?>, capturedLocation: Binding<CLLocationCoordinate2D?>, capturedDate: Binding<Date>) {
    init(capturedImage: Binding<UIImage?>, capturedLocation: Binding<CLLocationCoordinate2D?>) {
        // 他の初期化
        self._capturedImage = capturedImage
        self._capturedLocation = capturedLocation
        //self._capturedDate = capturedDate
        
        // region と mapNeedsUpdate を初期化
        _region = State(initialValue: MKCoordinateRegion(
            center: capturedLocation.wrappedValue ?? CLLocationCoordinate2D(latitude: 0, longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        ))
        _mapNeedupdate = State(initialValue: false)
    }
    // DateFormatterを作成
   let dateFormatter: DateFormatter = {
       let formatter = DateFormatter()
       formatter.dateFormat = "yyyy年MM月dd日 HH時mm分"
       //formatter.dateFormat = "yyyy/MM/dd　HH:mm"
       return formatter
   }()
    // 画像、撮影場所、撮影日時、入力欄、「投稿」ボタンを縦に配置
    var body: some View {
        NavigationView {
            //左揃え
            VStack(alignment: .leading){
                //Text("日時: \(capturedDate)")
                //Text("日時　\(dateFormatter.string(from: capturedDate))")
                Text("日時　\(postDate)")
                
                if !locationAddress.isEmpty {
                    Text("場所　\(locationAddress)")
                } else {
                    Text("場所　Unknown")
                }
                Spacer()
                // 自由記入欄
                //Text("特徴や特記事項など")
                TextField("特徴や特記事項など\n例: 近くの柵にかけておきました", text: $userInput, axis: .vertical)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    //.textFieldStyle(PlainTextFieldStyle())
                    //.frame(minHeight: 100)
                    .padding()

                //TextEditor(text: $userInput)
                
                
                if let image = capturedImage {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                } else {
                    Text("No Image Selected")
                }

                // 投稿ボタン
                Button(action: {
                    // ここでデータを投稿する処理を実行
                    // 例: データを送信し、MapViewに遷移する
                    //isMapViewActive = true
                    
                    //アニメーションの無効化
                    var transaction = Transaction()
                    transaction.disablesAnimations = true
                    withTransaction(transaction) {
                        isMapViewActive = true
                    }
                }) {
                    Text("投稿する")
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(15)
                }
                .fullScreenCover(isPresented: $isMapViewActive) {
                    //ContentView(itemImage: $capturedImage, itemLocation: $capturedLocation)
                    ContentView(itemImage: $capturedImage, itemSpot: $itemSpot, userInput: $userInput, postDate: $postDate, locationAddress: $locationAddress)
                        .onAppear{
                            // capturedLocationがnilでない場合に、itemSpotに新しいItemSpotオブジェクトを追加
                            if let location = capturedLocation {
                                itemSpot.append(ItemSpot(lat: location.latitude, long: location.longitude))
                            }
                        }
                }
                Spacer()
            }
            .padding()
            .onAppear {
                postDate = dateFormatter.string(from: capturedDate)
                if let location = capturedLocation {
                    reverseGeocodeLocation(location)
                }
            }
            .navigationBarTitle("落とし物投稿フォーム", displayMode: .inline)
        }
    }
    // 緯度経度を住所に変換する関数（逆ジオコーディング）
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
                if let prefecture = placemark.administrativeArea{
                    if let city = placemark.locality {
                        if let name = placemark.name {
                            locationAddress = prefecture + city + name
                        }
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
