import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:maple/models/usermodel.dart';

class UserModelMapper {
  StreamTransformer<User?, UserModel> get userMapper =>
      StreamTransformer<User?, UserModel>.fromHandlers(
        handleData: (User? user, EventSink<UserModel> sink) {
          if (user != null) {
            // Tạo UserModel từ User của Firebase
            UserModel userModel = UserModel(
              uid: user.uid,
              email: user.email,
              completedLessons: '0', // Ví dụ: Số bài học đã hoàn thành
              process: '0%', // Ví dụ: Tiến độ hoàn thành
              username: user.displayName, // Tên người dùng
            );
            sink.add(userModel);
          } else {
            // Không có người dùng đăng nhập
            sink.addError('User is null');
          }
        },
      );
}
