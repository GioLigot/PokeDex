import 'package:flutter/material.dart';
import 'package:listview_test/components/button1.dart';

import '../components/my_textfield.dart';
import '../models/pokemon.dart';
import '../services/pokemon_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TextEditingController nameController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<Pokemon> pokemon = [
    Pokemon(name: "Bulbasaur", type:"Grass, Poison",  description: "Seed Pokémon"),
    Pokemon(name: "Charmander", type:"Fire",  description: "Lizard-like Pokémon"),
    Pokemon(name: "Squirtle", type:"Water",  description: "Turtle Pokemon"),

  ];

  final PokemonManager pokemonManager = PokemonManager();


  int selectedIndex = -1;
  bool showTextFields = false;
  bool showSearchFields = false;
  bool addButton = false;


  final Duration _animationDuration = const Duration(milliseconds: 300);
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    pokemonManager.initializeFilteredPokemonList();

  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }


  void _onSearchTextChanged(String query) {
    setState(() {
      searchController.text = query;
      pokemonManager.searchPokemons(query);
    });
  }

  void toggleAddButton() {
    setState(() {
      addButton = !addButton;
    });
  }

  void _button1() {
    setState(() {
      nameController.text = '';
      typeController.text = '';
      descriptionController.text = '';
      showTextFields = !showTextFields;
      showSearchFields = false;

      toggleAddButton();
    });
  }

  void _button2() {
    setState(() {
      showSearchFields = !showSearchFields;
      showTextFields = false;
    });
  }




  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:  const Color(0xFFccffcc),
        appBar:
        AppBar(
          backgroundColor:  const Color(0xFF78C850),
          centerTitle: true,
          title:
          const Text(
                "PokeDex",
                style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 25,
                fontFamily: 'Outfit',

              ),
          ),

        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
      
              Row(
                children: [
                  MyButton1(
                      onTap: _button1,
                      iconData: addButton == true ? Icons.close : Icons.add,
                  ),
                  const SizedBox(width: 10,),
                  MyButton1(
                      onTap: _button2,
                      iconData: Icons.search
                  ),
                ],
              ),
      
              const SizedBox(height: 10,),
              AnimatedContainer(
                duration: _animationDuration,
                curve: Curves.easeInOut,
                height: showSearchFields ? 65.0 : 0.0,
                child: SingleChildScrollView(
                  child: Visibility(
                    visible: showSearchFields,
                    child: Column(
                      children: [
                        MyTextField(
                          controller: searchController,
                          hintText: "Search...",
                          onChanged: _onSearchTextChanged,),
      
                        const SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ),
              ),
      
              const SizedBox(height: 10,),
              AnimatedContainer(
                duration: _animationDuration,
                curve: Curves.easeInOut,
                height: showTextFields ? 270.0 : 0.0,
                child: SingleChildScrollView(
                  child: Visibility(
                    visible: showTextFields,
                    child: Column(
                      children: [
                        MyTextField(
                            controller: nameController,
                            hintText: "Name",
                            ),
                        const SizedBox(height: 10,),
                        MyTextField(
                          controller: typeController,
                          hintText: "Type",
                        ),
                        const SizedBox(height: 10,),
                        MyTextField(
                          controller: descriptionController,
                          hintText: "Description",
                        ),
                        const SizedBox(height: 10,),
      
      
                        ElevatedButton(
                            onPressed: (){
                              String name = nameController.text.trim();
                              String type = typeController.text.trim();
                              String description = descriptionController.text.trim();

                              if(name.isNotEmpty && type.isNotEmpty && description.isNotEmpty){

                                if(addButton == true) {
                                  if (pokemon
                                      .any((pokemon) => pokemon.name == name)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'Pokemon with this name already exists!')),
                                    );
                                  } else {
                                    setState(() {
                                      nameController.text = '';
                                      typeController.text = '';
                                      descriptionController.text = '';

                                      Pokemon newPokemon = Pokemon(
                                          name: name,
                                          type: type,
                                          description: description);
                                      pokemonManager.addPokemon(newPokemon);
                                    });
                                  }
                                }else{
                                  if (pokemon.any((pokemon) => pokemon.name == name)) {

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Pokemon with this name already exists!')),
                                    );
                                  }else {
                                    setState(() {
                                      nameController.text = '';
                                      typeController.text = '';
                                      descriptionController.text = '';

                                      Pokemon updatedPokemon = Pokemon(name: name, type: type, description: description);
                                      pokemonManager.updatePokemon(selectedIndex, updatedPokemon);
                                      selectedIndex = -1;
                                    });
                                  }
                                }
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('All fields are required!')),
                                );
                              }
                            },
                            child: Text(addButton == true ? "Save"  : "Update", style: const TextStyle(
                              color: Colors.black87,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              fontFamily: 'Outfit',

                            ),)
                        ),
      
                        const SizedBox(height: 10,),
                      ],
                    ),
                  ),
                ),
              ),
      
      
              const SizedBox(height: 10,),
      
              pokemon.isEmpty ? const Text("No Pokemons found..", style: TextStyle(fontSize: 22),):
      
              Expanded(
                child: ListView.builder(
                    itemCount: pokemonManager.filteredPokemonList.length,
                    itemBuilder: (context, index) => getRow(index)),
              ),
      
            ],
          ),
        ),
      ),
    );
  }

  Widget getRow(index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: index%2 == 0 ? Colors.green : Colors.greenAccent,
            foregroundColor: Colors.white,
            child: Text(pokemonManager.filteredPokemonList[index].name[0], style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 25,
              fontFamily: 'Outfit',

            ),
            )
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(pokemonManager.filteredPokemonList[index].name, style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Outfit',

            ),),
            Text(pokemonManager.filteredPokemonList[index].type, style: const TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.normal,
              fontSize: 15,
              fontFamily: 'Zilla',

            ),),
            Text(pokemonManager.filteredPokemonList[index].description, style: const TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.normal,
              fontSize: 15,
              fontFamily: 'Zilla',

            ),),
          ],
        ),
        trailing:  SizedBox(
          width: 70,
          child: Row(
            children: [
              GestureDetector(
                  onTap: ((){

                    nameController.text = pokemonManager.filteredPokemonList[index].name;
                    typeController.text = pokemonManager.filteredPokemonList[index].type;
                    descriptionController.text = pokemonManager.filteredPokemonList[index].description;

                    setState(() {
                      selectedIndex = index;
                      showTextFields = true;
                      showSearchFields = false;

                      if(addButton == false) {
                        toggleAddButton();
                      }

                    });

                  }
                  ),
                  child: const Icon(
                      Icons.edit)),
              const SizedBox(width: 10,),
              GestureDetector(
                  onTap: (){

                    int originalIndex = pokemonManager.pokemonList.indexOf(pokemonManager.filteredPokemonList[index]);
                    setState(() {
                      pokemonManager.removePokemon(originalIndex);
                      searchController.text = '';
                    });
                  },
                  child: const Icon(Icons.delete)
              ),
            ],
          ),
        ),
      ),
    );
  }


}
