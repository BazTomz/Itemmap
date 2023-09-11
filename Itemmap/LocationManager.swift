//
//  LocationManager.swift
//  Itemmap
//
//  Created by momoe goto on 2023/09/11.
//

import SwiftUI
import MapKit
import CoreLocation

// 位置情報を管理する独自のクラス
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    
    // 監視したいプロパティ
    @Published var userLocation: CLLocationCoordinate2D?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first?.coordinate else { return }
        userLocation = location
    }
}
