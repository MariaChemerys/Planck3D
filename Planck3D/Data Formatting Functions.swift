//
//  Data Formatting Functions.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 08.05.2024.
//

import Foundation

// Function to display the plot's tick marks using
func scientificNotationString(for value: CGFloat) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .scientific
    formatter.positiveFormat = "0.###E0"
    return formatter.string(from: NSNumber(value: value)) ?? "\(value)"
}

// Function to change the x axis tick interval, depending on the maximum wavelength chosen by the user
func setXTickInterval(maxλ: Double?) -> CGFloat {
    guard let maxλ = maxλ else { return 1e-6 }
    return maxλ < 5e-6 ? 1e-6 : 2e-6
}

// Function to change the y axis tick interval, depending on the maximum spectral radiance chosen by the user
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

// Function to change the z axis tick interval, depending on the maximum temperature chosen by the user
func setZTickInterval(maxT: Double?) -> CGFloat {
    guard let maxT = maxT else { return 200 }

    switch maxT {
    case ...1200:
        return 200
    case ...2400:
        return 600
    default:
        return 800
    }
}
