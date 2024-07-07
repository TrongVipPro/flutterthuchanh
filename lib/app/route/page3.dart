// import 'package:flutter/material.dart';

// class Page3 extends StatelessWidget {
//   const Page3({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Page 3"),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text(
//               "This is Page 3",
//               style: TextStyle(fontSize: 24),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 // Thêm hành động khi nhấn nút ở đây
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   const SnackBar(
//                     content: Text("Button clicked!"),
//                   ),
//                 );
//               },
//               child: const Text("Click me"),
//             ),
//           ],
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           // Điều hướng đến trang khác khi nhấn nút
//           Navigator.of(context).push(
//             MaterialPageRoute(
//               builder: (_) => const Scaffold(
//                 appBar: AppBar(
//                   title: Text('New Page'),
//                 ),
//                 body: Center(
//                   child: Text('This is a new page'),
//                 ),
//               ),
//             ),
//           );
//         },
//         tooltip: 'Navigate to new page',
//         child: const Icon(Icons.arrow_forward),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';

class Page3 extends StatelessWidget {
  const Page3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page 3"),
      ),
    );
  }
}
