// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import '../../../component/custom_navigator.dart';
// import '../../../generated/assets.dart';
// import '../../../helper/constant.dart';
// import '../../../helper/utils.dart';
// import '../../../database/entity/transaction_entity.dart';
// import '../../auth/provider/auth_provider.dart';
// import '../../history/view/history_view.dart';
// import '../../insight/view/insight_view.dart';
// import '../../profile/view/profile_view.dart';
// import '../../transaction/view/transaction_view.dart';
// import '../provider/home_provider.dart';
// import 'widget/list_item_widget.dart';

// class HomeView extends StatefulWidget {
//   const HomeView({super.key});

//   @override
//   State<HomeView> createState() => _HomeViewState();
// }

// class _HomeViewState extends State<HomeView> {
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       final user = context.read<AuthProvider>().user;
//       if (user != null) {
//         context.read<HomeProvider>().fetchData(user);
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final homeProvider = context.watch<HomeProvider>();
//     final homeData = homeProvider.homeModel;

//     return SafeArea(
//       child: Scaffold(
//         bottomNavigationBar: _buildFloatingBottomBar(),
//         backgroundColor: Constant.greenPrime,
//         body: homeProvider.isLoading
//             ? Center(child: CircularProgressIndicator(color: Constant.white))
//             : SafeArea(
//                 child: Padding(
//                   padding: const EdgeInsets.all(16.0),
//                   child: Column(
//                     children: [
//                       // Header
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 homeData?.userName ?? '',
//                                 style: Constant.bodyLarge.copyWith(
//                                   color: Constant.white,
//                                 ),
//                               ),
//                               Text(
//                                 Utils.formatDateShort(DateTime.now()),
//                                 style: Constant.textMedium.copyWith(
//                                   color: Constant.white,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           InkWell(
//                             onTap: () {
//                               CustomNavigator.push(
//                                 context,
//                                 const ProfileView(),
//                               );
//                             },
//                             child: Container(
//                               width: 40,
//                               height: 40,
//                               decoration: BoxDecoration(
//                                 color: Constant.white,
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Center(
//                                 child: Icon(
//                                   Icons.person,
//                                   color: Constant.greenPrime,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 24),
//                       // Current Balance Card
//                       ClipRRect(
//                         borderRadius: BorderRadius.circular(16),
//                         child: Container(
//                           decoration: BoxDecoration(
//                             color: Colors.white,
//                             borderRadius: BorderRadius.circular(16),
//                             boxShadow: [
//                               BoxShadow(
//                                 color: Colors.black.withValues(alpha: 0.08),
//                                 blurRadius: 10,
//                                 offset: const Offset(0, 4),
//                               ),
//                             ],
//                           ),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               // ── Section Atas ──
//                               Padding(
//                                 padding: const EdgeInsets.symmetric(
//                                   horizontal: 32,
//                                   vertical: 16,
//                                 ),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Current Balance",
//                                       style: TextStyle(
//                                         fontSize: 14,
//                                         color: Constant.greenPrime,
//                                       ),
//                                     ),
//                                     Text(
//                                       Utils.formatIDR(homeData?.balance ?? 0),
//                                       style: TextStyle(
//                                         fontSize: 24,
//                                         fontWeight: FontWeight.bold,
//                                         color: Constant.greenPrime,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),

//                               // ── Section Bawah (full-width, no padding issue) ──
//                               Container(
//                                 color: Constant.orange,
//                                 padding: const EdgeInsets.symmetric(
//                                   vertical: 12,
//                                   horizontal: 32,
//                                 ),
//                                 child: Row(
//                                   mainAxisAlignment:
//                                       MainAxisAlignment.spaceBetween,
//                                   children: [
//                                     // Total Income
//                                     Row(
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Total Income",
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Constant.greenPrime,
//                                               ),
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   Utils.formatIDR(
//                                                     homeData?.totalIncome ?? 0,
//                                                   ),
//                                                   style: TextStyle(
//                                                     fontSize: 14,
//                                                     color: Constant.greenPrime,
//                                                   ),
//                                                 ),
//                                                 const SizedBox(width: 4),
//                                                 Icon(
//                                                   Icons.arrow_drop_down,
//                                                   color: Constant.greenPrime,
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),

//                                     // Divider vertikal
//                                     Container(
//                                       height: 52,
//                                       width: 4,
//                                       color: Constant.greenPrime.withValues(
//                                         alpha: 0.2,
//                                       ),
//                                     ),

//                                     // Total Expenses
//                                     Row(
//                                       children: [
//                                         Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(
//                                               "Total Expenses",
//                                               style: TextStyle(
//                                                 fontSize: 12,
//                                                 fontWeight: FontWeight.bold,
//                                                 color: Constant.greenPrime,
//                                               ),
//                                             ),
//                                             Row(
//                                               children: [
//                                                 Text(
//                                                   Utils.formatIDR(
//                                                     homeData?.totalExpense ?? 0,
//                                                   ),
//                                                   style: TextStyle(
//                                                     fontSize: 14,
//                                                     color: Constant.greenPrime,
//                                                   ),
//                                                 ),
//                                                 const SizedBox(width: 4),
//                                                 Icon(
//                                                   Icons.arrow_drop_up,
//                                                   color: Constant.greenPrime,
//                                                 ),
//                                               ],
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                       const SizedBox(height: 24),

//                       // today transactions
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Text(
//                             "Today Transactions",
//                             style: Constant.textMedium.copyWith(
//                               color: Constant.white,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(height: 16),
//                       Expanded(
//                         child: ListView.separated(
//                           itemCount: homeData?.todayTransactions.length ?? 0,
//                           separatorBuilder: (context, index) =>
//                               const SizedBox(height: 12),
//                           itemBuilder: (context, index) {
//                             final transaction =
//                                 homeData!.todayTransactions[index];
//                             final isIncome =
//                                 transaction.type == TransactionType.income;
//                             return ListItemWidget(
//                               label:
//                                   (transaction.note != null &&
//                                       transaction.note!.isNotEmpty)
//                                   ? transaction.note!
//                                   : transaction.label,
//                               nominal:
//                                   '${isIncome ? '+' : '-'} ${Utils.formatIDR(transaction.amount)}',
//                               date: Utils.formatDateTimeToTime(
//                                 transaction.date,
//                               ),
//                               icon: transaction.icon.isNotEmpty
//                                   ? transaction.icon
//                                   : Assets.assetsIconsDollar,
//                               nominalColor: isIncome
//                                   ? Constant.greenPrime
//                                   : Constant.error,
//                             );
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//       ),
//     );
//   }

//   Widget _buildFloatingBottomBar() {
//     return SizedBox(
//       height: 95, // Tinggi total: 70 (bar) + 25 (tombol yang menonjol)
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         clipBehavior: Clip.none,
//         children: [
//           // Background Bar
//           Container(
//             height: 70,
//             margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//             decoration: BoxDecoration(
//               color: const Color(0xFF5F7874), // warna utama
//               borderRadius: BorderRadius.circular(24),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withValues(alpha: 0.2),
//                   blurRadius: 10,
//                   offset: const Offset(0, 5),
//                 ),
//               ],
//             ),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 _buildItem(
//                   icon: Icons.list,
//                   label: "History",
//                   onTap: () {
//                     CustomNavigator.push(context, const HistoryView());
//                   },
//                 ),
//                 const SizedBox(width: 60),
//                 _buildItem(
//                   icon: Icons.bar_chart,
//                   label: "Insight",
//                   onTap: () {
//                     CustomNavigator.push(context, const InsightView());
//                   },
//                 ),
//               ],
//             ),
//           ),

//           // Tombol Floating Tengah
//           Positioned(
//             top: 0,
//             child: GestureDetector(
//               onTap: () {
//                 CustomNavigator.push(context, const TransactionView());
//               },
//               child: Container(
//                 width: 70,
//                 height: 70,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE3B68D), // warna bulat tengah
//                   shape: BoxShape.circle,
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withValues(alpha: 0.25),
//                       blurRadius: 10,
//                       offset: const Offset(0, 5),
//                     ),
//                   ],
//                 ),
//                 child: const Icon(Icons.add, size: 32, color: Colors.black54),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildItem({
//     required IconData icon,
//     required String label,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: () => onTap(),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(icon, color: Colors.white),
//           const SizedBox(height: 4),
//           Text(label, style: TextStyle(color: Colors.white, fontSize: 12)),
//         ],
//       ),
//     );
//   }
// }
