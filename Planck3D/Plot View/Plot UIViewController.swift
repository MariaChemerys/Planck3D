//
//  Plot UIViewController.swift
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
let plotDefaultConfig = PlotDefaultConfig()

struct PlotUIViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        return PlotViewController()
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}

class PlotViewController: UIViewController {
    
    private var plotViewModel = PlotViewModel()
    var config = PlotConfiguration()
    
    var plotPointColor: UIColor = UIColor.blue
    var plotConnectionColor: UIColor = UIColor.green
    
    private var maxλCancellable: AnyCancellable?
    private var maxBCancellable: AnyCancellable?
    private var maxTCancellable: AnyCancellable?
    private var pointColorCancellable: AnyCancellable?
    private var connectionColorCancellable: AnyCancellable?
    
    var indicesExceedingYMax: Set<Int> = []
    var sphereIndices: Set<Int> = []

    lazy var wavelengthMaxLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(40.0)
        return label
    }()
    
    func updatePlot(maxλ: Double?, maxB: Double?, maxT: Double?, pointColor: UIColor?, connectionColor: UIColor?) {
        
        // Update the config values
        config.xMax = maxλ ?? plotDefaultConfig.maxλ
        config.yMax = maxB ?? plotDefaultConfig.maxB
        config.zMax = maxT ?? plotDefaultConfig.maxT
        
        // Clear the indices exceeding Y max and sphere indices
        indicesExceedingYMax.removeAll()
        sphereIndices.removeAll()
        
        // Reset the plot view with the updated configuration
        config.arrowHeight = 0
        config.xAxisHeight = 3
        config.yAxisHeight = 4.7
        config.zAxisHeight = 3.5
        
        config.xTickInterval = setXTickInterval(maxλ: maxλ)
        config.yTickInterval = setYTickInterval(maxB: maxB)
        config.zTickInterval = setZTickInterval(maxT: maxT)
        
        config.zMin = plotDefaultConfig.minT
        config.xMin = plotDefaultConfig.minλ
        config.yMin = plotDefaultConfig.minB
        plotPointColor = pointColor!
        plotConnectionColor = connectionColor!
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        
        let plotView = PlotView(frame: frame, configuration: config)
        plotView.translatesAutoresizingMaskIntoConstraints = false
        
        plotView.setCamera(position: PlotPoint(10, 6, 10))
        plotView.setCamera(lookAt: PlotPoint(0, 0, 1))
        
        let lookAtConstraint = SCNLookAtConstraint(target: plotView.plottedPoint(atIndex: 0))
        lookAtConstraint.isGimbalLockEnabled = true
        plotView.cameraNode.constraints = [lookAtConstraint]
        
        plotView.setAxisTitle(.x, text: "Wavelength, λ (m)", textColor: .white, fontSize: 0.38)
        plotView.setAxisTitle(.y, text: "Spectral Radiance, B (W⁻²sr⁻¹m⁻¹)", textColor: .white, fontSize: 0.35, offset: 0.8)
        plotView.setAxisTitle(.z, text: "Temperature, T (K)", textColor: .white, fontSize: 0.38)
        
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
        
        if config.xMax != plotDefaultConfig.maxλ { config.xMax = plotDefaultConfig.maxλ }
        if config.yMax != plotDefaultConfig.maxB { config.yMax = plotDefaultConfig.maxB }
        if config.zMax != plotDefaultConfig.maxT { config.zMax = plotDefaultConfig.maxT }
        
        maxλCancellable = plotViewModel.$maxλ.sink(receiveValue: { [weak self] maxλ in
            if let value = maxλ {
                self?.updatePlot(maxλ: value, maxB: self?.plotViewModel.maxB, maxT: self?.plotViewModel.maxT, pointColor: self?.plotViewModel.pointColor, connectionColor: self?.plotViewModel.connectionColor)
            }
        })
        
        maxBCancellable = plotViewModel.$maxB.sink(receiveValue: { [weak self] maxB in
            if let value = maxB {
                self?.updatePlot(maxλ: self?.plotViewModel.maxλ, maxB: value, maxT: self?.plotViewModel.maxT, pointColor: self?.plotViewModel.pointColor, connectionColor: self?.plotViewModel.connectionColor)
            }
        })
        
        maxTCancellable = plotViewModel.$maxT.sink(receiveValue: { [weak self] maxT in
            if let value = maxT {
                self?.updatePlot(maxλ: self?.plotViewModel.maxλ, maxB: self?.plotViewModel.maxB, maxT: value, pointColor: self?.plotViewModel.pointColor, connectionColor: self?.plotViewModel.connectionColor)
            }
        })
        
        pointColorCancellable = plotViewModel.$pointColor.sink(receiveValue: { [weak self] pointColor in
            if let value = pointColor {
                self?.updatePlot(maxλ: self?.plotViewModel.maxλ, maxB: self?.plotViewModel.maxB, maxT: self?.plotViewModel.maxT, pointColor: value, connectionColor: self?.plotViewModel.connectionColor)
            }
        })
        
        connectionColorCancellable = plotViewModel.$connectionColor.sink(receiveValue: { [weak self] connectionColor in
            if let value = connectionColor {
                self?.updatePlot(maxλ: self?.plotViewModel.maxλ, maxB: self?.plotViewModel.maxB, maxT: self?.plotViewModel.maxT, pointColor: self?.plotViewModel.pointColor, connectionColor: value)
            }
        })
        
        let sheetHostingController = UIHostingController(rootView: SheetViewContainer(plotViewModel: plotViewModel))
        
        guard let sheetView = sheetHostingController.view else { return }
        sheetView.translatesAutoresizingMaskIntoConstraints = false
        self.addChild(sheetHostingController)
        self.view.addSubview(sheetView)
    }
}

