import 'package:get/get.dart';

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
