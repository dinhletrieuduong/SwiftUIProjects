//
//  PokemonView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 16/01/2023.
//

import SwiftUI

enum LoadingState {
    case loading
    case loaded
    case error(Error)
    case idle
}

struct PokemonView: View {
    @State private var pokemonResults: Pokemons = Pokemons(count: 0, next: nil, previous: nil, results: [])
    @State private var loadingState: LoadingState = .idle
    @State private var pokemons: [PokemonAndImage] = []
    var body: some View {
        switch loadingState {
        case .loading:
//            PokeListLoading()
            Text("Loading")
        case .loaded:
//            PokeList(pokemons: pokemons)
            List(pokemons, id: \.id){ result in
                PokeRow(sprite: result.image, info: result.info)
            }
            .refreshable {
                loadPokes()
            }
        case .error(let error):
            Text(error.localizedDescription)
        case .idle:
            Color.clear.onAppear(perform: loadPokes)
        }
//        List(pokemonResults.results, id: \.name){ result in
//            Text("Pokemon: \(result.name)")
//        }.onAppear{
//            PokeAPIService.shared.fetchPokes(from: .pokemon) { (result: Result<Pokemons, PokeAPIService.PokeApiServiceError>) in
//
//                switch result {
//                case .success(let results):
//                    pokemonResults = results
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//
//            }
//
//        }
    }
    
    private func loadPokes() {
        loadingState = .loading
        Task {
            do {
                let tempPokemons = try await PokeAPIService.shared.fetchPokemons(from: .pokemon)
                for poke in tempPokemons.results {
                    let tempPoke = try await PokeAPIService.shared.fetchPokemonInfo(from: poke.url)
                    
                    guard let imageURL = tempPoke.sprites.frontDefault else {
                        return
                    }
                    let img = try await PokeAPIService.shared.fetchPokemonImage(from: imageURL)
                    
                    let pokemonToAdd = PokemonAndImage(info: tempPoke, image: img)
                    pokemons.append(pokemonToAdd)
                }
                loadingState = .loaded
            } catch {
                loadingState = .error(error)
            }
        }
    }
}
