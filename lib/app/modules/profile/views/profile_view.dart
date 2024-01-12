// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ia05_07_battlesearcher/app/controllers/auth_controller.dart';
import 'package:ia05_07_battlesearcher/app/modules/avatar/avatar_view.dart';
import 'package:ia05_07_battlesearcher/app/routes/app_pages.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../controllers/profile_controller.dart';
// DropdownMenuEntry labels and values for the second dropdown menu.

class ProfileView extends GetView<ProfileController> {
  final authC = Get.find<AuthController>();

  /// Called when image has been uploaded to Supabase storage from within Avatar widget
  Future<void> _onUpload(String imageUrl) async {
    try {
      final userId = authC.client.auth.currentUser!.id;
      await authC.client.from('profiles').upsert({
        'id': userId,
        'avatar_url': imageUrl,
      });
    } on PostgrestException catch (error) {
      SnackBar(
        content: Text(error.message),
      );
    } catch (error) {
      SnackBar(
        content: const Text('Unexpected error occurred'),
      );
    }
    controller.avatarUrl.value = imageUrl;
  }

  Widget pokemonSelector(
      TextEditingController controllerPkmn, RxString controllerPkmnId) {
    return Padding(
      padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
      child: DropdownMenu<String>(
        controller: controllerPkmn,
        enableFilter: true,
        requestFocusOnTap: true,
        leadingIcon: Obx(() => Image.network(
              'https://fnpdkywuecflignysqdi.supabase.co/storage/v1/object/public/icons/${controllerPkmnId.value}.png',
              height: 30.0,
            )),
        hintText: 'Pokémon ',
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          contentPadding: EdgeInsets.symmetric(vertical: 5.0),
        ),
        onSelected: (value) {
          controllerPkmnId.value = value!;
        },
        dropdownMenuEntries: controller.pkmnList
            .map((pokemon) => DropdownMenuEntry<String>(
                value: pokemon['id'].toString(),
                label: pokemon['name'],
                leadingIcon: Image.network(
                  'https://fnpdkywuecflignysqdi.supabase.co/storage/v1/object/public/icons/${pokemon['id'].toString()}.png',
                  height: 50.0,
                )))
            .toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: const Text(''),
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.settings)),
                  Tab(icon: Icon(Icons.person_pin)),
                ],
              ),
              centerTitle: true,
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 10.0),
                  child: FilledButton.icon(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        await controller.logout();
                        await authC.resetTimer();
                        Get.offAllNamed(Routes.LOGIN);
                      },
                      label: const Text(
                        "LOGOUT",
                        style: TextStyle(color: Colors.white),
                      )),
                )
              ],
            ),
            body: TabBarView(children: [
              FutureBuilder(
                  future: controller.getProfile(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return ListView(
                      padding: const EdgeInsets.all(10),
                      children: [
                        Center(
                          child: Text(
                            "Your team",
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                pokemonSelector(
                                    controller.pkmn1C, controller.pkmn1CId),
                                pokemonSelector(
                                    controller.pkmn2C, controller.pkmn2CId),
                                pokemonSelector(
                                    controller.pkmn3C, controller.pkmn3CId),
                                pokemonSelector(
                                    controller.pkmn4C, controller.pkmn4CId),
                                pokemonSelector(
                                    controller.pkmn5C, controller.pkmn5CId),
                                pokemonSelector(
                                    controller.pkmn6C, controller.pkmn6CId)
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Obx(() => ElevatedButton.icon(
                              icon: const Icon(Icons.refresh),
                              onPressed: () async {
                                if (controller.isLoading.isFalse) {
                                  await controller.updateTeam();

                                  Get.snackbar("Team updated",
                                      "Updated team on the server.",
                                      borderWidth: 1,
                                      borderColor: Colors.white,
                                      barBlur: 100);
                                }
                              },
                              label: Text(controller.isLoading.isFalse
                                  ? "UPDATE TEAM"
                                  : "UPDATING..."),
                            )),
                      ],
                    );
                  }),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        "User data",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Avatar(
                      imageUrl: controller.avatarUrl.value,
                      buttonUpload: true,
                      onUpload: _onUpload,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      autocorrect: false,
                      controller: controller.nameC2,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        labelText: "Username",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      enabled: false,
                      autocorrect: false,
                      controller: controller.emailC,
                      textInputAction: TextInputAction.done,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email_outlined),
                        prefixIconColor: Theme.of(context).colorScheme.outline,
                        labelText: "Email",
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextField(
                      autocorrect: false,
                      controller: controller.passwordC,
                      textInputAction: TextInputAction.done,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.password),
                        labelText: "New password",
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Obx(() => ElevatedButton.icon(
                          icon: const Icon(Icons.refresh),
                          onPressed: () async {
                            if (controller.isLoading.isFalse) {
                              if (controller.nameC.text ==
                                      controller.nameC2.text &&
                                  controller.passwordC.text.isEmpty) {
                                // Check if user have same name and not want to change password but they click the button
                                Get.snackbar(
                                    "Info", "There is no data to update",
                                    borderWidth: 1,
                                    borderColor: Colors.white,
                                    barBlur: 100);
                                return;
                              }
                              await controller.updateProfile();
                              if (controller.passwordC.text.isNotEmpty &&
                                  controller.passwordC.text.length >= 6) {
                                await controller.logout();
                                await authC.resetTimer();
                                Get.offAllNamed(Routes.LOGIN);
                              }
                            }
                          },
                          label: Text(controller.isLoading.isFalse
                              ? "UPDATE PASSWORD"
                              : "LOGGING OUT..."),
                        )),
                  ],
                ),
              )
            ])));
  }
}
