//
//  Networking.swift
//  BoxOffice
//
//  Created by Bora Yang on 2023/04/28.
//

import UIKit

class Networking {
    func loadData(request: String, completion: @escaping (DailyBoxOffice?, Error?) -> Void) {

        do {
            let url = try URLPath.dailyBoxOffice.configureURL(request)
            var urlRequest = URLRequest(url: url)

            URLSession.shared.dataTask(with: urlRequest) { data, response, error in
                guard error == nil else {
                    completion(nil, NetworkError.transportError)
                    return
                }

                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    completion(nil, NetworkError.serverError)
                    return
                }

                guard let safeData = data else {
                    completion(nil, NetworkError.missingData)
                    return
                }

                guard let decodedData = self.loadJSON(data: safeData) else {
                    completion(nil, NetworkError.decodingError)
                    return
                }

                completion(decodedData.convert(), nil)
            }.resume()
        } catch {
            completion(nil, URLComponentsError.invalidComponent)
        }
    }

    private func loadJSON(data: Data) -> BoxOfficeDTO? {
        let decoder = JSONDecoder()

        do {
            let decodedData = try decoder.decode(BoxOfficeDTO.self, from: data)
            return decodedData
        } catch {
            return nil
        }
    }
}