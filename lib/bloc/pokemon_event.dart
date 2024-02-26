import 'package:flutter/cupertino.dart';

abstract class PokemonEvent {}

class FetchPokemons extends PokemonEvent {
  final BuildContext context;

  FetchPokemons(this.context);
}

class AddPokemon extends PokemonEvent {
  final BuildContext context;
  final String name;
  final String type;
  final String description;
  final TextEditingController nameController;
  final TextEditingController typeController;
  final TextEditingController descriptionController;

  AddPokemon(
      this.context,
      this.name,
      this.type,
      this.description,
      this.nameController,
      this.typeController,
      this.descriptionController);
}

class UpdatePokemon extends PokemonEvent {
  final BuildContext context;
  final String selectedMon;
  final String name;
  final String type;
  final String description;
  final TextEditingController nameController;
  final TextEditingController typeController;
  final TextEditingController descriptionController;

  UpdatePokemon(
      this.context,
      this.selectedMon,
      this.name,
      this.type,
      this.description,
      this.nameController,
      this.typeController,
      this.descriptionController);
}

class DeletePokemon extends PokemonEvent {
  final BuildContext context;
  final String selectedMon;

  DeletePokemon(this.context,this.selectedMon);
}

class SearchPokemon extends PokemonEvent {
  final String name;

  SearchPokemon(this.name);
}
