import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maple/models/usermodel.dart';
import 'package:maple/utils/constants.dart';

class UserModelMapper {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  StreamTransformer<User?, UserModel> get userMapper =>
      StreamTransformer<User?, UserModel>.fromHandlers(
        handleData: (User? user, EventSink<UserModel> sink) async {
          if (user != null) {
            // Tạo UserModel từ User của Firebase
            DocumentSnapshot documentSnapshot =
          await _firestore.collection('Users').doc(user.uid).get();
           if (documentSnapshot.exists) {
        // Lấy dữ liệu từ document
        var userData = documentSnapshot.data() as Map<String, dynamic>;
            UserModel userModel = UserModel(
              uid: user.uid,
              email: user.email,
              completedLessons:  userData[completedLesson], // Ví dụ: Số bài học đã hoàn thành
              process: userData[process], // Ví dụ: Tiến độ hoàn thành
              username: user.displayName, // Tên người dùng
              language:'en',
              heart: userData[heart],
              streak: userData[streak],
              gem: userData[gem]

            );
            sink.add(userModel);
           }
          } else {
            // Không có người dùng đăng nhập
            sink.addError('User is null');
          }
        },
      );
}
