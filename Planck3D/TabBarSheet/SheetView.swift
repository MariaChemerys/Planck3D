//
//  UI2ViewControllerRepresentablePlanck3D.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 09.05.2024.
//

import SwiftUI

struct SheetView: View {
    
    // View Properties
    @State private var showSheet: Bool = false
    @State private var activeTab: Tab = .plot
    @ObservedObject var plotViewModel: PlotViewModel
    
    var body: some View {
            VStack {}
            .task {
                showSheet = true
            }
            .sheet(isPresented: $showSheet) {
                VStack(alignment: .leading, spacing: 10){
                    Text(activeTab.rawValue)
                        .font(.title2)
                        .fontWeight(.semibold)
                    ScrollView {
                        VStack {
                            TabBar()
                                .frame(height: 49)
                            switch activeTab {
                            case .plot:
                                VStack(alignment: .leading) {
                                    Text("Maximum wavelength in metres (m)")
                                        .fontWeight(.semibold)
                                    Slider(value: Binding(
                                        get: {
                                            return plotViewModel.maxλ ?? 0.0
                                        },
                                        set: {
                                            plotViewModel.maxλ = $0
                                        }
                                    ),
                                           in: 3e-6...6e-6,
                                           step: 3e-7,
                                           minimumValueLabel: Text("3E-6"),
                                           maximumValueLabel: Text("6E-6")){}
                                }
                                .padding(.vertical, 5)
                                
                                VStack(alignment: .leading) {
                                    Text("Maximum spectral radiance in watts per square meter per steradian per meter (W⁻²sr⁻¹m⁻¹)")
                                        .fontWeight(.semibold)
                                    Slider(value: Binding(
                                        get: {
                                            return plotViewModel.maxB ?? 0.0
                                        },
                                        set: {
                                            plotViewModel.maxB = $0
                                        }
                                    ),
                                           in: 4e9...9e12,
                                           step: 8996e8,
                                           minimumValueLabel: Text("4E9"),
                                           maximumValueLabel: Text("9E12")){}
                                }
                                .padding(.vertical, 5)
                                
                                VStack(alignment: .leading) {
                                    Text("Maximum temperature in kelvins (K)")
                                        .fontWeight(.semibold)
                                    Slider(value: Binding(
                                        get: {
                                            return plotViewModel.maxT ?? 0.0
                                        },
                                        set: {
                                            plotViewModel.maxT = $0
                                        }
                                    ),
                                           in: 1200...4000,
                                           step: 400,
                                           minimumValueLabel: Text("1200"),
                                           maximumValueLabel: Text("4000")){}
                                }
                                .padding(.vertical, 5)
                                
                            case .colors:
                                VStack(alignment: .leading) {
                                    Text("Point Color")
                                        .fontWeight(.semibold)
                                    CustomColorPicker(plotViewModel: plotViewModel, key: "point")
                                }
                                .padding(.vertical, 12)
                                
                                VStack(alignment: .leading) {
                                    Text("Connection Color")
                                        .fontWeight(.semibold)
                                    CustomColorPicker(plotViewModel: plotViewModel, key: "connection")
                                }
                                .padding(.vertical, 12)
                                
                            case .info:
                                Text("Planck's Equation")
                                EquationView(equation: "B(\\lambda, T) = \\frac{2 \\pi hc^2}{\\lambda^5 (e^ \\frac{hc}{\\lambda kT} - 1)}", fontSize: 30)
                            }
 
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .presentationDetents([.height(115), .medium, .large])
                .presentationCornerRadius(25)
                .presentationBackground(.regularMaterial)
                .presentationBackgroundInteraction(.enabled(upThrough: .large))
                .interactiveDismissDisabled()
        }
    }
    
    // Tab Bar
    @ViewBuilder
    func TabBar() -> some View {
        HStack(spacing: 0){
            ForEach(Tab.allCases, id: \.rawValue) { tab in
                Button(action: { activeTab = tab }, label: {
                    VStack(spacing: 2){
                        Image(systemName: tab.symbol)
                            .font(.title2)
                            .rotationEffect(tab.symbol == "cube.fill" ? .degrees(180) : .degrees(0))
                        Text(tab.rawValue)
                            .font(.caption2)
                    }
                    .foregroundColor(activeTab == tab ? Color.accentColor : .gray)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .contentShape(.rect)
                })
                .buttonStyle(.plain)
            }
        }
    }
}
