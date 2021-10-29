//
//  DescriptionView.swift
//  Pokedex
//
//  Created by Kevin Chromik on 02.11.21.
//

import SwiftUI

struct DescriptionView: View {
    
    var pokemon: Pokemon

    @Environment(\.presentationMode) var mode: Binding<PresentationMode>

    var body: some View {
        VStack(spacing: 0) {
            Text(pokemon.name).bold()
                .font(.system(size: 40))
                .textCase(.uppercase)
                .foregroundColor(.white)
                .padding(.bottom, 100)
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .fill(Color.white.opacity(0.25))
                        .offset(x: 0, y: -50)
                        .frame(height: 60)
                        .padding([.leading, .trailing], -10)
                )
                .frame(maxWidth: .infinity)
                .background(pokemon.backgroundColor())

            ZStack() {
                Rectangle()
                    .fill(Color.white)
                    .frame(maxWidth: .infinity).frame(height: 120)
                    .cornerRadius(40, corners: [
                        .topLeft, .topRight])
                AsyncImage(url: pokemon.imageURL()) { image in
                    image.resizable()
                        .resizable()
                        .scaledToFit()
                        .frame(width: 150, height: 150)
                        .offset(x: 0, y: -40)
                        .shadow(color: .black, radius: 5)
                } placeholder: {
                    Image("pokeball")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 140, height: 140)
                        .offset(x: 0, y: -40)
                }
                Text("\(pokemon.id)")
                    .font(.title).bold()
                    .offset(x: 130, y: -10)
                    .foregroundColor(.gray.opacity(0.8))
                    .overlay(
                        RoundedRectangle(cornerRadius: 40)
                            .fill(Color.gray.opacity(0.15))
                            .offset(x: 130, y: -10)
                            .frame(width: 100)

                    )
            }.background(pokemon.backgroundColor())
                .frame(maxWidth: .infinity).frame(height: 60)

            DetailView(pokemon: pokemon)
                .background(.white)
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action : {
            self.mode.wrappedValue.dismiss()
        }){
            Image(systemName: "arrow.left")
                .foregroundColor(.white)
        })
    }
}

struct DescriptionView_Previews: PreviewProvider {
    static var previews: some View {
        DescriptionView(pokemon: Pokemon.mock)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {

        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
