//
//  ContentView.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 02.05.2024.
//

import SwiftUI
import Plot3d
import SceneKit
import Numerics

let physConst = PhysicalConstants()

struct UIViewControllerRepresentablePlanck3D: View {
    var body: some View {
        PlanckDistributionUIViewControllerRepresentable()
    }
}

struct PlanckDistributionUIViewControllerRepresentable: UIViewControllerRepresentable{
    func makeUIViewController(context: Context) -> some UIViewController {
        return PlanckDistributionViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

class PlanckDistributionViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Configure the plot
        var config = PlotConfiguration()
        config.xAxisHeight = 3
        config.yAxisHeight = 4.7
        config.zAxisHeight = 3.5
        
        config.xTickInterval = 1e-6
        config.yTickInterval = 1e9
        config.zTickInterval = 200
        
        config.xMax = 3e-6
        config.yMax = 4e9
        config.zMax = 1200
        
        config.arrowHeight = 0

        // Initialize the PlotView
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let plotView = PlotView(frame: frame, configuration: config)
        plotView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(plotView)
        
        // Add constraints to the PlotView
        NSLayoutConstraint.activate([
            plotView.topAnchor.constraint(equalTo: view.topAnchor),
            plotView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            plotView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            plotView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        // Set camera's position and orientation
        plotView.setCamera(position: PlotPoint(10, 6, 10))
        plotView.setCamera(lookAt: PlotPoint(0, 0, 1))

        // Set axes' titles
        plotView.setAxisTitle(.x, text: "Wavelength, λ (µm)", textColor: .white, fontSize: 0.38)
        plotView.setAxisTitle(.y, text: "Spectral Radiance, B (W⁻²sr⁻¹m⁻¹)", textColor: .white, fontSize: 0.35, offset: 0.7)
        plotView.setAxisTitle(.z, text: "Temperature, T (K)", textColor: .white, fontSize: 0.38)
        
        plotView.dataSource = self
        plotView.delegate = self
        plotView.reloadData()
    }
}

extension PlanckDistributionViewController: PlotDataSource{
    func numberOfPoints() -> Int {
        return 900
    }
    func numberOfConnections() -> Int {
        return 900
    }
}

extension PlanckDistributionViewController: PlotDelegate{
    
    // Function to calculate the position of a point in the 3D plot based on its index
    func plot(_ plotView: PlotView, pointForItemAt index: Int) -> PlotPoint {
        // Define the number of points along the x-axis and z-axis
        let xCount = 30
        let zCount = 30
        
        // Calculate the x and z indices of the point based on its linear index
        let xIndex = index % xCount
        let zIndex = index / xCount
        
        // Calculate the step sizes along the x-axis and z-axis
        let xStep = 3e-6 / CGFloat(xCount - 1)
        let zStep = 1200 / CGFloat(zCount - 1)
        
        // Calculate the x and z coordinates of the point
        let x = CGFloat(xIndex) * xStep
        let z = CGFloat(zIndex) * zStep
        
        // Use Planck's law equation to calculate the y coordinate of the point
        let nominator = 2 * Double.pi * physConst.plancksConstant * pow(physConst.speedOfLight, 2)
        let denominator = pow(Double(x), 5) * (pow(Double(M_E), physConst.plancksConstant * (physConst.speedOfLight) / (Double(x) * physConst.boltzmannConstant * Double(z))) - 1)
        let y = nominator / denominator
        
        // Ensure that y is within bounds
        let yBound = min(4e9, max(0, y))
        
        // Exclude points that are too close to the y-axis boundary
        if y >= 3.99e9 {
            return PlotPoint(4e9, 3, 1200) // Return a point outside the plot area
        } else {
            return PlotPoint(x, CGFloat(yBound), 1200 - z)
        }
    }
    
    // Function to create geometry for a point in the 3D plot based on its index
    func plot(_ plotView: PlotView, geometryForItemAt index: Int) -> SCNGeometry? {
        let geo = SCNSphere(radius: 0.05)
        geo.materials.first!.diffuse.contents = UIColor.blue
        return geo
    }
    
    // Function to generate text for tick marks along the axes in the 3D plot
    func plot(_ plotView: PlotView, textAtTickMark index: Int, forAxis axis: PlotAxis) -> PlotText? {
        
        switch axis {
        case .x:
            return PlotText(text: "\(index + 1)", fontSize: 0.27, offset: 0.25)
        case .y:
            // Return text for the y-axis with the index converted to scientific notation (e.g., 1e9)
            return PlotText(text: "\(Int(CGFloat(index + 1)))e9", fontSize: 0.27, offset: 0.1)
        case .z:
            // Calculate and display the inverted z-value for the z-axis tick marks
            let invertedValue = 1200 - (CGFloat(index) + 1) * 200
            return PlotText(text: "\(Int(invertedValue))", fontSize: 0.27, offset: 0.25)
        }
    }
    
    // Function to specify points to connect in the 3D plot
    func plot(_ plotView: PlotView, pointsToConnectAt index: Int) -> (p0: Int, p1: Int)? {
        // Check if the index is within the valid range and not a multiple of 30
        guard index % 30 != 0 && index <= 900 else {
            return nil
        }
        
        if index < 900 - 30 {
            // Connect the current point (index) to the next point (index + 30)
            return (p0: index, p1: index + 30)
        }
        
        // Calculate the adjusted index for the last set of points
        let i = index - (900 - 30)
        
        // Connect the adjusted index to the next point (adjusted index + 1)
        return (p0: i, p1: i + 1)
    }
    
    // Function to specify the properties of a connection in the 3D plot
    func plot(_ plotView: PlotView, connectionAt index: Int) -> PlotConnection? {
        return PlotConnection(radius: 0.025, color: .green)
    }
}

#Preview {
    UIViewControllerRepresentablePlanck3D()
}
