// ignore_for_file: file_names
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SettingsManager extends StatefulWidget {
  const SettingsManager({Key? key}) : super(key: key);

  @override
  State<SettingsManager> createState() => _SettingsManagerState();
}

class _SettingsManagerState extends State<SettingsManager> {
  Future<Database> getDatabase() async {
    return openDatabase(
      join(await getDatabasesPath(), 'transactions.db'),
      version: 1,
    );
  }

  Future<void> deleteAllTransactions(Future<Database> database) async {
    // Get a reference to the database.
    final db = await database;

    // Remove the transaction from the database.
    await db.delete(
      'transactions',
    );
  }

  bool isLoading = true;
  @override
  Widget build(BuildContext context) {
    Future<Database> database = getDatabase().then(
      (value) {
        setState(() {
          isLoading = false;
        });
        return value;
      },
    );

    return Expanded(
      flex: 1,
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueGrey),
            )
          : Neumorphic(
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
                    ElevatedButton(
                      // ignore: prefer_const_constructors
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blueGrey),
                      ),
                      onPressed: () {
                        deleteAllTransactions(database);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Transactions Deleted'),
                          ),
                        );
                      },
                      child: const Text(
                        'Erase All Data',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ElevatedButton(
                      // ignore: prefer_const_constructors
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Colors.blueGrey),
                      ),
                      onPressed: () {},
                      child: const Text(
                        'Export Data as CSV',
                        style: TextStyle(fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
