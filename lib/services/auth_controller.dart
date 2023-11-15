import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';


final fi = FirebaseFirestore.instance;
final userFR = fi.collection('users');
FirebaseStorage storage = FirebaseStorage.instance;
Reference storageReference = storage.ref();



