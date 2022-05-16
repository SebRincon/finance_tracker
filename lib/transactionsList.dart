Widget neumorphicTextField(String hint) {
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
          ),
        ),
        padding: const EdgeInsets.only(bottom: 10, left: 10),
      ),
    );
}
Widget accountDetail(){
    return Neumorphic(
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

}
Widget transactionsList(){
    return Expanded(
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
                                        'Ex: bill, fast-food, gas'),
                                    neumorphicTextField('Ex: Light bill'),
                                    neumorphicTextField('Ex: \$100'),
                                    neumorphicTextField('Ex: 05-15-2022'),
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
                        ),),
                  ),

}