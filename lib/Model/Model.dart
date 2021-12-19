import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;

void writeToFireStore() {
  firestore.collection("test").add(
      {
        "name" : "john",
        "age" : 50,
        "email" : "example@example.com",
        "address" : {
          "street" : "street 24",
          "city" : "new york"
        }
      }).then((value){
    print(value.id);
  });
}