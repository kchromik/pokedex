//: [Previous](@previous)

import Foundation

class PokeManager {
    let numberOfPokemon = 151
    func fetchUser(for id: Int, completion: @escaping (Pokemon) -> ()) {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(id)")!
        URLSession.shared.dataTask(with: url) { data, _, _ in
            let pokemon = try! JSONDecoder().decode(Pokemon.self, from: data!)
            completion(pokemon)
        }.resume()
    }

    func fetchAll(_ completion: @escaping ([Pokemon]) -> ()) {
        var pokes = [Pokemon]()

        (1...numberOfPokemon).forEach { number in
            fetchUser(for: number) { pokemon in
                pokes.append(pokemon)
                if pokes.count == self.numberOfPokemon {
                    completion(pokes)
                }
            }
        }
    }
}

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



PokeManager().fetchAll { pokemon in
    let mutablePokemon = pokemon.sorted {
        $0.id < $1.id
    }
    
    let types = mutablePokemon.map { pokemon in
        pokemon.types.first!
    }
    
    
    print(Set(types))
}
