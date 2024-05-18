//
//  Tab.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 09.05.2024.
//

import Foundation

enum Tab: String, CaseIterable{
    case plot = "Plot"
    case colors = "Colors"
    case about = "About"
    
    var symbol: String{
        switch self {
        case .plot:
            return "cube.fill"
        case .colors:
            return "paintbrush.fill"
        case .about:
            return "questionmark.circle.fill"
        }
    }
}
