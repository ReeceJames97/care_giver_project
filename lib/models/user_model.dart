class UserModel{

  int? _userId;
  String? _userName;
  String? _email;
  String? _password;

  UserModel(dynamic obj){
    _userId = obj['userid'];
    _userName = obj['username'];
    _email = obj['email'];
    _password = obj['password'];
  }
  UserModel.fromMap(Map<String,dynamic> data){
    _userId = data['userid'];
    _userName = data['username'];
    _email = data['email'];
    _password = data['password'];
  }
  Map<String, dynamic> toMap() => {'userid' : _userId,'username' : _userName,'email' : _email, 'password' : _password};

  int get userId => _userId!;
  String get userName => _userName!;
  String get email => _email!;
  String get password => _password!;

}