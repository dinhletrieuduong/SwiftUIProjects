//
//  PokemonListView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 09/02/2023.
//

import SwiftUI

struct PokemonListView: View {
    @State private var pokemonList: [PokemonEntry] = []
    @State private var searchText = ""
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(searchText == "" ? pokemonList : pokemonList.filter({ pokemon in
                    pokemon.name.contains(searchText.lowercased())
                }), id: \.id) { pokemon in
                    HStack {
                        PokemonImageView(imageLink: pokemon.url)
                            .padding(.trailing, 20)
                        NavigationLink("\(pokemon.name)".capitalized, destination: Text("Detail view for \(pokemon.url)"))
                    }
                }
            }
            .onAppear(perform: {
//                Task {
//                    do {
//                        let tempPokemons = try await PokeAPIService.shared.fetchPokemons(from: .pokemon)
//                        for poke in tempPokemons.results {
//                            let tempPoke = try await PokeAPIService.shared.fetchPokemonInfo(from: poke.url)
//
//                            guard let imageURL = tempPoke.sprites.frontDefault else {
//                                return
//                            }
//                            let img = try await PokeAPIService.shared.fetchPokemonImage(from: imageURL)
//
//                            let pokemonToAdd = PokemonAndImage(info: tempPoke, image: img)
//                            pokemonList.append(pokemonToAdd)
//                        }
//                    } catch {
//                    }
//                }
                
//                PokeApi().getPokemonList { pokemons in
//                    self.pokemonList = pokemons
//
//                }
            })
            .searchable(text: $searchText)
            .navigationTitle("PokedexUI")
        }
    }
}

struct PokemonImageView: View {
    var imageLink = ""
    @State private var pokemonSprite = ""
    
    var body: some View {
        AsyncImage(url: URL(string: pokemonSprite))
            .frame(width: 75, height: 75, alignment: .center)
            .onAppear(perform: {
                let loadedData = UserDefaults.standard.string(forKey: imageLink)
                if loadedData == nil {
                    getSprite(url: imageLink)
                    UserDefaults.standard.set(imageLink, forKey: imageLink)
                }
                else {
                    getSprite(url: loadedData ?? "")
                }
            })
            .clipShape(Circle())
            .foregroundColor(Color.gray.opacity(0.60))
    }
    
    func getSprite(url: String) {
        var tempSprite: String?
//        PokeAPIService.shared.fetchPokes(from: .pokemon, result: <#T##(Result<Pokemons, PokeAPIService.PokeApiServiceError>) -> Void#>)
//        PokeApi().getPokemonSprites(url: url) { sprite in
//            tempSprite = sprite.front_default
//            self.pokemonSprite = tempSprite ?? "placeholder"
//        }
        
    }
}
