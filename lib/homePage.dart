// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/rendering.dart';

// import 'biodata_service.dart';

// class Homepage extends StatefulWidget {
//   const Homepage({super.key});

//   @override
//   State<Homepage> createState() => _HomepageState();
// }

// class _HomepageState extends State<Homepage> {
//   BiodataService? service;
//   String? selectedDocId; // Fixed variable name casing
  
//   final nameController = TextEditingController(); // Moved controllers to class level
//   final ageController = TextEditingController();
//   final addressController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     service = BiodataService(FirebaseFirestore.instance);
//   }

//   @override
//   void dispose() {
//     nameController.dispose(); // Added disposal of controllers
//     ageController.dispose();
//     addressController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//             child: Padding(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             children: [
//               TextField(
//                 controller: nameController,
//                 decoration: const InputDecoration(labelText: "Name"),
//               ),
//               TextField(
//                 controller: ageController,
//                 decoration: const InputDecoration(labelText: "Age"),
//               ),
//               TextField(
//                 controller: addressController,
//                 decoration: const InputDecoration(labelText: "Address"),
//               ),
//               Expanded(
//                 child: StreamBuilder(
//                   stream: service?.getBiodata(),
//                   builder: (context, snapshot) {
//                     if (snapshot.connectionState == ConnectionState.waiting ||
//                         snapshot.connectionState == ConnectionState.none) {
//                       return const Center(child: CircularProgressIndicator());
//                     } else if (snapshot.hasError) {
//                       return Text('Error fetching data: ${snapshot.error}');
//                     } else if (snapshot.hasData &&
//                         snapshot.data?.docs.isEmpty == true) {
//                       return const Center(child: Text('Empty documents'));
//                     }

//                     final documents = snapshot.data?.docs;
//                     return ListView.builder(
//                       shrinkWrap: true,
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: documents?.length ?? 0,
//                       itemBuilder: (context, index) {
//                         final doc = documents?[index];
//                         return ListTile(
//                           title: Text(doc?['name'] ?? ''),
//                           subtitle: Text(doc?['age'] ?? ''),
//                           onTap: () {
//                             setState(() {
//                               nameController.text = doc?['name'] ?? '';
//                               ageController.text = doc?['age'] ?? '';
//                               addressController.text = doc?['address'] ?? '';
//                               selectedDocId = doc?.id;
//                             });
//                           },

//                           // Added delete functionality
//                           trailing: IconButton(
//                             icon: const Icon(Icons.delete),
//                             onPressed: () {
//                               if (doc != null) {
//                                 service?.delete(doc.id);
//                               }
                              
//                             },
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         )),
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             if (nameController.text.isEmpty ||
//                 ageController.text.isEmpty ||
//                 addressController.text.isEmpty) {
//               ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(content: Text('Please fill all the fields')));
//               return;
//             }

//             final data = {
//               'name': nameController.text.trim(),
//               'age': ageController.text.trim(),
//               'address': addressController.text.trim()
//             };

//             if (selectedDocId != null) {
//               service?.update(selectedDocId!, data);
//             } else {
//               service?.add(data);
//             }

//             // Clear the fields after adding/updating
//             nameController.clear();
//             ageController.clear();
//             addressController.clear();
//             setState(() {
//               selectedDocId = null;
//             });
//           },
//           child: const Icon(Icons.add),
//         ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'biodata_service.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  BiodataService? service;
  String? selectedDocId;
  
  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final addressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    service = BiodataService(FirebaseFirestore.instance);
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Biodata Manager'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Name",
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: ageController,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Age",
                          prefixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: addressController,
                        decoration: const InputDecoration(
                          labelText: "Address",
                          prefixIcon: Icon(Icons.home),
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: StreamBuilder(
                  stream: service?.getBiodata(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
                      return const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.no_accounts, size: 64, color: Colors.grey),
                            SizedBox(height: 16),
                            Text('No data available'),
                          ],
                        ),
                      );
                    }

                    final documents = snapshot.data?.docs;
                    return Card(
                      elevation: 4,
                      child: ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemCount: documents?.length ?? 0,
                        separatorBuilder: (context, index) => const Divider(),
                        itemBuilder: (context, index) {
                          final doc = documents?[index];
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(
                                doc?['name']?[0] ?? '?',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                            title: Text(
                              doc?['name'] ?? '',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Age: ${doc?['age'] ?? ''}'),
                                Text('Address: ${doc?['address'] ?? ''}'),
                              ],
                            ),
                            isThreeLine: true,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit),
                                  onPressed: () {
                                    setState(() {
                                      nameController.text = doc?['name'] ?? '';
                                      ageController.text = doc?['age'] ?? '';
                                      addressController.text = doc?['address'] ?? '';
                                      selectedDocId = doc?.id;
                                    });
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                        title: const Text('Delete Confirmation'),
                                        content: const Text('Are you sure you want to delete this item?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(context),
                                            child: const Text('Cancel'),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              if (doc != null) {
                                                service?.delete(doc.id);
                                              }
                                              Navigator.pop(context);
                                            },
                                            child: const Text('Delete', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (nameController.text.isEmpty ||
              ageController.text.isEmpty ||
              addressController.text.isEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please fill all the fields'),
                backgroundColor: Colors.red,
              ),
            );
            return;
          }

          final data = {
            'name': nameController.text.trim(),
            'age': ageController.text.trim(),
            'address': addressController.text.trim()
          };

          if (selectedDocId != null) {
            service?.update(selectedDocId!, data);
          } else {
            service?.add(data);
          }

          nameController.clear();
          ageController.clear();
          addressController.clear();
          setState(() {
            selectedDocId = null;
          });
        },
        icon: Icon(selectedDocId != null ? Icons.save : Icons.add),
        label: Text(selectedDocId != null ? 'Update' : 'Add New'),
      ),
    );
  }
}