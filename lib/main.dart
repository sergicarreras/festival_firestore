import 'package:festival_firestore/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'community_meter/comm_meter.dart';
import 'team_member/team_member.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: const FirebaseOptions(
    apiKey: "AIzaSyBUNAIZyA5bLzayO9Up0wJfzfH8DuB5eSQ",
    authDomain: "sds2223-bfc01.firebaseapp.com",
    projectId: "sds2223-bfc01",
    storageBucket: "sds2223-bfc01.appspot.com",
    messagingSenderId: "71860665091",
    appId: "1:71860665091:web:757454408033b512e80736",
    measurementId: "G-VGWKTJZ2B1"
    )
  );

  runApp(const GDGApp());
}

class GDGApp extends StatelessWidget {
  const GDGApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.poppinsTextTheme(
          Theme.of(context).textTheme
        )
      ),
      home: const GDGCommunitySplash()   
    );
  }
}

class GDGCommunityHome extends StatelessWidget {
  const GDGCommunityHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.grey),
        title: Image.asset(Utils.appBarIcon,
          width: 40, height: 40, )
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 0, bottom: 0),
              child: Align(  
                alignment: Alignment.center,
                child: Image.asset(Utils.gdgCommunityLogoBlue, width: 150, height: 100)
              ),
            ),
            Container(
              color: Utils.lightMainColor,
              padding: const EdgeInsets.all(10),
              child: Row(
                children: const [
                  Icon(Icons.people, size: 30, color: Utils.mainColor),
                  SizedBox(width: 10),
                  Text('Meet the Team', 
                    style: TextStyle(color: Utils.mainColor, fontSize: 20)
                  )
                ]
              )
            ),
            Expanded(
              child: FutureBuilder(
                future: FirebaseFirestore.instance.collection('team').get(),
                builder: (context, snapshot) {
                  
                  if (snapshot.hasData) {
                    List<QueryDocumentSnapshot> memberDocs = (snapshot.data as QuerySnapshot).docs;
                    
                    List<TeamMember> members = memberDocs.map(
                      (doc) => TeamMember.fromJson(doc.data() as Map<String, dynamic>)
                    ).toList();

                    return TeamMemberList(members: members);                   
                  }

                  return const Center(
                    child: SizedBox(
                      width: 50,
                      height: 50,
                      child: CircularProgressIndicator(
                        strokeWidth: 5,
                        valueColor: AlwaysStoppedAnimation<Color>(Utils.mainColor)
                      )
                    )
                  );
                }
              )
            )
          ]
        )
      ),
      floatingActionButton: GlowingButton(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => const GDGCommunitySupport())
          );
        },
      ),
    );
  }
}

class GDGCommunitySplash extends StatelessWidget {
  const GDGCommunitySplash({super.key});

  @override
  Widget build(BuildContext context) {
    
    Future.delayed(const Duration(seconds: 2), () {
       Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const GDGCommunityHome())
       );
    });
    
    return Scaffold(
      backgroundColor: Utils.mainColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(Utils.gdgCommunityLogoWhite,
              width: 200, height: 200, fit: BoxFit.contain             
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 50,
              height: 50,
              child: CircularProgressIndicator(
                strokeWidth: 5,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.5))
              )
            )
          ]
        )
      )
    );
  }
}

class GlowingButton extends StatefulWidget {
  
  final Function? onTap;
  
  const GlowingButton({super.key,  this.onTap });
  @override
  GlowingButtonState createState() => GlowingButtonState();
}

class GlowingButtonState extends State<GlowingButton> with TickerProviderStateMixin {
  
  AnimationController? glowingController;
  
  @override
  void initState() {
    super.initState();
    
    glowingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();
  }
  
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap!();
      },
      child: Container(
        margin: const EdgeInsets.all(20),
        child: Stack(
          children: [
            ScaleTransition(
              scale: Tween<double>(begin: 1.0, end: 1.5)
              .animate(CurvedAnimation(parent: glowingController!, curve: Curves.easeInOut)),
              child: FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0)
                .animate(CurvedAnimation(parent: glowingController!, curve: Curves.easeInOut)),
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Utils.secondaryColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  width: 80,
                  height: 80,
                ),
              )
            ),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Utils.secondaryColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(blurRadius: 15, offset: Offset.zero, color: Utils.secondaryColor.withOpacity(0.8))
                ]
              ),
              width: 80,
              height: 80,
              child: const Icon(Icons.textsms, color: Colors.white, size: 30)
            )
          ]
        )
      )
    );
  }
}