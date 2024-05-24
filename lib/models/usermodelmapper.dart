import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maple/models/user_model.dart';
import 'package:maple/utils/constants.dart';

class UserModelMapper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamTransformer<User?, UserModel> get userMapper =>
      StreamTransformer<User?, UserModel>.fromHandlers(
        handleData: (User? user, EventSink<UserModel> sink) async {
          if (user != null) {
            DocumentSnapshot documentSnapshot =
                await _firestore.collection('Users').doc(user.uid).get();
            var userData = documentSnapshot.data() as Map<String, dynamic>;
            if (user.emailVerified || userData['signInMethod'] == "google") {
              if (documentSnapshot.exists) {
                // Lấy dữ liệu từ document
                UserModel userModel = UserModel(
                    uid: user.uid,
                    email: user.emailVerified ? user.email : userData['email'],
                    signInMethod: userData['signInMethod'],
                    completedLessons: userData[
                        completedLessons], // Ví dụ: Số bài học đã hoàn thành
                    progress: userData['progress'], // Ví dụ: Tiến độ hoàn thành
                    username: userData['username'], // Tên người dùng
                    language: 'en',
                    heart: userData[heart],
                    streak: userData[streak],
                    gem: userData[gem]);
                sink.add(userModel);
              }
            } else {
              throw 'email-not-verified';
            }
            // Tạo UserModel từ User của Firebase
          } else {
            return; //throw 'user-not-found';
          }
        },
      );
}
