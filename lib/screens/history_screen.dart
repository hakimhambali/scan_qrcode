import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scan_qrcode/model/user.dart';
import 'package:scan_qrcode/screens/result_scan_qr.dart';
import 'package:url_launcher/url_launcher.dart';
import 'register.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  bool reverseSort = false;
  bool isSelectionMode = false;
  bool showFavoritesOnly = false;
  Set<String> selectedItems = {};
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !isSelectionMode && !reverseSort && !showFavoritesOnly,
      onPopInvoked: (didPop) {
        if (!didPop && (isSelectionMode || reverseSort || showFavoritesOnly)) {
          setState(() {
            if (isSelectionMode) {
              isSelectionMode = false;
              selectedItems.clear();
            } else if (showFavoritesOnly) {
              showFavoritesOnly = false;
            } else if (reverseSort) {
              reverseSort = false;
            }
          });
        }
      },
      child: Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('History'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        leading: FirebaseAuth.instance.currentUser?.isAnonymous == true
            ? IconButton(
                icon: const Icon(Icons.info),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Register Now ?"),
                        content: Text(
                            'Currently signed in as: Anonymous\n\nYou have not registered yet. Register now to prevent losing your history if you uninstall this app or switch devices. You can also log in if you already have an account.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              if (FirebaseAuth.instance.currentUser?.isAnonymous == false) {
                                FirebaseAuth.instance.signOut();
                                FirebaseAuth.instance.signInAnonymously();
                              }
                              Navigator.pop(context);
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Register()))
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            child: const Text("Yes"),
                          ),
                        ],
                      );
                    },
                  );
                })
            : IconButton(
                icon: const Icon(Icons.info),
                onPressed: () {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Logout Now ?"),
                        content: Text(
                            'Currently signed in as: ${FirebaseAuth.instance.currentUser?.email ?? FirebaseAuth.instance.currentUser?.displayName ?? 'Unknown'}\n\nYour history data is linked to your account. You must log out before logging in with a different account or registering a new one.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("No"),
                          ),
                          TextButton(
                            onPressed: () {
                              if (FirebaseAuth.instance.currentUser?.isAnonymous == false) {
                                FirebaseAuth.instance.signOut();
                                FirebaseAuth.instance.signInAnonymously();
                              }
                              Navigator.pop(context);
                              Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const Register()))
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            child: const Text("Yes"),
                          ),
                        ],
                      );
                    },
                  );
                }),
        actions: <Widget>[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Transform.translate(
                offset: const Offset(24, 0),
                child: IconButton(
                  icon: Transform.flip(
                    flipY: reverseSort,
                    child: const Icon(Icons.sort),
                  ),
                  onPressed: () {
                    setState(() {
                      reverseSort = !reverseSort;
                    });
                  },
                ),
              ),
              Transform.translate(
                offset: const Offset(12, 0),
                child: IconButton(
                  icon: Icon(
                    showFavoritesOnly ? Icons.star : Icons.star_outline,
                    color: showFavoritesOnly ? Colors.amber : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      showFavoritesOnly = !showFavoritesOnly;
                    });
                  },
                ),
              ),
              IconButton(
                icon: Icon(isSelectionMode ? Icons.delete_outline : Icons.delete),
                onPressed: () {
                  setState(() {
                    isSelectionMode = !isSelectionMode;
                    if (!isSelectionMode) {
                      selectedItems.clear();
                    }
                  });
                },
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<List<History>>(
          stream: readUsers(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<History> users = snapshot.data!;
              
              // Check if we have no history data at all
              if (users.isEmpty && !showFavoritesOnly) {
                return RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.history,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'You have no history data yet',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Start scanning QR codes to build your history',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: Colors.grey[500],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }
              
              // Filter for favorites if needed
              if (showFavoritesOnly) {
                users = users.where((item) => item.isFavorite).toList();
                
                // Show message if no favorites found
                if (users.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: _onRefresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Container(
                        height: MediaQuery.of(context).size.height - 200,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(32.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.star_outline,
                                  size: 64,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'You have no favourited history yet',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Tap the star icon on any history item to add it to favorites',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
              }
              
              // Group items by date (day)
              Map<String, List<History>> groupedByDate = {};
              for (History item in users) {
                DateTime date = DateTime.parse(item.date).toLocal();
                String dateKey = DateFormat('yyyy-MM-dd').format(date);
                if (!groupedByDate.containsKey(dateKey)) {
                  groupedByDate[dateKey] = [];
                }
                groupedByDate[dateKey]!.add(item);
              }
              
              // Sort each group by time and sort groups by date
              List<String> sortedDateKeys = groupedByDate.keys.toList();
              sortedDateKeys.sort((a, b) => reverseSort ? a.compareTo(b) : b.compareTo(a));
              
              for (String dateKey in groupedByDate.keys) {
                groupedByDate[dateKey]!.sort((a, b) {
                  DateTime adate = DateTime.parse(a.date).toLocal();
                  DateTime bdate = DateTime.parse(b.date).toLocal();
                  return reverseSort ? adate.compareTo(bdate) : bdate.compareTo(adate);
                });
              }
              
              List<Widget> allItems = [];
              for (int i = 0; i < sortedDateKeys.length; i++) {
                allItems.add(buildDateHeader(sortedDateKeys[i], isFirst: i == 0));
                List<History> itemsInGroup = groupedByDate[sortedDateKeys[i]]!;
                for (int j = 0; j < itemsInGroup.length; j++) {
                  bool isLastItem = (i == sortedDateKeys.length - 1) && (j == itemsInGroup.length - 1);
                  allItems.add(buildScanQR(itemsInGroup[j], isLast: isLastItem));
                }
              }
              
              return RefreshIndicator(
                onRefresh: _onRefresh,
                child: ListView(
                  children: allItems,
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
      floatingActionButton: isSelectionMode && selectedItems.isNotEmpty
          ? FloatingActionButton(
              backgroundColor: Colors.red,
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text("Delete Selected Items?"),
                      content: Text('Are you sure you want to delete ${selectedItems.length} selected item(s)?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text("Cancel"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            bulkDeleteItems();
                          },
                          child: const Text("Delete"),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Icon(Icons.delete, color: Colors.white),
            )
          : null,
      ),
    );
  }

  Widget buildDateHeader(String dateKey, {bool isFirst = false}) {
    DateTime date = DateTime.parse(dateKey);
    DateTime now = DateTime.now();
    String displayText;
    
    if (DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(now)) {
      displayText = '${DateFormat('d MMM yyyy').format(date)} (Today)';
    } else if (DateFormat('yyyy-MM-dd').format(date) == DateFormat('yyyy-MM-dd').format(now.subtract(const Duration(days: 1)))) {
      displayText = '${DateFormat('d MMM yyyy').format(date)} (Yesterday)';
    } else {
      displayText = DateFormat('d MMM yyyy').format(date);
    }
    
    return Padding(
      padding: EdgeInsets.only(
        top: isFirst ? 20 : 28, 
        left: 16, 
        right: 16, 
        bottom: 0
      ),
      child: Text(
        displayText,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget buildScanQR(History item, {bool isLast = false}) => Padding(
        padding: EdgeInsets.only(
          top: 8, 
          left: 8, 
          right: 8, 
          bottom: isLast ? 80 : 0
        ),
        child: SizedBox(
          height: 75,
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(8),
            child: Container(
            decoration: BoxDecoration(
                color: Colors.green[100],
                borderRadius: BorderRadius.circular(8)),
            child: ListTile(
              leading: isSelectionMode
                  ? Checkbox(
                      value: selectedItems.contains(item.docID),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedItems.add(item.docID);
                          } else {
                            selectedItems.remove(item.docID);
                          }
                        });
                      },
                    )
                  : null,
              title: Text(
                item.link,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
              subtitle: Text(DateFormat('dd MMM yyyy')
                  .add_jm()
                  .format(DateTime.parse(item.date).toLocal())
                  .toString()),
              trailing: isSelectionMode
                  ? null
                  : Container(
                      width: 30,
                      height: 75,
                      alignment: Alignment.center,
                      child: InkWell(
                        onTap: () {
                          updateFavoriteStatus(item.docID, !item.isFavorite);
                        },
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 30,
                          height: 75,
                          alignment: Alignment.center,
                          child: Icon(
                            item.isFavorite ? Icons.star : Icons.star_outline,
                            color: item.isFavorite ? Colors.amber : Colors.grey,
                            size: 26,
                          ),
                        ),
                      ),
                    ),
              onTap: () {
                if (isSelectionMode) {
                  setState(() {
                    if (selectedItems.contains(item.docID)) {
                      selectedItems.remove(item.docID);
                    } else {
                      selectedItems.add(item.docID);
                    }
                  });
                } else {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) =>
                          ResultScanQR(result: item.link, onPop: (_) {})));
                }
              },
            ),
          ),
        ),
      ),
    );

  Future<void> _onRefresh() async {
    setState(() {
      reverseSort = false;
      showFavoritesOnly = false;
      isSelectionMode = false;
      selectedItems.clear();
    });
    
    // Add a small delay for better UX
    await Future.delayed(const Duration(milliseconds: 500));
  }

  Stream<List<History>> readUsers() => FirebaseFirestore.instance
      .collection('history')
      .where('userID', isEqualTo: FirebaseAuth.instance.currentUser?.uid ?? '')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => History.fromJson(doc.data())).toList());

  Future<void> updateFavoriteStatus(String docID, bool isFavorite) async {
    try {
      await FirebaseFirestore.instance
          .collection('history')
          .doc(docID)
          .update({'isFavorite': isFavorite});
      
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text(isFavorite 
              ? 'Added to favorites' 
              : 'Removed from favorites'),
        ));
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to update favorite status'),
        ));
    }
  }

  Future<void> bulkDeleteItems() async {
    try {
      // Delete all selected items
      for (String docID in selectedItems) {
        await FirebaseFirestore.instance
            .collection('history')
            .doc(docID)
            .delete();
      }

      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(SnackBar(
          backgroundColor: Colors.green,
          content: Text('Successfully deleted ${selectedItems.length} item(s)'),
        ));

      // Reset selection mode
      setState(() {
        selectedItems.clear();
        isSelectionMode = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
        ..removeCurrentSnackBar()
        ..showSnackBar(const SnackBar(
          backgroundColor: Colors.red,
          content: Text('Failed to delete some items'),
        ));
    }
  }

  Future<bool> launchURL(url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
      print("launched URL: $url");
      return true;
    } else {
      print('Could not launch $url');
      return false;
    }
  }
}
