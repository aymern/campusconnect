class ScheduleEntry {
  const ScheduleEntry({
    required this.id,
    required this.title,
    required this.start,
    required this.end,
    required this.location,
  });

  final String id;
  final String title;
  final DateTime start;
  final DateTime end;
  final String location;

  bool overlaps(ScheduleEntry other) {
    return start.isBefore(other.end) && end.isAfter(other.start);
  }

  ScheduleEntry copyWith({
    String? id,
    String? title,
    DateTime? start,
    DateTime? end,
    String? location,
  }) {
    return ScheduleEntry(
      id: id ?? this.id,
      title: title ?? this.title,
      start: start ?? this.start,
      end: end ?? this.end,
      location: location ?? this.location,
    );
  }
}
