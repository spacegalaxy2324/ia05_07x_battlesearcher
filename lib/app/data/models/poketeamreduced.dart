import 'package:get/get.dart';

class PokeTeamReduced extends GetxController {
  RxString id = "0".obs;
  RxString userName = "".obs;
  RxList<dynamic> team = [].obs;
  RxString avatar = "".obs;

  PokeTeamReduced({
    required String id,
    required String userName,
    required List<dynamic> team,
    String avatar = "",
  }) {
    this.id.value = id;
    this.userName.value = userName;
    this.team.value = team;
    this.avatar.value = avatar;
  }
}
