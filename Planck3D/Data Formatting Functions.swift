//
//  Data Formatting.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 08.05.2024.
//

import Foundation

func scientificNotationString(for value: CGFloat) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .scientific
    formatter.positiveFormat = "0.###E0"
    return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
}

func setZTickInterval(maxT: Double?) -> CGFloat {
    if maxT != nil{
        if maxT! <= 1200 {
            return 200
        }
        else if maxT! <= 2400 {
            return 600
        }
        else {
            return 800
        }
    }
    else {
        return 200
    }
}
