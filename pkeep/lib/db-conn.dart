// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages, file_names

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model.dart';

class SQLHelper {
  final String _createUserTableQuery = '''CREATE TABLE IF NOT EXISTS userInfo (
        user_id INTEGER PRIMARY KEY,
        name TEXT,
        username TEXT UNIQUE,
        email TEXT,
        password TEXT,
        loggedIn TEXT)''';
  final String _createPasswordTableQuery =
      '''CREATE TABLE IF NOT EXISTS passwordInfo (
        p_id INTEGER PRIMARY KEY, 
        username TEXT,
        client_name TEXT,
        client_username TEXT,
        client_password TEXT)''';

  _initDB() async {
    String dbPath = await getDatabasesPath();
    String path = join(dbPath, 'PKeep.db');
    Database db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        onCreateMethod(db, version);
      },
    );
    return db;
  }

  onCreateMethod(Database db, int version) async {
    db.execute(_createUserTableQuery);
    db.execute(_createPasswordTableQuery);
  }

  Database? _db;
  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  // CREATE METHODS

  Future<int> createUserEntry(User user) async {
    Database myDB = await db;
    return await myDB.rawInsert(
        '''INSERT INTO userInfo (user_id, name, username, email, password, loggedIn)
        VALUES (${user.userID}, "${user.name}", "${user.username}", "${user.email}", "${user.password}", "${user.loggedIn}")''');
  }

  Future<int> createPasswordEntry(Password password) async {
    Database myDB = await db;
    return await myDB.rawInsert(
        '''INSERT INTO passwordInfo (p_id, username, client_name, client_username, client_password)
        VALUES(${password.pID}, "${password.username}", "${password.clientName}", "${password.clientUsername}", "${password.clientPassword}")''');
  }

  //
  // UPDATE METHODS
  //

  // Updating password

  Future<int> updatePassword_cName(String newValue, int pID) async {
    Database myDB = await db;
    return await myDB.rawUpdate(
        '''UPDATE passwordInfo SET client_name = "$newValue" WHERE p_id = $pID''');
  }

  Future<int> updatePassword_cUsername(String newValue, int pID) async {
    Database myDB = await db;
    return await myDB.rawUpdate(
        '''UPDATE passwordInfo SET client_username = "$newValue" WHERE p_id = $pID''');
  }

  Future<int> updatePassword_cPassword(String newValue, int pID) async {
    Database myDB = await db;
    return await myDB.rawUpdate(
        '''UPDATE passwordInfo SET client_password = "$newValue" WHERE p_id = $pID''');
  }

  // Updating user

  Future<int> updateUser_Name(String newValue, int userID) async {
    Database myDB = await db;
    return await myDB.rawInsert(
        '''UPDATE userInfo SET name = "$newValue" WHERE user_id = $userID''');
  }

  Future<int> updateUser_Username(String newValue, int userID) async {
    Database myDB = await db;
    return await myDB.rawInsert(
        '''UPDATE userInfo SET username = "$newValue" WHERE user_id = $userID''');
  }

  Future<int> updateUser_Email(String newValue, int userID) async {
    Database myDB = await db;
    return await myDB.rawInsert(
        '''UPDATE userInfo SET email = "$newValue" WHERE user_id = $userID''');
  }

  Future<int> updateUser_Password(String newValue, int userID) async {
    Database myDB = await db;
    return await myDB.rawInsert(
        '''UPDATE userInfo SET password = "$newValue" WHERE user_id = $userID''');
  }

  // Updating logged in state
  Future<int> updateLoggedInState(
      {required String newValue, required int userID}) async {
    Database myDB = await db;
    return await myDB.rawInsert(
        '''UPDATE userInfo SET loggedIn = "$newValue" WHERE user_id = $userID''');
  }

  //
  // READ METHODS
  //

  // Read all password records of a user
  Future<List<Password>> readPasswordsByUsername(String username) async {
    Database myDB = await db;
    var resultSet = await myDB.query(
      'passwordInfo',
      where: 'username = ?',
      whereArgs: [username],
    );
    List<Password> allItems = [];
    for (var map in resultSet) {
      Password obj = Password.fromMap(map);
      allItems.add(obj);
    }
    return allItems;
  }

  // Read all passwords of any and all users
  Future<List<Password>> readAllPasswords() async {
    Database myDB = await db;
    var resultSet = await myDB.query('passwordInfo');
    List<Password> allItems = [];
    for (var map in resultSet) {
      Password obj = Password.fromMap(map);
      allItems.add(obj);
    }
    return allItems;
  }

  // Read all password records of a domain - eg: all youtube passwords of a user
  Future<List<Password>> readPasswordsByUsernameAndClientName(
      String username, String clientName) async {
    Database myDB = await db;
    var resultSet = await myDB.query(
      'passwordInfo',
      where: 'username = ? and client_name = ?',
      whereArgs: [username, clientName],
    );
    List<Password> allItems = [];
    for (var map in resultSet) {
      Password obj = Password.fromMap(map);
      allItems.add(obj);
    }
    return allItems;
  }

  // Read all users
  Future<List<User>> readAllUsers() async {
    Database myDB = await db;
    var resultSet = await myDB.query('userInfo');
    List<User> allItems = [];
    for (var map in resultSet) {
      User obj = User.fromMap(map);
      allItems.add(obj);
    }
    return allItems;
  }

  Future<User> getLoggedInUsername() async {
    Database myDB = await db;
    var resultSet =
        await myDB.query('userInfo', where: 'loggedIn = ?', whereArgs: ['YES']);
    User allItems = User();
    for (var map in resultSet) {
      allItems = User.fromMap(map);
    }
    return allItems;
  }

  //
  // DELETE METHODS
  //

  Future<int> deletePasswordByID(int ID) async {
    Database myDB = await db;
    return await myDB.delete(
      'passwordInfo',
      where: 'p_id = ?',
      whereArgs: [ID],
    );
  }

  Future<int> deleteUserByID(int ID) async {
    Database myDB = await db;
    return await myDB.delete(
      'userInfo',
      where: 'user_id = ?',
      whereArgs: [ID],
    );
  }
}
