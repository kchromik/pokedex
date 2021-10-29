import Combine
import Foundation

private let baseURL = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=151")!

private var cancellable: AnyCancellable?
private var pokeCancellable: AnyCancellable?

func fetchPokemonList() {
    cancellable = URLSession.shared.dataTaskPublisher(for: baseURL)
        .map { $0.data }
        .decode(type: Results.self, decoder: JSONDecoder())
        .replaceError(with: Results(results: []))
        .eraseToAnyPublisher()
        .sink(receiveCompletion: { completion in
            switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }, receiveValue: { results in
            print(results.results.count)

            results.results.forEach { item in
                print(item.url)


            }
        })
}


struct Results: Codable {
    let results: [Item]
}

struct Item: Codable {
    let url: String
}

struct Pokemon: Codable {
    let name: String
}

fetchPokemonList()
