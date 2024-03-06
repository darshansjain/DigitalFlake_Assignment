class Slot {
  final String slotName;
  final int slotId;
  final bool slotActive;

  Slot({
    required this.slotName,
    required this.slotId,
    required this.slotActive,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      slotName: json['slot_name'],
      slotId: json['slot_id'],
      slotActive: json['slot_active'],
    );
  }
}
