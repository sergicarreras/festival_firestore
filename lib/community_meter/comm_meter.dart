
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../utils.dart';

class GDGCommunitySupport extends StatelessWidget {
  
  final int messagesGoal = 300;

  const GDGCommunitySupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.grey),
        title: Image.asset(Utils.appBarIcon,
          width: 40, height: 40, fit: BoxFit.contain)
      ),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Community Meter',
              textAlign: TextAlign.center,
              style: TextStyle(color: Utils.mainColor, fontSize: 30)  
            ),
            
            Text('Goal: $messagesGoal Messages',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Utils.mainColor, fontSize: 15)  
            ),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('community_support_meter').snapshots(),
                builder: (context, snapshot) {
                  
                  if (snapshot.hasData) {
                    List<QueryDocumentSnapshot> messages = 
                      (snapshot.data as QuerySnapshot).docs;

                    if (messages.length >= messagesGoal) {
                      return const GDGCommunityGoal();
                    }

                    return Column(
                      children: [
                        Expanded(
                          child: GDGCommunitySupportMeter(count: messages.length)
                        ),
                        const SizedBox(height: 40),
                        GDGCommunityButton(
                          label: 'Send Message!',
                          icon: Icons.send,
                          onTap: () {
                            FirebaseFirestore.instance.collection('community_support_meter').add({
                              'message': 'I love Flutter!'
                            });
                          }
                        )
                      ]
                    );
                  }

                  return const SizedBox();
                }
              )
            )
          ]
        )
      )
    );
  }
}

class GDGCommunityGoal extends StatelessWidget {
  const GDGCommunityGoal({super.key});


  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        Text('Congrats!',
          style: TextStyle(color: Utils.mainColor, fontSize: 30)    
        ),
        SizedBox(height: 5),
        Text('We did it!',
          style: TextStyle(color: Utils.mainColor, fontSize: 50)    
        ),
        SizedBox(height: 20),
        Icon(Icons.thumb_up, size: 100, color: Utils.mainColor)
      ],
    );
  }
}

class GDGCommunitySupportMeter extends StatelessWidget {
  
  final int? count;
  
  const GDGCommunitySupportMeter({super.key,  this.count = 0 });
  
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 150, height: 150,
          child: Stack(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 12),
                  child: const Icon(
                    Icons.chat_bubble, 
                    color: Utils.mainColor, size: 150
                  )
                )
              ),
              Center(
                child: Text(
                  count!.toString(), 
                  style: const TextStyle(
                    color: Colors.white, fontSize: 60, fontWeight: FontWeight.bold
                  )
                )
              )
            ]
          )
        ),
        Container(
          margin: const EdgeInsets.only(top: 20, bottom: 20),
          child: const Text('Messages\nIn Firebase', 
            textAlign: TextAlign.center, 
            style: TextStyle(color: Utils.mainColor)
          )
        ),
        Container(
          width: 200,
          height: count!.toDouble(),
          decoration: const BoxDecoration(
            color: Utils.mainColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30), topRight: Radius.circular(30),
            )
          )
        ),
        Container(
          height: 10,
          color: Utils.mainColor
        )
      ]
    );
  }
}

class GDGCommunityButton extends StatelessWidget {
  
  final String? label;
  final Function? onTap;
  final IconData? icon;
  
  const GDGCommunityButton({super.key,  this.label, this.onTap, this.icon });
  
  @override
  Widget build(BuildContext context) {
     return Material(
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
       color: Utils.secondaryColor,
       child: InkWell(
          onTap: () { onTap!(); },
          highlightColor: Utils.lightMainColor,
          splashColor: Utils.lightMainColor,
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(label!, style: const TextStyle(fontSize: 20, color: Colors.white)),
                const SizedBox(width: 10),
                Icon(icon!, color: Colors.white, size: 30)
              ]
            )
        )
      )
     );
  }
}
