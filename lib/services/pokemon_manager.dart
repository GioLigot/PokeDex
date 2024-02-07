// pokemon_manager.dart

import 'package:listview_test/models/pokemon.dart';

class PokemonManager {
  List<Pokemon> pokemonList = [
    Pokemon(name: "Bulbasaur", type: "Grass, Poison", description: "Seed Pokémon"),
    Pokemon(name: "Charmander", type: "Fire", description: "Lizard-like Pokémon"),
    Pokemon(name: "Squirtle", type: "Water", description: "Turtle Pokemon"),
  ];

  List<Pokemon> filteredPokemonList = [];

  void initializeFilteredPokemonList() {
    filteredPokemonList = List.from(pokemonList);
  }

  void searchPokemons(String query) {
    filteredPokemonList = pokemonList.where((pokemon) {
      final nameLower = pokemon.name.toLowerCase();
      final queryLower = query.toLowerCase();
      return nameLower.contains(queryLower);
    }).toList();
  }

  void addPokemon(Pokemon newPokemon) {
    if (!pokemonList.any((pokemon) => pokemon.name == newPokemon.name)) {
      pokemonList.add(newPokemon);
      filteredPokemonList = List.from(pokemonList);
    }
  }

  void updatePokemon(int index, Pokemon updatedPokemon) {
    if (index >= 0 && index < pokemonList.length) {
      pokemonList[index] = updatedPokemon;
      filteredPokemonList = List.from(pokemonList);
    }
  }

  void removePokemon(int index) {
    if (index >= 0 && index < pokemonList.length) {
      pokemonList.removeAt(index);
      filteredPokemonList = List.from(pokemonList);
    }
  }

  void printPokemonLists() {
    print('Pokemon List:');
    for (Pokemon pokemon in pokemonList) {
      print('Name: ${pokemon.name}, Type: ${pokemon.type}, Description: ${pokemon.description}');
    }

    print('\nFiltered Pokemon List:');
    for (Pokemon pokemon in filteredPokemonList) {
      print('Name: ${pokemon.name}, Type: ${pokemon.type}, Description: ${pokemon.description}');
    }
  }

}
