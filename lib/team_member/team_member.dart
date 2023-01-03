import 'package:flutter/material.dart';
import '../utils.dart';

class TeamMemberCard extends StatelessWidget {
  
  final TeamMember? member;
  
  const  TeamMemberCard({super.key,  this.member });
  
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 20, bottom: 20),
      child: Row(
        children: [
          ClipOval(
            child: Image.network(member!.photoUrl!,
              width: 50, height: 50, fit: BoxFit.cover
            )
          ),
          const SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(member!.fullName!, 
                style: const TextStyle(color: Utils.mainColor, fontSize: 20)
              ),
              Text(member!.title!, 
                style: const TextStyle(color: Colors.grey, fontSize: 15)
              ),
            ]
          )
        ]
      )
    );
  }
}

class TeamMemberList extends StatelessWidget {
  
  final List<TeamMember>? members;
  
  const TeamMemberList({super.key,  this.members });
  
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: members!.length,
      itemBuilder: (context, index) {

        TeamMember member = members![index];
        return TeamMemberCard(member: member);
      }
    );
  }
}

class TeamMember {
  
  String? fullName;
  String? photoUrl;
  String? title;
  
  TeamMember({ this.fullName, this.photoUrl, this.title });
  
  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      fullName: json['fullName'],
      photoUrl: json['photoUrl'],
      title: json['title']
    );
  }
}
