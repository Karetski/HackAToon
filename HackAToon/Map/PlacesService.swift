//
//  PlacesService.swift
//  HackAToon
//
//  Created by Alexey Karetski on 3/18/18.
//  Copyright © 2018 Karetski. All rights reserved.
//

import Alamofire
import Foundation
import CoreLocation

let mocked: String = """
[
{
"latitude": 53.7024914,
"longitude": 23.8125823,
"identifier": "1042596899175884",
"name": "Effile Tower Paris",
"rating": 3.2
},
{
"latitude": 53.6939036,
"longitude": 23.8283751,
"identifier": "1042596899175884",
"name": "Effile Tower Paris",
"rating": 3.2
}
]
"""

struct PlaceDescription: Codable {
    let latitude: Double
    let longitude: Double
    let identifier: String
    let name: String
    let rating: Double
}

class PlacesService {

    enum Error: Swift.Error {
        case invalidURL
        case parsingFailure
    }

    typealias FetchResult = (Result<[PlaceDescription]>) -> Void

    func fetchPlaces(on location: CLLocationCoordinate2D, completion: FetchResult?) {
//        let base = "https://example.com"
//        let query = "?latitude=\(location.latitude)&longitude\(location.longitude)"

        guard let url = URL(string: "https://api.myjson.com/bins/14a8ej"/*base + query*/) else {
            completion?(.failure(Error.invalidURL))
            return
        }

        Alamofire.request(url, method: .get).responseData { (response) in
            do {
                switch response.result {
                case .success(let data):
                    print("\(data)")
                    let decoded: [PlaceDescription] = try JSONDecoder().decode([PlaceDescription].self, from: data)
                    completion?(.success(decoded))
                case .failure(let error):
                    completion?(.failure(error))
                }
            } catch {
                completion?(.failure(Error.parsingFailure))
            }
        }
    }
}

