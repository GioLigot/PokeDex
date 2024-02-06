import 'package:flutter/material.dart';

import 'pokemon.dart';

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

  List<Pokemon> filteredPokemon = [];


  int selectedIndex = -1;
  bool showTextFields = false;
  bool showSearchFields = false;
  bool addButton = false;
  bool updateButton = false;

  final Duration _animationDuration = const Duration(milliseconds: 300);
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: _animationDuration,
    );

    filteredPokemon = pokemon;

  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  void _searchPokemons(String query) {
    setState(() {
      filteredPokemon = pokemon.where((pokemon) {
        final nameLower = pokemon.name.toLowerCase();
        final queryLower = query.toLowerCase();
        return nameLower.contains(queryLower);
      }).toList();
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
                  CircleAvatar(
                    backgroundColor: const Color(0xFF78C850),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        setState(() {
                          nameController.text = '';
                          typeController.text = '';
                          descriptionController.text = '';
                          showTextFields = !showTextFields;
                          showSearchFields = false;
                          addButton = !addButton;
                          updateButton = false;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: 10,),
                  CircleAvatar(
                    backgroundColor: const Color(0xFF78C850),
                    child: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        setState(() {
                          showSearchFields = !showSearchFields;
                          showTextFields = false;
                        });
                      },
                    ),
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
                        TextField(
                          controller: searchController,
                          onChanged: _searchPokemons,
                          decoration: const InputDecoration(
                              hintText: "Search",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10),)
                              )
                          ),
                        ),
      
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
                        TextField(
                          controller: nameController,
                          decoration: const InputDecoration(
                              hintText: "Pokemon Name",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10),)
                              )
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextField(
                          controller: typeController,
      
                          decoration: const InputDecoration(
                              hintText: "Type",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10),)
                              )
                          ),
                        ),
                        const SizedBox(height: 10,),
                        TextField(
                          controller: descriptionController,
      
                          decoration: const InputDecoration(
                              hintText: "Descriptioon",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(10),)
                              )
                          ),
                        ),
                        const SizedBox(height: 10,),
      
      
                        Visibility(
                          visible: addButton,
                          child: ElevatedButton(
                              onPressed: (){
                                String name = nameController.text.trim();
                                String type = typeController.text.trim();
                                String description = descriptionController.text.trim();
      
                                if(name.isNotEmpty && type.isNotEmpty && description.isNotEmpty){
      
                                  if (pokemon.any((pokemon) => pokemon.name == name)) {
      
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Pokemon with this name already exists!')),
                                    );
                                  }else {
                                    setState(() {
                                      nameController.text = '';
                                      typeController.text = '';
                                      descriptionController.text = '';
      
                                      pokemon.add(Pokemon(name: name, type: type, description: description));
                                      filteredPokemon = pokemon;
                                    });
                                  }
                                }else{
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('All fields are required!')),
                                  );
                                }
                              },
                              child: const Text("Save")
                          ),
                        ),
                        Visibility(
                          visible: updateButton,
                          child: ElevatedButton(
                              onPressed: (){
                                String name = nameController.text.trim();
                                String type = typeController.text.trim();
                                String description = descriptionController.text.trim();
      
                                if(name.isNotEmpty && type.isNotEmpty && description.isNotEmpty){
      
                                  setState(() {
                                    nameController.text = '';
                                    typeController.text = '';
                                    descriptionController.text = '';
      
                                    pokemon[selectedIndex].name = name;
                                    pokemon[selectedIndex].type = type;
                                    pokemon[selectedIndex].description = description;
                                    selectedIndex = -1;
      
                                  });
                                }
      
      
                              },
                              child: const Text("Update")
                          ),
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
                    itemCount: filteredPokemon.length,
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
            child: Text(filteredPokemon[index].name[0], style: const TextStyle(
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
            Text(filteredPokemon[index].name, style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'Outfit',

            ),),
            Text(filteredPokemon[index].type, style: const TextStyle(
              color: Colors.black38,
              fontWeight: FontWeight.normal,
              fontSize: 15,
              fontFamily: 'Zilla',

            ),),
            Text(filteredPokemon[index].description, style: const TextStyle(
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

                    nameController.text = pokemon[index].name;
                    typeController.text = pokemon[index].type;
                    descriptionController.text = pokemon[index].description;

                    setState(() {
                      selectedIndex = index;
                      showTextFields = !showTextFields;
                      showSearchFields = false;
                      updateButton = !updateButton;
                      addButton = false;
                    });

                  }
                  ),
                  child: const Icon(
                      Icons.edit)),
              const SizedBox(width: 10,),
              GestureDetector(
                  onTap: ((){

                    int originalIndex = pokemon.indexOf(filteredPokemon[index]);

                    setState(() {
                      pokemon.removeAt(originalIndex);
                      filteredPokemon = pokemon;
                      searchController.text = '';

                    });

                  }
                  ),
                  child: const Icon(
                      Icons.delete))
              ,
            ],
          ),
        ),
      ),
    );
  }


}
