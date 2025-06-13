import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/task_model.dart';

class AddEditTodoScreen extends StatefulWidget {
  final ApiService api;
  final Task? task;

  AddEditTodoScreen({required this.api, this.task});

  @override
  _AddEditTodoScreenState createState() => _AddEditTodoScreenState();
}

class _AddEditTodoScreenState extends State<AddEditTodoScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String priority = 'low';
  DateTime? dueDate;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      titleController.text = widget.task!.title;
      descriptionController.text = widget.task!.description;
      priority = widget.task!.priority;
      dueDate = widget.task!.dueDate;
    }
  }

  void saveTask() async {
    if (titleController.text.trim().isEmpty || dueDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Judul dan tenggat waktu wajib diisi')),
      );
      return;
    }

    Task task = Task(
      id: widget.task?.id ?? 0,
      title: titleController.text.trim(),
      description: descriptionController.text.trim(),
      priority: priority,
      dueDate: dueDate!,
      isDone: widget.task?.isDone ?? false,
    );

    try {
      if (widget.task == null) {
        await widget.api.addTask(task);
      } else {
        await widget.api.updateTask(task);
      }
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal menyimpan tugas')),
      );
    }
  }

  void pickDate() async {
    DateTime now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: dueDate ?? now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() => dueDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.task == null ? "Tambah Tugas" : "Edit Tugas")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Judul"),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: "Deskripsi"),
              ),
              DropdownButtonFormField<String>(
                value: priority,
                items: ['low', 'medium', 'high']
                    .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                    .toList(),
                onChanged: (value) => setState(() => priority = value!),
                decoration: InputDecoration(labelText: "Prioritas"),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      dueDate == null
                          ? "Belum pilih tenggat waktu"
                          : "Tenggat: ${dueDate!.toLocal().toString().split(' ')[0]}",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  IconButton(
                    onPressed: pickDate,
                    icon: Icon(Icons.calendar_today),
                  ),
                ],
              ),
              SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveTask,
                  child: Text("Simpan"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
