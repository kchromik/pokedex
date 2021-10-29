//
//  PokeService.swift
//  Pokedex
//
//  Created by Kevin Chromik on 29.10.21.
//

import Foundation
import Combine

class PokeService: ObservableObject {
    
    // MARK: Public
    
    @Published var pokemon = [Pokemon]()
    private var internalPokemon = [Pokemon]()
    
    func loadPokemon() {
        fetchPokemon()
    }

    // MARK: Private
    
    private var pokemonRequests: AnyCancellable?
    private var urls: [URL] = {
        (1...151).map { URL(string: "https://pokeapi.co/api/v2/pokemon/\($0)")! }
    }()

    private func pokemonPublisher(for urls: [URL]) -> AnyPublisher<Pokemon, URLError> {
        Publishers.Sequence(sequence: urls.map { pokemonPublisher(for: $0) })
            .flatMap(maxPublishers: .max(2)) { $0 }
            .eraseToAnyPublisher()
    }

    private func pokemonPublisher(for url: URL) -> AnyPublisher<Pokemon, URLError> {
        URLSession.shared.dataTaskPublisher(for: url)
            .compactMap { try! JSONDecoder().decode(Pokemon.self, from: $0.data) }
            .receive(on: RunLoop.main)
            .eraseToAnyPublisher()
    }

    private func fetchPokemon() {
        pokemonRequests = pokemonPublisher(for: urls).sink { completion in
            switch completion {
            case .finished:
                self.pokemon = self.internalPokemon.sorted(by: { first, second in
                    first.id < second.id
                })
                print("done")
            case .failure(let error):
                print("failed", error)
            }
        } receiveValue: { pok in
            self.internalPokemon.append(pok)
        }
    }
}
