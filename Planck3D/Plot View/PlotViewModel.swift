//
//  PlotViewModel.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 11.05.2024.
//

import SwiftUI

class PlotViewModel: ObservableObject {
    @Published var maxλ: Double? = 3e-6 // Maximum Wavelength in metres

//    let maxB: CGFloat = 4e9 // Maximum Spectral Radiance in watts per square meter per steradian per meter
//    let maxT: CGFloat = 1200 // Maximum Temperature in kelvins
//    
//    let minλ: CGFloat = 0 // Minimum Wavelength in metres
//    let minB: CGFloat = 0 // Minimum Spectral Radiance in watts per square meter per steradian per meter
//    let minT: CGFloat = 0 // Minimum Temperature in kelvins
}

struct SheetViewContainer: View {
    @ObservedObject var plotViewModel: PlotViewModel
    
    var body: some View {
        SheetView(plotViewModel: plotViewModel)
    }
}
