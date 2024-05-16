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
        GeometryReader { geometry in
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
                        VStack{
                            TabBar()
                                .frame(height: 49)
                            if activeTab == .plot {
                                
                                Text("x axis range")
                                Slider(value: Binding(
                                    get: {
                                        return plotViewModel.maxλ ?? 0.0
                                    },
                                    set: {
                                        plotViewModel.maxλ = $0
                                    }
                                ), in: 3e-6...6e-6, step: 1e-6)
                                
                                Text("y axis range")
                                Slider(value: Binding(
                                    get: {
                                        return plotViewModel.maxB ?? 0.0
                                    },
                                    set: {
                                        plotViewModel.maxB = $0
                                    }
                                ), in: 4e9...9e12, step: 8996e8)
                                
                                Text("z axis range")
                                Slider(value: Binding(
                                    get: {
                                        return plotViewModel.maxT ?? 0.0
                                    },
                                    set: {
                                        plotViewModel.maxT = $0
                                    }
                                ), in: 1200...4000, step: 400)
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
