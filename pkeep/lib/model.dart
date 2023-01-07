import 'dart:io';

class User {
  String? name, username, email, password, loggedIn;
  int? userID;

  User(
      {this.userID,
      this.name,
      this.username,
      this.email,
      this.password,
      this.loggedIn});
  User.fromMap(Map map) {
    userID = map['user_id'];
    name = map['name'];
    username = map['username'];
    email = map['email'];
    password = map['password'];
    loggedIn = map['loggedIn'];
  }
}

class Password {
  String? username, clientName, clientUsername, clientPassword;
  int? pID;
  Password(this.pID, this.username, this.clientName, this.clientUsername,
      this.clientPassword);
  Password.fromMap(Map map) {
    pID = map['p_id'];
    username = map['username'];
    clientName = map['client_name'];
    clientUsername = map['client_username'];
    clientPassword = map['client_password'];
  }
}
