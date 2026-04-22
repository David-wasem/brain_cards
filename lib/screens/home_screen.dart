import 'package:brain_cards/models/quiz.dart';
import 'package:brain_cards/models/quiz_list.dart';
import 'package:brain_cards/models/result_list.dart';
import 'package:brain_cards/screens/exam_screen.dart';
import 'package:brain_cards/widgets/drawer.dart';
import 'package:brain_cards/widgets/recent.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? currentCategory;
  bool _selected = false;
  int _selectedIndex = -1;

  // ── 1. Add Category Dialog ──────────────────────────────────────────
  void _showAddCategoryDialog() {
    final ctrl = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.symmetric(horizontal: 28),
        child: LayoutBuilder(
          builder: (context, _) {
            final kb = MediaQuery.of(context).viewInsets.bottom;
            final sh = MediaQuery.of(context).size.height;
            return ConstrainedBox(
              constraints: BoxConstraints(maxHeight: sh - kb - 80),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                ),
                clipBehavior: Clip.hardEdge,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Gradient header
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                        vertical: 24,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF3B82F6), Color(0xFF2F4D77)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(
                              Icons.create_new_folder_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          SizedBox(width: 12),
                          Text(
                            'New Category',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Content + Actions — scrollable so keyboard doesn't cause overflow
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 24, 20, 8),
                              child: TextField(
                                controller: ctrl,
                                autofocus: true,
                                textCapitalization: TextCapitalization.words,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF2F4D77),
                                ),
                                decoration: InputDecoration(
                                  hintText: 'e.g. Biology, History…',
                                  hintStyle: TextStyle(
                                    color: Colors.grey.shade400,
                                  ),
                                  prefixIcon: Icon(
                                    Icons.label_rounded,
                                    color: Color(0xFF3B82F6),
                                  ),
                                  filled: true,
                                  fillColor: Color(0xFFF0F5FF),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(14),
                                    borderSide: BorderSide(
                                      color: Color(0xFF3B82F6),
                                      width: 2,
                                    ),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 14,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 12, 20, 20),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () => Navigator.pop(context),
                                      style: OutlinedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        side: BorderSide(
                                          color: Colors.grey.shade300,
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      child: Text(
                                        'Cancel',
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Color(0xFF3B82F6),
                                        foregroundColor: Colors.white,
                                        padding: EdgeInsets.symmetric(
                                          vertical: 14,
                                        ),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                      ),
                                      onPressed: () {
                                        final name = ctrl.text.trim();
                                        if (name.isEmpty) return;
                                        if (quizList.containsKey(name)) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Category "$name" already exists',
                                              ),
                                              backgroundColor: Colors.red,
                                              behavior:
                                                  SnackBarBehavior.floating,
                                            ),
                                          );
                                          Navigator.pop(context);
                                          return;
                                        }
                                        setState(() => quizList[name] = []);
                                        Navigator.pop(context);
                                      },
                                      child: Text(
                                        'Add',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ── 2. Manage Questions Bottom Sheet ───────────────────────────────
  void _showManageSheet() {
    if (currentCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Select a category first'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _ManageSheet(
        category: currentCategory!,
        onChanged: () => setState(() {}),
      ),
    );
  }

  // ── 3. Add / Edit Question Dialog (static so _ManageSheet can call it) ──
  static void showAddEditQuestion(
    BuildContext context,
    String category, {
    Quiz? existing,
    int? editIndex,
    required VoidCallback onSaved,
  }) {
    final qCtrl = TextEditingController(text: existing?.question ?? '');
    final optCtrls = List.generate(
      4,
      (i) => TextEditingController(
        text: (existing != null && i < existing.options.length)
            ? existing.options[i]
            : '',
      ),
    );
    int correctIdx = existing?.correctAnswer ?? 0;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setLocal) => Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            clipBehavior: Clip.hardEdge,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gradient header
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF3B82F6), Color(0xFF2F4D77)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(
                          existing == null
                              ? Icons.add_circle_outline_rounded
                              : Icons.edit_rounded,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            existing == null ? 'Add Question' : 'Edit Question',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            category,
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.75),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Scrollable content
                Flexible(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question field
                        Text(
                          'Question',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2F4D77),
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 8),
                        TextField(
                          controller: qCtrl,
                          maxLines: 3,
                          style: TextStyle(
                            fontSize: 14,
                            color: Color(0xFF2F4D77),
                          ),
                          decoration: InputDecoration(
                            hintText: 'Type your question here…',
                            hintStyle: TextStyle(color: Colors.grey.shade400),
                            filled: true,
                            fillColor: Color(0xFFF0F5FF),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(14),
                              borderSide: BorderSide(
                                color: Color(0xFF3B82F6),
                                width: 2,
                              ),
                            ),
                            contentPadding: EdgeInsets.all(14),
                          ),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'OPTIONS  —  tap ● to mark correct answer',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF2F4D77),
                            letterSpacing: 0.5,
                          ),
                        ),
                        SizedBox(height: 10),
                        // Option tiles
                        ...List.generate(4, (i) {
                          final isCorrect = correctIdx == i;
                          return GestureDetector(
                            onTap: () => setLocal(() => correctIdx = i),
                            child: AnimatedContainer(
                              duration: Duration(milliseconds: 200),
                              margin: EdgeInsets.only(bottom: 10),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isCorrect
                                    ? Color(0xFF3B82F6).withOpacity(0.08)
                                    : Color(0xFFF0F5FF),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: isCorrect
                                      ? Color(0xFF3B82F6)
                                      : Colors.transparent,
                                  width: 1.5,
                                ),
                              ),
                              child: Row(
                                children: [
                                  // Letter badge
                                  AnimatedContainer(
                                    duration: Duration(milliseconds: 200),
                                    width: 30,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: isCorrect
                                          ? Color(0xFF3B82F6)
                                          : Colors.grey.shade300,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Center(
                                      child: isCorrect
                                          ? Icon(
                                              Icons.check_rounded,
                                              color: Colors.white,
                                              size: 16,
                                            )
                                          : Text(
                                              ['A', 'B', 'C', 'D'][i],
                                              style: TextStyle(
                                                color: Colors.grey.shade600,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 13,
                                              ),
                                            ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: TextField(
                                      controller: optCtrls[i],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: isCorrect
                                            ? Color(0xFF2F4D77)
                                            : Colors.grey.shade700,
                                        fontWeight: isCorrect
                                            ? FontWeight.w600
                                            : FontWeight.normal,
                                      ),
                                      decoration: InputDecoration(
                                        hintText: 'Option ${i + 1}',
                                        hintStyle: TextStyle(
                                          color: Colors.grey.shade400,
                                        ),
                                        border: InputBorder.none,
                                        isDense: true,
                                        contentPadding: EdgeInsets.symmetric(
                                          vertical: 12,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                // Actions
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 4, 20, 20),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(ctx),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14),
                            side: BorderSide(color: Colors.grey.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF3B82F6),
                            foregroundColor: Colors.white,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            final q = qCtrl.text.trim();
                            final opts = optCtrls
                                .map((c) => c.text.trim())
                                .toList();
                            if (q.isEmpty || opts.any((o) => o.isEmpty)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please fill in all fields'),
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                              return;
                            }
                            final quiz = Quiz(
                              question: q,
                              options: opts,
                              correctAnswer: correctIdx,
                            );
                            if (existing == null) {
                              quizList[category]!.add(quiz);
                            } else {
                              quizList[category]![editIndex!] = quiz;
                            }
                            onSaved();
                            Navigator.pop(ctx);
                          },
                          child: Text(
                            existing == null ? 'Add' : 'Save',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Build ───────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    List<String> categories = quizList.keys.toList();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: CustomDrawer(),
      body: Builder(
        builder: (context) => Stack(
          children: [
            // Background
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF2F4D77)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            // Header Row
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 50.0,
                horizontal: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.menu, color: Colors.white, size: 28),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                  Text(
                    "Welcome Back",
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 5,
                          offset: Offset(0, 0),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      child: ClipOval(
                        child: Image.asset(
                          'assets/Splash.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Main white card
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.15,
              ),
              width: MediaQuery.of(context).size.width,
              height: double.infinity,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Categories heading + Manage button ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Categories",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2F4D77),
                              ),
                            ),
                            TextButton.icon(
                              onPressed: _showManageSheet,
                              icon: Icon(
                                Icons.edit_note_rounded,
                                color: Color(0xFF3B82F6),
                              ),
                              label: Text(
                                'Manage',
                                style: TextStyle(
                                  color: Color(0xFF3B82F6),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      // ── Category chips + "+" tile ──
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: SizedBox(
                          height: 90,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: categories.length + 1,
                            itemBuilder: (context, index) {
                              // "Add" tile at the end
                              if (index == categories.length) {
                                return GestureDetector(
                                  onTap: _showAddCategoryDialog,
                                  child: Container(
                                    width: 90,
                                    margin: EdgeInsets.only(right: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: Color(
                                          0xFF3B82F6,
                                        ).withOpacity(0.5),
                                        width: 2,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.add_rounded,
                                          color: Color(0xFF3B82F6),
                                          size: 28,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Add',
                                          style: TextStyle(
                                            color: Color(0xFF3B82F6),
                                            fontWeight: FontWeight.w600,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              // Normal category chip
                              return GestureDetector(
                                onTap: () => setState(() {
                                  currentCategory = categories[index];
                                  _selected = true;
                                  _selectedIndex = index;
                                }),
                                child: Container(
                                  width: 120,
                                  margin: EdgeInsets.only(right: 12),
                                  decoration: BoxDecoration(
                                    color:
                                        (_selected && _selectedIndex == index)
                                        ? Color(0xFF3B82F6)
                                        : Color.fromARGB(255, 139, 182, 252),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: Center(
                                    child:
                                        (_selected && _selectedIndex == index)
                                        ? Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.check_circle_rounded,
                                                size: 25,
                                                color: Colors.white,
                                              ),
                                              Text(
                                                categories[index],
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ],
                                          )
                                        : Text(
                                            categories[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      // ── Flashcards heading ──
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          "Flashcards",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F4D77),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      // ── Start button ──
                      Center(
                        child: InkWell(
                          onTap: () {
                            if (currentCategory == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Please select a category'),
                                  duration: Duration(seconds: 2),
                                  backgroundColor: Colors.red,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(10),
                                ),
                              );
                              return;
                            }
                            if ((quizList[currentCategory] ?? []).isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'No questions in this category yet',
                                  ),
                                  backgroundColor: Colors.orange,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                  margin: EdgeInsets.all(10),
                                ),
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ExamScreen(category: currentCategory!),
                              ),
                            ).then((_) => setState(() {}));
                          },
                          child: Container(
                            width: 220,
                            height: 56,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Color(0xFF3B82F6), Color(0xFF2F4D77)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: Color(0xFF3B82F6).withOpacity(0.45),
                                  blurRadius: 16,
                                  offset: Offset(0, 8),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.play_arrow_rounded,
                                  color: Colors.white,
                                  size: 26,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Start",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      // ── Recent Quizzes ──
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20.0,
                          vertical: 0,
                        ),
                        child: Text(
                          "Recent Quizzes",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2F4D77),
                          ),
                        ),
                      ),
                      (resultList.isEmpty)
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 20.0,
                              ),
                              child: Center(
                                child: Text(
                                  "No recent quizzes",
                                  style: TextStyle(
                                    color: const Color(
                                      0xFF757575,
                                    ).withOpacity(0.5),
                                  ),
                                ),
                              ),
                            )
                          : SizedBox(
                              height: 300,
                              child: ListView.builder(
                                padding: const EdgeInsets.only(
                                  top: 8,
                                  bottom: 20,
                                ),
                                itemCount: resultList.length,
                                itemBuilder: (context, index) {
                                  return Recent(
                                    title: resultList[index].category,
                                    subtitle:
                                        "${resultList[index].correctAnswers}/${resultList[index].totalAnswers}",
                                    tile: "${index + 1}",
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Manage Sheet — separate StatefulWidget so it can call setState on its own
// ──────────────────────────────────────────────────────────────────────────────
class _ManageSheet extends StatefulWidget {
  final String category;
  final VoidCallback onChanged;

  const _ManageSheet({required this.category, required this.onChanged});

  @override
  State<_ManageSheet> createState() => _ManageSheetState();
}

class _ManageSheetState extends State<_ManageSheet> {
  void _refresh() {
    setState(() {});
    widget.onChanged(); // also refreshes home screen
  }

  @override
  Widget build(BuildContext context) {
    final questions = quizList[widget.category] ?? [];

    return Container(
      height: MediaQuery.of(context).size.height * 0.78,
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFF),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          // Drag handle
          Container(
            margin: EdgeInsets.only(top: 12, bottom: 4),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          // Title row
          Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 16, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.category,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2F4D77),
                      ),
                    ),
                    Text(
                      '${questions.length} question${questions.length != 1 ? 's' : ''}',
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: () => _HomePageState.showAddEditQuestion(
                    context,
                    widget.category,
                    onSaved: _refresh,
                  ),
                  icon: Icon(Icons.add_rounded, size: 16),
                  label: Text(
                    'Add',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF3B82F6),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1),
          // Questions list
          Expanded(
            child: questions.isEmpty
                ? Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.quiz_outlined,
                          size: 52,
                          color: Colors.grey.shade300,
                        ),
                        SizedBox(height: 12),
                        Text(
                          'No questions yet.\nTap "Add" to create one.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade400),
                        ),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: questions.length,
                    separatorBuilder: (_, __) => SizedBox(height: 8),
                    itemBuilder: (ctx, i) {
                      final q = questions[i];
                      return ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        tileColor: Color(0xFFF5F8FF),
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFF3B82F6),
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(
                          q.question,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: Text(
                          '✓  ${q.options[q.correctAnswer]}',
                          style: TextStyle(
                            color: Colors.green.shade600,
                            fontSize: 12,
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Edit
                            IconButton(
                              icon: Icon(
                                Icons.edit_rounded,
                                color: Color(0xFF3B82F6),
                                size: 20,
                              ),
                              onPressed: () =>
                                  _HomePageState.showAddEditQuestion(
                                    context,
                                    widget.category,
                                    existing: q,
                                    editIndex: i,
                                    onSaved: _refresh,
                                  ),
                            ),
                            // Delete
                            IconButton(
                              icon: Icon(
                                Icons.delete_outline_rounded,
                                color: Colors.red,
                                size: 20,
                              ),
                              onPressed: () {
                                setState(
                                  () => quizList[widget.category]!.removeAt(i),
                                );
                                widget.onChanged();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
