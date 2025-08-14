import 'package:flutter/material.dart';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Screens/IndividualPage.dart';
import 'package:chatapp/database/DatabaseHelper.dart';

class ContactSelectionScreen extends StatefulWidget {
  final ChatModel sourceChat;

  ContactSelectionScreen({Key? key, required this.sourceChat}) : super(key: key);

  @override
  _ContactSelectionScreenState createState() => _ContactSelectionScreenState();
}

class _ContactSelectionScreenState extends State<ContactSelectionScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<ContactModel> _contacts = [];
  List<ContactModel> _filteredContacts = [];
  TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _searchController.addListener(_filterContacts);
  }

  Future<void> _loadContacts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load contacts from database
      List<Map<String, dynamic>> dbContacts = await _databaseHelper.getAllContacts();
      
      if (dbContacts.isEmpty) {
        // If no contacts in database, add sample contacts
        await _addSampleContacts();
        dbContacts = await _databaseHelper.getAllContacts();
      }

      _contacts = dbContacts.map((contact) => ContactModel(
        id: contact['id'],
        name: contact['name'],
        phoneNumber: contact['phoneNumber'],
        avatar: contact['avatar'],
        isSelected: false,
        isFavorite: contact['isFavorite'] == 1,
      )).toList();

      _filteredContacts = List.from(_contacts);
    } catch (e) {
      print('Error loading contacts: $e');
      // Fallback to sample contacts
      _contacts = _getSampleContacts();
      _filteredContacts = List.from(_contacts);
    }
    
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _addSampleContacts() async {
    List<ContactModel> sampleContacts = _getSampleContacts();
    
    for (var contact in sampleContacts) {
      await _databaseHelper.insertContact(
        contact.name,
        contact.phoneNumber,
        avatar: contact.avatar,
        isFavorite: contact.isFavorite,
      );
    }
  }

  List<ContactModel> _getSampleContacts() {
    return [
      ContactModel(
        name: "Alice Johnson",
        phoneNumber: "+1 234 567 8901",
        avatar: null,
        isSelected: false,
        isFavorite: true,
      ),
      ContactModel(
        name: "Bob Smith",
        phoneNumber: "+1 234 567 8902",
        avatar: null,
        isSelected: false,
        isFavorite: false,
      ),
      ContactModel(
        name: "Carol Davis",
        phoneNumber: "+1 234 567 8903",
        avatar: null,
        isSelected: false,
        isFavorite: true,
      ),
      ContactModel(
        name: "David Wilson",
        phoneNumber: "+1 234 567 8904",
        avatar: null,
        isSelected: false,
        isFavorite: false,
      ),
      ContactModel(
        name: "Emma Brown",
        phoneNumber: "+1 234 567 8905",
        avatar: null,
        isSelected: false,
        isFavorite: false,
      ),
      ContactModel(
        name: "Frank Miller",
        phoneNumber: "+1 234 567 8906",
        avatar: null,
        isSelected: false,
        isFavorite: false,
      ),
      ContactModel(
        name: "Grace Lee",
        phoneNumber: "+1 234 567 8907",
        avatar: null,
        isSelected: false,
        isFavorite: true,
      ),
      ContactModel(
        name: "Henry Taylor",
        phoneNumber: "+1 234 567 8908",
        avatar: null,
        isSelected: false,
        isFavorite: false,
      ),
      ContactModel(
        name: "Ivy Chen",
        phoneNumber: "+1 234 567 8909",
        avatar: null,
        isSelected: false,
        isFavorite: false,
      ),
      ContactModel(
        name: "Jack Anderson",
        phoneNumber: "+1 234 567 8910",
        avatar: null,
        isSelected: false,
        isFavorite: false,
      ),
      // Chinese contacts
      ContactModel(
        name: "張小明",
        phoneNumber: "+86 138 0013 8000",
        avatar: null,
        isSelected: false,
        isFavorite: true,
      ),
      ContactModel(
        name: "李美麗",
        phoneNumber: "+86 138 0013 8001",
        avatar: null,
        isSelected: false,
        isFavorite: false,
      ),
      ContactModel(
        name: "王建國",
        phoneNumber: "+86 138 0013 8002",
        avatar: null,
        isSelected: false,
        isFavorite: false,
      ),
      ContactModel(
        name: "陳雅婷",
        phoneNumber: "+86 138 0013 8003",
        avatar: null,
        isSelected: false,
        isFavorite: true,
      ),
      ContactModel(
        name: "劉志強",
        phoneNumber: "+86 138 0013 8004",
        avatar: null,
        isSelected: false,
        isFavorite: false,
      ),
    ];
  }

  void _filterContacts() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        return contact.name.toLowerCase().contains(query) ||
               contact.phoneNumber.contains(query);
      }).toList();
    });
  }

  void _toggleContactSelection(int index) {
    setState(() {
      _filteredContacts[index].isSelected = !_filteredContacts[index].isSelected;
    });
  }

  void _addNewContact() {
    showDialog(
      context: context,
      builder: (context) => _ContactEditDialog(
        contact: null,
        onSave: (contact) async {
          // Add to database
          int newId = await _databaseHelper.insertContact(
            contact.name,
            contact.phoneNumber,
            avatar: contact.avatar,
            isFavorite: contact.isFavorite,
          );
          
          // Add to local list
          contact.id = newId;
          setState(() {
            _contacts.add(contact);
            _filterContacts(); // Refresh filtered list
          });
          
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contact added successfully')),
          );
        },
      ),
    );
  }

  void _editContact(int index) {
    final contact = _filteredContacts[index];
    showDialog(
      context: context,
      builder: (context) => _ContactEditDialog(
        contact: contact,
        onSave: (updatedContact) async {
          // Update in database
          await _databaseHelper.updateContact(
            contact.id!,
            updatedContact.name,
            updatedContact.phoneNumber,
            avatar: updatedContact.avatar,
            isFavorite: updatedContact.isFavorite,
          );
          
          // Update in local list
          setState(() {
            contact.name = updatedContact.name;
            contact.phoneNumber = updatedContact.phoneNumber;
            contact.avatar = updatedContact.avatar;
            contact.isFavorite = updatedContact.isFavorite;
            _filterContacts(); // Refresh filtered list
          });
          
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Contact updated successfully')),
          );
        },
      ),
    );
  }

  void _deleteContact(int index) {
    final contact = _filteredContacts[index];
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${contact.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              // Delete from database
              await _databaseHelper.deleteContact(contact.id!);
              
              // Remove from local list
              setState(() {
                _contacts.removeWhere((c) => c.id == contact.id);
                _filterContacts(); // Refresh filtered list
              });
              
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Contact deleted successfully')),
              );
            },
            child: Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _toggleFavorite(int index) async {
    final contact = _filteredContacts[index];
    final newFavoriteStatus = !contact.isFavorite;
    
    // Update in database
    await _databaseHelper.toggleFavorite(contact.id!, newFavoriteStatus);
    
    // Update in local list
    setState(() {
      contact.isFavorite = newFavoriteStatus;
      _filterContacts(); // Refresh filtered list
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(newFavoriteStatus ? 'Added to favorites' : 'Removed from favorites'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  void _startChat() {
    final selectedContacts = _filteredContacts.where((contact) => contact.isSelected).toList();
    
    if (selectedContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select at least one contact')),
      );
      return;
    }

    // For now, we'll start a chat with the first selected contact
    // In a real app, you might want to create a group chat if multiple contacts are selected
    final selectedContact = selectedContacts.first;
    
    // Create a new chat model
    final newChat = ChatModel(
      name: selectedContact.name,
      isGroup: false,
      currentMessage: "",
      time: DateTime.now().toString().substring(10, 16),
      icon: "person.svg",
      id: DateTime.now().millisecondsSinceEpoch,
      status: "Online",
    );

    // Navigate to the chat screen
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => IndividualPage(
          chatModel: newChat,
          sourchat: widget.sourceChat,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Contact', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF075E54),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person_add, color: Colors.white),
            onPressed: _addNewContact,
            tooltip: 'Add Contact',
          ),
          if (_filteredContacts.any((contact) => contact.isSelected))
            TextButton(
              onPressed: _startChat,
              child: Text(
                'Start Chat',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Container(
            padding: EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
          ),
          
          // Contact list
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: _filteredContacts.length,
                    itemBuilder: (context, index) {
                      final contact = _filteredContacts[index];
                                             return ListTile(
                         leading: CircleAvatar(
                           backgroundColor: contact.isSelected 
                               ? Color(0xFF25D366) 
                               : Colors.grey[300],
                           child: contact.isSelected
                               ? Icon(Icons.check, color: Colors.white)
                               : Text(
                                   contact.name.isNotEmpty 
                                       ? contact.name[0].toUpperCase() 
                                       : '?',
                                   style: TextStyle(
                                     color: Colors.grey[700],
                                     fontWeight: FontWeight.bold,
                                   ),
                                 ),
                         ),
                         title: Row(
                           children: [
                             Expanded(
                               child: Text(
                                 contact.name,
                                 style: TextStyle(
                                   fontWeight: FontWeight.w500,
                                   color: contact.isSelected ? Color(0xFF25D366) : Colors.black,
                                 ),
                               ),
                             ),
                             if (contact.isFavorite)
                               Icon(Icons.star, color: Colors.amber, size: 16),
                           ],
                         ),
                         subtitle: Text(
                           contact.phoneNumber,
                           style: TextStyle(
                             color: contact.isSelected ? Color(0xFF25D366) : Colors.grey[600],
                           ),
                         ),
                         trailing: Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                             if (contact.isSelected)
                               Icon(Icons.check_circle, color: Color(0xFF25D366)),
                             PopupMenuButton<String>(
                               icon: Icon(Icons.more_vert, color: Colors.grey[600]),
                               onSelected: (value) {
                                 switch (value) {
                                   case 'edit':
                                     _editContact(index);
                                     break;
                                   case 'delete':
                                     _deleteContact(index);
                                     break;
                                   case 'favorite':
                                     _toggleFavorite(index);
                                     break;
                                 }
                               },
                               itemBuilder: (context) => [
                                 PopupMenuItem(
                                   value: 'edit',
                                   child: Row(
                                     children: [
                                       Icon(Icons.edit, color: Colors.blue),
                                       SizedBox(width: 8),
                                       Text('Edit'),
                                     ],
                                   ),
                                 ),
                                 PopupMenuItem(
                                   value: 'favorite',
                                   child: Row(
                                     children: [
                                       Icon(
                                         contact.isFavorite ? Icons.star_border : Icons.star,
                                         color: Colors.amber,
                                       ),
                                       SizedBox(width: 8),
                                       Text(contact.isFavorite ? 'Remove from favorites' : 'Add to favorites'),
                                     ],
                                   ),
                                 ),
                                 PopupMenuItem(
                                   value: 'delete',
                                   child: Row(
                                     children: [
                                       Icon(Icons.delete, color: Colors.red),
                                       SizedBox(width: 8),
                                       Text('Delete'),
                                     ],
                                   ),
                                 ),
                               ],
                             ),
                           ],
                         ),
                         onTap: () => _toggleContactSelection(index),
                       );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

class _ContactEditDialog extends StatefulWidget {
  final ContactModel? contact;
  final Function(ContactModel) onSave;

  _ContactEditDialog({required this.contact, required this.onSave});

  @override
  _ContactEditDialogState createState() => _ContactEditDialogState();
}

class _ContactEditDialogState extends State<_ContactEditDialog> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _phoneController = TextEditingController(text: widget.contact?.phoneNumber ?? '');
    _isFavorite = widget.contact?.isFavorite ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.contact == null ? 'Add Contact' : 'Edit Contact'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            SizedBox(height: 16),
            SwitchListTile(
              title: Text('Add to Favorites'),
              value: _isFavorite,
              onChanged: (value) {
                setState(() {
                  _isFavorite = value;
                });
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty && _phoneController.text.isNotEmpty) {
              final contact = ContactModel(
                id: widget.contact?.id,
                name: _nameController.text.trim(),
                phoneNumber: _phoneController.text.trim(),
                avatar: widget.contact?.avatar,
                isSelected: false,
                isFavorite: _isFavorite,
              );
              widget.onSave(contact);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Please fill in all fields')),
              );
            }
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}

class ContactModel {
  int? id;
  String name;
  String phoneNumber;
  String? avatar;
  bool isSelected;
  bool isFavorite;

  ContactModel({
    this.id,
    required this.name,
    required this.phoneNumber,
    this.avatar,
    this.isSelected = false,
    this.isFavorite = false,
  });
}
