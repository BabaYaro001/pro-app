import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/achievement.dart';
import 'achievement_form_screen.dart';

class AchievementListScreen extends StatefulWidget {
  const AchievementListScreen({super.key});

  @override
  State<AchievementListScreen> createState() => _AchievementListScreenState();
}

class _AchievementListScreenState extends State<AchievementListScreen> {
  late Future<List<Achievement>> _achievementsFuture;

  @override
  void initState() {
    super.initState();
    _refreshAchievements();
  }

  void _refreshAchievements() {
    setState(() {
      _achievementsFuture = DatabaseHelper.instance.getAllAchievements();
    });
  }

  void _addAchievement() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AchievementFormScreen()),
    );
    if (result == true) _refreshAchievements();
  }

  void _editAchievement(Achievement achievement) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (_) => AchievementFormScreen(achievement: achievement)),
    );
    if (result == true) _refreshAchievements();
  }

  void _deleteAchievement(int id) async {
    await DatabaseHelper.instance.deleteAchievement(id);
    _refreshAchievements();
    ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Achievement deleted successfully')));
  }

  Color _typeColor(String type) {
    switch (type) {
      case "Academic":
        return Colors.blue;
      case "Sports":
        return Colors.green;
      case "Arts":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Achievements"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addAchievement,
            tooltip: "Add Achievement",
          )
        ],
      ),
      body: FutureBuilder<List<Achievement>>(
        future: _achievementsFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.data!.isEmpty) {
            return const Center(child: Text("No achievements found."));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final achievement = snapshot.data![index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: _typeColor(achievement.type),
                  child: const Icon(Icons.emoji_events, color: Colors.white),
                ),
                title: Text(achievement.title),
                subtitle: Text(
                  '${achievement.description}\nStudent: ${achievement.studentName}\nDate: ${achievement.date}\nType: ${achievement.type}',
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                isThreeLine: true,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blue),
                      onPressed: () => _editAchievement(achievement),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteAchievement(achievement.id!),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}