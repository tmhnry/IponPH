import 'package:flutter/material.dart';
import './login_screen.dart';

class SignUp extends StatelessWidget {
  static String routeName = 'sign_up';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50),
            Center(
              child: FittedBox(
                child: Text(
                  'CATALYST',
                  style: TextStyle(
                    fontSize: 40,
                    fontFamily: 'quicktechhalf',
                  ),
                ),
              ),
            ),
            Center(
              child: FittedBox(
                child: Text(
                  'IPON',
                  style: TextStyle(
                    fontSize: 32,
                    fontFamily: 'quicktechhalf',
                  ),
                ),
              ),
            ),
            Center(
              child: FittedBox(
                child: const Text(
                  'Catalyze your Business with us!',
                  style: TextStyle(fontSize: 20, color: Colors.blue),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Form(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    child: TextFormField(
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 12),
                          hintText: 'Product Key',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          prefixIcon: Icon(Icons.vpn_key_rounded)),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    child: TextFormField(
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                        hintText: 'Email',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        prefixIcon: Icon(
                          Icons.email_sharp,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                        hintText: 'Password',
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        prefixIcon: Icon(
                          Icons.no_encryption_gmailerrorred_rounded,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(12),
                    child: TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 15, horizontal: 12),
                        hintText: 'Confirm Password',
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        prefixIcon: Icon(
                          Icons.no_encryption_gmailerrorred_rounded,
                        ),
                      ),
                    ),
                  ),
                  const Center(
                    child: FittedBox(
                      child: Text(
                        'By clicking Sign Up, you agree to our Terms and Conditions.',
                        style: TextStyle(fontSize: 14, color: Colors.black),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () =>
                        Navigator.of(context).pushNamed(LogIn.routeName),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 18),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width - 150,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
