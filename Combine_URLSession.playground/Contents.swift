import Foundation
import Combine

// JSONの構造に合わせた構造体
struct WeatherForecast: Codable {
    let title: String
    let desctiption: Description
}

struct Description: Codable {
    let text: String
    let publicTime: Data
}

let decoder = JSONDecoder()
decoder.dateDecodingStrategy = .iso8601

let url = URL(string: "http://weather.livedoor.com/forecast/webservice/json/v1?city=400040")!

let request = URLRequest(url: url)

let cancellable = URLSession.shared.dataTaskPublisher(for: request)
    .map({ (data, response) in
        return data
    })
    .decode(type: WeatherForecast.self, decoder: decoder)
    .sink(receiveCompletion: { completion in
        switch completion {
        case .failure(let error):
            print("エラー: " + error.localizedDescription)
        case .finished:
            print("=== 終了 ===")
        }
    }, receiveValue: { weatherForecast in
        print(weatherForecast.title)
        print(weatherForecast.desctiption.text)
    })
