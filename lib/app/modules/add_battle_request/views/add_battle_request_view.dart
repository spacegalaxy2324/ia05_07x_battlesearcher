// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:ia05_07_battlesearcher/app/data/models/battlestatusstyle.dart';
import 'package:ia05_07_battlesearcher/app/modules/home/controllers/home_controller.dart';
import 'package:ia05_07_battlesearcher/app/modules/home/views/home_view.dart';
import 'package:ia05_07_battlesearcher/app/routes/app_pages.dart';

import '../controllers/add_battle_request_controller.dart';

class AddBattleRequestView extends GetView<AddBattleRequestController> {
  HomeController homeC = Get.find();

  AddBattleRequestView({super.key}); // get controller from another controller
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Request battle'),
        centerTitle: true,
      ),
      body: FutureBuilder(
          future: controller.getAllUsers(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            return Obx(() => controller.availableOpponents.isEmpty
                ? const Center(
                    child: Text(
                        "We found no data on the server, create your team on your user profile page."),
                  )
                : ListView.builder(
                    itemCount: controller.availableOpponents.length,
                    itemBuilder: (BuildContext context, int index) {
                      String teamUser =
                          controller.availableOpponents.keys.elementAt(index);
                      BattleStatusStyle bss = const BattleStatusStyle(
                          backgroundColorStart: Color(0xFF006a6a),
                          backgroundColorEnd: Color(0xFFcaf2b2),
                          statusIcon: Icon(Icons.person));
                      return Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                // Create a gradient background
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    bss.backgroundColorStart,
                                    bss.backgroundColorEnd,
                                  ],
                                ),
                              ),
                              child: ListTile(
                                onTap: () async {
                                  if (controller.isLoading.isFalse) {
                                    await controller.addBattle(controller
                                        .availableOpponents[teamUser].id.value);
                                    Get.offAllNamed(Routes.HOME);
                                    controller.isLoading.value = false;
                                  }
                                },
                                textColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                iconColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                leading: TrainerProfile(
                                    controller: controller, teamUser: teamUser),
                                title: Text(controller
                                    .availableOpponents[teamUser]
                                    .userName
                                    .value),
                                subtitle: teamToImage(
                                    teamList: List.from(controller
                                        .availableOpponents[teamUser]
                                        .team
                                        .value)),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ));
          }),
    );
  }
}

class TrainerProfile extends StatelessWidget {
  const TrainerProfile({
    super.key,
    required this.controller,
    required this.teamUser,
  });

  final AddBattleRequestController controller;
  final String teamUser;

  @override
  Widget build(BuildContext context) {
    if (controller.availableOpponents[teamUser].avatar.value != "") {
      return Container(
        width: 30,
        height: 30,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Image.network(
          controller.availableOpponents[teamUser].avatar.value,
          width: 30,
          height: 30,
          fit: BoxFit.cover,
        ),
      );
    } else {
      return const Icon(Icons.person_pin_circle_rounded);
    }
  }
}
