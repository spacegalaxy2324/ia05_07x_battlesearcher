import 'package:get/get.dart';

import '../controllers/add_battle_request_controller.dart';

class AddBattleRequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddBattleRequestController>(
      () => AddBattleRequestController(),
    );
  }
}
