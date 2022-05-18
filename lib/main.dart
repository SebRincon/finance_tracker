import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'transactionsList.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open database
  final database = openDatabase(
    join(await getDatabasesPath(), 'transactions.db'),

    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      db.execute(
          'CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY, name TEXT, cashAmount INTEGER)');
      return db.execute(
        'CREATE TABLE IF NOT EXISTS transactions(id INTEGER PRIMARY KEY, title TEXT, amount INTEGER, date TEXT, category TEXT)',
      );
    },
    // Set the version. This executes the onCreate function and provides a
    // path to perform database upgrades and downgrades.
    version: 1,
  );

  runApp(MyApp(database));
}

class MyApp extends StatelessWidget {
  final Future<Database> database;
  const MyApp(this.database, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(database),
    );
  }
}

//   _  _               ___                __      ___    _          _
//  | || |___ _ __  ___| _ \__ _ __ _ ___  \ \    / (_)__| |__ _ ___| |_
//  | __ / _ \ '  \/ -_)  _/ _` / _` / -_)  \ \/\/ /| / _` / _` / -_)  _|
//  |_||_\___/_|_|_\___|_| \__,_\__, \___|   \_/\_/ |_\__,_\__, \___|\__|
//                              |___/                      |___/

class MyHomePage extends StatefulWidget {
  final Future<Database> database;
  const MyHomePage(this.database, {Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<MyHomePage> createState() => _MyHomePageState(database);
}

enum FormType {
  category,
  title,
  amount,
  date,
}

class _MyHomePageState extends State<MyHomePage> {
  final Future<Database> database;
  _MyHomePageState(this.database);

//    ___       __       __
//   / _ \___ _/ /____ _/ /  ___ ____ ___
//  / // / _ `/ __/ _ `/ _ \/ _ `(_-</ -_)
// /____/\_,_/\__/\_,_/_.__/\_,_/___/\__/

  Future<void> insertUser(
    Map<String, Object> user,
    Future<Database> database,
  ) async {
    final db = await database;
    await db.insert(
      'users',
      user,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Map> fetchUser(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The transactions.

    final List<Map<String, dynamic>> userData =
        await db.query('users', where: 'id = ?', whereArgs: [id]);

    return userData[0];
  }

  // Define a function that inserts transactions into the database
  Future<void> insertTransaction(
    UserTransaction transaction,
    Future<Database> database,
  ) async {
    // Get a reference to the database.
    final db = await database;

    // Insert the Transaction into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same transaction is inserted twice.
    //
    // In this case, replace any previous data.
    await db.insert(
      'transactions',
      transaction.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

// A method that retrieves all the transactions from the transactions table.
  Future<List<UserTransaction>> fetchTransactions() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The transactions.
    final List<Map<String, dynamic>> maps = await db.query('transactions');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return UserTransaction(
        id: maps[i]['id'],
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        category: maps[i]['category'],
        date: maps[i]['date'],
      );
    });
  }

  Future<void> updateTransaction(UserTransaction transaction) async {
    // Get a reference to th
    //e database.
    final db = await database;

    // Update the given Transaction.
    await db.update(
      'transactions',
      transaction.toMap(),
      // Ensure that the Transaction has a matching id.
      where: 'id = ?',
      // Pass the Transaction's id as a whereArg to prevent SQL injection.
      whereArgs: [transaction.id],
    );
  }

  Future<void> deleteTransaction(int id) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the transaction from the database.
    await db.delete(
      'transactions',
      // Use a `where` clause to delete a specific transaction.
      where: 'id = ?',
      // Pass the transaction's id as a whereArg to prevent SQL injection.
      whereArgs: [id],
    );
  }

  Widget neumorphicTextField(String hint, FormType field) {
    return Expanded(
      flex: 1,
      child: Neumorphic(
        margin: const EdgeInsets.only(right: 10, top: 10),

        style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(15),
          ),
          depth: -4,
          intensity: .5,
          lightSource: LightSource.bottomRight,
          // color: Colors.grey[300],
          color: Colors.white,
        ),
        // padding: const EdgeInsets.all(20),
        child: Container(
          // margin: EdgeInsets.all(20),
          width: 100,
          height: 15,
          margin: const EdgeInsets.only(top: 5),
          child: TextFormField(
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: hint,
              hintStyle: const TextStyle(fontSize: 10, color: Colors.grey),
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
            onSaved: (newValue) {
              switch (field) {
                case FormType.category:
                  setState(
                    () {
                      formCategory = newValue!;
                    },
                  );

                  break;
                case FormType.title:
                  setState(
                    () {
                      formTitle = newValue!;
                    },
                  );
                  break;
                case FormType.amount:
                  setState(
                    () {
                      formAmount = newValue!;
                    },
                  );
                  break;
                case FormType.date:
                  setState(
                    () {
                      formDate = newValue!;
                    },
                  );
                  break;
              }
            },
          ),
        ),
        padding: const EdgeInsets.only(bottom: 10, left: 10),
      ),
    );
  }

//    ___       _ __   __
//   / _ )__ __(_) /__/ /
//  / _  / // / / / _  /
// /____/\_,_/_/_/\_,_/

  int index = 0;
  int accountSelection = 0;

