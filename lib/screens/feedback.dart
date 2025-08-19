import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:scan_qrcode/screens/thanks.dart';

class Improvement extends StatefulWidget {
  const Improvement({Key? key}) : super(key: key);

  @override
  State<Improvement> createState() => _ImprovementState();
}

class _ImprovementState extends State<Improvement> {
  final controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Feedback'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Container(
        padding: const EdgeInsets.all(45.30),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Got any problems ? Or is there any features that you want to see in the future ? In order to serve the best for you, we would love to hear your feedback !',
                textAlign: TextAlign.center,
              ),
              const Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 15.0, vertical: 20)),
              SizedBox(
                width: 300,
                child: TextFormField(
                  controller: controller,
                  decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 120.0, horizontal: 10.0),
                      label: const Center(
                        child: Text("Enter your Feedback here"),
                      ),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8))),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: 300,
                    child: ElevatedButton(
                      style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(18.0))),
                          backgroundColor: MaterialStateProperty.all(
                              Colors.purple.shade900), foregroundColor: MaterialStateProperty.all(
                              Colors.white)),
                      onPressed: () async {
                        if (controller.text.isNotEmpty) {
                          return PanaraConfirmDialog.show(
                            context,
                            title: "Submit Feedback ?",
                            message:
                                'Are you sure want to submit your feedback ?',
                            confirmButtonText: "Yes",
                            cancelButtonText: "No",
                            onTapCancel: () {
                              Navigator.pop(context);
                            },
                            onTapConfirm: () {
                              submitFeedback(
                                  feedback: controller.text,
                                  date: DateTime.now().toString());
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(
                                const SnackBar(
                                    backgroundColor: Colors.green,
                                    content: Text(
                                        'Feedback has been submitted succesfully')),
                              );
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const Thanks()));
                            },
                            panaraDialogType: PanaraDialogType.normal,
                          );
                        } else {
                          ScaffoldMessenger.of(context)..removeCurrentSnackBar()..showSnackBar(
                            const SnackBar(
                                backgroundColor: Colors.red,
                                content: Text(
                                    'Please enter your feedback before clicking submit')),
                          );
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future submitFeedback(
      {required String feedback, required String date}) async {
    final feedbackUser =
        FirebaseFirestore.instance.collection('feedback').doc();
    final json = {
      'feedback': feedback,
      'date': date,
      'type': "Feedback",
      'userID': FirebaseAuth.instance.currentUser!.uid.toString()
    };
    await feedbackUser.set(json);
  }
}
