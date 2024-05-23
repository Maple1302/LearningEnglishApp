import 'package:maple/utils/constants.dart';

class Validation {
  String? validateEmail(String? value) {
   const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(pattern);
    if (value!.isEmpty) {
      return emailEmpty;
    }
    return regex.hasMatch(value) ? null : emailInvalid;
  }

  String? validatePassword(String value) {
    const pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$';
    final regex = RegExp(pattern);
    if (value.isEmpty) {
      return passwordEmpty;
    }
    return regex.hasMatch(value) ? null : passwordInvalid;
  }
  String? validateConfirmPassword(String password,String passwordConfirm) {
  
    if (password != passwordConfirm) {
      return 'Mật khẩu không trùng khớp';
    }
      return null;
    
    
  }
  String? validateUsername(String username) {
  // Kiểm tra xem tên người dùng có hợp lệ không
  // Theo các quy tắc sau:
  // - Phải có độ dài từ 3 đến 20 ký tự
  // - Chỉ chứa các ký tự chữ và số
  // - Phải bắt đầu bằng một ký tự chữ

  if (username.isEmpty) {
    return "Vui lòng nhập tên người dùng";
  }

  // Kiểm tra độ dài
  if (username.length < 3 || username.length > 20) {
    return "Tên phải có độ dài từ 3 đến 20 ký tự ";
  }

  // Kiểm tra ký tự chữ và số
  if (!username.contains(RegExp(r'^[a-zA-Z0-9]+$'))) {
    return "Tên chỉ được chứa chữ hoặc số";
  }

  // Kiểm tra ký tự đầu tiên là chữ
  if (username[0].toUpperCase() == username[0].toLowerCase()) {
    return "Ký tự đầu tiên phải là chữ";
  }

  return null;
}

}
