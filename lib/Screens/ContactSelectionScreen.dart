import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:chatapp/Model/ChatModel.dart';
import 'package:chatapp/Screens/IndividualPage.dart';
import 'package:chatapp/database/DatabaseHelper.dart';

// Immutable ContactModel for safe state management
class ContactModel {
  final int? id;
  final String name;
  final String phoneNumber;
  final String? avatar;
  final bool isSelected;
  final bool isFavorite;

  ContactModel({
    this.id,
    required this.name,
    required this.phoneNumber,
    this.avatar,
    this.isSelected = false,
    this.isFavorite = false,
  });

  // CopyWith method for immutable updates
  ContactModel copyWith({
    int? id,
    String? name,
    String? phoneNumber,
    String? avatar,
    bool? isSelected,
    bool? isFavorite,
  }) {
    return ContactModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      avatar: avatar ?? this.avatar,
      isSelected: isSelected ?? this.isSelected,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class ContactSelectionScreen extends StatefulWidget {
  final ChatModel sourceChat;

  const ContactSelectionScreen({
    Key? key,
    required this.sourceChat,
  }) : super(key: key);

  @override
  _ContactSelectionScreenState createState() => _ContactSelectionScreenState();
}

class _ContactSelectionScreenState extends State<ContactSelectionScreen> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  List<ContactModel> _contacts = [];
  List<ContactModel> _filteredContacts = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = true;
  bool _hasDbError = false;
  final _debounceDuration = const Duration(milliseconds: 300);
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  // Debounced search to avoid excessive UI rebuilds
  void _onSearchChanged() {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(_debounceDuration, () {
      if (mounted) _filterContacts();
    });
  }

  // Load contacts from DB (with fallback to samples)
  Future<void> _loadContacts() async {
    setState(() {
      _isLoading = true;
      _hasDbError = false;
    });

    try {
      final dbContacts = await _databaseHelper.getAllContacts();
      
      if (dbContacts.isEmpty) {
        await _addSampleContactsToDb();
        final updatedDbContacts = await _databaseHelper.getAllContacts();
        _contacts = _mapDbToContactModels(updatedDbContacts);
      } else {
        _contacts = _mapDbToContactModels(dbContacts);
      }

      _sortContacts();
      _filteredContacts = List.from(_contacts);

    } catch (e, stackTrace) {
      debugPrint('DB Error loading contacts: $e\n$stackTrace');
      setState(() {
        _hasDbError = true;
        _contacts = _getSampleContacts();
        _filteredContacts = List.from(_contacts);
      });
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // Map database rows to ContactModel list
  List<ContactModel> _mapDbToContactModels(List<Map<String, dynamic>> dbRows) {
    return dbRows.map((row) => ContactModel(
      id: row['id'],
      name: row['name'] ?? 'Unknown Contact',
      phoneNumber: row['phoneNumber'] ?? '',
      avatar: row['avatar'],
      isFavorite: row['isFavorite'] == 1,
    )).toList();
  }

  // Add sample contacts to database (persistent)
  Future<void> _addSampleContactsToDb() async {
    final sampleContacts = _getSampleContacts();
    for (final contact in sampleContacts) {
      await _databaseHelper.insertContact(
        contact.name,
        contact.phoneNumber,
        avatar: contact.avatar,
        isFavorite: contact.isFavorite,
      );
    }
  }

  // In-memory sample contacts (for DB fallback)
  List<ContactModel> _getSampleContacts() {
    return [
      ContactModel(name: "Alice Johnson", phoneNumber: "+1 234 567 8901", isFavorite: true),
      ContactModel(name: "Bob Smith", phoneNumber: "+1 234 567 8902"),
      ContactModel(name: "Carol Davis", phoneNumber: "+1 234 567 8903", isFavorite: true),
      ContactModel(name: "David Wilson", phoneNumber: "+1 234 567 8904"),
      ContactModel(name: "Emma Brown", phoneNumber: "+1 234 567 8905"),
      // Chinese contacts
      ContactModel(name: "張小明", phoneNumber: "+86 138 0013 8000", isFavorite: true),
      ContactModel(name: "李美麗", phoneNumber: "+86 138 0013 8001"),
      ContactModel(name: "王建國", phoneNumber: "+86 138 0013 8002"),
      ContactModel(name: "陳雅婷", phoneNumber: "+86 138 0013 8003", isFavorite: true),
      ContactModel(name: "劉志強", phoneNumber: "+86 138 0013 8004"),
    ];
  }

  // Sort contacts: Favorites → Alphabetical (A-Z)
  void _sortContacts() {
    _contacts.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return a.name.compareTo(b.name);
    });
  }

  // Filter contacts by search query
  void _filterContacts() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      _filteredContacts = _contacts.where((contact) {
        return contact.name.toLowerCase().contains(query) ||
               contact.phoneNumber.contains(query);
      }).toList();
    });
  }

  // Toggle contact selection (immutable update)
  void _toggleContactSelection(int index) {
    setState(() {
      final currentContact = _filteredContacts[index];
      _filteredContacts[index] = currentContact.copyWith(
        isSelected: !currentContact.isSelected,
      );
    });
  }

  // Open bottom sheet to add new contact
  void _addNewContact() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _ContactEditSheet(
        isEditing: false,
        onSave: _handleAddContactToDb,
      ),
    );
  }

  // Open bottom sheet to edit existing contact
  void _editContact(ContactModel contact) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => _ContactEditSheet(
        isEditing: true,
        contact: contact,
        onSave: (updatedContact) => _handleUpdateContactInDb(contact, updatedContact),
      ),
    );
  }

  // DB: Add new contact
  Future<void> _handleAddContactToDb(ContactModel newContact) async {
    try {
      final newContactId = await _databaseHelper.insertContact(
        newContact.name,
        newContact.phoneNumber,
        avatar: newContact.avatar,
        isFavorite: newContact.isFavorite,
      );

      final contactWithId = newContact.copyWith(id: newContactId);
      setState(() {
        _contacts.add(contactWithId);
        _sortContacts();
        _filterContacts();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact added successfully')),
        );
      }
    } catch (e) {
      _showDbErrorSnackBar('Failed to add contact');
      debugPrint('DB Add Error: $e');
    }
  }

  // DB: Update existing contact
  Future<void> _handleUpdateContactInDb(ContactModel oldContact, ContactModel updatedContact) async {
    try {
      await _databaseHelper.updateContact(
        oldContact.id!,
        updatedContact.name,
        updatedContact.phoneNumber,
        avatar: updatedContact.avatar,
        isFavorite: updatedContact.isFavorite,
      );

      setState(() {
        final index = _contacts.indexOf(oldContact);
        if (index != -1) {
          _contacts[index] = updatedContact;
        }
        _sortContacts();
        _filterContacts();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact updated successfully')),
        );
      }
    } catch (e) {
      _showDbErrorSnackBar('Failed to update contact');
      debugPrint('DB Update Error: $e');
    }
  }

  // DB: Delete contact (with confirmation)
  Future<void> _deleteContact(ContactModel contact) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Contact'),
        content: Text('Are you sure you want to delete ${contact.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await _databaseHelper.deleteContact(contact.id!);

                setState(() {
                  _contacts.remove(contact);
                  _filterContacts();
                });

                if (mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${contact.name} deleted')),
                  );
                }
              } catch (e) {
                if (mounted) Navigator.pop(context);
                _showDbErrorSnackBar('Failed to delete contact');
                debugPrint('DB Delete Error: $e');
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // DB: Toggle favorite status
  Future<void> _toggleFavorite(ContactModel contact) async {
    final newFavoriteStatus = !contact.isFavorite;
    try {
      await _databaseHelper.toggleFavorite(contact.id!, newFavoriteStatus);

      setState(() {
        final index = _contacts.indexOf(contact);
        if (index != -1) {
          _contacts[index] = contact.copyWith(isFavorite: newFavoriteStatus);
        }
        _sortContacts();
        _filterContacts();
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(newFavoriteStatus 
                ? 'Added to favorites' 
                : 'Removed from favorites'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      _showDbErrorSnackBar('Failed to update favorites');
      debugPrint('DB Favorite Error: $e');
    }
  }

  // Start chat with selected contact
  void _startChat() {
    final selectedContacts = _filteredContacts.where((c) => c.isSelected).toList();

    if (selectedContacts.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one contact')),
      );
      return;
    }

    final selectedContact = selectedContacts.first;
    final newChat = ChatModel(
      name: selectedContact.name,
      isGroup: false,
      currentMessage: "",
      time: TimeOfDay.now().format(context),
      icon: "person.svg",
      id: DateTime.now().millisecondsSinceEpoch,
      status: "Online",
      profileImage: selectedContact.avatar,
    );

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

  // Show database error snackbar
  void _showDbErrorSnackBar(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasSelectedContacts = _filteredContacts.any((c) => c.isSelected);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Contact', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF075E54),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
          splashRadius: 24,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add, color: Colors.white),
            onPressed: _addNewContact,
            tooltip: 'Add Contact',
            splashRadius: 24,
          ),
          if (hasSelectedContacts)
            TextButton(
              onPressed: _startChat,
              child: const Text(
                'Start Chat',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search contacts...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),

          // Main Content (Loading/Error/List)
          Expanded(
            child: _buildMainContent(theme),
          ),
        ],
      ),
    );
  }

  // Build loading, error, or contact list state
  Widget _buildMainContent(ThemeData theme) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF075E54)));
    }

    if (_hasDbError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 24),
              const Text(
                'Database Error',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Failed to load contacts from storage. Using temporary data.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadContacts,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      );
    }

    if (_filteredContacts.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.contacts, size: 80, color: const Color.fromARGB(77, 158, 158, 158)),
              const SizedBox(height: 24),
              const Text(
                'No contacts found',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Text(
                _searchController.text.isNotEmpty
                    ? 'Try a different search term'
                    : 'Your contacts will appear here',
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.hintColor),
              ),
            ],
          ),
        ),
      );
    }

    return _buildContactList(theme);
  }

  // Build contact list with favorites section
  Widget _buildContactList(ThemeData theme) {
    final favorites = _filteredContacts.where((c) => c.isFavorite).toList();
    final regularContacts = _filteredContacts.where((c) => !c.isFavorite).toList();

    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: (favorites.isNotEmpty ? 1 : 0) + favorites.length + regularContacts.length,
      itemBuilder: (context, index) {
        // Favorites Header
        if (favorites.isNotEmpty && index == 0) {
          return const Padding(
            padding: EdgeInsets.only(top: 16, left: 16, bottom: 8),
            child: Text(
              'Favorites',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          );
        }

        // Adjust index for favorites
        final adjustedIndex = favorites.isNotEmpty ? index - 1 : index;
        
        // Build Favorite Contacts
        if (favorites.isNotEmpty && adjustedIndex < favorites.length) {
          return _buildContactTile(favorites[adjustedIndex], theme);
        }

        // Build Regular Contacts
        final regularIndex = favorites.isNotEmpty 
            ? adjustedIndex - favorites.length 
            : adjustedIndex;
        return _buildContactTile(regularContacts[regularIndex], theme);
      },
    );
  }

  // Build individual contact list tile
  Widget _buildContactTile(ContactModel contact, ThemeData theme) {
    return ListTile(
      leading: _buildContactAvatar(contact),
      title: Row(
        children: [
          Expanded(
            child: Text(
              contact.name,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: contact.isSelected ? const Color(0xFF25D366) : theme.textTheme.bodyLarge?.color,
              ),
            ),
          ),
          if (contact.isFavorite)
            const Icon(Icons.star, color: Colors.amber, size: 16),
        ],
      ),
      subtitle: Text(
        contact.phoneNumber,
        style: TextStyle(
          color: contact.isSelected ? const Color(0xFF25D366) : theme.hintColor,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (contact.isSelected)
            const Icon(Icons.check_circle, color: Color(0xFF25D366)),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            onSelected: (value) {
              switch (value) {
                case 'edit':
                  _editContact(contact);
                  break;
                case 'favorite':
                  _toggleFavorite(contact);
                  break;
                case 'delete':
                  _deleteContact(contact);
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
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
                    const SizedBox(width: 8),
                    Text(contact.isFavorite 
                        ? 'Remove from favorites' 
                        : 'Add to favorites'),
                  ],
                ),
              ),
              const PopupMenuItem(
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
      onTap: () => _toggleContactSelection(_filteredContacts.indexOf(contact)),
    );
  }

  // Build contact avatar (initials fallback)
  Widget _buildContactAvatar(ContactModel contact) {
    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: contact.isSelected
            ? const Color(0xFF25D366)
            : Colors.grey[200],
      ),
      child: Center(
        child: Text(
          contact.name.isNotEmpty ? contact.name[0].toUpperCase() : '?',
          style: TextStyle(
            color: contact.isSelected ? Colors.white : Colors.grey[700],
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

// Contact Edit Bottom Sheet (replaces AlertDialog)
class _ContactEditSheet extends StatefulWidget {
  final bool isEditing;
  final ContactModel? contact;
  final Function(ContactModel) onSave;

  const _ContactEditSheet({
    required this.isEditing,
    this.contact,
    required this.onSave,
  });

  @override
  __ContactEditSheetState createState() => __ContactEditSheetState();
}

class __ContactEditSheetState extends State<_ContactEditSheet> {
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  bool _isFavorite = false;
  bool _isNameValid = true;
  bool _isPhoneValid = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.contact?.name ?? '');
    _phoneController = TextEditingController(text: widget.contact?.phoneNumber ?? '');
    _isFavorite = widget.contact?.isFavorite ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  // Validate form before saving
  bool _validateForm() {
    bool isValid = true;

    setState(() {
      _isNameValid = _nameController.text.trim().isNotEmpty;
      _isPhoneValid = _phoneController.text.trim().isNotEmpty;
    });

    if (!_isNameValid) {
      _showError('Please enter a name');
      isValid = false;
    } else if (!_isPhoneValid) {
      _showError('Please enter a phone number');
      isValid = false;
    }

    return isValid;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 16,
        right: 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.isEditing ? 'Edit Contact' : 'Add New Contact',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 24),

          // Name Input
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              errorText: _isNameValid ? null : 'Name is required',
              prefixIcon: const Icon(Icons.person),
              border: const OutlineInputBorder(),
            ),
            textCapitalization: TextCapitalization.words,
            autofocus: true,
            onChanged: (_) => setState(() => _isNameValid = true),
          ),
          const SizedBox(height: 16),

          // Phone Input
          TextField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: 'Phone Number',
              errorText: _isPhoneValid ? null : 'Phone number is required',
              prefixIcon: const Icon(Icons.phone),
              border: const OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              _PhoneNumberFormatter(),
            ],
            onChanged: (_) => setState(() => _isPhoneValid = true),
          ),
          const SizedBox(height: 16),

          // Favorite Toggle
          SwitchListTile(
            title: const Text('Add to Favorites'),
            value: _isFavorite,
            onChanged: (value) => setState(() => _isFavorite = value),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 24),

          // Buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    if (_validateForm()) {
                      final newContact = ContactModel(
                        id: widget.contact?.id,
                        name: _nameController.text.trim(),
                        phoneNumber: _phoneController.text.trim(),
                        isFavorite: _isFavorite,
                      );
                      widget.onSave(newContact);
                      Navigator.pop(context);
                    }
                  },
                  child: Text(widget.isEditing ? 'Update' : 'Save'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

// Phone number formatter (adds spaces every 3 digits)
class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final buffer = StringBuffer();

    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if ((i + 1) % 3 == 0 && i != digits.length - 1) {
        buffer.write(' ');
      }
    }

    return newValue.copyWith(
      text: buffer.toString(),
      selection: TextSelection.collapsed(offset: buffer.length),
    );
  }
}