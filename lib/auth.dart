import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:jerias_math/api/loadtestdata.dart';
import 'package:jerias_math/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class NavigationController extends ChangeNotifier {
//   String screenName = '/';
//   void changeScreen(String newScreenName) {
//     screenName = newScreenName;
//     notifyListeners();
//   }

//   void gotoLoginPage() {
//     screenName = '/login';
//   }
// }

class PhoneAuthApp extends StatelessWidget {
  const PhoneAuthApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phone Auth App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PhoneAuthScreen(),
    );
  }
}

class PhoneAuthScreen extends StatefulWidget {
  const PhoneAuthScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PhoneAuthScreenState createState() => _PhoneAuthScreenState();
}

class _PhoneAuthScreenState extends State<PhoneAuthScreen> {
  final TextEditingController _phoneNumberController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _loginWithPhone(BuildContext context) async {
    await _auth.verifyPhoneNumber(
      phoneNumber:
          _phoneNumberController.text, // Replace with your phone number
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        // User successfully logged in, navigate to the home page
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MyHomePage()),
        );
      },
      verificationFailed: (FirebaseAuthException e) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error logging ${_phoneNumberController.text}'),
              content:
                  Text('Verification failed. Please try again. ${e.message}'),
              actions: [
                TextButton(
                  child: const Text('OK'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ],
            );
          },
        );
      },
      codeSent: (String verificationId, int? resendToken) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            String smsCode = "";
            return AlertDialog(
              title: const Text('Enter Verification Code'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      smsCode = value;
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: const Text('Submit'),
                  onPressed: () async {
                    PhoneAuthCredential credential =
                        PhoneAuthProvider.credential(
                      verificationId: verificationId,
                      smsCode: smsCode,
                    );
                    await _auth.signInWithCredential(credential);

                    await getUser(_auth.currentUser!.uid.toString());

                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    await prefs.setString('verificationId', verificationId);
                    await prefs.setString('smsCode', smsCode);

                    // User successfully logged in, navigate to the home page
                    // ignore: use_build_context_synchronously
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyHomePage()),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _phoneNumberController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Phone Number',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Login with Phone'),
              onPressed: () => _loginWithPhone(context),
            ),
          ],
        ),
      ),
    );
  }
}
