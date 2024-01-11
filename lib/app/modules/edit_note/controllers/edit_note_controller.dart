import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EditNoteController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController battleStatus = TextEditingController();
  SupabaseClient client = Supabase.instance.client;

  Future<void> updateBattle(int newStatus, String idUser) async {
    isLoading.value = true;
    await client.from("battles").update({"status": newStatus}).match({
      "id_local": client.auth.currentUser!.id,
      "id_visitante": idUser,
    });
    isLoading.value = false;
  }
}
