//
//  AppError.swift
//  MVVMBasicStructure
//
//  Created by Apple on 21/09/22.
//

import Foundation

enum AppError {
    case network(type: Enums.NetworkError)
    case file(type: Enums.FileError)
    case dataSource(type: Enums.DataSourceError)
    case custom(errorDescription: String?)
    class Enums { }
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .network(let type): return type.localizedDescription
        case .file(let type): return type.localizedDescription
        case .dataSource(let type): return type.localizedDescription
        case .custom(let errorDescription): return errorDescription
        }
    }
}
