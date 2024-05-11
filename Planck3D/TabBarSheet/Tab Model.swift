//
//  Tab.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 09.05.2024.
//

import Foundation

enum Tab: String, CaseIterable{
    case plot = "Plot"
    case format = "Format"
    case info = "Info"
    
    var symbol: String{
        switch self {
        case .plot:
            return "cube.fill"
        case .format:
            return "paintbrush.fill"
        case .info:
            return "info.circle.fill"
        }
    }
}
