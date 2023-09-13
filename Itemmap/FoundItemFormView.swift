import SwiftUI
import CoreLocation

struct FoundItemFormView: View {
    @Binding var capturedImage: UIImage?
    @Binding var capturedLocation: CLLocationCoordinate2D?
    @Binding var capturedDate: String
    
    @State private var userInput: String = ""
    @State private var isMapViewActive = false
    @State private var locationAddress: String = "" // 住所情報を格納するプロパティ

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
