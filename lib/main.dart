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
        colorSchemeSeed: const Color(0xFFFFB574),
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
      description:
          'Update IconLabel, TaskCard, modal UX. Verify visuals and commit.',
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: IconLabel(icon: Icons.person, label: 'Shaki'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ProfileHeader(onAddTask: () async {
              final created = await _openCreateModal(context);
              if (created != null) {
                setState(() => _demoTasks.insert(0, created));
              }
            }),
            const SizedBox(height: 16),
            _MyTasksSection(),
            const SizedBox(height: 16),
            const _ActiveProjectsSection(),
            const SizedBox(height: 16),
            Text('Today', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            ..._demoTasks
                .map((t) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: TaskCard(
                        title: t.title,
                        description: t.description,
                        priority: t.priority,
                        dueDate: t.dueDate,
                        assignee: t.assignee,
                        tags: t.tags,
                        isImportant: t.isImportant,
                      ),
                    ))
                .toList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final created = await _openCreateModal(context);
          if (created != null) {
            setState(() => _demoTasks.insert(0, created));
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task created')),
              );
            }
          }
        },
        label: const Text('Add task'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  Future<TaskItem?> _openCreateModal(BuildContext context) async {
    return showModalBottomSheet<TaskItem>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        String selectedPriority = 'Medium';
        final titleCtrl = TextEditingController(text: 'Weekly sync notes');
        final descCtrl = TextEditingController(
            text: 'Template: goals, updates, blockers, action items.');
        final dueCtrl = TextEditingController(text: 'Today');
        final assigneeCtrl = TextEditingController(text: 'Me');
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
                  Text('New Task',
                      style: Theme.of(context).textTheme.titleLarge),
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
                            .map((p) =>
                                DropdownMenuItem(value: p, child: Text(p)))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => selectedPriority = v ?? 'Medium'),
                      ),
                      const Spacer(),
                      SizedBox(
                        width: 140,
                        child: TextField(
                          controller: dueCtrl,
                          decoration: const InputDecoration(labelText: 'Due'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: 220,
                    child: TextField(
                      controller: assigneeCtrl,
                      decoration: const InputDecoration(labelText: 'Assignee'),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Spacer(),
                      FilledButton(
                        onPressed: () {
                          final item = TaskItem(
                            title: titleCtrl.text.trim(),
                            description: descCtrl.text.trim(),
                            priority: selectedPriority,
                            dueDate: dueCtrl.text.trim().isEmpty
                                ? null
                                : dueCtrl.text.trim(),
                            assignee: assigneeCtrl.text.trim().isEmpty
                                ? null
                                : assigneeCtrl.text.trim(),
                            tags: const [],
                          );
                          Navigator.of(context).pop(item);
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

class _ProfileHeader extends StatelessWidget {
  final VoidCallback onAddTask;
  const _ProfileHeader({required this.onAddTask});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: color, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Sourav Suman',
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                Text('App Developer',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          FilledButton.tonal(
            onPressed: onAddTask,
            child: const Text('Add task'),
          ),
        ],
      ),
    );
  }
}

class _MyTasksSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    TextStyle? label = Theme.of(context)
        .textTheme
        .bodyMedium
        ?.copyWith(fontWeight: FontWeight.w600);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('My Tasks', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        _statusTile(context,
            color: Colors.redAccent,
            label: 'To Do',
            subtitle: '5 tasks now. 1 started',
            icon: Icons.radio_button_unchecked),
        const SizedBox(height: 8),
        _statusTile(context,
            color: Colors.orange,
            label: 'In Progress',
            subtitle: '1 tasks now. 1 started',
            icon: Icons.timelapse),
        const SizedBox(height: 8),
        _statusTile(context,
            color: Colors.green,
            label: 'Done',
            subtitle: '18 tasks now. 12 started',
            icon: Icons.check_circle),
      ],
    );
  }

  Widget _statusTile(BuildContext context,
      {required Color color,
      required String label,
      required String subtitle,
      required IconData icon}) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          ),
          Icon(Icons.more_horiz,
              color: Theme.of(context).colorScheme.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _ActiveProjectsSection extends StatelessWidget {
  const _ActiveProjectsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Active Projects', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Row(
          children: const [
            Expanded(
                child: _ProjectCard(
                    title: 'Medical App', percent: 0.23, color: Colors.teal)),
            SizedBox(width: 12),
            Expanded(
                child: _ProjectCard(
                    title: 'Making History notes',
                    percent: 0.62,
                    color: Colors.pinkAccent)),
          ],
        ),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final String title;
  final double percent;
  final Color color;
  const _ProjectCard(
      {required this.title, required this.percent, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ),
              Text('${(percent * 100).round()}%',
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall
                      ?.copyWith(color: color, fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 10,
              value: percent,
              color: color,
              backgroundColor: color.withOpacity(0.2),
            ),
          ),
        ],
      ),
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
                          IconLabel(
                              icon: Icons.calendar_today,
                              label: widget.dueDate!,
                              color: color),
                        if (widget.assignee != null)
                          IconLabel(
                              icon: Icons.person,
                              label: widget.assignee!,
                              color: color),
                      ],
                    ),
                  ],
                ),
                crossFadeState: _expanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
