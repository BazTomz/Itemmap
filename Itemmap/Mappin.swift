//
//  Mappin.swift
//  Itemmap
//
//  Created by momoe goto on 2023/09/14.
//

import SwiftUI
import MapKit

struct ItemSpot: Identifiable {
    let id: UUID
    let location: CLLocationCoordinate2D
    init(id: UUID = UUID(), lat: Double, long: Double) {
        self.id = id
        self.location = CLLocationCoordinate2D(
            latitude: lat,
            longitude: long)
    }
}

// マップマーカーの吹き出しを表示するカスタムビュー
/*
struct CalloutView: View {
    var text: String
    init(text: String) {
            self.text = text
        }
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .frame(width: 200, height: 80)
                .shadow(radius: 5)
            
            Text(text)
                .font(.body)
                .multilineTextAlignment(.center)
                .padding(8)
        }
    }
}
 */

    

struct CalloutView: View {
    
    var itemImage: Image?
    var userLocation: CLLocationCoordinate2D?
    var text: String
    var postDate: String
    
    // 住所情報を格納するプロパティ
    @State private var locationCity: String = ""
    @State private var locationName: String = ""
    
    init(text: String, itemImage: UIImage?, userLocation: CLLocationCoordinate2D?, postDate: String) {
        self.text = text
        self.itemImage = Image(uiImage: itemImage!)
        self.userLocation = userLocation
        self.postDate = postDate
    }
    
    var body: some View {
        
        
        ZStack {
            // 吹き出しの背景
            Path { path in
                let width: CGFloat = 200
                let height: CGFloat = 120
                let cornerRadius: CGFloat = 10
                let arrowHeight: CGFloat = 20
                
                // 吹き出しの形状を定義
                path.addRoundedRect(in: CGRect(x: 0, y: 0, width: width, height: height), cornerSize: CGSize(width: cornerRadius, height: cornerRadius))
                
                // 吹き出しの三角部分を追加
                path.move(to: CGPoint(x: width / 2 - arrowHeight / 2, y: height))
                path.addLine(to: CGPoint(x: width / 2, y: height + arrowHeight))
                path.addLine(to: CGPoint(x: width / 2 + arrowHeight / 2, y: height))
            }
            .fill(Color.white)
            .shadow(radius: 5)
            
            HStack (spacing: 0) {
               
                // 吹き出しの左側
                VStack (spacing: 0) {
                    
                    
                    // 位置情報を表示
                    Text("\(locationCity)\n\(locationName)")
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .padding(4)
                        .frame(width: 100)
                        .lineLimit(2)
                        //.offset(x: 0, y: itemImage != nil ? 20 : 0) // 画像がある場合は下にずらす
                    
                    
                    // 日時を表示
                    Text(postDate)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .padding(4)
                        .frame(width: 100)
                        .lineLimit(2)
                    
                    
                    // テキスト(特記事項)
                    Text(text)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .padding(4)
                        .frame(width: 100)
                        .lineLimit(3)
                    
                    
                    
                    
                }
                
                //Spacer()
                
                //吹き出しの右側
                //画像の表示
                if let itemImage = itemImage{
                    VStack {
                        //Spacer()
                        itemImage
                            .resizable()
                            .scaledToFit()
                            .frame(width: 75, height: 100) // 画像のサイズを調整
                            //.offset(x: 0, y: +30) // 画像をテキストの上に配置
                    }
                }
                
            }
            
            
            
                        
            
            
        }
        .onAppear {
            // 逆ジオコーディング
            if let userLocation = userLocation {
                reverseGeocodeLocation(userLocation)
            }
        }
    }
    
    // 緯度経度を住所に変換する関数（逆ジオコーディング）
    func reverseGeocodeLocation(_ location: CLLocationCoordinate2D) {
        let geocoder = CLGeocoder()
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)

        geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
            if let error = error {
                print("Error reverse geocoding: \(error.localizedDescription)")
                locationCity = "Error: \(error.localizedDescription)"
            } else if let placemark = placemarks?.first {
                // 住所情報を取得して表示
                print(placemark)
                if let prefecture = placemark.administrativeArea{
                    if let city = placemark.locality {
                        if let name = placemark.name {
                            locationCity = prefecture + city
                            locationName = name
                        }
                    }
                } else {
                    locationCity = "Address not found"
                }
            }
        }
    }

            
}





// プレビュー用
struct CalloutView_Previews: PreviewProvider {
    static var previews: some View {
        CalloutView(text: "吹き出しの内容", itemImage: nil, userLocation: nil, postDate: "")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}


