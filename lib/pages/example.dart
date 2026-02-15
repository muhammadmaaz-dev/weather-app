// class WeatherOnsearch extends StatelessWidget {
//   const WeatherOnsearch({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 18),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // --- Header Row ---
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     IconButton(
//                       onPressed: () {},
//                       icon: const Icon(Icons.arrow_back),
//                     ),
//                     // "Add to List" Button
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 16, vertical: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.black,
//                         borderRadius: BorderRadius.circular(20), // Rounded pill shape
//                       ),
//                       child: Row(
//                         children: const [
//                           Text(
//                             "Add to List",
//                             style: TextStyle(
//                               color: Colors.white, 
//                               fontWeight: FontWeight.w600
//                             ),
//                           ),
//                           SizedBox(width: 8), // Space between text and icon
//                           Icon(
//                             Icons.add_circle_outline, // Slightly nicer icon
//                             color: Colors.white, 
//                             size: 18
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
                
//                 const SizedBox(height: 30),
                
//                 // --- Your Weather Card ---
//                 const WeatherCard(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }