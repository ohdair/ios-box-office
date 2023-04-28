//
//  URLPath.swift
//  BoxOffice
//
//  Created by 박재우 on 2023/04/28.
//

import UIKit

enum URLPath {
    case dailyBoxOffice
    case movieInformation

    private var path: String {
        switch self {
        case .dailyBoxOffice:
            return "boxOffice/searchDailyBoxOfficeLst.json"
        case .movieInformation:
            return "movie/searchMovieInfo.json"
        }
    }

    private var queryItemName: String {
        switch self {
        case .dailyBoxOffice:
            return "targetDt"
        case .movieInformation:
            return "movieCd"
        }
    }

    func configureURL(_ value: String) throws -> URL {
        let baseURL = "https://www.kobis.or.kr/kobisopenapi/webservice/rest/"

        guard var component = URLComponents(string: "\(baseURL)\(path)") else {
            throw URLComponentsError.invalidComponent
        }

        let apiKey = Bundle.main.object(forInfoDictionaryKey: "MOVIE_API_KEY") as? String
        let apiKeyItem = URLQueryItem(name: "key", value: apiKey)
        let requestItem = URLQueryItem(name: queryItemName, value: value)

        component.queryItems = [apiKeyItem, requestItem]

        guard let url = component.url else {
            throw URLComponentsError.invalidComponent
        }

        return url
    }
}
