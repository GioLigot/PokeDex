// import 'package:flutter/material.dart';
// import 'package:listview_test/components/button1.dart';
// import 'package:listview_test/services/database_helper.dart';
// import '../components/my_textfield.dart';
// import '../components/pokemonCard.dart';
// import '../models/pokemon.dart';
// import '../models/queries.dart';
// import '../services/pokemon_manager.dart';
//
// class HomePage extends StatefulWidget {
//   const HomePage({super.key});
//
//   @override
//   State<HomePage> createState() => _HomePageState();
// }
//
// class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
//   TextEditingController nameController = TextEditingController();
//   TextEditingController typeController = TextEditingController();
//   TextEditingController descriptionController = TextEditingController();
//   TextEditingController searchController = TextEditingController();
//   final PokemonManager pokemonManager = PokemonManager();
//   int selectedIndex = -1;
//   bool showTextFields = false;
//   bool showSearchFields = false;
//   final Duration _animationDuration = const Duration(milliseconds: 300);
//   AnimationController? _animationController;
//   final SQLHelper sqlHelper = SQLHelper();
//   List<Map<String, dynamic>> _pokemons = [];
//   bool addButton = false;
//   bool closeButton = false;
//   int id = 0;
//   int pokemonId = 0;
//   late String selectedMon = " ";
//
//   void _refreshPokemons() async {
//     final data = await SQLHelper.getPokemons(context);
//     setState(() {
//       _pokemons = data;
//     });
//   }
//
//   void _onSearchTextChanged(String query) async{
//     String getName = searchController.text.toLowerCase();
//     if(getName.isNotEmpty) {
//       final data = await SQLHelper.getPokemon(context, getName);
//       setState(() {
//         _pokemons = data;
//       });
//     }else{
//       _refreshPokemons();
//     }
//   }
//
//   void toggleCloseButton() {
//     setState(() {
//       closeButton = !closeButton;
//     });
//   }
//
//   void toggleAddButton() {
//     setState(() {
//       addButton = !addButton;
//     });
//   }
//
//   void _button1() {
//     setState(() {
//       nameController.text = '';
//       typeController.text = '';
//       descriptionController.text = '';
//       showTextFields = !showTextFields;
//       showSearchFields = false;
//       toggleCloseButton();
//       addButton = true;
//     });
//   }
//
//   void _button2() {
//     setState(() {
//       showSearchFields = !showSearchFields;
//       showTextFields = false;
//     });
//   }
//
//   void _button3() async{
//     await SQLHelper.clearTable(context);
//     _refreshPokemons();
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: _animationDuration,
//     );
//     pokemonManager.initializeFilteredPokemonList();
//     _refreshPokemons();
//     print(".. number of pokemons ${_pokemons.length}");
//   }
//
//   @override
//   void dispose() {
//     _animationController?.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         backgroundColor:  const Color(0xFFccffcc),
//         appBar:
//         AppBar(
//           backgroundColor:  const Color(0xFF78C850),
//           centerTitle: true,
//           title:
//           const Text(
//             "PokeDex",
//             style: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 25,
//               fontFamily: 'Outfit',
//
//             ),
//           ),
//
//         ),
//         body: Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//
//               Row(
//                 children: [
//                   MyButton1(
//                     onTap: _button1,
//                     iconData: closeButton == true ? Icons.close : Icons.add,
//                   ),
//                   const SizedBox(width: 10,),
//                   MyButton1(
//                       onTap: _button2,
//                       iconData: Icons.search
//                   ),
//                   const SizedBox(width: 10,),
//                   MyButton1(
//                       onTap: _button3,
//                       iconData: Icons.delete_forever
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 10,),
//               AnimatedContainer(
//                 duration: _animationDuration,
//                 curve: Curves.easeInOut,
//                 height: showSearchFields ? 65.0 : 0.0,
//                 child: SingleChildScrollView(
//                   child: Visibility(
//                     visible: showSearchFields,
//                     child: Column(
//                       children: [
//                         MyTextField(
//                           controller: searchController,
//                           hintText: "Search...",
//                           onChanged: _onSearchTextChanged,
//                         ),
//
//                         const SizedBox(height: 10,),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 10,),
//               AnimatedContainer(
//                 duration: _animationDuration,
//                 curve: Curves.easeInOut,
//                 height: showTextFields ? 270.0 : 0.0,
//                 child: SingleChildScrollView(
//                   child: Visibility(
//                     visible: showTextFields,
//                     child: Column(
//                       children: [
//                         MyTextField(
//                           controller: nameController,
//                           hintText: "Name",
//                         ),
//                         const SizedBox(height: 10,),
//                         MyTextField(
//                           controller: typeController,
//                           hintText: "Type",
//                         ),
//                         const SizedBox(height: 10,),
//                         MyTextField(
//                           controller: descriptionController,
//                           hintText: "Description",
//                         ),
//                         const SizedBox(height: 10,),
//
//                         ElevatedButton(
//                             onPressed: () async{
//                               String name = nameController.text.trim();
//                               String type = typeController.text.trim();
//                               String description = descriptionController.text.trim();
//                               print("Selected Pokemon ID: $pokemonId");
//
//                               if(name.isNotEmpty && type.isNotEmpty && description.isNotEmpty){
//
//                                 if(addButton == true) {
//                                   await SQLHelper.addPokemon(
//                                       context,
//                                       name,
//                                       type,
//                                       description,
//                                       nameController,
//                                       typeController,
//                                       descriptionController);
//                                   setState(() {
//                                     _refreshPokemons();
//                                   });
//                                 }else if(addButton == false){
//                                   await SQLHelper.updatePokemon(
//                                       context,
//                                       selectedMon,
//                                       name,
//                                       type,
//                                       description,
//                                       nameController,
//                                       typeController,
//                                       descriptionController);
//                                   pokemonId = 0;
//                                   setState(() {
//                                     _refreshPokemons();
//                                   });
//                                 }
//                               }else{
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(content: Text('All fields are required!')),
//                                 );
//                               }
//                             },
//                             child:
//                             Text(addButton == true ? "Save"  : "Update",
//                               style: const TextStyle(
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                                 fontFamily: 'Outfit',
//                               ),
//                             )
//                         ),
//                         const SizedBox(height: 10,),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//               const SizedBox(height: 10,),
//               _pokemons.isEmpty ? const Text("No Pokemons found..", style: TextStyle(fontSize: 22),):
//               Expanded(
//                 child: ListView.builder(
//                     itemCount: _pokemons.length,
//                     itemBuilder: (context, index) => PokemonCard(
//                         onTap: (){
//                           nameController.text = _pokemons[index]['name'];
//                           typeController.text = _pokemons[index]['type'];
//                           descriptionController.text = _pokemons[index]['description'];
//                           setState((){
//                             selectedIndex = index;
//                             showTextFields = true;
//                             showSearchFields = false;
//                             addButton = false;
//                             selectedMon = _pokemons[index]['name'].toString();
//                             if(closeButton == false) {
//                               toggleCloseButton();
//                             }
//                           });
//                         },
//                         onTap2: (){
//                           setState(() {
//                             selectedMon = _pokemons[index]['name'].toString();
//                             searchController.clear();
//                           });
//                           SQLHelper.deletePokemon(context,selectedMon);
//                           _refreshPokemons();
//                           selectedMon = "";
//                         },
//                         index: index,
//                         name: _pokemons[index]['name'],
//                         type: _pokemons[index]['type'],
//                         description: _pokemons[index]['description']
//                     )
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
