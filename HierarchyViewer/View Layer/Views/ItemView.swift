//
//  ItemView.swift
//  HierarchyViewer
//
//  Created by Aya Fayad on 14/04/2025.
//

import SwiftUI

struct ItemView: View {
    let item: Item
    let onTapGesture: (Item) -> Void
    let depth: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            switch item.type {
            case .page:
                if let title = item.title {
                    PageView(title: title,
                             fontSize: fontSize)
                }
            case .section:
                if let title = item.title {
                    SectionView(title: title,
                                fontSize: fontSize)
                }
            case .text:
                if let title = item.title {
                    TextView(text: title,
                             fontSize: fontSize)
                }
            case .image:
                ImageView(item: item,
                          fontSize: fontSize,
                          onTapGesture: onTapGesture)
            }
        }
        .padding(.vertical, 4)
    }
    
    private var fontSize: CGFloat {
        switch item.type {
        case .page:
            return 22
        case .section:
            return max(18 - CGFloat(depth), 14)
        case .text, .image:
            return 12
        }
    }
}

private struct PageView: View {
    
    let title: String
    let fontSize: CGFloat
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "doc.text")
            
            Text(title)
                .font(.system(size: fontSize))
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
    }
}

private struct SectionView: View {
    
    let title: String
    let fontSize: CGFloat
    
    var body: some View {
        HStack {
            Image(systemName: "folder")
            
            Text(title)
                .font(.system(size: fontSize))
                .fontWeight(.medium)
                .foregroundColor(.secondary)
        }
    }
}

private struct ImageView: View {
    
    let item: Item
    let fontSize: CGFloat
    let onTapGesture: (Item) -> Void
    
    var body: some View {
        HStack(alignment: .center, spacing: 8) {
            VStack {
                Image(systemName: "rectangle.on.rectangle")
                Spacer()
            }
            
            VStack(spacing: 16) {
                if let imageURL = item.smallImgURL {
                    if let title = item.title {
                        Text(title)
                            .font(.system(size: fontSize))
                            .foregroundColor(.black)
                    }
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                                .frame(width: 100, height: 100)
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                        case .failure:
                            Image(systemName: "xmark.circle")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .onTapGesture {
                        onTapGesture(item)
                    }
                }
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(Color(Constants.ImageProperties.imgBgColor)
                .opacity(0.8)))
        }
    }
}

private struct TextView: View {
    
    let text: String
    let fontSize: CGFloat
    
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "questionmark.circle")
            
            Text(text)
                .font(.system(size: fontSize))
                .foregroundColor(.accentColor)
        }
    }
}

#Preview {
    ItemView(item: Item(type: .page,
                        title: "Main Page",
                        image: nil,
                        items: nil),
             onTapGesture: { _ in } ,
             depth: 0)
}
