// ignore_for_file: must_be_immutable, invalid_use_of_protected_member

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ia05_07_battlesearcher/app/data/models/battlestate.dart';
import 'package:ia05_07_battlesearcher/app/data/models/poketeam.dart';
import 'package:ia05_07_battlesearcher/app/modules/edit_battle_request/controllers/edit_battle_request_controller.dart';
import 'package:ia05_07_battlesearcher/app/modules/home/controllers/home_controller.dart';
import 'package:ia05_07_battlesearcher/app/modules/home/views/home_view.dart';

class EditBattleRequestView extends GetView<EditBattleRequestController> {
  PokeTeam opponentTeam = Get.arguments;
  HomeController homeC = Get.find();

  EditBattleRequestView({super.key});

  @override
  Widget build(BuildContext context) {
    BattleState selectedBattleState = battleStates[opponentTeam.status.value];
    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Battle Status'),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.secondary,
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            Text(
              opponentTeam.userName.value,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            teamToImage(
              teamList: List.from(opponentTeam.team.value),
              imageSize: 50.0,
            ),
            DropdownButton<BattleState>(
              value: selectedBattleState,
              onChanged: (newValue) async {
                await controller.updateBattle(
                    newValue!.id, opponentTeam.id.value);
                homeC.getBattles();
                Get.back();
              },
              items: battleStates.map((BattleState bs) {
                return DropdownMenuItem<BattleState>(
                  value: bs,
                  child: Text(bs.name),
                );
              }).toList(),
            ),
            Obx(() => ElevatedButton(
                onPressed: () async {
                  if (controller.isLoading.isFalse) {
                    await homeC.getBattles();
                    Get.back();

                    controller.isLoading.value = false;
                  }
                },
                child: Text(
                    controller.isLoading.isFalse ? "Edit note" : "Loading...")))
          ],
        ));
  }
}
