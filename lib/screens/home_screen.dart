import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:stash_notes/screens/login_screen.dart';
import 'package:stash_notes/screens/note_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class Note {
  final String id;
  final String title;
  final String description;

  Note({required this.id, required this.title, required this.description});

  factory Note.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Note(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'timestamp': FieldValue.serverTimestamp(),
    };
  }
}

class _HomeScreenState extends State<HomeScreen> {
  String _searchQuery = '';
  final Set<String> _selectedNoteIds = {};
  bool _fabExpanded = false;

  Stream<List<Note>> get _notesStream {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return const Stream.empty();
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notes')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => Note.fromDoc(doc)).toList(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_selectedNoteIds.isNotEmpty) {
          setState(() => _selectedNoteIds.clear());
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title:
              _selectedNoteIds.isNotEmpty
                  ? Text('${_selectedNoteIds.length} selected')
                  : Text('My Notes'),
          actions:
              _selectedNoteIds.isNotEmpty
                  ? [
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: _deleteSelectedNotes,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => setState(() => _selectedNoteIds.clear()),
                    ),
                  ]
                  : [
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: _logout,
                    ),
                  ],
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: StreamBuilder<List<Note>>(
                stream: _notesStream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final notes = snapshot.data ?? [];
                  final filtered =
                      notes.where((note) {
                        final query = _searchQuery.toLowerCase();
                        return note.title.toLowerCase().contains(query) ||
                            note.description.toLowerCase().contains(query);
                      }).toList();

                  if (filtered.isEmpty) {
                    return Center(
                      child: Text(
                        'No notes yet. Tap + to create one!',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    );
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: MasonryGridView.count(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final note = filtered[index];
                        final isSelected = _selectedNoteIds.contains(note.id);

                        return GestureDetector(
                          onTap: () {
                            if (_selectedNoteIds.isNotEmpty) {
                              _toggleSelection(note.id);
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => NoteEditorScreen(
                                        docId: note.id,
                                        initialTitle: note.title,
                                        initialDescription: note.description,
                                      ),
                                ),
                              );
                            }
                          },
                          onLongPress: () => _toggleSelection(note.id),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color:
                                  Theme.of(
                                    context,
                                  ).colorScheme.surfaceContainerLowest,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color:
                                    isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(
                                          context,
                                        ).colorScheme.outlineVariant,
                                width: isSelected ? 2.5 : 1,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note.title,
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  note.description,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
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
        floatingActionButton:
            _selectedNoteIds.isNotEmpty
                ? null
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (_fabExpanded) ...[
                      _buildFabAction(
                        Icons.note_add,
                        'New Note',
                        _openNoteEditor,
                      ),
                      _buildFabAction(Icons.mic, 'New Recording', () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('WIP')));
                      }),
                      _buildFabAction(Icons.list_alt, 'New List', () {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(const SnackBar(content: Text('WIP')));
                      }),
                      const SizedBox(height: 10),
                    ],
                    FloatingActionButton(
                      onPressed: () {
                        setState(() {
                          _fabExpanded = !_fabExpanded;
                        });
                      },
                      child: Icon(_fabExpanded ? Icons.close : Icons.add),
                    ),
                  ],
                ),
      ),
    );
  }

  Widget _buildFabAction(IconData icon, String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: GestureDetector(
        onTap: () {
          setState(() {
            _fabExpanded = false;
          });
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteSelectedNotes() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final batch = FirebaseFirestore.instance.batch();
    for (var noteId in _selectedNoteIds) {
      final docRef = FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('notes')
          .doc(noteId);
      batch.delete(docRef);
    }
    await batch.commit();
    setState(() => _selectedNoteIds.clear());
  }

  void _logout() async {
    await FirebaseAuth.instance.signOut();
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Signed out successfully')));
    }
  }

  void _openNoteEditor() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => NoteEditorScreen()),
    );
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedNoteIds.contains(id)) {
        _selectedNoteIds.remove(id);
      } else {
        _selectedNoteIds.add(id);
      }
    });
  }
}
