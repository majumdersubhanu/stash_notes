import 'dart:async';

import 'package:flutter/material.dart';

class NoteEditorScreen extends StatefulWidget {
  final String? initialTitle;
  final String? initialDescription;
  final void Function(String title, String description, Color color)? onSave;

  const NoteEditorScreen({
    super.key,
    this.initialTitle,
    this.initialDescription,
    this.onSave,
  });

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  // Light & dark mode color palettes
  static const List<Color> _lightNoteColors = [
    Colors.white,
    Color(0xFFFFF8E1),
    Color(0xFFE1F5FE),
    Color(0xFFF1F8E9),
    Color(0xFFFFEBEE),
    Color(0xFFFFF3E0),
    Color(0xFFEDE7F6),
  ];
  static const List<Color> _darkNoteColors = [
    Color(0xFF303030),
    Color(0xFF424242),
    Color(0xFF37474F),
    Color(0xFF2E7D32),
    Color(0xFF4E342E),
    Color(0xFF5D4037),
    Color(0xFF4527A0),
  ];
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  late Color _selectedColor;

  Timer? _autoSaveTimer;

  bool get isDarkMode => Theme.of(context).brightness == Brightness.dark;

  List<Color> get _noteColors =>
      isDarkMode ? _darkNoteColors : _lightNoteColors;

  @override
  Widget build(BuildContext context) {
    final Color bgColor =
        _selectedColor == Colors.transparent
            ? Theme.of(context).scaffoldBackgroundColor
            : _selectedColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: const [
          IconButton(icon: Icon(Icons.push_pin_outlined), onPressed: null),
          IconButton(icon: Icon(Icons.archive_outlined), onPressed: null),
        ],
      ),
      body: Column(
        children: [
          // Title + Description Inputs
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextField(
                    controller: _titleController,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: _descriptionController,
                      maxLines: null,
                      expands: true,
                      keyboardType: TextInputType.multiline,
                      style: Theme.of(context).textTheme.bodyLarge,
                      decoration: const InputDecoration(
                        hintText: 'Note',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Color Picker
          Padding(
            padding: const EdgeInsets.only(bottom: 32, left: 16, right: 16),
            child: SizedBox(
              height: 48,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _noteColors.length,
                itemBuilder: (context, index) {
                  final color = _noteColors[index];
                  final isSelected = color == _selectedColor;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedColor = color;
                      });
                      _triggerAutoSave();
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      margin: const EdgeInsets.symmetric(horizontal: 6),
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color:
                              isSelected
                                  ? Colors.black.withOpacity(0.7)
                                  : Colors.transparent,
                          width: 2,
                        ),
                      ),
                      child:
                          isSelected ? const Icon(Icons.check, size: 18) : null,
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _autoSaveTimer?.cancel();
    _titleController.removeListener(_triggerAutoSave);
    _descriptionController.removeListener(_triggerAutoSave);
    _saveNote(); // final save on exit
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle ?? '');
    _descriptionController = TextEditingController(
      text: widget.initialDescription ?? '',
    );
    _selectedColor = Colors.transparent;

    _titleController.addListener(_triggerAutoSave);
    _descriptionController.addListener(_triggerAutoSave);
  }

  void _saveNote() {
    final title = _titleController.text.trim();
    final description = _descriptionController.text.trim();
    if (title.isEmpty && description.isEmpty) return;

    widget.onSave?.call(
      title,
      description,
      _selectedColor == Colors.transparent
          ? Theme.of(context).scaffoldBackgroundColor
          : _selectedColor,
    );
  }

  void _triggerAutoSave() {
    _autoSaveTimer?.cancel();
    _autoSaveTimer = Timer(const Duration(milliseconds: 800), () {
      _saveNote();
    });
  }
}
