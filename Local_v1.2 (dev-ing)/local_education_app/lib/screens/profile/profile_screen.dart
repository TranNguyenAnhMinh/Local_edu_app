import 'package:flutter/material.dart';
import 'package:local_education_app/models/user/user.dart';
import 'package:local_education_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        return FutureBuilder<User?>(
          future: auth.getProfile(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text("HỒ SƠ CỦA BẠN"),
                  centerTitle: true,
                ),
                body: Center(
                  child: CircularProgressIndicator(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              );
            } else {
              User? currentUser = snapshot.data;
              return Scaffold(
                appBar: AppBar(
                  title: const Text("HỒ SƠ CỦA BẠN"),
                  centerTitle: true,
                ),
                body: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Hello ${currentUser?.name}",
                      ),
                      Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white),
                            onPressed: () async {
                              await auth.logOut();
                            },
                            child: const Text("Logout")),
                      )
                    ],
                  ),
                ),
              );
            }
          },
        );
      },
    );
  }
}
