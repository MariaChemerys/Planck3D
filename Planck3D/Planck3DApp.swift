//
//  Planck3DApp.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 02.05.2024.
//

import SwiftUI

@main
struct Planck3DApp: App {
    var body: some Scene {
        WindowGroup {
            PlotUIViewControllerRepresentable()
                .preferredColorScheme(.light)
        }
    }
}
