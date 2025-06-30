import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FollowUpController extends GetxController {
  var selectedType = 'Call'.obs;
  var selectedDate = Rxn<DateTime>();
  var lastNote = ''.obs;

  final followUpTypes = ['Call', 'Message', 'Email', 'Meeting'];

  @override
  void onInit() {
    super.onInit();
    loadLastNote();
  }

  void setType(String type) {
    selectedType.value = type;
  }

  void setDate(DateTime date) {
    selectedDate.value = date;
  }

  void addFollowUp({
    required String leadId,
    required String type,
    required String note,
    required DateTime followUpDate,
  })async {
    // Save to DB or API call
    print("Lead: $leadId, Type: $type, Note: $note, Date: $followUpDate");
    lastNote.value = note;
    await saveLastNote(note);
  }

  Future<void> saveLastNote(String note) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_note', note);
  }

  Future<void> loadLastNote() async {
    final prefs = await SharedPreferences.getInstance();
    lastNote.value = prefs.getString('last_note') ?? '';
  }
}
