import 'package:flutter/material.dart';
import 'widgets/icon_label.dart';
import 'widgets/task_card.dart';

void main() {
  runApp(const TaskPersonalizeApp());
}

class TaskPersonalizeApp extends StatelessWidget {
  const TaskPersonalizeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasks',
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFF6C63FF),
        useMaterial3: true,
      ),
      home: const TaskHomePage(),
    );
  }
}

class TaskItem {
  final String title;
  final String description;
  final String priority; // High | Medium | Low
  final String? dueDate;
  final String? assignee;
  final List<String> tags;
  final bool isImportant;

  const TaskItem({
    required this.title,
    required this.description,
    required this.priority,
    this.dueDate,
    this.assignee,
    this.tags = const [],
    this.isImportant = false,
  });
}

class TaskHomePage extends StatefulWidget {
  const TaskHomePage({super.key});

  @override
  State<TaskHomePage> createState() => _TaskHomePageState();
}

class _TaskHomePageState extends State<TaskHomePage> {
  final List<TaskItem> _demoTasks = [
    const TaskItem(
      title: 'Ship widgets-personalize exercise',
      description: 'Update IconLabel, TaskCard, modal UX. Verify visuals and commit.',
      priority: 'High',
      dueDate: 'Today',
      assignee: 'Shaki',
      tags: ['flutter', 'ui'],
      isImportant: true,
    ),
    const TaskItem(
      title: 'Weekly sync notes',
      description: 'Draft agenda, capture action items, and share recap.',
      priority: 'Medium',
      dueDate: 'Fri',
      assignee: 'Me',
      tags: ['team', 'meeting'],
    ),
    const TaskItem(
      title: 'Refactor theming',
      description: 'Consolidate colors and text styles, reduce duplication.',
      priority: 'Low',
      dueDate: 'Next week',
      assignee: 'Me',
      tags: ['tech-debt'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: IconLabel(icon: Icons.person, label: 'Shaki'),
          ),
        ],
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final t = _demoTasks[index];
          return TaskCard(
            title: t.title,
            description: t.description,
            priority: t.priority,
            dueDate: t.dueDate,
            assignee: t.assignee,
            tags: t.tags,
            isImportant: t.isImportant,
          );
        },
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemCount: _demoTasks.length,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openCreateModal(context),
        label: const Text('Create'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _openCreateModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        String selectedPriority = 'Medium';
        final titleCtrl = TextEditingController(text: 'Weekly sync notes');
        final descCtrl = TextEditingController(text: 'Template: goals, updates, blockers, action items.');
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('New Task', style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: 12),
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: descCtrl,
                    minLines: 2,
                    maxLines: 4,
                    decoration: const InputDecoration(labelText: 'Description'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Priority:'),
                      const SizedBox(width: 12),
                      DropdownButton<String>(
                        value: selectedPriority,
                        items: ['High', 'Medium', 'Low']
                            .map((p) => DropdownMenuItem(value: p, child: Text(p)))
                            .toList(),
                        onChanged: (v) => setState(() => selectedPriority = v ?? 'Medium'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Spacer(),
                      FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(this.context).showSnackBar(
                            const SnackBar(content: Text('(UI-only) Task created')),
                          );
                        },
                        child: const Text('Create'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class ExpandableTaskCard extends StatefulWidget {
  final String title;
  final String description;
  final String priority;
  final String? dueDate;
  final String? assignee;
  final List<String> tags;

  const ExpandableTaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.priority,
    this.dueDate,
    this.assignee,
    this.tags = const [],
  });

  @override
  State<ExpandableTaskCard> createState() => _ExpandableTaskCardState();
}

class _ExpandableTaskCardState extends State<ExpandableTaskCard> {
  bool _expanded = false;

  Color _priorityColor(BuildContext context) {
    switch (widget.priority.toLowerCase()) {
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
    return InkWell(
      onTap: () => setState(() => _expanded = !_expanded),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    Text(widget.description),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 12,
                      children: [
                        if (widget.dueDate != null)
                          IconLabel(icon: Icons.calendar_today, label: widget.dueDate!, color: color),
                        if (widget.assignee != null)
                          IconLabel(icon: Icons.person, label: widget.assignee!, color: color),
                      ],
                    ),
                  ],
                ),
                crossFadeState:
                    _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
