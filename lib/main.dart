import 'package:flutter/material.dart';

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Open database
  final database = openDatabase(
    join(await getDatabasesPath(), 'transactions.db'),

    onCreate: (db, version) {
      // Run the CREATE TABLE statement on the database.
      return db.execute(
        'CREATE TABLE transactions(id INTEGER PRIMARY KEY, title TEXT, amount INTEGER)',
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

  Widget build(BuildContext context) {
    Future<List<Transaction>> finalTransactions = fetchTransactions();

    return Scaffold(
      body: Column(
        children: [
          Container(
            width: double.infinity,
            height: 50,
            color: Colors.orange,
          ),
          Row(
            children: [
              SizedBox(
                height: 100,
                width: 100,
                child: ElevatedButton(
                  child: const Text("Add to Transactions"),
                  onPressed: () {
                    setState(
                      () {
                        insertTransaction(
                            Transaction(
                              id: index,
                              title: 'Test Transaction',
                              amount: 1000,
                            ),
                            database);
                        index++;
                      },
                    );
                  },
                ),
              ),
              SizedBox(
                width: 500,
                height: 500,
                child: FutureBuilder<List<Transaction>>(
                  future: finalTransactions,
                  builder: (context, snapshot) {
                    return ListView.builder(
                      itemCount: snapshot.data?.length,
                      itemBuilder: (context, index) {
                        List? _transactions = snapshot.data;
                        return Container(
                          margin: EdgeInsets.only(top: 5, bottom: 5),
                          decoration: BoxDecoration(
                            color: Colors.indigo,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          width: 300,
                          height: 75,
                          child: Center(
                            child: Text(
                                "${_transactions![index].id} - ${_transactions[index].title} - \$${_transactions[index].amount}"),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
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

class Transaction {
  final int id;
  final String title;
  final int amount;

  const Transaction({
    required this.id,
    required this.title,
    required this.amount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
    };
  }

  @override
  String toString() {
    return 'Transaction{id: $id, title: $title, amount: $amount}';
  }
}
