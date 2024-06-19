import 'package:crud/firebase_service.dart';
import 'package:crud/item_model.dart';
import 'package:flutter/material.dart';

class SubitemsPage extends StatelessWidget {
  final Item item;
  final FirebaseService firebaseService;

  const SubitemsPage({
    Key? key,
    required this.item,
    required this.firebaseService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Subitems for ${item.name}'),
      ),
      body: StreamBuilder<List<SubItem>>(
        stream: firebaseService.getSubitems(item.id!),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const CircularProgressIndicator();

          List<SubItem> subitems = snapshot.data!;

          return ListView.builder(
            itemCount: subitems.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(subitems[index].name),
                subtitle: Text('Quantity: ${subitems[index].quantity}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        _editSubitemDialog(context, item, subitems[index]);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        _deleteSubitemDialog(context, item, subitems[index]);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addSubitemDialog(context, item);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _addSubitemDialog(BuildContext context, Item item) {
    TextEditingController nameController = TextEditingController();
    TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Subitem'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Add'),
              onPressed: () {
                SubItem newSubitem = SubItem(
                  name: nameController.text,
                  quantity: int.parse(quantityController.text),
                  id: '',
                );
                firebaseService.addSubcollection(item.id!, newSubitem);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _editSubitemDialog(BuildContext context, Item item, SubItem subitem) {
    TextEditingController nameController =
        TextEditingController(text: subitem.name);
    TextEditingController quantityController =
        TextEditingController(text: subitem.quantity.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Subitem'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Update'),
              onPressed: () {
                subitem.name = nameController.text;
                subitem.quantity = int.parse(quantityController.text);
                firebaseService.updateSubitem(item.id!, subitem);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteSubitemDialog(BuildContext context, Item item, SubItem subitem) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Subitem'),
          content: const Text('Are you sure you want to delete this subitem?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () {
                firebaseService.deleteSubitem(item.id!, subitem.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
