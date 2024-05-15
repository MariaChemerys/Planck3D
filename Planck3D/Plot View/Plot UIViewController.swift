//
//  ContentView.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 02.05.2024.
//

import SwiftUI
import UIKit
import Combine
import Plot3d
import SceneKit
import Numerics

let physConst = PhysicalConstants()
let plotConst = PlotConstants()

struct PlanckDistributionUIViewControllerRepresentable: UIViewControllerRepresentable{
    func makeUIViewController(context: Context) -> some UIViewController {
        return PlanckDistributionViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

class PlanckDistributionViewController: UIViewController{
    
    private var plotViewModel = PlotViewModel()
    private var cancellable: AnyCancellable?
    
    // Configure the plot
    var config = PlotConfiguration()
   
    lazy var wavelengthMaxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(40.0)
        return label
    }()
    
    // Function to update the configuration of the plot when the user changes its parameters
    func updatePlot(maxλ: Double?) {
        
        // Re-create the PlotView with updated configuration
        config.xMax = maxλ ?? plotConst.maxλ
        config.arrowHeight = 0
        config.xAxisHeight = 3
        config.yAxisHeight = 4.7
        config.zAxisHeight = 3.5
        config.yTickInterval = plotConst.yTickInterval
        config.zTickInterval = plotConst.zTickInterval
        config.xTickInterval = plotConst.xTickInterval
        config.zMin = plotConst.minT
        config.xMin = plotConst.minλ
        config.yMin = plotConst.minB
        config.yMax = plotConst.maxB
        config.zMax = plotConst.maxT
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        let plotView = PlotView(frame: frame, configuration: config)
        plotView.translatesAutoresizingMaskIntoConstraints = false
        
        // Set camera's position and orientation
        plotView.setCamera(position: PlotPoint(10, 6, 10))
        plotView.setCamera(lookAt: PlotPoint(0, 0, 1))
        
        // Set axes' titles
        plotView.setAxisTitle(.x, text: "Wavelength, λ (m)", textColor: .white, fontSize: 0.38)
        plotView.setAxisTitle(.y, text: "Spectral Radiance, B (W⁻²sr⁻¹m⁻¹)", textColor: .white, fontSize: 0.35, offset: 0.7)
        plotView.setAxisTitle(.z, text: "Temperature, T (K)", textColor: .white, fontSize: 0.38)
        
        // Remove the old PlotView (if any) and add the new one
        view.subviews.forEach { view in
            if view is PlotView {
                view.removeFromSuperview()
            }
        }
        
        view.addSubview(plotView)
        plotView.dataSource = self
        plotView.delegate = self
        plotView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if config.xMax != plotConst.maxλ {
    
            config.xMax = plotConst.maxλ

        }
        
        cancellable = plotViewModel.$maxλ.sink(receiveValue: { [weak self] maxλ in
            if let value = maxλ {
                self?.updatePlot(maxλ: value)
            }
            
        })
        
        let sheetHostingController = UIHostingController(rootView: SheetViewContainer(wavelengthMax: plotViewModel))
        
        guard let sheetView = sheetHostingController.view else { return }
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        
        
        self.addChild(sheetHostingController)
        
        
        self.view.addSubview(sheetView)
        
//        view.addSubview(wavelengthMaxLabel)
//        
//        wavelengthMaxLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        wavelengthMaxLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
}

extension PlanckDistributionViewController: PlotDataSource{
    func numberOfPoints() -> Int {
        return plotConst.numberOfPoints
    }
    func numberOfConnections() -> Int {
        return plotConst.numberOfPoints
    }
}

extension PlanckDistributionViewController: PlotDelegate{
    
    // Function to calculate the position of a point in the 3D plot based on its index
    func plot(_ plotView: PlotView, pointForItemAt index: Int) -> PlotPoint {
        // Define the number of points along the x-axis and z-axis
        let xCount = plotConst.numberOfXZAxesPoints
        let zCount = plotConst.numberOfXZAxesPoints
        
        // Calculate the x and z indices of the point based on its linear index
        let xIndex = index % xCount
        let zIndex = index / xCount
        
        // Calculate the step sizes along the x-axis and z-axis
        //        let xStep = (plotConst.maxλ - plotConst.minλ) / CGFloat(xCount - 1)
        let xStep = (config.xMax - plotConst.minλ) / CGFloat(xCount - 1)
        let zStep = (plotConst.maxT - plotConst.minT) / CGFloat(zCount - 1)
        
        // Calculate the x and z coordinates of the point
        let x = plotConst.minλ + CGFloat(xIndex) * xStep
        let z = plotConst.minT + CGFloat(zIndex) * zStep
        
        // Use Planck's law equation to calculate the y coordinate of the point
        let nominator = 2 * Double.pi * physConst.plancksConstant * pow(physConst.speedOfLight, 2)
        let denominator = pow(Double(x), 5) * (pow(Double(M_E), physConst.plancksConstant * (physConst.speedOfLight) / (Double(x) * physConst.boltzmannConstant * Double(z))) - 1)
        let y = nominator / denominator
        
        // Ensure that y is within bounds
        let yBound = min(plotConst.maxB, max(plotConst.minB, y))
        
        // Exclude points that are on or out of the y-axis boundary
        if y >= plotConst.maxB {
            return PlotPoint(plotConst.maxB, 3, plotConst.maxT) // Return a point outside the plot area
        } else {
            return PlotPoint(x, CGFloat(yBound), plotConst.maxT - z)
        }
    }
    
    
    // Function to create geometry for a point in the 3D plot based on its index
    func plot(_ plotView: PlotView, geometryForItemAt index: Int) -> SCNGeometry? {
        let geo = SCNSphere(radius: 0.045)
        geo.materials.first!.diffuse.contents = UIColor.blue
        return geo
    }
    
    // Function to generate text for tick marks along the axes in the 3D plot
    func plot(_ plotView: PlotView, textAtTickMark index: Int, forAxis axis: PlotAxis) -> PlotText? {
        
        switch axis {
        case .x:
            return PlotText(text: scientificNotationString(for: CGFloat((index + 1)) * plotConst.xTickInterval), fontSize: 0.27, offset: 0.25)
        case .y:
            // Return text for the y-axis with the index converted to scientific notation (e.g., 1E9)
            return PlotText(text: scientificNotationString(for: CGFloat((index + 1)) * plotConst.yTickInterval), fontSize: 0.27, offset: 0.1)
        case .z:
            // Calculate and display the inverted z-value for the z-axis tick marks
            let invertedValue = plotConst.maxT - (CGFloat(index) + 1) * plotConst.zTickInterval
            return PlotText(text: "\(Int(invertedValue))", fontSize: 0.27, offset: 0.25)
        }
    }
    
    // Function to specify points to connect in the 3D plot
    func plot(_ plotView: PlotView, pointsToConnectAt index: Int) -> (p0: Int, p1: Int)? {
        // Check if the index is within the valid range and not a multiple of plotConst.numberOfXZAxesPoints
        guard index % plotConst.numberOfXZAxesPoints != 0 && index <= plotConst.numberOfPoints else {
            return nil
        }
        
        if index < plotConst.numberOfPoints - plotConst.numberOfXZAxesPoints {
            // Connect the current point (index) to the next point (index + plotConst.numberOfXZAxesPoints)
            return (p0: index, p1: index + plotConst.numberOfXZAxesPoints)
        }
        
        // Calculate the adjusted index for the last set of points
        let i = index - (plotConst.numberOfPoints - plotConst.numberOfXZAxesPoints)
        
        // Connect the adjusted index to the next point (adjusted index + 1)
        return (p0: i, p1: i + 1)
    }
    
    // Function to specify the properties of a connection in the 3D plot
    func plot(_ plotView: PlotView, connectionAt index: Int) -> PlotConnection? {
        return PlotConnection(radius: 0.025, color: .green)
    }
}
