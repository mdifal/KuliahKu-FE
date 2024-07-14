import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:kuliahku/ui/shared/global.dart';
import 'package:kuliahku/ui/shared/style.dart';
import 'package:kuliahku/ui/widgets/text_field.dart';

import '../CustomUI/ContactCard.dart';
import '../Model/ContactModel.dart';

class NewChatPage extends StatefulWidget {
  const NewChatPage({Key? key}) : super(key: key);

  @override
  State<NewChatPage> createState() => _NewChatPageState();
}

class _NewChatPageState extends State<NewChatPage> {
  late List<ContactModel> contacts;
  late List<ContactModel> filteredContacts;
  TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  Future<void> fetchUsersData() async {
    try {
      final query = searchController.text.toLowerCase();
      var url = 'http://$ipUrl/users/search?email=$query';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final List<dynamic> ListContact = json.decode(response.body);
        setState(() {
          contacts = ListContact.map((data) {
            return ContactModel(
              name: data['fullname'] ?? 'unknown',
              icon: data['profilePict'] ?? '',
              email: data['id'],
            );
          }).toList();
          filteredContacts = contacts;
        });
      } else {
        throw Exception('Failed to fetch chats data');
      }
    } catch (error) {
      print('Error fetching chats data: $error');
      throw Exception('Failed to fetch chats data');
    }
  }

  @override
  void initState() {
    super.initState();
    contacts = [];
    filteredContacts = [];
    searchController.addListener(() {
      // Hapus listener ini jika Anda hanya ingin memanggil saat submitted.
    });
  }

  void filterContacts() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredContacts = contacts.where((contact) {
        return contact.name.toLowerCase().contains(query) || contact.email.toLowerCase().contains(query);
      }).toList();
    });
  }

  void onSearchSubmitted(String query) {
    fetchUsersData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chat Baru',
          style: TextStyle(
            color: white,
            fontFamily: 'Poppins',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: mainColor,
        iconTheme: IconThemeData(
          color: white,
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: secondaryColor.withOpacity(0.6),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: CustomTextFieldNoLabel(
                      password: false,
                      placeholder: "Search",
                      controller: searchController,
                      onSubmitted: onSearchSubmitted, // Tambahkan ini
                    ),
                  ),
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 15),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: filteredContacts.isEmpty
                  ? Center(child: Text('Search your friend by email'))
                  : ListView.builder(
                itemCount: filteredContacts.length,
                itemBuilder: (context, index) {
                  return ContactCard(
                    contact: filteredContacts[index],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
