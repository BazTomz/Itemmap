//
//  FoundItemFormView.swift
//  Itemmap
//
//  Created by momoe goto on 2023/08/22.
//

import SwiftUI

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

/*
struct FoundItemFormView_Previews: PreviewProvider {
    static var previews: some View {
        FoundItemFormView()
    }
}
*/
