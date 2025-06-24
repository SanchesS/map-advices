import Foundation
import CoreLocation

struct Place: Identifiable {
    let id: String
    let name: String
    let address: String
    let coords: CLLocationCoordinate2D
    var photos: [URL]
    let rating: String
    let workingHours: String
    let tags: [Tag]
    let friends: [URL]
    let markerPhoto: URL?
}

extension Place {
    init(from apiItem: APIItem) {
        self.id = apiItem.id ?? UUID().uuidString
        self.name = apiItem.name_ex?.primary ?? apiItem.name ?? "Unknown"
        self.address = apiItem.address_name ?? apiItem.address ?? ""
        self.coords = CLLocationCoordinate2D(latitude: apiItem.point?.lat ?? 0,
                                             longitude: apiItem.point?.lon ?? 0)
        if let urlStr = apiItem.cover?.preview_urls.values.first,
           let url = URL(string: urlStr) {
            self.photos = [url]
        } else {
            self.photos = [fallbackPhotos.randomElement()!]
        }
        if let rating = apiItem.reviews?.rating {
            self.rating = String(format: "%.1f", rating)
        } else if let rating = apiItem.rating {
            self.rating = String(format: "%.1f", rating)
        } else {
            self.rating = "0"
        }
        self.workingHours = formatWorkingHours(apiItem.schedule)
        self.tags = createTags(from: apiItem.context)
        self.friends = (0..<Int.random(in: 2...3)).map { _ in avatarURLs.randomElement()! }
        self.markerPhoto = self.photos.first
    }
}

struct APIItem: Decodable {
    struct NameEx: Decodable { let primary: String? }
    struct Point: Decodable { let lat: Double?; let lon: Double? }
    struct Cover: Decodable { let preview_urls: [String: String] }
    struct Reviews: Decodable { let rating: Double? }
    struct StopFactor: Decodable { let tag: String?; let name: String? }
    struct Context: Decodable { let stop_factors: [StopFactor]? }
    struct WorkingHours: Decodable { let from: String?; let to: String? }
    struct Day: Decodable { let working_hours: [WorkingHours]? }
    typealias Schedule = [String: Day]

    let id: String?
    let name: String?
    let address_name: String?
    let address: String?
    let name_ex: NameEx?
    let point: Point?
    let cover: Cover?
    let reviews: Reviews?
    let rating: Double?
    let context: Context?
    let schedule: Schedule?
}

struct APIResponse: Decodable {
    struct Result: Decodable { let items: [APIItem] }
    let result: Result?
}

func createTags(from context: APIItem.Context?) -> [Tag] {
    guard let factors = context?.stop_factors, !factors.isEmpty else {
        return [Tag(icon: "🍴", text: "Поесть")]
    }
    let iconMap: [String: String] = [
        "food_service_avg_price": "💳",
        "food_service_assortment_assortment_hamburgers": "🍔",
        "food_service_assortment_assortment_frenchfries": "🍟",
        "food_service_assortment_assortment_nuggets": "🍗",
        "cocktail_bars_types_coffee_take_away": "☕",
        "cocktail_bars_types_tea_take_away": "🍵",
        "cocktail_bars_types_milk_shake": "🥤",
        "covid_homedelivery": "🚚",
        "food_service_details_food_takeaway": "📦",
        "food_service_details_food_kids_menu": "🧒",
        "additionally_services_wifi": "📶",
        "general_payment_type_card": "💳",
        "accessible_entrance_accessible_entrance": "♿"
    ]
    let limited = factors.prefix(2)
    var tags: [Tag] = []
    for f in limited {
        let icon = iconMap[f.tag ?? ""] ?? "🏷️"
        let text = f.name ?? ""
        tags.append(Tag(icon: icon, text: text))
    }
    return tags.isEmpty ? [Tag(icon: "🍴", text: "Поесть")] : tags
}

func formatWorkingHours(_ schedule: APIItem.Schedule?) -> String {
    guard let schedule = schedule else { return "Часы работы уточняйте" }
    let dayNames = ["Sun","Mon","Tue","Wed","Thu","Fri","Sat"]
    let dayNamesRu = ["Вс","Пн","Вт","Ср","Чт","Пт","Сб"]
    let weekday = Calendar.current.component(.weekday, from: Date()) - 1
    let currentDay = dayNames[weekday]
    if let day = schedule[currentDay], let wh = day.working_hours?.first, let to = wh.to {
        return "Сегодня до \(to)"
    }
    for (i, name) in dayNames.enumerated() {
        if let day = schedule[name], let wh = day.working_hours?.first,
           let from = wh.from, let to = wh.to {
            return "\(dayNamesRu[i]) \(from)-\(to)"
        }
    }
    return "Часы работы уточняйте"
}
