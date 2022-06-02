import 'package:finance_tracker/pages/SettingsManager.dart';
import 'package:finance_tracker/pages/TransactionsManager.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Finance Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // routes: <String, WidgetBuilder>{
      //   '/dashboard': (BuildContext context) => const SettingsPage(),
      // },
      home: const MyHomePage(),
    );
  }
}

//   _  _               ___                __      ___    _          _
//  | || |___ _ __  ___| _ \__ _ __ _ ___  \ \    / (_)__| |__ _ ___| |_
//  | __ / _ \ '  \/ -_)  _/ _` / _` / -_)  \ \/\/ /| / _` / _` / -_)  _|
//  |_||_\___/_|_|_\___|_| \__,_\__, \___|   \_/\_/ |_\__,_\__, \___|\__|
//                              |___/                      |___/

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState();

//    ___       _ __   __
//   / _ )__ __(_) /__/ /
//  / _  / // / / / _  /
// /____/\_,_/_/_/\_,_/

  int index = 0;
  int accountSelection = 0;

  void changeIndex(int _index) {
    setState(
      () {
        index = _index;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                    padding: const EdgeInsets.only(top: 80),
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
                    width: 300,
                    decoration: const BoxDecoration(
                      color: Colors.blueGrey,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 40,
                        ),

                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Dashboard',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {
                                  changeIndex(0);
                                },
                                icon: const Icon(Icons.account_balance),
                              ),
                            ],
                          ),
                        ),

                        // IconButton(
                        //   onPressed: () {
                        //     changeIndex(1);
                        //   },
                        //   icon: const Icon(Icons.add_chart_outlined),
                        // ),
                        Container(
                          margin: const EdgeInsets.only(left: 10, right: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Settings',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              IconButton(
                                onPressed: () {
                                  changeIndex(1);
                                },
                                icon: const Icon(Icons.settings),
                              ),
                            ],
                          ),
                        ),
                      ],
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
                  // accountDetail(accountSelection),
                  const SizedBox(height: 10),
                  Text(
                    index == 0 ? 'Transactions' : "Settings",
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),

                  //
                  // TRANSACTIONS *******************
                  //
                  index == 0 ? TransactionManager() : SettingsManager()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
