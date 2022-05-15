import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

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
    Transaction transaction,
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
  Future<List<Transaction>> fetchTransactions() async {
    // Get a reference to the database.
    final db = await database;

    // Query the table for all The transactions.
    final List<Map<String, dynamic>> maps = await db.query('transactions');

    // Convert the List<Map<String, dynamic> into a List<Dog>.
    return List.generate(maps.length, (i) {
      return Transaction(
        id: maps[i]['id'],
        title: maps[i]['title'],
        amount: maps[i]['amount'],
        category: maps[i]['category'],
        date: maps[i]['date'],
      );
    });
  }

  Future<void> updateTransaction(Transaction transaction) async {
    // Get a reference to the database.
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

//    ___       _ __   __
//   / _ )__ __(_) /__/ /
//  / _  / // / / / _  /
// /____/\_,_/_/_/\_,_/

  int index = 0;
  int accountSelection = 0;
  @override
  Widget build(BuildContext context) {
    Future<List<Transaction>> finalTransactions = fetchTransactions();
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )),
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
          // SizedBox(
          //   height: 100,
          //   width: 100,
          //   child: ElevatedButton(
          //     child: const Text("Add to Transactions"),
          //     onPressed: () {
          //       setState(
          //         () {
          //           insertTransaction(
          //               Transaction(
          //                 id: index,
          //                 title: 'Test Transaction',
          //                 amount: 1000,
          //               ),
          //               database);
          //           index++;
          //         },
          //       );
          //     },
          //   ),
          // ),

          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.only(left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const SizedBox(height: 10),
                  Neumorphic(
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // ignore: prefer_const_literals_to_create_immutables
                      children: [
                        Row(
                          children: [
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'All Accounts',
                                style: TextStyle(
                                    color: accountSelection == 0
                                        ? Colors.blue
                                        : Colors.grey),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Bank',
                                style: TextStyle(
                                    color: accountSelection == 1
                                        ? Colors.blue
                                        : Colors.grey),
                              ),
                            ),
                            const SizedBox(width: 30),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                'Add Account',
                                style: TextStyle(
                                    color: accountSelection == 2
                                        ? Colors.blue
                                        : Colors.grey),
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        // ignore: prefer_const_constructors
                        Text(
                          'Total Cash: \$1,700',
                          // ignore: prefer_const_constructors
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 40,
                          width: double.infinity,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Transactions',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
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
                                    Neumorphic(
                                      margin: const EdgeInsets.only(
                                          right: 10, top: 10),

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
                                        height: 20,
                                        margin: const EdgeInsets.only(top: 5),
                                        child: TextFormField(
                                          decoration: const InputDecoration(
                                            hintText: 'Category',
                                            hintStyle: TextStyle(
                                                fontSize: 10,
                                                color: Colors.grey),
                                          ),
                                          validator: (String? value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Please enter some text';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 16.0),
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: const Text('Submit'),
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

          // Expanded(
          //   flex: 1,
          //   child: Neumorphic(
          //     margin: EdgeInsets.only(right: 10),
          //     style: NeumorphicStyle(
          //       shape: NeumorphicShape.flat,
          //       boxShape: NeumorphicBoxShape.roundRect(
          //         BorderRadius.circular(12),
          //       ),
          //       depth: -4,
          //       intensity: .5,
          //       lightSource: LightSource.bottomRight,
          //       color: Colors.grey[200],
          //     ),
          //     padding: const EdgeInsets.all(20),
          //     child: Container(
          //       width: 100,
          //       height: 100,
          //     ),
          //   ),
          // ),
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

class Transaction {
  final int id;
  final String title;
  final int amount;
  final String date;
  final String category;

  const Transaction({
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
