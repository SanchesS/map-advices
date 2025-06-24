import SwiftUI
import CoreLocation

struct PlaceCardView: View {
    let place: Place

    var body: some View {
        VStack(spacing: 0) {
            if !place.photos.isEmpty {
                TabView {
                    ForEach(place.photos, id: \.self) { url in
                        AsyncImage(url: url) { image in
                            image.resizable().scaledToFill()
                        } placeholder: {
                            Color.gray.opacity(0.3)
                        }
                        .frame(height: 170)
                        .clipped()
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
                .frame(height: 170)
            }
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(place.name)
                        .font(.headline)
                    Spacer()
                    Text("★ \(place.rating)")
                        .font(.subheadline)
                }
                Text("\(place.workingHours) • \(place.address)")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                HStack {
                    ForEach(place.tags) { tag in
                        HStack(spacing: 4) {
                            Text(tag.icon)
                            Text(tag.text)
                                .font(.caption)
                        }
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.black.opacity(0.65))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                HStack(spacing: -10) {
                    ForEach(place.friends.prefix(2), id: \.self) { url in
                        AsyncImage(url: url) { img in
                            img.resizable().scaledToFill()
                        } placeholder: { Color.gray }
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 2))
                    }
                    if !place.friends.isEmpty {
                        Text("Были друзья")
                            .font(.caption)
                            .foregroundColor(.white)
                            .padding(.leading, 8)
                    }
                }
                .padding(.top, 4)
            }
            .padding()
            HStack(spacing: 40) {
                Image(systemName: "figure.walk")
                Image(systemName: "bookmark")
                Image(systemName: "hand.thumbsup")
                Image(systemName: "hand.thumbsdown")
            }
            .font(.title3)
            .padding(.bottom, 12)
        }
        .background(Color.white)
        .cornerRadius(20)
        .shadow(radius: 6)
    }
}
