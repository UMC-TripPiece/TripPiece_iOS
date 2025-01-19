// Copyright © 2024 TripPiece. All rights reserved

import Foundation
import SwiftyToaster
import Moya

class MapManager {
    
    static func getSearchedCities(keyword: String, completion: @escaping (Result<DefaultMultiResponse<SearchedCityResponse>, Error>) -> Void) {
        APIManager.MapProvider.request(.getMapSearch(keyword: keyword)) { result in
            switch result {
            case .success(let response):
                do {
                    let searchResult = try response.map(DefaultMultiResponse<SearchedCityResponse>.self)
                    print("success")
                    completion(.success(searchResult))
                } catch {
                    print("mapping error: \(error.localizedDescription)")
                    completion(.failure(error)) // 디코딩 실패 전달
                }
                
            case .failure(let error):
                print("network error: \(error.localizedDescription)")
                completion(.failure(error)) // 네트워크 실패 전달
            }
        }
    }
    
    
    static func getCountryColors(userId: Int, completion: @escaping (Result<DefaultMultiResponse<ColorVisitRecord>, Error>) -> Void) {
        APIManager.MapProvider.request(.getUserMap(userId: userId)) { result in
            switch result {
            case .success(let response):
                do {
                    let userData = try response.map(DefaultMultiResponse<ColorVisitRecord>.self)
                    print("success")
                    completion(.success(userData))
                } catch {
                    print("mapping error: \(error.localizedDescription)")
                    Toaster.shared.makeToast("\(response.statusCode) : 색칠된 나라 데이터를 불러오는데 실패했습니다.")
                    completion(.failure(error))
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(.failure(error))
            }
        }
    }
    
    static func getCountryStats(userId: Int, completion: @escaping (Result<DefaultResponse<StatsVisitRecord>, Error>) -> Void) {
        APIManager.MapProvider.request(.getUserMapStats(userId: userId)) { result in
            switch result {
            case .success(let response):
                do {
                    let userData = try response.map(DefaultResponse<StatsVisitRecord>.self)
                    print("success")
                    completion(.success(userData))
                } catch {
                    print("mapping error: \(error.localizedDescription)")
                    Toaster.shared.makeToast("\(response.statusCode) : 방문한 도시 개수 데이터를 불러오는데 실패했습니다.")
                    completion(.failure(error))
                }
            case .failure(let error):
                if let response = error.response {
                    Toaster.shared.makeToast("\(response.statusCode) : \(error.localizedDescription)")
                }
                completion(.failure(error))
            }
        }
    }
    
    static func postCountryColor(_ userParameter: MapRequest, completion: @escaping (Bool, Response?) -> Void) {
        APIManager.MapProvider.request(.postMaps(param: userParameter)) { result in
            switch result {
            case .success(let response):
                print(response)
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                if let responseData = error.response?.data,
                   let jsonString = String(data: responseData, encoding: .utf8) {
                    print("지도 색칠/서버 응답 메시지: \(jsonString)")
                }
                Toaster.shared.makeToast("세계지도 색칠 중 오류가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
    
    static func deleteCountryColor(_ userParameter: MapRequest, completion: @escaping (Bool, Response?) -> Void) {
        APIManager.MapProvider.request(.deleteMapColor(param: userParameter)) { result in
            switch result {
            case .success(let response):
                print(response)
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                if let responseData = error.response?.data,
                   let jsonString = String(data: responseData, encoding: .utf8) {
                    print("색칠 정보 삭제/서버 응답 메시지: \(jsonString)")
                }
                Toaster.shared.makeToast("색칠한 컬러 삭제 중 오류가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
    
    static func changeCountryColor(_ userParameter: MapRequest, completion: @escaping (Bool, Response?) -> Void) {
        APIManager.MapProvider.request(.changeMapColor(param: userParameter)) { result in
            switch result {
            case .success(let response):
                print(response)
                if response.statusCode == 200 {
                    completion(true, response)
                } else {
                    completion(false, response)
                }
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
                if let responseData = error.response?.data,
                   let jsonString = String(data: responseData, encoding: .utf8) {
                    print("색칠 정보 수정/서버 응답 메시지: \(jsonString)")
                }
                Toaster.shared.makeToast("색칠한 컬러 수정 중 오류가 발생했습니다.")
                completion(false, error.response)
            }
        }
    }
    
    
    
}

