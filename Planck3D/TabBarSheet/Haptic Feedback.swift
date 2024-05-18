//
//  Haptic Feedback.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 18.05.2024.
//

import SwiftUI
import CoreHaptics

// Function to Run Soft Haptic Effect
func softHaptic() {
    let softHaptic = UIImpactFeedbackGenerator(style: .soft)
    softHaptic.impactOccurred()
}
