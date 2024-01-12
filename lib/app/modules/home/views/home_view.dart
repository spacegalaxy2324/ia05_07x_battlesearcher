// ignore_for_file: camel_case_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ia05_07_battlesearcher/app/data/models/battlestatusstyle.dart';
import 'package:ia05_07_battlesearcher/app/modules/avatar/avatar_view.dart';
import 'package:ia05_07_battlesearcher/app/routes/app_pages.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text('BATTLE SEARCHER', style: GoogleFonts.tiltWarp()),
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          centerTitle: true,
          leading: IconButton(
            onPressed: () async {
              controller.getBattles();
            },
            icon: const Icon(Icons.refresh),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton.filledTonal(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () async {
                  Get.toNamed(Routes.PROFILE);
                },
                icon: Avatar(onUpload: (_) {}, size: 30.0),
              ),
            )
          ],
        ),
        body: Column(
          children: [
            Flexible(
              flex: 1,
              child: Center(
                child: Text(
                  "Pending Battles",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            Flexible(
                flex: 6,
                child: battleRequested(
                    controller: controller, battleStatus: "pending")),
            Flexible(
              flex: 1,
              child: Center(
                child: Text(
                  "Battle History",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ),
            Flexible(
                flex: 6,
                child: battleRequested(
                    controller: controller, battleStatus: "all")),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Get.toNamed(Routes.ADD_NOTE),
          child: const Icon(Icons.add),
        ));
  }
}

class battleRequested extends StatelessWidget {
  final HomeController controller;
  final String battleStatus;

  const battleRequested(
      {super.key, required this.controller, required this.battleStatus});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: controller.getBattles(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          return Obx(() => controller.battleHistory.isEmpty
              ? const Center(
                  child: Text(
                      "We found no data on the server, create your team on your user profile page."),
                )
              : ListView.builder(
                  itemCount: controller.battleHistory.length,
                  itemBuilder: (BuildContext context, int index) {
                    int teamUser =
                        controller.battleHistory.keys.elementAt(index);
                    int statusValue =
                        controller.battleHistory[teamUser].status.value;
                    BattleStatusStyle bss = getBSS(statusValue);
                    return Column(
                      children: <Widget>[
                        if (battleStatus == "all" ||
                            battleStatus == "pending" && statusValue == 0)
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
                                onTap: () => Get.toNamed(
                                  Routes.EDIT_NOTE,
                                  arguments: controller.battleHistory[teamUser],
                                ),
                                textColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                iconColor:
                                    Theme.of(context).colorScheme.onPrimary,
                                leading: bss.statusIcon,
                                title: Text(controller
                                    .battleHistory[teamUser].userName.value),
                                subtitle: teamToImage(
                                    teamList: List.from(controller
                                        .battleHistory[teamUser].team.value)),
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ));
        });
  }
}

class teamToImage extends StatelessWidget {
  const teamToImage(
      {super.key,
      required this.teamList,
      this.imageSize = 30.0,
      this.alignment = MainAxisAlignment.start});

  final List<String> teamList;
  final double imageSize;
  final MainAxisAlignment alignment;

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: alignment,
        children: teamList
            .map((item) => Image.network(
                  'https://fnpdkywuecflignysqdi.supabase.co/storage/v1/object/public/icons/$item.png',
                  height: imageSize,
                ))
            .toList());
  }
}
