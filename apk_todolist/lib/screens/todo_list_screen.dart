import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/task_model.dart';
import 'add_edit_todo_screen.dart';
import 'login_screen.dart';
import '../widgets/todo_tile.dart';

class TodoListScreen extends StatefulWidget {
  final ApiService api;
  TodoListScreen({required this.api});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<Task> tasks = [];
  List<Task> filteredTasks = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    try {
      final fetchedTasks = await widget.api.fetchTasks();
      setState(() {
        tasks = fetchedTasks;
        filteredTasks = fetchedTasks;
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Gagal memuat data: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void search(String keyword) {
    setState(() {
      filteredTasks = tasks
          .where((t) => t.title.toLowerCase().contains(keyword.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final notDoneTasks = filteredTasks.where((t) => !t.isDone).toList();
    final doneTasks = filteredTasks.where((t) => t.isDone).toList();
    final orderedTasks = [...notDoneTasks, ...doneTasks];

    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
        automaticallyImplyLeading: false, // ⛔ Menghilangkan tombol back
        actions: [
          Container(
            width: 200,
            margin: EdgeInsets.symmetric(vertical: 8),
            child: TextField(
              controller: searchController,
              onChanged: search,
              style: TextStyle(color: Colors.black),
              decoration: InputDecoration(
                hintText: 'Search task...',
                hintStyle: TextStyle(color: Colors.black54),
                prefixIcon: Icon(Icons.search, color: Colors.black54),
                filled: true,
                fillColor: Colors.white24,
                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              try {
                await widget.api.logoutFromServer();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout gagal: $e')),
                );
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: isLoading
                ? Center(child: CircularProgressIndicator())
                : errorMessage.isNotEmpty
                    ? Center(child: Text(errorMessage))
                    : orderedTasks.isEmpty
                        ? Center(child: Text("Nothing task"))
                        : ListView.builder(
                            itemCount: orderedTasks.length,
                            itemBuilder: (context, index) {
                              final task = orderedTasks[index];
                              return TodoTile(
                                task: task,
                                onDone: () async {
                                  final updatedTask = Task(
                                    id: task.id,
                                    title: task.title,
                                    description: task.description,
                                    priority: task.priority,
                                    dueDate: task.dueDate,
                                    isDone: true,
                                  );
                                  await widget.api.updateTask(updatedTask);
                                  await fetchData();
                                },
                                onDelete: () async {
                                  await widget.api.deleteTask(task.id);
                                  await fetchData();
                                },
                                onEdit: () async {
                                  if (task.isDone) return;
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => AddEditTodoScreen(
                                        api: widget.api,
                                        task: task,
                                      ),
                                    ),
                                  );
                                  await fetchData();
                                },
                              );
                            },
                          ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddEditTodoScreen(api: widget.api),
            ),
          );
          await fetchData();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