extension PlotViewController: PlotDataSource {
    func numberOfPoints() -> Int {
        return plotDefaultConfig.numberOfPoints
    }
    func numberOfConnections() -> Int {
        return plotDefaultConfig.numberOfPoints
    }
}

extension PlotViewController: PlotDelegate {
    
    func plot(_ plotView: PlotView, pointForItemAt index: Int) -> PlotPoint {
        let xCount = plotDefaultConfig.numberOfXZAxesPoints
        let zCount = plotDefaultConfig.numberOfXZAxesPoints
        
        let xIndex = index % xCount
        let zIndex = index / xCount
        
        let xStep = (config.xMax - plotDefaultConfig.minλ) / CGFloat(xCount - 1)
        let zStep = (config.zMax - plotDefaultConfig.minT) / CGFloat(zCount - 1)
        
        let x = plotDefaultConfig.minλ + CGFloat(xIndex) * xStep
        let z = plotDefaultConfig.minT + CGFloat(zIndex) * zStep
        
        let nominator = 2 * Double.pi * physConst.plancksConstant * pow(physConst.speedOfLight, 2)
        let denominator = pow(Double(x), 5) * (pow(Double(M_E), physConst.plancksConstant * (physConst.speedOfLight) / (Double(x) * physConst.boltzmannConstant * Double(z))) - 1)
        let y = nominator / denominator
        
        if y > config.yMax {
            indicesExceedingYMax.insert(index)
        }
        
        let yBound = min(config.yMax, max(plotDefaultConfig.minB, y))
        return PlotPoint(x, yBound, config.zMax - z)
    }
    
    func plot(_ plotView: PlotView, geometryForItemAt index: Int) -> SCNGeometry? {
        if indicesExceedingYMax.contains(index) {
            let geo = SCNPlane(width: 0, height: 0)
            geo.materials.first?.diffuse.contents = UIColor.clear
            return geo
        } else {
            let geo = SCNSphere(radius: 0.045)
            geo.materials.first?.diffuse.contents = plotPointColor
            sphereIndices.insert(index)
            return geo
        }
    }
    
    func plot(_ plotView: PlotView, textAtTickMark index: Int, forAxis axis: PlotAxis) -> PlotText? {
        switch axis {
        case .x:
            return PlotText(text: scientificNotationString(for: CGFloat((index + 1)) * config.xTickInterval), fontSize: 0.27, offset: 0.25)
        case .y:
            return PlotText(text: scientificNotationString(for: CGFloat((index + 1)) * config.yTickInterval), fontSize: 0.27, offset: 0.1)
        case .z:
            let invertedValue = config.zMax - (CGFloat(index) + 1) * config.zTickInterval
            return PlotText(text: "\(Int(invertedValue))", fontSize: 0.27, offset: 0.25)
        }
    }
    
    func plot(_ plotView: PlotView, pointsToConnectAt index: Int) -> (p0: Int, p1: Int)? {
        let xCount = plotDefaultConfig.numberOfXZAxesPoints
        let totalPoints = plotDefaultConfig.numberOfPoints

        // Compute the index for the point directly above the current point along the z-axis
        let aboveIndex = index + xCount

        // Check if the aboveIndex is within bounds
        if aboveIndex < totalPoints {
            // Check if both the current point and the point above are within the sphereIndices
            if sphereIndices.contains(index) && sphereIndices.contains(aboveIndex) {
                return (p0: index, p1: aboveIndex)
            }
        }

        return nil
    }
    
    func plot(_ plotView: PlotView, connectionAt index: Int) -> PlotConnection? {
        let connection = plot(plotView, pointsToConnectAt: index)
        if let connection = connection, sphereIndices.contains(connection.p0), sphereIndices.contains(connection.p1) {
            return PlotConnection(radius: 0.025, color: plotConnectionColor)
        } else {
            return PlotConnection(radius: 0.025, color: UIColor.clear)
        }
    }
}
