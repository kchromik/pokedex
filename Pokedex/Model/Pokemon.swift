//
//  Pokemon.swift
//  Pokedex
//
//  Created by Kevin Chromik on 29.10.21.
//

import Foundation
import SwiftUI

struct Pokemon: Decodable, Identifiable {

    internal init(name: String, id: Int, height: Int, weight: Int, types: [String], stats: [Pokemon.Stat]) {
        self.name = name
        self.id = id
        self.height = height
        self.weight = weight
        self.types = types
        self.stats = stats
    }
    
    let name: String
    let id: Int
    let height: Int
    let weight: Int
    let types: [String]
    let stats: [Stat]
    
    func imageURL() -> URL {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(id).png")!
    }
    
    func backgroundColor() -> Color {
        Color(PokeColor(rawValue: types.first!)!.backgroundColor())
    }

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
    
    static let mock = {
       Pokemon(name: "Glurak", id: 1, height: 36, weight: 22, types: ["fire"], stats: [Stat(name: "HP", base: 387)])
    }()
}

enum PokeColor: String {
    case poison
    case normal
    case ground
    case psychic
    case water
    case dragon
    case rock
    case ghost
    case fire
    case fighting
    case grass
    case electric
    case ice
    case fairy
    case bug
    
    func backgroundColor() -> UIColor {
        switch self {
        case .poison:
            return .systemOrange
        case .normal:
            return .systemGray
        case .ground:
            return .systemBrown
        case .psychic:
            return .systemOrange
        case .water:
            return .systemTeal
        case .dragon:
            return .systemIndigo
        case .rock:
            return .systemGray
        case .ghost:
            return .systemPurple
        case .fire:
            return .systemRed
        case .fighting:
            return .systemCyan
        case .grass:
            return .systemGreen
        case .electric:
            return .systemYellow
        case .ice:
            return .systemIndigo
        case .fairy:
            return .systemPink
        case .bug:
            return .systemOrange
        }
    }
    
}
