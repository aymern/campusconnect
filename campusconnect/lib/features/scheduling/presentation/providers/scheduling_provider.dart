import 'package:flutter/foundation.dart';

import '../../domain/entities/schedule_entry.dart';

class SchedulingProvider extends ChangeNotifier {
  SchedulingProvider() {
    final base = DateTime.now();
    _entries = [
      ScheduleEntry(
        id: 'entry-1',
        title: 'Algorithms',
        start: DateTime(base.year, base.month, base.day, 9, 0),
        end: DateTime(base.year, base.month, base.day, 10, 0),
        location: 'Riverside Hall',
      ),
    ];
  }

  late List<ScheduleEntry> _entries;

  List<ScheduleEntry> get entries => List.unmodifiable(_entries);

  bool hasConflict(ScheduleEntry candidate) {
    return _entries.any((entry) => entry.overlaps(candidate));
  }

  void addEntry(ScheduleEntry entry) {
    _entries = [..._entries, entry];
    notifyListeners();
  }
}
