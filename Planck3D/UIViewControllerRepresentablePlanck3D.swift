//
//  ContentView.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 02.05.2024.
//

import SwiftUI
import Plot3d
import SceneKit

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
        config.zAxisHeight = 3
        config.xTickInterval = 1
        config.zTickInterval = 1
        config.xMax = 6
        config.zMax = 6

        // Initialize the PlotView
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        let plotView = PlotView(frame: frame, configuration: config)
        view.addSubview(plotView)

        // When using a custom configuration, the camera's position and orientation might need to be updated
        plotView.setCamera(position: PlotPoint(10, 6, 10))
        plotView.setCamera(lookAt: PlotPoint(0, 0, 0))

        plotView.setAxisTitle(.x, text: "x axis", textColor: .white)
        plotView.setAxisTitle(.y, text: "y axis", textColor: .white)
        plotView.setAxisTitle(.z, text: "z axis", textColor: .white)
        
        plotView.dataSource = self
        plotView.delegate = self
        plotView.reloadData()
    }
}

extension PlanckDistributionViewController: PlotDataSource{
    func numberOfPoints() -> Int {
            return 33 // The example in this artcile will only need a fixed number of points.
        }
}

extension PlanckDistributionViewController: PlotDelegate{
    // 1
    func plot(_ plotView: PlotView, pointForItemAt index: Int) -> PlotPoint {
        let v = CGFloat(index % 16)
        if index < 16 {
            return PlotPoint(cos(v) + 5, v, sin(v) + 5)
        }
        return PlotPoint(cos(v + 1.57) + 5, v, sin(v + 1.57) + 5)
    }
    
    // 2
    func plot(_ plotView: PlotView, geometryForItemAt index: Int) -> SCNGeometry? {
        let geo = SCNSphere(radius: 0.15)
        if index < 16  {
            geo.materials.first!.diffuse.contents = UIColor.red
        } else {
            geo.materials.first!.diffuse.contents = UIColor.blue
        }
        return geo
    }
    
    // 3
    func plot(_ plotView: PlotView, textAtTickMark index: Int, forAxis axis: PlotAxis) -> PlotText? {
        let config = PlotConfiguration()
        switch axis {
        case .x:
            return PlotText(text: "\(index + 1)", fontSize: 0.3, offset: 0.25)
        case .y:
            return PlotText(text: "\(Int(CGFloat(index + 1) * config.yTickInterval))", fontSize: 0.3, offset: 0.1)
        case .z:
            return PlotText(text: "\(index + 1)", fontSize: 0.3, offset: 0.25)
        }
    }
}

#Preview {
    UIViewControllerRepresentablePlanck3D()
}
