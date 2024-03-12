# -はじめに-
・このアプリはユーザーが自由に掲示板へポストを投稿したり、他ユーザーとメッセージができるアプリです。  
・会員登録/ログインは電話番号のみで行います。(SMS認証)  

# -動作-
・Firebaseの電話番号認証機能を使用してユーザーの会員登録/ログインを行う。  
・ユーザーは自分のプロフィールを編集できる。  
・ユーザーは掲示板へポストを投稿できる。  
・ユーザーは他のユーザーとメッセージができる。  
・"メニュー"タブは未実装  
・各データはFirestoreへ保存  
 ・ユーザーのプロフィール    コレクション名'users'.ドキュメント名'ユーザーUID'.各フィールド  
 ・掲示板のポストデータ      コレクション名'posts'.ドキュメント名'投稿者のユーザーUID'.各フィールド  
 ・メッセージデータ          コレクション名'conversations'.ドキュメント名'両者ののユーザーUIDの組み合わせ'.サブコレクション名'messages'.各フィールド  
 ・最近のメッセージデータ     コレクション名'conversations'.ドキュメント名'両者ののユーザーUIDの組み合わせ'.各フィールド  
 


# -会員登録用テスト電話番号-
電話番号	      SMS確認コード  
080-1111-0000  123456  
080-1111-2222	 123456  
080-1111-3333	 123456  
080-1111-4444	 123456  
080-1111-5555	 123456  
080-1111-6666	 123456  
080-1111-7777	 123456  
080-1111-8888	 123456  
080-1111-9999	 123456  	


# -以下個人的なメモ-
・IoTボタンでチェンジ  
・GPT機能  
・店内人数確認時のwebviewで他のページ閲覧時にエラー  
・webviewロード中アイコン実装  
・認証の際、パーミッションが許可されていない場合の設定  


import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRViewExample extends StatefulWidget {
  const QRViewExample({super.key});

  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  MobileScannerController cameraController = MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.front,
    torchEnabled: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MobileScanner(
        controller: cameraController,
        onDetect: (capture) {
          final List<Barcode> barcodes = capture.barcodes;
          for (final barcode in barcodes) {
            debugPrint('Barcode found! ${barcode.rawValue}');
          }
        },
      ),
    );
  }
}
