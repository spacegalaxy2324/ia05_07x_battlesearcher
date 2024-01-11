import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ia05_07_battlesearcher/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController nameC = TextEditingController();
  TextEditingController nameC2 = TextEditingController();
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();
  TextEditingController pkmn1C = TextEditingController();
  RxString pkmn1CId = "0".obs;
  TextEditingController pkmn2C = TextEditingController();
  RxString pkmn2CId = "0".obs;
  TextEditingController pkmn3C = TextEditingController();
  RxString pkmn3CId = "0".obs;
  TextEditingController pkmn4C = TextEditingController();
  RxString pkmn4CId = "0".obs;
  TextEditingController pkmn5C = TextEditingController();
  RxString pkmn5CId = "0".obs;
  TextEditingController pkmn6C = TextEditingController();
  RxString pkmn6CId = "0".obs;

  List<dynamic> pkmnList = [].obs;

  SupabaseClient client = Supabase.instance.client;

  Future<void> logout() async {
    await client.auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }

  Future<void> getProfile() async {
    List<dynamic> res = await client
        .from("profiles")
        .select()
        .match({"id": client.auth.currentUser!.id});
    Map<String, dynamic> user = (res).first as Map<String, dynamic>;
    nameC.text = user["username"];
    nameC2.text = user["username"];
    emailC.text = client.auth.currentUser!.email!;

    pkmnList = await client.from("pokemon").select();

    List<dynamic> res2 = await client
        .from("teams")
        .select()
        .match({"id": client.auth.currentUser!.id});
    if (res2.isNotEmpty) {
      Map<String, dynamic> teamInfo = (res2).first as Map<String, dynamic>;
      pkmn1C.text = pkmnList[int.parse(teamInfo["team"][0]) - 1]["name"];
      pkmn1CId.value = teamInfo["team"][0];
      pkmn2C.text = pkmnList[int.parse(teamInfo["team"][1]) - 1]["name"];
      pkmn2CId.value = teamInfo["team"][1];
      pkmn3C.text = pkmnList[int.parse(teamInfo["team"][2]) - 1]["name"];
      pkmn3CId.value = teamInfo["team"][2];
      pkmn4C.text = pkmnList[int.parse(teamInfo["team"][3]) - 1]["name"];
      pkmn4CId.value = teamInfo["team"][3];
      pkmn5C.text = pkmnList[int.parse(teamInfo["team"][4]) - 1]["name"];
      pkmn5CId.value = teamInfo["team"][4];
      pkmn6C.text = pkmnList[int.parse(teamInfo["team"][5]) - 1]["name"];
      pkmn6CId.value = teamInfo["team"][5];
      //print(teamInfo);
    }
  }

  Future<void> updateProfile() async {
    if (nameC2.text.isNotEmpty) {
      isLoading.value = true;
      await client.from("profiles").update({
        "username": nameC2.text,
      }).match({"id": client.auth.currentUser!.id});
      // if user want to update password
      if (passwordC.text.isNotEmpty) {
        if (passwordC.text.length >= 6) {
          try {
            await client.auth.updateUser(UserAttributes(
              password: passwordC.text,
            ));
          } catch (e) {
            Get.snackbar("ERROR", e.toString());
          }
        } else {
          Get.snackbar("ERROR", "Password must be longer than 6 characters");
        }
      }
      Get.defaultDialog(
          barrierDismissible: false,
          title: "Update Profile success",
          middleText: "Name or Password will be updated",
          actions: [
            OutlinedButton(
                onPressed: () {
                  Get.back(); //close dialog
                  Get.back(); //back to login page
                },
                child: const Text("OK"))
          ]);
      isLoading.value = false;
    }
  }

  Future<void> updateTeam() async {
    try {
      await client.from('teams').upsert({
        'id': client.auth.currentUser!.id,
        'team': [
          pkmn1CId.value,
          pkmn2CId.value,
          pkmn3CId.value,
          pkmn4CId.value,
          pkmn5CId.value,
          pkmn6CId.value
        ]
      });
    } catch (e) {
      Get.snackbar("ERROR", e.toString());
    }
  }
}
