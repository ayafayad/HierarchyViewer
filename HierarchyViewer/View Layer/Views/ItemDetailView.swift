//
//  ItemDetailView.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 13/04/2025.
//

import SwiftUI

struct ItemDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var item: Item
    
    var body: some View {
        GeometryReader { gr in
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Spacer()
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title)
                            .foregroundColor(.secondary)
                    }
                    .padding()
                }
                if let imageURL = item.largeImageURL {
                    AnimatedImageView(url: imageURL)
                        .aspectRatio(1, contentMode: .fit)
                        .background(RoundedRectangle(cornerRadius: 10)
                            .fill(Color(Constants.ImageProperties.imgBgColor)
                                .opacity(0.8)))
                }
                if let title = item.title {
                    Text(title)
                        .font(.title3)
                        .fontWeight(.bold)
                }
                Spacer()
            }
            .padding(16)
            .frame(height: gr.size.height)
            
        }
    }
}

struct AnimatedImageView: View {
    let url: URL

    @State private var isLoaded = false

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .aspectRatio(1, contentMode: .fit)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .opacity(isLoaded ? 1 : 0)
                    .animation(.easeIn(duration: 1), value: isLoaded)
                    .onAppear {
                        isLoaded = true
                    }
            case .failure:
                Image(systemName: "xmark.circle")
            @unknown default:
                EmptyView()
            }
        }
    }
}

#Preview {
    ItemDetailView(item: Item(type: .image,
                              title: "Welcome Image",
                              image: "https://robohash.org/280?&set=set4&size=400x400",
                              items: []))
}
