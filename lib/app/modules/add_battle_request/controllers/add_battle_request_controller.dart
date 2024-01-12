// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:get/get.dart';
import 'package:ia05_07_battlesearcher/app/data/models/poketeamreduced.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddBattleRequestController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  RxMap availableOpponents = {}.obs;

  SupabaseClient client = Supabase.instance.client;

  Future<void> getAllUsers() async {
    isLoading.value = true;
    //get user id before get all notes data
    var teamRegistry = await client
        .from("profiles")
        .select("id, username, avatar_url, teams ( team )");

    availableOpponents.clear();

    teamRegistry.forEach((element) async {
      if (element["teams"] != null) {
        availableOpponents[element["id"]] = PokeTeamReduced(
            id: element["id"],
            userName: element["username"],
            team: element["teams"]["team"],
            avatar: element["avatar_url"] ?? '');
        //print(availableOpponents.toString());
      }
    });
    isLoading.value = false;
  }

  Future<void> addBattle(String externalId) async {
    try {
      //print(externalId);
      await client.from('battles').upsert({
        'id_local': client.auth.currentUser!.id,
        'status': 0,
        'id_visitante': externalId
      });
    } catch (e) {
      Get.snackbar("ERROR", e.toString());
    }
  }
}
