//
//  Constants.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 03.05.2024.
//

import SwiftUI

struct PhysicalConstants{
    let plancksConstant = 6.62607015e-34 // Planck's constant in Joule-seconds
    let speedOfLight = 299_792_458.0 // Speed of light in meters per second
    let boltzmannConstant = 1.380649e-23 // Boltzmann constant in Joules per Kelvin
}

struct PlotConstants{
    let maxλ: CGFloat = 3e-6 // Maximum Wavelength in metres
    let maxB: CGFloat = 4e9 // Maximum Spectral Radiance in watts per square meter per steradian per meter
    let maxT: CGFloat = 1200 // Maximum Temperature in kelvins
    
    let minλ: CGFloat = 0 // Minimum Wavelength in metres
    let minB: CGFloat = 0 // Minimum Spectral Radiance in watts per square meter per steradian per meter
    let minT: CGFloat = 0 // Minimum Temperature in kelvins
    
    let xTickInterval: CGFloat = 1e-6 // Tick interval along the x axis in metres
    let yTickInterval: CGFloat = 1e9 // Tick interval along the y axis in watts per square meter per steradian per meter
    let zTickInterval: CGFloat = 200 // Tick interval along the z axis in kelvins
    
    let numberOfPoints = 900 // Overall number of points in the plot
    let numberOfXZAxesPoints = 30 // The number of points along the x and z axes
}

#Preview {
    UIViewControllerRepresentablePlanck3D()
}
