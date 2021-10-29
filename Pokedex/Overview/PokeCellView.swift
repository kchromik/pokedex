//
//  PokeCellView.swift
//  Pokedex
//
//  Created by Kevin Chromik on 29.10.21.
//

import SwiftUI

struct PokeCellView: View {
    var pokemon: Pokemon
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                Text(pokemon.name)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 8)
                    .padding(.leading)
                    .textCase(.uppercase)
                HStack {
                    Text(pokemon.types.first!)
                        .font(.footnote).bold()
                        .textCase(.uppercase)
                        .foregroundColor(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .overlay(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.25))
                        )
                        .frame(width: 100, height: 24)

                    AsyncImage(url: pokemon.imageURL()) { image in
                        image.resizable()
                            .scaledToFit()
                            .frame(width: 68, height: 68)
                    } placeholder: {
                        Image("pokeball")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 68, height: 68)
                    }
                }
            }
        }
        .background(pokemon.backgroundColor())
        .cornerRadius(12)
        .shadow(color: pokemon.backgroundColor(), radius: 10, x: 0, y: 0)
    }
}

struct PokeCellView_Previews: PreviewProvider {
    static var previews: some View {
        PokeCellView(pokemon: Pokemon.mock)
    }
}
