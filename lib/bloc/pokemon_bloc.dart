import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/pokemon.dart';
import '../services/database_helper.dart';
import './pokemon_event.dart';
import './pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  PokemonBloc() : super(PokemonLoading()) {
    on<FetchPokemons>((event, emit) async {
      emit(PokemonLoading());
      try {
        List<Map<String, dynamic>> mapPokemons =
            await SQLHelper.getPokemons(event.context);
        List<Pokemon> pokemons = List.generate(
            mapPokemons.length, (index) => Pokemon.fromMap(mapPokemons[index]));
        emit(PokemonLoaded(pokemons));
      } catch (error) {
        emit(PokemonError("Error fetching Pokemons"));
      }
    });

    on<AddPokemon>((event, emit) async {
      emit(PokemonLoading());
      try {
        await SQLHelper.addPokemon(
            event.context,
            event.name,
            event.type,
            event.description,
            event.nameController,
            event.typeController,
            event.descriptionController);
        add(FetchPokemons(event.context));
      } catch (error) {
        emit(PokemonError("Error adding Pokemon"));
      }
    });

    on<UpdatePokemon>((event, emit) async {
      emit(PokemonLoading());
      try {
        await SQLHelper.updatePokemon(
            event.context,
            event.selectedMon,
            event.name,
            event.type,
            event.description,
            event.nameController,
            event.typeController,
            event.descriptionController);
        add(FetchPokemons(event.context));
      } catch (error) {
        emit(PokemonError("Error adding Pokemon"));
      }
    });

    on<DeletePokemon>((event, emit) async {
      emit(PokemonLoading());
      try {
        await SQLHelper.deletePokemon(event.context, event.selectedMon);
        add(FetchPokemons(event.context));
      } catch (error) {
        emit(PokemonError("Error deleting Pokemon"));
      }
    });

    on<SearchPokemon>((event, emit) async {
      emit(PokemonLoading());
      try {
        List<Map<String, dynamic>> mapPokemons = await SQLHelper.getPokemon(event.context,event.search);
        List<Pokemon> pokemons = List.generate(
            mapPokemons.length, (index) => Pokemon.fromMap(mapPokemons[index]));
        emit(PokemonLoaded(pokemons));
      } catch (error) {
        emit(PokemonError("Error fetching Pokemons"));
      }
    });
  }
}
