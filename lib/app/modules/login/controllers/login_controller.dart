import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isHidden = true.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passwordC = TextEditingController();

  TextEditingController nameNewC = TextEditingController();
  TextEditingController emailNewC = TextEditingController();
  TextEditingController passwordNewC = TextEditingController();

  SupabaseClient client = Supabase.instance.client;

  Future<bool?> login() async {
    if (emailC.text.isNotEmpty && passwordC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        await client.auth
            .signInWithPassword(email: emailC.text, password: passwordC.text);
        isLoading.value = false;
        Get.defaultDialog(
            barrierDismissible: false,
            title: "Login success",
            middleText: "Will be redirect to Home Page",
            backgroundColor: Colors.green);
        return true;
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("ERROR", e.toString());
      }
    } else {
      Get.snackbar("ERROR", "Email and password are required");
    }
    return null;
  }

  Future<void> signUp(context) async {
    if (emailNewC.text.isNotEmpty &&
        passwordNewC.text.isNotEmpty &&
        nameNewC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        //print(nameNewC.text);
        AuthResponse res = await client.auth.signUp(
            password: passwordNewC.text,
            email: emailNewC.text,
            data: {'username': nameNewC.text});
        isLoading.value = false;

        //print('registro ok');
        Get.defaultDialog(
            barrierDismissible: false,
            title: "You've been signed up!",
            middleText:
                "Check your inbox or spam folder at ${res.user!.email} to confirm your account.",
            actions: [
              OutlinedButton(
                  onPressed: () {
                    Get.back(); //close dialog
                    Navigator.of(context).pop(); //back to login page
                  },
                  child: const Text("GOT IT"))
            ]);
      } catch (e) {
        isLoading.value = false;
        Get.snackbar("ERROR", e.toString());
      }
    } else {
      Get.snackbar("ERROR", "Email, password and name are required");
    }
  }
}
