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

//func setYTickInterval(maxB: Double?) -> CGFloat {
//    if maxB != nil{
//        if maxB! <= 10e9 {
//            return 1e9
//        }
//        else if maxB! <= 10e10 {
//            return 1e10
//        }
//        else if maxB! <= 10e11 {
//            return 1e11
//        }
//        else {
//            return 1e12
//        }
//    }
//    else {
//        return 1e9
//    }
//}

func setYTickInterval(maxB: Double?) -> CGFloat {
    guard let maxB = maxB else { return 1e9 }

    switch maxB {
    case ..<1e10:
        return 1e9
    case ..<1e11:
        return 1e10
    case ..<1e12:
        return 1e11
    default:
        return 1e12
    }
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