  String formCategory = 'Misc';
  String formTitle = 'Purchase';
  String formAmount = '\$0.0';
  String formDate = DateTime.now().toString();

  @override
  Widget build(BuildContext context) {
    Future<List<UserTransaction>> finalTransactions = fetchTransactions();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    void _submitOrder(
      String formCategory,
      String formTitle,
      String formAmount,
      String formDate,
    ) {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _formKey.currentState!.save();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('$formCategory - $formTitle - $formAmount - $formDate'),
          ),
        );
        setState(
          () {
            formCategory = 'Misc';
            formTitle = 'Purchase';
            formAmount = '\$0.0';
            formDate = DateTime.now().toString();
            _formKey.currentState!.reset();
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please fill the entire entry'),
          ),
        );
      }
    }

    return Scaffold(
      body: Row(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            width: 150,
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: EdgeInsets.only(top: 40),
                    child: const Text(
                      "Dashboard",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                //
                // SIDE BAR
                //
                Expanded(
                  flex: 10,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          //
          // MAIN VIEW *******************
          //
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  accountDetail(accountSelection),
                  const SizedBox(height: 10),
                  const Text(
                    'Transactions',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  //
                  // TRANSACTIONS *******************
                  //

                  Expanded(
                    flex: 1,
                    child: Neumorphic(
                        margin: const EdgeInsets.only(right: 10, bottom: 10),
                        style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(12),
                          ),
                          depth: -4,
                          intensity: .5,
                          lightSource: LightSource.bottomRight,
                          color: Colors.grey[200],
                        ),
                        padding: const EdgeInsets.all(20),
                        child: SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * .65,
                          child: Column(
                            children: [
                              Row(
                                children: const [
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      // width: 200,
                                      child: Text(
                                        'Category',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      // width: 200,
                                      child: Text(
                                        'Title',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      // width: 200,
                                      child: Text(
                                        'Amount',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: SizedBox(
                                      // width: 200,
                                      child: Text(
                                        'Date',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Form(
                                key: _formKey,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    neumorphicTextField(
                                        'Ex: Bill, fast-food, gas',
                                        FormType.category),
                                    neumorphicTextField(
                                        'Ex: Light bill', FormType.title),
                                    neumorphicTextField(
                                        'Ex: \$100', FormType.amount),
                                    neumorphicTextField(
                                        'Ex: 05-15-2022', FormType.date),
                                    // NeumorphicButton(
                                    //   style: NeumorphicStyle(
                                    //     shape: NeumorphicShape.flat,
                                    //     boxShape: NeumorphicBoxShape.roundRect(
                                    //       BorderRadius.circular(15),
                                    //     ),
                                    //     depth: -4,
                                    //     intensity: .5,
                                    //     lightSource: LightSource.bottomRight,
                                    //     // color: Colors.grey[300],
                                    //     color: Colors.white,
                                    //   ),
                                    //   child: const Text("ADD"),
                                    //   onPressed: () {},
                                    // ),
                                    Neumorphic(
                                      margin: const EdgeInsets.only(top: 10),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _submitOrder(formCategory, formTitle,
                                              formAmount, formDate);
                                        },
                                        child: const Text('ADD',
                                            style:
                                                TextStyle(color: Colors.black)),
                                        style: ElevatedButton.styleFrom(
                                          onPrimary: Colors.black,
                                          animationDuration: const Duration(
                                              milliseconds: 1000),
                                          primary: Colors.white,
                                          shadowColor: Colors.grey[100],
                                          elevation: 10,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Divider(),
                              SizedBox(
                                width: double.infinity,
                                height:
                                    MediaQuery.of(context).size.height * .56,
                                child: FutureBuilder<List<Transaction>>(
                                  future: finalTransactions,
                                  builder: (context, snapshot) {
                                    return ListView.builder(
                                      itemCount: snapshot.data?.length,
                                      itemBuilder: (context, index) {
                                        List? _transactions = snapshot.data;
                                        return Container(
                                          // margin: const EdgeInsets.only(
                                          //     top: 5, bottom: 5),
                                          // decoration: BoxDecoration(
                                          //   color: Colors.indigo,
                                          //   borderRadius: BorderRadius.circular(5),
                                          // ),
                                          width: double.infinity,
                                          height: 50,
                                          child: Column(
                                            children: [
                                              Center(
                                                child: Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          "${_transactions![index].id}"),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          "${_transactions[index].title}"),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          "\$${_transactions[index].amount}"),
                                                    ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                          "\$${_transactions[index].amount}"),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              const Divider(),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//   _____                          _   _             ___  _     _        _
//  |_   _| _ __ _ _ _  ___ __ _ __| |_(_)___ _ _    / _ \| |__ (_)___ __| |_
//    | || '_/ _` | ' \(_-</ _` / _|  _| / _ \ ' \  | (_) | '_ \| / -_) _|  _|
//    |_||_| \__,_|_||_/__/\__,_\__|\__|_\___/_||_|  \___/|_.__// \___\__|\__|
//                                                            |__/

class UserTransaction {
  final int id;
  final String title;
  final int amount;
  final String date;
  final String category;

  const UserTransaction({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date,
      'category': category,
    };
  }

  @override
  String toString() {
    return 'Transaction{id: $id, title: $title, amount: $amount, category: $category, date: $date}';
  }
}
