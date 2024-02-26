import '../models/pokemon.dart';

abstract class PokemonState {}

class PokemonLoading extends PokemonState {}

class PokemonLoaded extends PokemonState {
  final List<Pokemon> pokemons;

  PokemonLoaded(this.pokemons);
}

class PokemonError extends PokemonState {
  final String message;

  PokemonError(this.message);
}
