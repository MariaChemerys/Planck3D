//
//  PlotViewModel.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 11.05.2024.
//

import SwiftUI

class PlotViewModel: ObservableObject {
    @Published var maxλ: Double? = 3e-6 // Maximum Wavelength in metres
    @Published var maxB: Double? = 4e9 // Maximum Spectral Radiance in watts per square meter per steradian per meter
    @Published var maxT: Double? = 1200 // Maximum Temperature in kelvins

//    let maxB: CGFloat = 4e9 // Maximum Spectral Radiance in watts per square meter per steradian per meter
//    
//    let minλ: CGFloat = 0 // Minimum Wavelength in metres
//    let minB: CGFloat = 0 // Minimum Spectral Radiance in watts per square meter per steradian per meter
//    let minT: CGFloat = 0 // Minimum Temperature in kelvins
}

// Hosting View
struct SheetViewContainer: View {
    @ObservedObject var plotViewModel: PlotViewModel
    
    var body: some View {
        SheetView(plotViewModel: plotViewModel)
    }
}
