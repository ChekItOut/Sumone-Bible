import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

/// Firebase 클라이언트 전역 인스턴스
///
/// 앱 전체에서 동일한 Firebase 클라이언트를 사용하기 위한 전역 변수
/// main.dart에서 Firebase.initializeApp() 호출 후 사용 가능
///
/// 사용 예시:
/// ```dart
/// final user = firebaseAuth.currentUser;
/// final data = await firestore.collection('users').get();
/// ```

/// Firebase Authentication 인스턴스
final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

/// Cloud Firestore 인스턴스
final FirebaseFirestore firestore = FirebaseFirestore.instance;

/// Firebase Storage 인스턴스
final FirebaseStorage storage = FirebaseStorage.instance;

/// Cloud Functions 인스턴스
final FirebaseFunctions functions = FirebaseFunctions.instance;

/// Firebase Cloud Messaging 인스턴스
final FirebaseMessaging messaging = FirebaseMessaging.instance;
