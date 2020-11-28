//
//  NetworkService.swift
//  Depromeet8th4
//
//  Created by Soso on 2020/07/16.
//  Copyright © 2020 Depromeet. All rights reserved.
//

import Foundation
import Moya
import MoyaSugar
import RxMoya
import RxSwift

protocol NetworkServiceType {
    func request<T: Decodable>(
        _ target: AnythingAPI,
        type: T.Type,
        _ file: StaticString,
        _ function: StaticString,
        _ line: UInt
    ) -> Single<T>
}

class NetworkService: BaseService, NetworkServiceType {
    private var networkProvider = MoyaSugarProvider<AnythingAPI>()
    private var disposeBag = DisposeBag()
    private var decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        return decoder
    }()

    func request<T: Decodable>(
        _ target: AnythingAPI,
        type _: T.Type,
        _ file: StaticString,
        _ function: StaticString,
        _ line: UInt
    ) -> Single<T> {
        let requestString = "\(target.method.rawValue) \(target.path)"
        return networkProvider.rx.request(target)
            .filterSuccessfulStatusCodes()
            .do(
                onSuccess: { value in
                    let message = "SUCCESS: \(requestString) (\(value.statusCode))"
                    log.debug(message, file: file, function: function, line: line)
                },
                onError: { error in
                    if let response = (error as? MoyaError)?.response {
                        if let jsonObject = try? response.mapJSON(failsOnEmptyData: false) {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(jsonObject)"
                            log.warning(message, file: file, function: function, line: line)
                        } else if let rawString = String(data: response.data, encoding: .utf8) {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))\n\(rawString)"
                            log.warning(message, file: file, function: function, line: line)
                        } else {
                            let message = "FAILURE: \(requestString) (\(response.statusCode))"
                            log.warning(message, file: file, function: function, line: line)
                        }
                    } else {
                        let message = "FAILURE: \(requestString)\n\(error)"
                        log.warning(message, file: file, function: function, line: line)
                    }
                },
                onSubscribed: {
                    let message = "REQUEST: \(requestString)"
                    log.debug(message, file: file, function: function, line: line)
                }
            )
            .map(T.self, using: decoder)
            .do(
                onError: { error in
                    if let error = (error as? MoyaError) {
                        let code = error.errorCode
                        var message: String
                        if let description = error.errorDescription {
                            message = "FAILURE: \(requestString) (\(code)) (\(description))"
                        } else {
                            message = "FAILURE: \(requestString) (\(code))"
                        }
                        log.warning(message, file: file, function: function, line: line)
                    }
                }
            )
    }
}
