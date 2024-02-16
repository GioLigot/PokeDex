// import 'package:flutter/material.dart';
// import 'package:listview_test/components/button1.dart';
// import 'package:listview_test/services/database_helper.dart';
// import '../components/my_textfield.dart';
// import '../models/pokemon.dart';
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
//
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
//
//   int id = 0;
//
//   int pokemonId = 0;
//
//   void _refreshPokemons() async {
//     final data = await SQLHelper.getPokemons(context,);
//     for (final pokemon in data) {
//       print('ID: ${pokemon['id']}, Name: ${pokemon['name']}, Type: ${pokemon['type']}');
//     }
//     setState(() {
//       _pokemons = data;
//
//     });
//   }
//
//   void addPokemon(String name, String type, String description) async {
//     await SQLHelper.addPokemon(context, name, type, description);
//     _refreshPokemons();
//   }
//
//   void deletePokemon(int id) async {
//     if (_pokemons.any((pokemon) => pokemon['id'] == id)) {
//       await SQLHelper.deletePokemon(id);
//
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Pokemon deleted!')),
//       );
//
//       _refreshPokemons();
//
//
//
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Pokemon not found!')),
//       );
//     }
//
//   }
//
//   void updatePokemon(int id, String name, String type, String description) async {
//     print("Updating Pokemon with ID: $id");
//     print("Current Pokemon list: $_pokemons");
//
//     if (_pokemons.any((pokemon) => pokemon['id'] == id)) {
//       int index = _pokemons.indexWhere((pokemon) => pokemon['id'] == id);
//       print("Found Pokemon at index: $index");
//
//       // Pokemon updatedPokemon = Pokemon(
//       //   id: id,
//       //   name: name,
//       //   type: type,
//       //   description: description,
//       // );
//       if (index != -1) {
//         await SQLHelper.updatePokemon(context, id, name, type, description);
//         _refreshPokemons();
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Pokemon not found!')),
//       );
//     }
//   }
//
//
//   void _onSearchTextChanged(String query) {
//     setState(() {
//       searchController.text = query;
//       pokemonManager.searchPokemons(query);
//     });
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
//
//       toggleCloseButton();
//       addButton = true;
//
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
//   @override
//   void initState() {
//     super.initState();
//     _animationController = AnimationController(
//       vsync: this,
//       duration: _animationDuration,
//     );
//
//     pokemonManager.initializeFilteredPokemonList();
//
//     _refreshPokemons();
//     print(".. number of pokemons ${_pokemons.length}");
//
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
//
//                         ElevatedButton(
//                             onPressed: (){
//                               String name = nameController.text.trim();
//                               String type = typeController.text.trim();
//                               String description = descriptionController.text.trim();
//
//                               print("Selected Pokemon ID: $pokemonId");
//
//
//                               if(name.isNotEmpty && type.isNotEmpty && description.isNotEmpty){
//
//                                 if(addButton == true) {
//                                   if (_pokemons.any((pokemon) => _pokemons[pokemonId]['name'] == name)) {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(
//                                           content: Text(
//                                               'Pokemon with this name already exists!')),
//                                     );
//                                   } else {
//                                     addPokemon(name, type, description);
//                                     setState(() {
//                                       nameController.text = '';
//                                       typeController.text = '';
//                                       descriptionController.text = '';
//                                       pokemonId = 0;
//
//                                     });
//
//                                   }
//                                 }else if(addButton == false){
//                                   if (_pokemons.any((pokemon) => _pokemons[pokemonId]['name'] == name))
//                                   {
//                                     ScaffoldMessenger.of(context).showSnackBar(
//                                       const SnackBar(content: Text('Pokemon with this name already exists!')),
//                                     );
//                                   }else {
//
//                                     updatePokemon(pokemonId, name, type, description);
//
//                                     setState(() {
//                                       nameController.text = '';
//                                       typeController.text = '';
//                                       descriptionController.text = '';
//                                       selectedIndex = -1;
//                                       _refreshPokemons();
//                                     });
//                                   }
//                                 }
//                               }else{
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   const SnackBar(content: Text('All fields are required!')),
//                                 );
//                               }
//                             },
//                             child: Text(addButton == true ? "Save"  : "Update",
//                               style: const TextStyle(
//                                 color: Colors.black87,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 18,
//                                 fontFamily: 'Outfit',
//
//                               ),)
//                         ),
//
//                         const SizedBox(height: 10,),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//
//
//               const SizedBox(height: 10,),
//
//               _pokemons.isEmpty ? const Text("No Pokemons found..", style: TextStyle(fontSize: 22),):
//
//               Expanded(
//                 child: ListView.builder(
//                     itemCount: _pokemons.length,
//                     itemBuilder: (context, index) => getRow(index)
//                 ),
//               ),
//
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget getRow(index) {
//     return Card(
//       child: ListTile(
//         leading: CircleAvatar(
//             backgroundColor: index%2 == 0 ? Colors.green : Colors.greenAccent,
//             foregroundColor: Colors.white,
//             child: Text(_pokemons[index]['name'][0], style: const TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//               fontSize: 25,
//               fontFamily: 'Outfit',
//
//             ),
//             )
//         ),
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(_pokemons[index]['name'], style: const TextStyle(
//               color: Colors.black87,
//               fontWeight: FontWeight.bold,
//               fontSize: 18,
//               fontFamily: 'Outfit',
//
//             ),),
//             Text(_pokemons[index]['type'], style: const
//             TextStyle(
//               color: Colors.black38,
//               fontWeight: FontWeight.normal,
//               fontSize: 15,
//               fontFamily: 'Zilla',
//
//             ),
//             ),
//             Text(_pokemons[index]['description'], style: const
//             TextStyle(
//               color: Colors.black38,
//               fontWeight: FontWeight.normal,
//               fontSize: 15,
//               fontFamily: 'Zilla',
//
//             ),
//             ),
//           ],
//         ),
//         trailing:  SizedBox(
//           width: 70,
//           child: Row(
//             children: [
//               GestureDetector(
//                   onTap: ((){
//
//                     nameController.text = _pokemons[index]['name'];
//                     typeController.text = _pokemons[index]['type'];
//                     descriptionController.text = _pokemons[index]['description'];
//
//
//                     setState(() {
//                       selectedIndex = index;
//                       showTextFields = true;
//                       showSearchFields = false;
//                       pokemonId = _pokemons[index]['id'];
//                       addButton = false;
//
//                       if(closeButton == false) {
//                         toggleCloseButton();
//                       }
//
//                     });
//
//                   }
//                   ),
//                   child: const Icon(
//                       Icons.edit)),
//               const SizedBox(width: 10,),
//               GestureDetector(
//                   onTap: (){
//
//                     setState(() {
//                       pokemonId = _pokemons[index]['id'];
//                       searchController.text = '';
//                     });
//                     deletePokemon(pokemonId);
//                     _refreshPokemons();
//                     pokemonId = 0;
//                   },
//                   child: const Icon(Icons.delete)
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
// }
