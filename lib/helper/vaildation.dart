

class Validation {
 String? validateEmail(String? value) {
  const pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
  final regex = RegExp(pattern);

  if (value == null || value.isEmpty) {
    return 'Email không được để trống';
  }
  if (!regex.hasMatch(value)) {
    if (!value.contains('@')) {
      return 'Email phải chứa ký tự @';
    }
    if (!value.contains('.')) {
      return 'Email phải chứa dấu chấm (.) sau ký tự @';
    }
    return 'Định dạng email không hợp lệ';
  }
  return null;
}

String? validatePassword(String value) {
  const pattern = r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#$&*~]).{8,}$';
  final regex = RegExp(pattern);

  if (value.isEmpty) {
    return 'Mật khẩu không được để trống';
  }
  if (value.length < 8) {
    return 'Mật khẩu phải có ít nhất 8 ký tự';
  }
  if (!value.contains(RegExp(r'[A-Z]'))) {
    return 'Mật khẩu phải chứa ít nhất một chữ cái viết hoa';
  }
  if (!value.contains(RegExp(r'[a-z]'))) {
    return 'Mật khẩu phải chứa ít nhất một chữ cái viết thường';
  }
  if (!value.contains(RegExp(r'[0-9]'))) {
    return 'Mật khẩu phải chứa ít nhất một chữ số';
  }
  if (!value.contains(RegExp(r'[!@#$&*~]'))) {
    return "Mật khẩu phải chứa ít nhất một ký tự đặc biệt ('!@#*~)";
  }
  if (!regex.hasMatch(value)) {
    return 'Định dạng mật khẩu không hợp lệ';
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
