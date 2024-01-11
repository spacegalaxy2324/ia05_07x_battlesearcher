import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ia05_07_battlesearcher/app/controllers/auth_controller.dart';
import 'package:ia05_07_battlesearcher/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  final authC = Get.find<AuthController>();

  LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Image.asset('assets/logo.png'),
            ),
          ),
          TextField(
            autocorrect: false,
            controller: controller.emailC,
            textInputAction: TextInputAction.next,
            decoration: const InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.email_outlined),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(() => TextField(
                autocorrect: false,
                controller: controller.passwordC,
                textInputAction: TextInputAction.done,
                obscureText: controller.isHidden.value,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                      onPressed: () => controller.isHidden.toggle(),
                      icon: controller.isHidden.isTrue
                          ? const Icon(Icons.remove_red_eye)
                          : const Icon(Icons.remove_red_eye_outlined)),
                  labelText: "Password",
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.password),
                ),
              )),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton.icon(
                  icon: const Icon(Icons.help),
                  onPressed: null,
                  label: const Text("FORGOT PASSWORD")),
              Obx(() => ElevatedButton.icon(
                    icon: const Icon(Icons.login),
                    onPressed: () async {
                      if (controller.isLoading.isFalse) {
                        bool? cekAutoLogout = await controller.login();
                        if (cekAutoLogout != null && cekAutoLogout == true) {
                          await authC.autoLogout();
                          Get.offAllNamed(Routes.HOME);
                        }
                      }
                    },
                    label: Text(
                        controller.isLoading.isFalse ? "LOGIN" : "Loading..."),
                  )),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          const Row(children: <Widget>[
            Expanded(child: Divider()),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 20.0),
              child: Text(
                "or",
                style: TextStyle(fontSize: 20),
              ),
            ),
            Expanded(child: Divider()),
          ]),
          const SizedBox(
            height: 20,
          ),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
                icon: const Icon(Icons.person_add_alt_1),
                onPressed: () => {dialogSMBS(context)},
                label: const Text("CREATE AN ACCOUNT")),
          ),
        ],
      ),
    ));
  }

  Future<dynamic> dialogSMBS(BuildContext context) {
    InputDecoration inputModuleDecoration(String label, Icon prefix,
        [IconButton? suffix]) {
      return InputDecoration(
        prefixIconColor: Theme.of(context).colorScheme.onPrimary,
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onPrimary, width: 0.0),
        ),
        labelText: label,
        border: const OutlineInputBorder(),
        prefixIcon: prefix,
        suffixIcon: suffix,
      );
    }

    return showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              height: 400,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      Text("Create your account here",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge!
                              .copyWith(
                                color: Theme.of(context).colorScheme.onPrimary,
                              )),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                          autocorrect: false,
                          controller: controller.nameNewC,
                          textInputAction: TextInputAction.next,
                          decoration: inputModuleDecoration(
                              "Username", const Icon(Icons.person))),
                      const SizedBox(
                        height: 20,
                      ),
                      TextField(
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        autocorrect: false,
                        controller: controller.emailNewC,
                        textInputAction: TextInputAction.next,
                        decoration: inputModuleDecoration(
                            "Email", const Icon(Icons.email_outlined)),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(() => TextField(
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                            autocorrect: false,
                            controller: controller.passwordNewC,
                            textInputAction: TextInputAction.done,
                            obscureText: controller.isHidden.value,
                            decoration: inputModuleDecoration(
                              "Password",
                              const Icon(Icons.password),
                              IconButton(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  onPressed: () => controller.isHidden.toggle(),
                                  icon: controller.isHidden.isTrue
                                      ? const Icon(Icons.remove_red_eye)
                                      : const Icon(
                                          Icons.remove_red_eye_outlined)),
                            ),
                          )),
                      const SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton.icon(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            label: const Text("CANCEL"),
                            style: TextButton.styleFrom(
                              iconColor:
                                  Theme.of(context).colorScheme.onPrimary,
                              foregroundColor:
                                  Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                          Obx(() => ElevatedButton.icon(
                                icon: const Icon(Icons.publish),
                                onPressed: () {
                                  if (controller.isLoading.isFalse) {
                                    controller.signUp(context);
                                  }
                                },
                                label: Text(controller.isLoading.isFalse
                                    ? "REGISTER"
                                    : "Loading..."),
                              )),
                        ],
                      ),
                    ],
                  ),
                ),
              ));
        });
  }
}
