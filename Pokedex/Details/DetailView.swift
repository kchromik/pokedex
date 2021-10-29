//
//  DetailView.swift
//  Pokedex
//
//  Created by Kevin Chromik on 29.10.21.
//

import SwiftUI

struct DetailView: View {
    let pokemon: Pokemon
    
    var body: some View {
        List {
            Text("Details").font(.title).bold().foregroundColor(.gray).listRowSeparator(.hidden)
            StatDetailView(with: "Height", value: "\(pokemon.height)m").listRowSeparator(.hidden)
            StatDetailView(with: "Weight", value: "\(pokemon.height)kg").listRowSeparator(.hidden)
            Text("Base Stats").font(.title).bold().foregroundColor(.gray).padding([.top])
            
            ForEach(pokemon.stats, id: \.name) { stat in
                BaseStatsView(with: stat.name, value: Float(stat.base))
            }.listRowSeparator(.hidden)
        }
        .listStyle(.plain)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(pokemon: Pokemon.mock)
    }
}

struct StatDetailView: View {

    private let key: String
    private let value: String


    init(with key: String, value: String) {
        self.key = key
        self.value = value
    }

    var body: some View {
        HStack(alignment: .lastTextBaseline, spacing: 0) {
            Text(key)
                .font(.title2)
                .foregroundColor(.gray)
                .frame(width: 100, alignment: .leading)
                .padding(.leading, 8)
            Text(value)
                .font(.title2)
                .foregroundColor(Color.black.opacity(0.7))
                .frame(width: 170, alignment: .leading)
        }
    }
}

struct BaseStatsView: View {

    private let key: String
    private let value: Float


    init(with key: String, value: Float) {
        self.key = key
        self.value = value
    }

    var body: some View {
        HStack {
            Text(key)
                .font(.title2)
                .foregroundColor(.gray)
                .frame(width: 150, alignment: .leading)
                .padding(.leading, 8)

            ProgressView(value: value, total: 110)
                .accentColor(.green)
                .frame(width: 170, height: 2, alignment: .leading)
        }
    }
}
