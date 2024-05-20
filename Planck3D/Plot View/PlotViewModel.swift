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
    @Published var pointColor: UIColor? = UIColor.blue
    @Published var connectionColor: UIColor? = UIColor.green

}

// Hosting View for data transferring between SwiftUI and UIKit
struct SheetViewContainer: View {
    @ObservedObject var plotViewModel: PlotViewModel
    
    var body: some View {
        SheetView(plotViewModel: plotViewModel)
    }
}
