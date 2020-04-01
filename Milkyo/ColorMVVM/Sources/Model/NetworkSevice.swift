//
//  NetworkSevice.swift
//  ColorMVVM
//
//  Created by Seokho on 2020/03/31.
//

import Foundation
import RxSwift

class NetworkService {
    func fetchColors() -> Single<[Color]> {
        ApiProvider.request(.colors)
    }
}

enum ApiProviderError: Error {
    case parseError
    case unknownError
}

// MARK: - API Provider
fileprivate struct ApiProvider {
    static func request(_ type: ApiType) -> Single<[Color]> {
    
        return Single.create { emitter in
            
            let session: URLSession = URLSession(configuration: .default)
            session.dataTask(with: ApiURL.url(type)) { (data: Data?, response: URLResponse?, error: Error?)  in
                
                if let _ = error {
                    emitter(.error(ApiProviderError.unknownError))
                }
                
                guard let jsonData = data else {
                    emitter(.error(ApiProviderError.unknownError))
                    return
                }
                
                guard let model = JSONDecoder.decodeOptional(jsonData,type: [Color].self) else {
                    emitter(.error(ApiProviderError.parseError))
                    return
                }
                
                emitter(.success(model))
            }.resume()
            
            return Disposables.create()
        }
    }
}
