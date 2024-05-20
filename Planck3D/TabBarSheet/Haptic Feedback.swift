//
//  Haptic Feedback.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 18.05.2024.
//

import SwiftUI
import CoreHaptics

// Function to run soft haptic effect when the user taps on a color in a CustomColorPicker
func softHaptic() {
    let softHaptic = UIImpactFeedbackGenerator(style: .soft)
    softHaptic.impactOccurred()
}
