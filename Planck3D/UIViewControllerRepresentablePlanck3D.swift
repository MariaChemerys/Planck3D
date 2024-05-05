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

let scienceConst = ScientificConstants()

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
        
        // Configure the plot.
        var config = PlotConfiguration()
        config.xAxisHeight = 3
        config.yAxisHeight = 4
        config.zAxisHeight = 3.7
        
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
        view.addSubview(plotView)

        // When using a custom configuration, the camera's position and orientation might need to be updated
        plotView.setCamera(position: PlotPoint(10, 6, 10))
        plotView.setCamera(lookAt: PlotPoint(0, 0, 1))

        plotView.setAxisTitle(.x, text: "Wavelength, λ (µm)", textColor: .white, fontSize: 0.5)
        plotView.setAxisTitle(.y, text: "Spectral Power Density, B (W⁻²sr⁻¹m⁻¹)", textColor: .white, fontSize: 0.3, offset: 1)
        plotView.setAxisTitle(.z, text: "Temperature, T (K)", textColor: .white)
        
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
    
    // 1
    func plot(_ plotView: PlotView, pointForItemAt index: Int) -> PlotPoint {
//        let config = PlotConfiguration()
        let xCount = 30  // Number of points along the x-axis
        let zCount = 30  // Number of points along the z-axis
        
        let xIndex = index % xCount
        let zIndex = index / xCount
        
        let xStep = 3e-6 / CGFloat(xCount - 1)
        let zStep = 1200 / CGFloat(zCount - 1)
        
        let x = CGFloat(xIndex) * xStep
        let z = CGFloat(zIndex) * zStep
        
        // Use the Planck's law equation to calculate y
        let nominator = 2 * Double.pi * scienceConst.plancksConstant * pow(scienceConst.speedOfLight, 2)
        let denominator = pow(Double(x), 5) * (pow(Double(M_E), scienceConst.plancksConstant * (scienceConst.speedOfLight) / (Double(x) * scienceConst.boltzmannConstant * Double(z))) - 1)
        let y = nominator / denominator
        
        // Ensure y is within bounds
        let yBound = min(4e9, max(0, y))
        
        // Exclude points that are too close to the y-axis boundary
        if y >= 3.99e9 {
            return PlotPoint(4e9, 3, 1200) // Return a point outside the plot area
        } else {
            return PlotPoint(x, CGFloat(yBound), 1200 - z)
        }
    }
    
    // 2
    func plot(_ plotView: PlotView, geometryForItemAt index: Int) -> SCNGeometry? {
        let geo = SCNSphere(radius: 0.05)
        geo.materials.first!.diffuse.contents = UIColor.blue
        return geo
    }
    
    // 3
    func plot(_ plotView: PlotView, textAtTickMark index: Int, forAxis axis: PlotAxis) -> PlotText? {
        
        switch axis {
        case .x:
            return PlotText(text: "\(index + 1)", fontSize: 0.3, offset: 0.25)
        case .y:
            return PlotText(text: "\(Int(CGFloat(index + 1)))e9", fontSize: 0.3, offset: 0.1)
        case .z:
            // Calculate and display the inverted z-value
            let invertedValue = 1200 - (CGFloat(index) + 1) * 200
            return PlotText(text: "\(Int(invertedValue))", fontSize: 0.3, offset: 0.25)
        }
    }
    
    func plot(_ plotView: PlotView, pointsToConnectAt index: Int) -> (p0: Int, p1: Int)? {
        guard index % 30 != 0 && index <= 900 else {
            return nil
        }
        
        if index < 900 - 30 {
            return (p0: index, p1: index + 30)
        }
        
        let i = index - (900 - 30)
        return (p0: i, p1: i + 1)
    }
    

    func plot(_ plotView: PlotView, connectionAt index: Int) -> PlotConnection? {
        return PlotConnection(radius: 0.025, color: .green)
    }
}

#Preview {
    UIViewControllerRepresentablePlanck3D()
}
