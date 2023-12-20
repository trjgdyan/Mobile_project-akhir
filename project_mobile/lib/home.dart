import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        //bottom navigation bar
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.upload_file), label: 'Upload'),
            BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Print'),
          ],
          currentIndex: 0,
          selectedItemColor: Colors.pink,
          onTap: (index) {
            if (index == 1) {
              Navigator.pushNamed(context, '/upload');
            } else if (index == 2) {
              Navigator.pushNamed(context, '/print');
            }
          },
        ),
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: const Text(
            'EZVerify',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.search),
              tooltip: 'Show Snackbar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hello, im yani yg comel')));
              },
            ),
            IconButton(
              icon: const Icon(Icons.people),
              tooltip: 'My Profile',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute<void>(
                  builder: (BuildContext context) {
                    return Scaffold(
                      appBar: AppBar(
                        title: const Text('Profile'),
                      ),
                      body: const Center(
                        child: Text(
                          'My Profile',
                          style: TextStyle(fontSize: 24),
                        ),
                      ),
                    );
                  },
                ));
              },
            ),
            IconButton(
              icon: const Icon(Icons.more_vert),
              tooltip: 'Show Snackbar',
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Hello, im yani yg comel')));
              },
            ),
          ],
        ),
        body: Container(
          color: Colors.pink[50],
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          "${DateTime.now().hour}:${DateTime.now().minute}",
                          style: const TextStyle(fontSize: 50),
                        ),
                        Text(
                          "${DateFormat('EEEE').format(DateTime.now())}, ${DateTime.now().day} ${DateFormat('MMMM').format(DateTime.now())} ${DateTime.now().year}",
                          style: const TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.all(20),
                      // color: Colors.pink,
                      padding: const EdgeInsets.all(10),
                      // decoration: BoxDecoration(
                      //     color: Colors.pink,
                      //     borderRadius: BorderRadius.circular(10)),
                      child: const Text(
                        "MENU",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        // padding: EdgeInsets.all(10),
                        // color: Colors.pink,
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/upload');
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.only(left: 40, right: 40),
                              child: const Text("Select Image"),
                            ))),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/print');
                      },
                      child: Container(
                        padding: const EdgeInsets.only(left: 40, right: 40),
                        child: const Text("Print Text"),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        )
        // body: Center(
        //   child: Container(
        //     child: Column(
        //       children: [
        //         ElevatedButton(
        //             onPressed: () {
        //               Navigator.pushNamed(context, '/upload');
        //             },
        //             child: const Column(
        //               children: [Text("upload")],
        //             ))
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
