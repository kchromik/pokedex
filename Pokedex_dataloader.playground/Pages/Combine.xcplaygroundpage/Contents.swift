//: [Previous](@previous)

import Combine
import Foundation

struct Pokemon: Decodable {
    let name: String
    let id: Int
    let height: Int
    let weight: Int
    let types: [String]
    let stats: [Stat]

    enum RootKeys: String, CodingKey {
        case name = "name"
        case id = "id"
        case height = "height"
        case weight = "weight"
        case types = "types"
        case stats = "stats"
    }

    enum TypeKeys: String, CodingKey {
        case type = "type"
    }

    enum TypeNameKeys: String, CodingKey {
        case name
    }
    
    enum StatKeys: String, CodingKey {
        case base = "base_stat"
        case stat
    }

    enum StatNameKeys: String, CodingKey {
        case name
    }

    struct Stat {
        let name: String
        let base: Int
    }

    init(from decoder: Decoder) throws {

        let container = try decoder.container(keyedBy: RootKeys.self)
        name = try container.decode(String.self, forKey: .name)
        id = try container.decode(Int.self, forKey: .id)
        height = try container.decode(Int.self, forKey: .height)
        weight = try container.decode(Int.self, forKey: .weight)

        var typeContainer = try container.nestedUnkeyedContainer(forKey: .types)
        var allNames = [String]()
        while !typeContainer.isAtEnd {
            let typeName = try typeContainer.nestedContainer(keyedBy: TypeKeys.self)
            let somethingElse = try typeName.nestedContainer(keyedBy: TypeNameKeys.self, forKey: .type)
            let actualValue = try somethingElse.decode(String.self, forKey: .name)
            allNames.append(actualValue)
        }
        types = allNames
        
        
        var statContainer = try container.nestedUnkeyedContainer(forKey: .stats)
        var allStats = [Stat]()
        while !statContainer.isAtEnd {
            let statName = try statContainer.nestedContainer(keyedBy: StatKeys.self)
            let baseValue = try statName.decode(Int.self, forKey: .base)
            let anotherElse = try statName.nestedContainer(keyedBy: TypeNameKeys.self, forKey: .stat)
            let actualNameValue = try anotherElse.decode(String.self, forKey: .name)
            allStats.append(Stat(name: actualNameValue, base: baseValue))
        }
        stats = allStats
    }
}


var urls: [URL] = {
    (1...2).map { URL(string: "https://pokeapi.co/api/v2/pokemon/\($0)")! }
}()

func imagesPublisher(for urls: [URL]) -> AnyPublisher<Pokemon, URLError> {
    Publishers.Sequence(sequence: urls.map { imagePublisher(for: $0) })
        .flatMap(maxPublishers: .max(2)) { $0 }
        .eraseToAnyPublisher()
}


func imagePublisher(for url: URL) -> AnyPublisher<Pokemon, URLError> {
    URLSession.shared.dataTaskPublisher(for: url)
        .compactMap { try! JSONDecoder().decode(Pokemon.self, from: $0.data) }
        .receive(on: RunLoop.main)
        .eraseToAnyPublisher()
}

var imageRequests: AnyCancellable?

func fetchImages() {
    imageRequests = imagesPublisher(for: urls).sink { completion in
        switch completion {
        case .finished:
            print("done")
        case .failure(let error):
            print("failed", error)
        }
    } receiveValue: { image in
        print(image)
        // do whatever you want with the images as they come in
    }
}

fetchImages()
