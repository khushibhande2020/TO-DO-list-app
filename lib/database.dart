import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
class TodoDatabase{
 Future<Database> createDB() async{
  Database db = await  openDatabase(
    join( await getDatabasesPath(),"TodoDB.db"),
    version:1,
    onCreate:(db, version) async{
    await db.execute(
    '''
    CREATE TABLE todo{
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title TEXT,
    description TEXT,
    date TEXT
    }
'''
  );
},
  );
  return db;
  }
//------------------------------------------------------------GET DATA-----------------------------------------------------------
Future<List<Map>> getTodoItems() async{
  Database localDb = await createDB();
  List<Map> list =await localDb.query("todo");
  return list;
}
//-----------------------------------------------------------INSERT/ADD DATA------------------------------------------------------
void insertTodoItem(Map<String, dynamic> obj) async{
  Database localdb= await createDB();
  await localdb.insert("todo", obj, conflictAlgorithm: ConflictAlgorithm.replace,);
}
//-----------------------------------------------------------UPDATE DATA----------------------------------------------------------
Future<void> updateTodoItem(Map<String, dynamic> obj) async{
Database  localDb = await createDB();
await localDb.update("todo", obj, where:"id=?",whereArgs:[obj['id']]);
}
//-----------------------------------------------------------DELETE DATA----------------------------------------------------------
Future<void> deleteTodoItem(int index) async{
  Database db = await createDB();
  await db.delete("todo",where:"id=?",whereArgs:[index]);
}
}
