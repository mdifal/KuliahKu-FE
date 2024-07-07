import 'package:flutter/material.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/chat/CustomUI/ContactCard.dart';
import 'package:kuliahku/ui/widgets/chat/Model/ContactModel.dart';

class SelectContact extends StatefulWidget {
  SelectContact({Key? key}) : super(key: key);

  @override
  _SelectContactState createState() => _SelectContactState();
}

class _SelectContactState extends State<SelectContact> {
  late List<ContactModel> contacts;
  late List<ContactModel> filteredContacts;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    contacts = List.generate(
      20,
          (index) => ContactModel(
        id: "index",
        name: 'User $index',
        email: 'user$index@gmail.com',
        icon: 'https://via.placeholder.com/150',
      ),
    );
    filteredContacts = contacts;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: isSearching
            ? Row(
          children: [
            Expanded(
              child: TextField(
                controller: searchController,
                style: TextStyle(color: darkBlue),
                decoration: InputDecoration(
                  hintText: "Search contacts...",
                  hintStyle: TextStyle(color: darkBlue),
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  filterContacts(value);
                },
              ),
            ),
          ],
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Select Contact",
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: isSearching ? Icon(Icons.cancel) : Icon(Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                if (!isSearching) {
                  filteredContacts = contacts;
                  searchController.clear();
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredContacts.length,
        itemBuilder: (context, index) {
          return ContactCard(
            contact: filteredContacts[index],
          );
        },
      ),
    );
  }

  void filterContacts(String query) {
    List<ContactModel> searchResult = contacts.where((contact) {
      return contact.name.toLowerCase().contains(query.toLowerCase()) ||
          contact.email.toLowerCase().contains(query.toLowerCase());
    }).toList();

    setState(() {
      filteredContacts = searchResult;
    });
  }
}
