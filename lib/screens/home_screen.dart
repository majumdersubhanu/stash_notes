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
  final String title;
  final String description;

  Note({required this.title, required this.description});

  Note copyWith({String? title, String? description}) {
    return Note(
      title: title ?? this.title,
      description: description ?? this.description,
    );
  }
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Note> _notes = [];
  final Set<int> _selectedNoteIndices = {};
  String _searchQuery = '';
  bool _fabExpanded = false;

  @override
  Widget build(BuildContext context) {
    final filteredNotes =
        _notes.where((note) {
          final query = _searchQuery.toLowerCase();
          return note.title.toLowerCase().contains(query) ||
              note.description.toLowerCase().contains(query);
        }).toList();

    return WillPopScope(
      onWillPop: () async {
        if (_selectedNoteIndices.isNotEmpty) {
          setState(() => _selectedNoteIndices.clear());
          return false;
        }
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          forceMaterialTransparency: true,
          title:
              _selectedNoteIndices.isNotEmpty
                  ? Text('${_selectedNoteIndices.length} selected')
                  : Text(
                    'My Notes',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
          actions:
              _selectedNoteIndices.isNotEmpty
                  ? [
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: _deleteSelectedNotes,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed:
                          () => setState(() => _selectedNoteIndices.clear()),
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
            // Search Bar
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

            // Notes Grid
            Expanded(
              child:
                  filteredNotes.isEmpty
                      ? Center(
                        child: Text(
                          'No notes yet. Tap + to create one!',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      )
                      : Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: MasonryGridView.count(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          itemCount: filteredNotes.length,
                          itemBuilder: (context, index) {
                            final note = filteredNotes[index];
                            final actualIndex = _notes.indexOf(note);
                            final isSelected = _selectedNoteIndices.contains(
                              actualIndex,
                            );

                            return GestureDetector(
                              onTap: () {
                                if (_selectedNoteIndices.isNotEmpty) {
                                  _toggleSelection(actualIndex);
                                } else {
                                  _editNote(actualIndex, note);
                                }
                              },
                              onLongPress: () => _toggleSelection(actualIndex),
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(
                                        context,
                                      ).colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color:
                                        isSelected
                                            ? Theme.of(
                                              context,
                                            ).colorScheme.primary
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
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      note.description,
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
            ),
          ],
        ),

        // Expandable FAB
        floatingActionButton:
            _selectedNoteIndices.isNotEmpty
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
                        // TODO: Implement voice note
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('WIP')));
                      }),
                      _buildFabAction(Icons.list_alt, 'New List', () {
                        // TODO: Implement list note
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('WIP')));
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

  void _deleteSelectedNotes() {
    setState(() {
      _selectedNoteIndices.toList()
        ..sort((a, b) => b.compareTo(a))
        ..forEach((index) => _notes.removeAt(index));
      _selectedNoteIndices.clear();
    });
  }

  void _editNote(int index, Note existingNote) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (_) => NoteEditorScreen(
              initialTitle: existingNote.title,
              initialDescription: existingNote.description,
              onSave: (title, description) {
                setState(() {
                  _notes[index] = existingNote.copyWith(
                    title: title,
                    description: description,
                  );
                });
              },
            ),
      ),
    );
  }

  Future<void> _logout() async {
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
      MaterialPageRoute(
        builder:
            (_) => NoteEditorScreen(
              onSave: (title, description) {
                setState(() {
                  _notes.add(Note(title: title, description: description));
                });
              },
            ),
      ),
    );
  }

  void _toggleSelection(int index) {
    setState(() {
      if (_selectedNoteIndices.contains(index)) {
        _selectedNoteIndices.remove(index);
      } else {
        _selectedNoteIndices.add(index);
      }
    });
  }
}
