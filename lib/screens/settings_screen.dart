import 'package:cloud_gaming/Providers/user_provider.dart';
import 'package:cloud_gaming/helpers/helper_validations.dart';
import 'package:cloud_gaming/services/backend_service.dart';
import 'package:cloud_gaming/services/firebase_auth_service.dart';
import 'package:cloud_gaming/services/notifications_service.dart';
import 'package:cloud_gaming/themes/app_theme.dart';
import 'package:cloud_gaming/widgets/custom_input_field.dart';
import 'package:cloud_gaming/widgets/widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int value = 0;
  Widget settingContainer = Container();
  refresh(Widget newWidget) {
    setState(() {
      settingContainer = newWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          const BackGround(),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CustomPannel(),
              Padding(
                padding: EdgeInsets.only(top: size.width * 0.08, left: size.height * 0.05),
                child: Container(
                  height: size.height * 0.5,
                  width: size.width * 0.55,
                  decoration: BoxDecoration(color: AppTheme.pannelColor.withOpacity(0.45), borderRadius: BorderRadius.circular(5)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20, left: 40),
                        child: Text("Settings", style: AppTheme.commonText(Colors.white54, 40)),
                      ),
                      //Aca listar las distintas opciones, se podría usar un GriView para mostrarlas
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SettingOption(
                                title: "Change Username",
                                notifyParent: refresh,
                                settingContainer: const ChangeUsername(),
                              ),
                              SettingOption(
                                title: "Change Payment",
                                notifyParent: refresh,
                                settingContainer: const ChangePayment(),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, right: 10),
                            child: Container(
                              color: Colors.white54,
                              width: 1,
                              height: size.height * 0.4,
                            ),
                          ),
                          settingContainer
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class SettingOption extends StatefulWidget {
  final Widget settingContainer;
  final Function(Widget) notifyParent;
  final String title;
  const SettingOption({
    super.key,
    required this.title,
    required this.notifyParent,
    required this.settingContainer,
  });

  @override
  State<SettingOption> createState() => _SettingOptionState();
}

class _SettingOptionState extends State<SettingOption> {
  Color color = Colors.white;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 40),
      child: InkWell(
          onTap: () {
            widget.notifyParent(widget.settingContainer);
          },
          onHover: (value) {
            if (value) {
              setState(() {
                color = AppTheme.onHoverColor.withOpacity(0.7);
              });
            } else {
              setState(() {
                color = Colors.white;
              });
            }
          },
          child: Text(widget.title, style: AppTheme.commonText(color, 20))),
    );
  }
}

class ChangeUsername extends StatelessWidget {
  const ChangeUsername({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    return SizedBox(
        height: 300,
        width: 500,
        child: Padding(
          padding: const EdgeInsets.only(left: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "New username: ",
                style: AppTheme.loginTextStyle,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: CustomInputField(
                  controller: usernameController,
                  obscureText: false,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: SizedBox(
                    width: 120,
                    height: 50,
                    child: OutlinedButton(
                        style: OutlinedButton.styleFrom(elevation: 10, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)), backgroundColor: AppTheme.primary),
                        onPressed: () async {
                          String username = usernameController.text;
                          usernameController.clear();
                          if (!isValidUsername(username)) {
                            NotificationsService.showSnackBar("Please enter a valid username", Colors.red, AppTheme.loginPannelColor);
                          } else {
                            final provider = Provider.of<UserProvider>(context, listen: false);

                            String oldUsername = provider.user["username"];

                            if (await FirebaseAuthService().changeUsername(username)) {
                              String? resp = await BackendService().changeUserData(oldUsername, provider.user);
                              if (resp != null) {
                                //Error en el cambio de nombre desde el back
                                NotificationsService.showSnackBar("Error changing username: $resp", Colors.red, AppTheme.loginPannelColor);
                                //Revertir el cambio de nombre en firebase
                                await FirebaseAuthService().changeUsername(oldUsername);
                              } else {
                                //Actualizar el usuario en el provider
                                Map<String, dynamic>? newData = await BackendService().getUser();
                                if (newData == null) {
                                  NotificationsService.showSnackBar("Error getting new user data", Colors.red, AppTheme.loginPannelColor);
                                } else {
                                  provider.updateFormValue(newData);
                                }
                              }
                            } else {
                              NotificationsService.showSnackBar("Username already taken", Colors.red, AppTheme.loginPannelColor);
                            }
                          }
                          usernameController.clear();
                        },
                        child: Text(
                          "Change",
                          style: AppTheme.commonText(Colors.white, 18),
                        )),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class ChangePayment extends StatelessWidget {
  const ChangePayment({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      height: 100,
      width: 100,
    );
  }
}
