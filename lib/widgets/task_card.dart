import 'package:flutter/material.dart';
import 'icon_label.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String priority; // e.g., High, Medium, Low
  final String? dueDate;
  final String? assignee;
  final List<String> tags;
  final bool isImportant;

  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.priority,
    this.dueDate,
    this.assignee,
    this.tags = const [],
    this.isImportant = false,
  });

  Color _priorityColor(BuildContext context) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.redAccent;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _priorityColor(context);
    final titleStyle = Theme.of(context)
        .textTheme
        .titleMedium
        ?.copyWith(fontWeight: FontWeight.w600);
    final descriptionStyle = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.9));

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 1.5,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: color.withOpacity(0.5)),
                  ),
                  child: Text(
                    priority,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                ),
                const Spacer(),
                if (isImportant)
                  Icon(Icons.push_pin_rounded, size: 18, color: color),
              ],
            ),
            const SizedBox(height: 8),
            Text(title, style: titleStyle),
            const SizedBox(height: 6),
            Text(description, style: descriptionStyle, maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),

            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                if (dueDate != null)
                  IconLabel(icon: Icons.calendar_today, label: dueDate!, color: color),
                if (assignee != null)
                  IconLabel(icon: Icons.person, label: assignee!, color: color),
              ],
            ),

            if (tags.isNotEmpty) ...[
              const SizedBox(height: 10),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: tags
                    .map(
                      (t) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '#$t',
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
