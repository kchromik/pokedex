//
//  Overview.swift
//  Pokedex
//
//  Created by Kevin Chromik on 29.10.21.
//

import SwiftUI

struct Overview: View {

    @State private var sourceType: UIImagePickerController.SourceType = .camera
    @State private var selectedImage: UIImage?
    @State private var isImagePickerDisplay = false

    @StateObject var mlManager = MLManager()
    @StateObject var pokeloader = PokeService()

    private let gridItems = [GridItem(.flexible()), GridItem(.flexible())]

    @State private var searchText = ""

    var searchResults: [Pokemon] {
        if searchText.isEmpty {
            return pokeloader.pokemon
        } else {
            return pokeloader.pokemon.filter { $0.name.uppercased().contains(searchText.uppercased())}
        }
    }
    
    var pokenames: [String] {
        searchResults.map { $0.name }
    }
    
    var body: some View {
        NavigationView {
            if pokeloader.pokemon.isEmpty {
                ProgressView()
            } else {
                ScrollView {
                    LazyVGrid(columns: gridItems, spacing: 20, content: {
                        ForEach(searchResults, id: \.name) { pokemon in
                            NavigationLink(destination: DescriptionView(pokemon: pokemon)) {
                                PokeCellView(pokemon: pokemon)
                            }
                        }
                    })
                }.searchable(text: $searchText)
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                self.sourceType = .camera
                                self.isImagePickerDisplay.toggle()
                            } label: {
                                Image("red_dot")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            }
                        }

                        ToolbarItem(placement: .principal) {
                            Image("pokemon_logo")
                                .resizable()
                                .frame(width: 500 / 4.5, height: 184 / 4.5)
                                .padding(.bottom, 4)
                        }
                    }
            }
                
        }.onAppear(perform: pokeloader.loadPokemon)
        .sheet(isPresented: self.$isImagePickerDisplay) {
            ImagePickerView(selectedImage: self.$selectedImage, sourceType: self.sourceType).onDisappear {
                guard let selectedImage = selectedImage else { return }
                mlManager.updateClassifications(for: selectedImage) { text in
                    searchText = text
                }
            }
        }
    }
}

struct Overview_Previews: PreviewProvider {
    static var previews: some View {
        Overview()
    }
}

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
