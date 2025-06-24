import SwiftUI
import MapKit

struct ContentView: View {
    @State private var places: [Place] = []
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 55.752256, longitude: 37.630866),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var currentIndex: Int = 0
    @State private var showOnboarding: Bool = !UserDefaults.standard.bool(forKey: "hasSeenOnboarding")

    var body: some View {
        ZStack(alignment: .bottom) {
            Map(coordinateRegion: $region, annotationItems: places) { place in
                MapAnnotation(coordinate: place.coords) {
                    ZStack {
                        Circle()
                            .fill(place.id == places[currentIndex].id ? Color.green : Color.white)
                            .frame(width: 32, height: 32)
                            .shadow(radius: 4)
                        Text("★")
                            .font(.caption)
                            .foregroundColor(.orange)
                    }
                    .onTapGesture {
                        if let idx = places.firstIndex(where: { $0.id == place.id }) {
                            currentIndex = idx
                        }
                    }
                }
            }
            if places.isEmpty {
                ProgressView("Loading...")
                    .padding()
                    .background(Color.white)
                    .cornerRadius(12)
            } else {
                CardStackView(places: $places, currentIndex: $currentIndex)
                    .padding(.horizontal)
                    .frame(height: 360)
            }
            if showOnboarding {
                OnboardingOverlay {
                    showOnboarding = false
                    UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                }
            }
        }
        .ignoresSafeArea()
        .onAppear {
            PlaceService.shared.fetchPlaces { result in
                DispatchQueue.main.async {
                    if case let .success(items) = result {
                        self.places = items
                    }
                }
            }
        }
    }
}
