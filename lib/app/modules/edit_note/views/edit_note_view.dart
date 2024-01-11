// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ia05_07_battlesearcher/app/modules/home/controllers/home_controller.dart';
import 'package:ia05_07_battlesearcher/app/modules/home/views/home_view.dart';

import '../controllers/edit_note_controller.dart';

class BattleState {
  const BattleState(this.id, this.name);

  final String name;
  final int id;
}

class EditNoteView extends GetView<EditNoteController> {
  PokeTeam opponentTeam = Get.arguments;
  HomeController homeC = Get.find();

  List<BattleState> battleStates = <BattleState>[
    const BattleState(0, "Pending"),
    const BattleState(1, "In progress"),
    const BattleState(2, "Won"),
    const BattleState(3, "Lost"),
    const BattleState(4, "Cancelled")
  ];

  EditNoteView({super.key});

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
            // TextField(
            //   controller: controller.titleC,
            //   decoration: const InputDecoration(
            //     labelText: "Title",
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            // const SizedBox(
            //   height: 25,
            // ),
            // TextField(
            //   controller: controller.descC,
            //   decoration: const InputDecoration(
            //     labelText: "Description",
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
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
