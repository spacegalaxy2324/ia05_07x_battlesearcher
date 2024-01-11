import 'package:get/get.dart';
import 'package:ia05_07_battlesearcher/app/modules/edit_battle_request/controllers/edit_battle_request_controller.dart';

class EditBattleRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EditBattleRequestController>(
      () => EditBattleRequestController(),
    );
  }
}
