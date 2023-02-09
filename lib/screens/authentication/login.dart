import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:socket_io_chat_flutter/repository/data_client/user_client.dart';
import 'package:socket_io_chat_flutter/repository/data_model/user_login_model.dart';
import 'package:socket_io_chat_flutter/screens/custom_widgets/input_text_field.dart';

import '../home_page/home.dart';
import '../utils/show_toast.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController =
      TextEditingController(text: 'admin@gmail.com');
  final TextEditingController passwordController =
      TextEditingController(text: 'admin');
  late UserClient _userClient;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    _userClient = Provider.of<UserClient>(context, listen: false);
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextInputFiled(
                controller: emailController,
                hintText: 'UserName',
                userValidationMessage: 'UserName',
                onChanged: (String? value) {
                  if (value == null) {
                    "Please enter userName";
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              MyTextInputFiled(
                controller: passwordController,
                hintText: 'Password',
                onChanged: (value) {
                  if (value.isEmpty) {
                    "Please enter password";
                  }
                },
                userValidationMessage: 'Password',
              ),
              const SizedBox(
                height: 50,
              ),
              ElevatedButton(
                  onPressed: () async {
                    print('..........${formKey.currentState!.validate()}');
                    if (formKey.currentState!.validate()) {
                      var user = await _userClient.postUserAuth(
                          userLoginModel: UserLoginModel(
                              username: 'admin@gmail.com', password: 'admin'));
                      if (user!.email!.isNotEmpty) {
                        CustomToast.showToast(msg: 'Login Successfully');
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const MyHomePage(
                                title: 'Welcome To chat',
                              ),
                            ));
                      } else {
                        CustomToast.showToast(msg: 'Login failed');
                      }
                    }
                  },
                  child: const Text('Login'))
            ],
          ),
        ),
      ),
    );
  }
}
