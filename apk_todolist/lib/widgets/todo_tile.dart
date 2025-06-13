import 'package:flutter/material.dart';
import '../models/task_model.dart';

class TodoTile extends StatelessWidget {
  final Task task;
  final VoidCallback onDone;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  TodoTile({
    required this.task,
    required this.onDone,
    required this.onEdit,
    required this.onDelete,
  });

  
  Color getCardColor() {
    if (task.isDone) {
      return Colors.green.shade100; 
    }

    switch (task.priority.toLowerCase()) {
      case 'high':
        return Colors.red.shade100;
      case 'medium':
        return Colors.orange.shade100;
      case 'low':
      default:
        return Colors.grey.shade300; 
    }
  }

  
  IconData getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.priority_high; 
      case 'medium':
        return Icons.warning_amber; 
      case 'low':
      default:
        return Icons.low_priority; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: getCardColor(),
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Icon(
          getPriorityIcon(task.priority),
          color: Colors.black54,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isDone ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty) Text(task.description),
            SizedBox(height: 4),
            Text(
              "Priority: ${task.priority}, Deadline: ${task.dueDate.toLocal().toString().split(' ')[0]}",
              style: TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (!task.isDone)
              IconButton(
                icon: Icon(Icons.check, color: Colors.green),
                onPressed: onDone,
                tooltip: "Done",
              ),
            if (!task.isDone)
              IconButton(
                icon: Icon(Icons.edit, color: Colors.blue),
                onPressed: onEdit,
                tooltip: "Edit task",
              ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
              tooltip: "Delete task",
            ),
          ],
        ),
      ),
    );
  }
}
