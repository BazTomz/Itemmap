//
//  CameraCaptureView.swift
//  Itemmap
//
//  Created by momoe goto on 2023/08/22.
//
import SwiftUI
import UIKit
import Photos   //投稿画面作成時に追加

extension UIImage {

    func resize(targetSize: CGSize) -> UIImage {
        return UIGraphicsImageRenderer(size:targetSize).image { _ in
            self.draw(in: CGRect(origin: .zero, size: targetSize))
        }
    }

}


//CameraCaptureView という名前の UIViewControllerRepresentable プロトコルに準拠する構造体を宣言
struct CameraCaptureView: UIViewControllerRepresentable {
    //カメラキャプチャビューがアクティブかどうかを管理
    @Binding var isActive: Bool
    //カメラで撮影された画像を保持
    //UIImage?:UIImage(画像データを表すクラス)型の値を持つか、もしくは nil を持つ可能性を持つ型
    //UIImage は画像データを表すクラスであり、UIImage? 型はその画像データが存在するかどうかを示す
    //①capturedImage に画像データが存在する場合:UIImage型の有効なインスタンスが格納
    //②capturedImage が nil の場合:画像データが存在しないことを示すためnil が格納
    //@Binding var capturedImage: UIImage?
    @State private var capturedImage: UIImage? = nil
    
    // 投稿画面作成時に追加した2つのデータ
    @Binding var userLocation: CLLocationCoordinate2D?
        //@State var capturedDate: String
        //Date型に変更
    //@State var capturedDate: Date
    
    //Coordinator クラスの定義
    //NSObject: Swift のクラスであることを示す基本的なプロトコル
    //UINavigationControllerDelegate: UIKit フレームワークによって提供されるプロトコル、ナビゲーションコントローラのイベントや状態の変更をハンドリングするためのメソッドを定義、カメラキャプチャ画面のナビゲーションに関連する処理に使用
    //UIImagePickerControllerDelegate: UIKit フレームワークによって提供されるプロトコル、イメージピッカーコントローラのイベントや状態の変更をハンドリングするためのメソッドを定義、カメラやフォトライブラリから画像を取得する処理に関連する処理に使用
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        
        //let: 定数の定義
        //parentという名前のプロパティを定義
        //CameraCaptureView のインスタンスを保持
        //親ビューへのアクセスを可能にするため
        let parent: CameraCaptureView
        
        //Coordinator クラスのイニシャライザ（Coordinator クラスのインスタンスを初期化する際に呼び出される）
        //parent プロパティを受け取る
        init(_ parent: CameraCaptureView) {
            self.parent = parent
        }
        
        // カメラキャプチャ完了時の処理
        //func: 関数宣言
        //infoパラメータ: didFinishPickingMediaWithInfo メソッドのパラメータ、画像に関する情報が辞書形式で渡される
        //辞書内のキー（InfoKey 列挙型の要素）を使って画像に関連する情報にアクセス
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            //撮影日時取得
            //parent.capturedDate = Date()
            /*
            //投稿画面作成時に追加⇩ここから
            // 撮影時に得られるデータから撮影日時を抜き出す
            if let metadata = info[.mediaMetadata] as? [String: Any] {
                if let tiffInfo = metadata["{TIFF}"] as? [String: Any],
                   let dateTimeOriginal = tiffInfo["DateTime"] as? Date {
                    parent.capturedDate = dateTimeOriginal
                }
            }
            //⇧ここまで
            */
            //辞書から .originalImage（撮影された元の画像データを含むオブジェクト）キーに対応する値を取り出し
            //'as? 変換したい型'でキャスト（型変換）、オプショナル型を使用した安全なキャストを行う、キャスト成功→変換された値が代入、キャスト失敗→nil が代入
            //取り出した値を UIImage 型にダウンキャスト
            //info[.originalImage] の値が UIImage 型ではなく、キャストできない別の型だった場合、キャストは失敗し、image には nil が代入、このような場合でも、プログラムはクラッシュせずに進行する
            if let image = info[.originalImage] as? UIImage {
                //画像を保存（撮影された画像データを capturedImage プロパティに保持）
                //parent.capturedImage = image
                parent.capturedImage = image.resize(targetSize: CGSize(width: image.size.width / 10, height: image.size.height / 10))
                /*
                if let jpegData = image.jpegData(compressionQuality: 0.0) {
                        // JPEGデータを保存（圧縮品質0.5）
                        parent.capturedImage = UIImage(data: jpegData)
                }
                 */
            }
            
            //parent:親ビューである CameraCaptureView インスタンスへの参照、Coordinator クラス内で CameraCaptureView のプロパティやメソッドにアクセスできる
            //カメラキャプチャが完了しfalseに変更
            parent.isActive = false
            
