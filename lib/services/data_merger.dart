import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scan_qrcode/model/user.dart';

class DataMerger {
  static Future<int> mergeAnonymousDataToExistingAccount(String anonymousUserId, String targetUserId) async {
    final firestore = FirebaseFirestore.instance;
    
    try {
      print('Starting merge from $anonymousUserId to $targetUserId');
      
      // Get all history data from anonymous user
      final anonymousHistoryQuery = await firestore
          .collection('history')
          .where('userID', isEqualTo: anonymousUserId)
          .get();
      
      if (anonymousHistoryQuery.docs.isEmpty) {
        print('No anonymous data to merge');
        return 0; // No data to merge
      }
      
      print('Found ${anonymousHistoryQuery.docs.length} anonymous history items');
      
      // Batch write operations for efficiency
      final batch = firestore.batch();
      int mergedCount = 0;
      
      for (final doc in anonymousHistoryQuery.docs) {
        final historyData = doc.data();
        final anonymousHistory = History.fromJson(historyData);
        
        // Create new document for the existing account (no duplicate checking)
        final newDocRef = firestore.collection('history').doc();
        final mergedHistory = History(
          docID: newDocRef.id,
          link: anonymousHistory.link,
          date: anonymousHistory.date,
          userID: targetUserId,
          isFavorite: anonymousHistory.isFavorite,
        );
        
        batch.set(newDocRef, mergedHistory.toJson());
        mergedCount++;
        print('Merging item: ${anonymousHistory.link}');
        
        // Delete the anonymous version
        batch.delete(doc.reference);
      }
      
      // Commit all changes
      await batch.commit();
      print('Data merge completed: $mergedCount items processed');
      
      return mergedCount;
      
    } catch (e) {
      print('Error merging anonymous data: $e');
      return 0; // Don't throw exception, just return 0 to indicate no merge
    }
  }
  
  static Future<int> getAnonymousHistoryCount() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null || !currentUser.isAnonymous) {
      return 0;
    }
    
    try {
      final query = await FirebaseFirestore.instance
          .collection('history')
          .where('userID', isEqualTo: currentUser.uid)
          .get();
      
      return query.docs.length;
    } catch (e) {
      print('Error getting anonymous history count: $e');
      return 0;
    }
  }
  
  static Future<void> deleteAnonymousAccount(String anonymousUserId) async {
    final firestore = FirebaseFirestore.instance;
    
    try {
      print('Cleaning up anonymous account: $anonymousUserId');
      
      // Delete all remaining anonymous data (in case merge wasn't called)
      final anonymousHistoryQuery = await firestore
          .collection('history')
          .where('userID', isEqualTo: anonymousUserId)
          .get();
      
      if (anonymousHistoryQuery.docs.isNotEmpty) {
        final batch = firestore.batch();
        for (final doc in anonymousHistoryQuery.docs) {
          batch.delete(doc.reference);
        }
        await batch.commit();
        print('Deleted ${anonymousHistoryQuery.docs.length} remaining anonymous history items');
      }
      
      print('Anonymous account cleanup completed');
      
    } catch (e) {
      print('Error cleaning up anonymous account: $e');
      // Don't throw error, just log it - account cleanup shouldn't block sign-in
    }
  }
}