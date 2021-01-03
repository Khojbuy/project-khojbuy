import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserInformation {
  String name, phnNo, city;
  void initState() async {
    DocumentSnapshot snap = await FirebaseFirestore.instance
        .collection('BuyerData')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    name = snap.data()['Name'];
    phnNo = snap.data()['Contact'];
    city = snap.data()['City'];
  }

  String getName() {
    print(name);
    return name;
  }

  String getCity() {
    return city;
  }
}
