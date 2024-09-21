import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firestore_demo/item_card.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MainPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference users = firestore.collection('users');

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.purple,
          title: StreamBuilder<DocumentSnapshot>(
              stream: users.doc('T2MEcpr9s2rvIYUSu6cG').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data != null) {
                  final data = snapshot.data!.data() as Map<String, dynamic>?;
                  final age = data?['age'] ?? 'Unknown Age';
                  return Text(
                    '$age',
                    style: const TextStyle(color: Colors.white),
                  );
                } else {
                  return const Text(
                    'Loading',
                    style: TextStyle(color: Colors.white),
                  );
                }
              }),
        ),
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            ListView(
              children: [
                //// VIEW DATA HERE
                // Note: 1x Ambil
                // FutureBuilder<QuerySnapshot>(
                //   future: users.get(),
                //   builder: (context, snapshot) {
                //     // Check if the snapshot has data
                //     if (snapshot.hasData) {
                //       // Ensure snapshot.data is not null before accessing docs
                //       var docs = snapshot.data?.docs ?? [];

                //       return Column(
                //         children: docs.map((e) {
                //           // Ensure that e.data() returns a map by casting it properly
                //           final data = e.data() as Map<String, dynamic>;

                //           return ItemCard(
                //             data['name'] ??
                //                 'No Name', // Ensure the key exists, or use a default
                //             data['age'] ?? 0,
                //             onUpdate: () {},
                //             onDelete:
                //                 () {}, // Ensure the key exists, or use a default
                //           );
                //         }).toList(),
                //       );
                //     } else if (snapshot.hasError) {
                //       // Handle error case
                //       return Text('Error: ${snapshot.error}');
                //     } else {
                //       // Show loading while waiting for data
                //       return const Text('Loading');
                //     }
                //   },
                // ),

                //SYNCED
                StreamBuilder<QuerySnapshot>(
                  stream: users.snapshots(),
                  builder: (context, snapshot) {
                    // Check if the snapshot has data
                    if (snapshot.hasData) {
                      // Ensure snapshot.data is not null before accessing docs
                      var docs = snapshot.data?.docs ?? [];

                      return Column(
                        children: docs.map((e) {
                          // Ensure that e.data() returns a map by casting it properly
                          final data = e.data() as Map<String, dynamic>;

                          return ItemCard(
                            data['name'] ??
                                'No Name', // Ensure the key exists, or use a default
                            data['age'] ?? 0,
                            onUpdate: () {
                              final age =
                                  (e.data() as Map<String, dynamic>?)?['age'];
                              if (age != null && age is int) {
                                users.doc(e.id).update({'age': age + 1});
                              } else {
                                return const Text(
                                    "Error: Age is null or not an integer.");
                              }
                            },
                            onDecrease: () {
                              final age =
                                  (e.data() as Map<String, dynamic>?)?['age'];
                              if (age != null && age is int) {
                                users.doc(e.id).update({'age': age - 1});
                              } else {
                                return const Text(
                                    "Error: Age is null or not an integer.");
                              }
                            },
                            onDelete: () {
                              users.doc(e.id).delete();
                            }, // Ensure the key exists, or use a default
                          );
                        }).toList(),
                      );
                    } else if (snapshot.hasError) {
                      // Handle error case
                      return Text('Error: ${snapshot.error}');
                    } else {
                      // Show loading while waiting for data
                      return const Text('Loading');
                    }
                  },
                ),
                const SizedBox(
                  height: 150,
                )
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration:
                      const BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(-5, 0),
                        blurRadius: 15,
                        spreadRadius: 3)
                  ]),
                  width: double.infinity,
                  height: 130,
                  child: Row(
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width - 160,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: nameController,
                              decoration:
                                  const InputDecoration(hintText: "Name"),
                            ),
                            TextField(
                              style: GoogleFonts.poppins(),
                              controller: ageController,
                              decoration:
                                  const InputDecoration(hintText: "Age"),
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 130,
                        width: 130,
                        padding: const EdgeInsets.fromLTRB(15, 15, 0, 15),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.zero,
                                backgroundColor: Colors.purple,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                            child: Text(
                              'Add Data',
                              style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed: () {
                              //// ADD DATA HERE
                              users.add({
                                'name': nameController.text,
                                'age': int.tryParse(ageController.text) ?? 0
                              });
                              nameController.text = '';
                              ageController.text = '';
                            }),
                      )
                    ],
                  ),
                )),
          ],
        ));
  }
}
