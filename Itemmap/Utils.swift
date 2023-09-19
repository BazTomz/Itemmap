//
//  Utils.swift
//  Itemmap
//
//  Created by momoe goto on 2023/09/11.
//
/*
基本情報をまとめておく
使う時は、
 import Itemmap.Utils するか、
 Utils.変数（定数）名で使う
*/

import SwiftUI

struct Utils {
    //スクリーンサイズ
    static let screenWidth = UIScreen.main.bounds.width
    static let screenHeight = UIScreen.main.bounds.height
    //ボタンサイズ
    static let buttonsize = screenWidth * 0.15
    //吹き出しサイズ
    static let calloutWidth = screenWidth * 0.5
    static let calloutHeight = calloutWidth * 0.6
    //mapannotationサイズ
    static let annotationSize = screenWidth * 0.13
    static let annotationImageSize = annotationSize * 0.9
}

