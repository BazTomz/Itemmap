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
struct CalloutView: View {

    var itemImage: Image?
    var userLocation: CLLocationCoordinate2D?
    var text: String
    var postDate: String
    
    //locationAddressを渡す
    var itemAddress: String

    // 住所情報を格納するプロパティ
    @State private var locationCity: String = ""
    @State private var locationName: String = ""

    init(text: String, itemImage: UIImage?, userLocation: CLLocationCoordinate2D?, postDate: String, itemAddress: String) {
        self.text = text
        self.itemImage = Image(uiImage: itemImage!)
        self.userLocation = userLocation
        self.postDate = postDate
        self.itemAddress = itemAddress
    }
    
    var body: some View {
        ZStack {
            // 吹き出しの背景
            Path { path in
                let width: CGFloat = Utils.calloutWidth
                let height: CGFloat = Utils.calloutHeight
                let cornerRadius: CGFloat = 10
                let arrowHeight: CGFloat = height * 0.15

                // 吹き出しの形状を定義
                path.move(to: CGPoint(x: cornerRadius, y: 0))
                path.addLine(to: CGPoint(x: width - cornerRadius, y: 0))
                path.addArc(center: CGPoint(x: width - cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: -90), endAngle: Angle(degrees: 0), clockwise: false)
                path.addLine(to: CGPoint(x: width, y: height - cornerRadius))
                path.addArc(center: CGPoint(x: width - cornerRadius, y: height - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 0), endAngle: Angle(degrees: 90), clockwise: false)
                path.addLine(to: CGPoint(x: width / 2 + arrowHeight / 2, y: height))
                path.addLine(to: CGPoint(x: width / 2, y: height + arrowHeight))
                path.addLine(to: CGPoint(x: width / 2 - arrowHeight / 2, y: height))
                path.addLine(to: CGPoint(x: 0, y: height))
                path.addArc(center: CGPoint(x: cornerRadius, y: height - cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 90), endAngle: Angle(degrees: 180), clockwise: false)
                path.addLine(to: CGPoint(x: 0, y: 0))
                path.addArc(center: CGPoint(x: cornerRadius, y: cornerRadius), radius: cornerRadius, startAngle: Angle(degrees: 180), endAngle: Angle(degrees: 270), clockwise: false)
                path.closeSubpath()
                
            }
            .fill(Color.firstColor)
            .shadow(radius: 5)

            //HStack(spacing: 0){
            HStack(){
                //吹き出し右側に情報の表示
                VStack (alignment: .leading) {
                    // 日時を表示
                    Text(postDate)
                        .font(.caption2)
                        .foregroundColor(Color.secondColor)
                        //.font(Font.custom("Avenir-Roman", size: 24))
                        //.font(Font.custom("Courier", size: 10))
                        .multilineTextAlignment(.leading)
                        .padding(4)
                        .frame(width: Utils.calloutWidth * 0.5)
                    //テキストの行数の制限,テキストが指定された行数に収まらない場合、テキストは省略記号（"..."）で切り詰められる
                        .lineLimit(2)
                    // 位置情報を表示
                    Text(itemAddress)
                        .font(.caption)
                        .fontWeight(.medium)
                        .foregroundColor(Color.forthColor)
                        .multilineTextAlignment(.leading)
                        .padding(4)
                        //.frame(width: 100)
                        .frame(width: Utils.calloutWidth * 0.5)
                        .lineLimit(2)
                        //copyable まだうまくいってない！
                        .textSelection(.enabled)
                    // テキスト(特記事項)
                    //Text("コメント:")
                    //   .font(.caption2)
                    Text(text)
                        .font(.caption)
                        .multilineTextAlignment(.leading)
                        .padding(4)
                        //.frame(width: 100)
                        .frame(width: Utils.calloutWidth * 0.5)
                        .lineLimit(3)
                }
                //吹き出し左側に画像を表示
                //画像の表示
                if let itemImage = itemImage{
                    itemImage
                        .resizable()
                        .scaledToFit()
                        .frame(height: Utils.calloutHeight * 0.9) // 画像のサイズを調整
                        .cornerRadius(10)
                        //.padding(.top, (Utils.calloutHeight - Utils.calloutHeight * 0.9) / 2)
                        //.padding(.leading, (Utils.calloutHeight - Utils.calloutHeight * 0.9) / 2)
                        .padding(.all, (Utils.calloutHeight - Utils.calloutHeight * 0.9) / 2)
                    //.offset(x: 0, y: +30) // 画像をテキストの上に配置
                }

            }
            }
        .onAppear {
            /*
            // 逆ジオコーディング
            if let userLocation = userLocation {
                reverseGeocodeLocation(userLocation)
            }
             */
        }
    }
}
/*
// プレビュー用
struct CalloutView_Previews: PreviewProvider {
    static var previews: some View {
        CalloutView(text: "吹き出しの内容", itemImage: nil, userLocation: nil, postDate: "")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
*/
