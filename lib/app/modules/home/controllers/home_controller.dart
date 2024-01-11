// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PokeTeam extends GetxController {
  RxString id = "0".obs;
  RxString userName = "".obs;
  RxList<dynamic> team = [].obs;
  RxInt status = 0.obs;

  PokeTeam({
    required String id,
    required String userName,
    required List<dynamic> team,
    required int status,
  }) {
    this.id.value = id;
    this.userName.value = userName;
    this.team.value = team;
    this.status.value = status;
  }
}

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  // RxMap teamsList = <List<dynamic>, List<dynamic>>{}.obs;
  RxMap battleHistory = {}.obs;
  SupabaseClient client = Supabase.instance.client;

  Future<void> getBattles() async {
    //print("asking for battles");
    //get user id before get all notes data
    var battleRegistry = await client.from("battles").select().match(
      {
        "id_local": client.auth.currentUser!.id
      }, //get all notes data with match user id
    );

    battleHistory.clear();

    battleRegistry.forEach((element) async {
      String idVisitante = element["id_visitante"];
      List<dynamic> res2 = await client
          .from("teams")
          .select("team , profiles ( username )")
          .match({"id": idVisitante});
      Map<dynamic, dynamic> teamInfo = (res2).first as Map<String, dynamic>;
      battleHistory[element["id"]] = PokeTeam(
          id: idVisitante,
          userName: teamInfo["profiles"]["username"],
          team: teamInfo["team"],
          status: element["status"]);
      //print(battleHistory.toString());
    });
  }

  Future<void> deleteNote(int id) async {
    await client.from("notes").delete().match({
      "id": id,
    });
    getBattles();
  }
}
