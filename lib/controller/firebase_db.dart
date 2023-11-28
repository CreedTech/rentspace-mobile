import 'package:firebase_auth/firebase_auth.dart';
import 'package:rentspace/constants/firebase_auth_constants.dart';

final User? user = auth.currentUser;
final userId = user?.uid;
