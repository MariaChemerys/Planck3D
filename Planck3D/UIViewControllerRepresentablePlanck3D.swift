//
//  ContentView.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 02.05.2024.
//

import SwiftUI
import Plot3d

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
    }
}

#Preview {
    UIViewControllerRepresentablePlanck3D()
}
