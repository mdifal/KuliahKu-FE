// import 'package:kuliahku/ui/widgets/chat/Model/GroupModel.dart';
// import 'package:kuliahku/ui/widgets/chat/Screens/GroupPage.dart';
// import 'package:kuliahku/ui/widgets/chat/Screens/IndividualPage.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
//
// import '../../../shared/images.dart';
// import '../../../shared/style.dart';
//
// class ListGroupCard extends StatelessWidget {
//   const ListGroupCard({
//     Key? key,
//     required this.groupModel
//   }) : super(key: key);
//   final GroupModel groupModel;
//
//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (contex) => GroupPage(
//                     grupModel: groupModel
//                 )));
//       },
//       child: Column(
//         children: [
//           ListTile(
//             leading: CircleAvatar(
//               radius: 30,
//               child: SvgPicture.asset(
//                 image_person,
//                 fit: BoxFit.cover,
//                 width: 45,
//                 height: 45,
//               ),
//               backgroundColor: greySoft,
//             ),
//             title: Text(
//               groupModel.groupName,
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             subtitle: Row(
//               children: [
//                 Text(
//                   groupModel.currentMessage,
//                   style: TextStyle(
//                     fontSize: 13,
//                   ),
//                 ),
//               ],
//             ),
//             trailing: Text(groupModel.time),
//           ),
//           Padding(
//             padding: const EdgeInsets.only(right: 20, left: 80),
//             child: Divider(
//               thickness: 1,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
