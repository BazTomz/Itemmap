//
//  ItemmapApp.swift
//  Itemmap
//
//  Created by momoe goto on 2023/08/15.
//

import SwiftUI

@main
struct ItemmapApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(itemImage: .constant(nil), itemSpot: .constant([]), userInput: .constant(""), postDate: .constant(""), locationAddress: .constant(""))
        }
    }
}
