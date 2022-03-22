import 'package:vehicles_app/models/document_type.dart';
import 'package:vehicles_app/models/user.dart';

class Token {
  String token = '';
  String expiration = '';
  User user = User(
      firstName: '',
      lastName: '',
      documentType: DocumentType(id: 0, description: ''),
      document: '',
      address: '',
      imageId: '',
      imageFullPath: '',
      userType: 0,
      fullName: '',
      id: '',
      userName: '',
      email: '',
      phoneNumber: '');

  Token({required token, required expiration, required user});

  Token.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    expiration = json['expiration'];
    user = User.fromJson(json['user']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = token;
    data['expiration'] = expiration;
    data['user'] = user.toJson();
    return data;
  }
}