            // 写真を使用ボタンが押されたら、FoundItemFormView に遷移する
            // 写真、撮影場所、撮影日時をバインディング（投稿画面作成時に追加）
            //let viewController = UIHostingController(rootView: FoundItemFormView(capturedImage: parent.$capturedImage, capturedLocation: parent.$userLocation, capturedDate: parent.$capturedDate))
            //写真、撮影場所をバインディング            
            let viewController = UIHostingController(rootView: FoundItemFormView(capturedImage: parent.$capturedImage, capturedLocation: parent.$userLocation))
            viewController.modalPresentationStyle = .fullScreen
            picker.present(viewController, animated: true, completion: nil)
        }
        // キャンセル時の処理
        //Swiftの関数では通常外部引数名（関数呼び出し時に使われる名前）と内部引数名（関数内で使われる名前）を指定する
        //『func 関数名（外部引数名 内部引数名: データ型）』で定義、関数を呼び出す際は『関数名（外部引数名: 値）』
                //(例)func Square(width x: Int, height y: Int)
                //      print(x * y)
                //    }
                //の時、Square(width: 10, height: 20)で呼び出し。
        //'_(アンダースコア）': 引数の外部引数名を省略
                //(例)func Square(_ x: Int, _ y: Int)
                //      print(x * y)
                //    }
                //の時、Square(10, 20)で呼び出し。
        //picker: 引数の内部引数名、UIImagePickerController 型のオブジェクトを受け取る
                //(例)imagePickerController(myPickerController)等で呼び出し、myPickerController という UIImagePickerController 型のオブジェクトを引数として渡している
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            //カメラキャプチャのキャンセルを示す
            parent.isActive = false
            //キャプチャした画像をクリア
            parent.capturedImage = nil
            
            //カメラキャプチャ画面を閉じるために、親ビューコントローラに対して dismiss メソッドを呼び出し
            //picker.presentingViewController （:カメラキャプチャ画面を表示している親のビューコントローラを取得）の値が存在する場合、
            if let presentingController =
                picker.presentingViewController {
                //カメラキャプチャ画面を閉じる
                //dismiss(animated:completion:) メソッド
                //animated: trueの場合、画面がアニメーションとともに閉じられる
                //completion: 閉じる処理が完了した後に実行するクロージャを指定可
                presentingController.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    //UIViewControllerRepresentable プロトコルを適合させるために必要
    // Coordinator インスタンスを作成
    //CameraCaptureView のインスタンスに対して Coordinator クラスのインスタンスを作成するためのメソッド
    //CameraCaptureView と Coordinator の連携が確立され、カメラキャプチャ画面の操作とデータの受け渡しがスムーズに行えるようになる
    //makeCoordinator(): Coordinator クラスのインスタンスを生成して返す役割
    func makeCoordinator() -> Coordinator {
        //self: CameraCaptureView 自体を指す
        Coordinator(self)
    }
    
    //UIViewControllerRepresentable プロトコルを適合させるために必要
    // UIViewController のインスタンスを生成して返す
    //context パラメータ: Context 型の情報を提供し、必要なコンテキスト情報を取得する
    //CameraCaptureView が UIKit の UIImagePickerController を利用してカメラキャプチャ画面を表示し、操作を処理できるようになる
    func makeUIViewController(context: Context) -> UIImagePickerController {
        //新しい UIImagePickerController オブジェクトを作成、カメラキャプチャ画面を表示するためのコントローラ
        let picker = UIImagePickerController()
        //.camera:カメラを起動
        //picker の sourceType プロパティを .camera に設定
        picker.sourceType = .camera
        //picker の delegate プロパティに context.coordinator を設定
        //これにより、カメラキャプチャ画面の操作や写真の選択時に Coordinator クラスのメソッドが呼び出され、デリゲートパターンを活用して処理が行われる
        picker.delegate = context.coordinator
        //構成した picker オブジェクトをこのメソッドの戻り値として返す
        //これにより、SwiftUI はカメラキャプチャ画面を表示するためにこの UIImagePickerController を使用
        return picker
    }
    //UIViewControllerRepresentable プロトコルを適合させるために必要
    // UIViewControllerがアップデートされる際の処理
    //UIImagePickerController: カメラキャプチャ画面を表示し、ユーザーが写真を撮るためのインターフェースを提供するUIKit のビューコントローラ
    //content: この引数は Context 型の情報を提供し、ビューコントローラの更新に関する情報やコンテキスト情報を含む、通常はこの情報を使用してビューコントローラの外観や動作をカスタマイズするが、このメソッドは現在空。
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
    }
}

/*
struct CameraCaptureView_Previews: PreviewProvider {
    static var previews: some View {
        CameraCaptureView()
    }
}
*/
