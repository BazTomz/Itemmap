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

// プレビュー用
struct CalloutView_Previews: PreviewProvider {
    static var previews: some View {
        CalloutView(text: "吹き出しの内容")
            .previewLayout(.sizeThatFits)
            .padding()
    }
}


