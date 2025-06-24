import Foundation
import CoreLocation

class PlaceService {
    static let shared = PlaceService()

    private let session = URLSession(configuration: .default)
    private let apiKey = "dad2d895-611d-4dc7-8e3d-3827eed58f2c"
    private let baseURL = "https://catalog.api.2gis.com/3.0/items"

    func fetchPlaces(completion: @escaping (Result<[Place], Error>) -> Void) {
        var components = URLComponents(string: baseURL)!
        components.queryItems = [
            URLQueryItem(name: "q", value: "Поесть"),
            URLQueryItem(name: "location", value: "37.630866,55.752256"),
            URLQueryItem(name: "page_size", value: "20"),
            URLQueryItem(name: "key", value: apiKey),
            URLQueryItem(name: "fields", value: "items.point,items.address_name,items.name_ex,items.reviews,items.cover,items.context,items.schedule")
        ]

        guard let url = components.url else { return }

        let task = session.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "data", code: -1)))
                return
            }
            do {
                let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
                var places = apiResponse.result?.items.map { Place(from: $0) } ?? []
                for i in 0..<places.count {
                    if places[i].photos.isEmpty {
                        places[i].photos = [fallbackPhotos.randomElement()!]
                    }
                }
                completion(.success(places))
            } catch {
                completion(.failure(error))
            }
        }
        task.resume()
    }
}
