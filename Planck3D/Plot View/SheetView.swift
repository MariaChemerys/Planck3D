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
                            switch activeTab {
                            case .plot:
                                Text("x axis range")
                                Slider(value: Binding(
                                    get: {
                                        return plotViewModel.maxλ ?? 0.0
                                    },
                                    set: {
                                        plotViewModel.maxλ = $0
                                    }
                                ), in: 3e-6...6e-6, step: 3e-7)
                                
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
                            case .format:
                                Text("Point Color")
                                CustomColorPicker(plotViewModel: plotViewModel, key: "point")
                                Text("Connection Color")
                                CustomColorPicker(plotViewModel: plotViewModel, key: "connection")
                                
                            case .info:
                                Text("Info")
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

struct CustomColorPicker: View {
    @ObservedObject var plotViewModel: PlotViewModel
    var key: String
    
    var pointColors: [UIColor] = [UIColor.blue, UIColor.red, UIColor.orange, UIColor.magenta, UIColor.yellow, UIColor.cyan, UIColor.purple, UIColor.green, UIColor.brown, UIColor.gray, UIColor.white, UIColor.black]
    var connectionColors: [UIColor] = [UIColor.green, UIColor.red, UIColor.orange, UIColor.magenta, UIColor.yellow, UIColor.cyan, UIColor.purple, UIColor.blue, UIColor.brown, UIColor.gray, UIColor.white, UIColor.black]
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                if key == "point" {
                    ForEach(pointColors, id: \.self) { color in
                        Circle()
                            .foregroundColor(Color(color))
                            .frame(width: 45, height: 45)
                            .scaleEffect(color == plotViewModel.pointColor! ? 1.1 : 0.9)
                            .onTapGesture {
                                plotViewModel.pointColor = color
                            }
                    }
                }
                else if key == "connection" {
                    ForEach(connectionColors, id: \.self) { color in
                        Circle()
                            .foregroundColor(Color(color))
                            .frame(width: 45, height: 45)
                            .scaleEffect(color == plotViewModel.connectionColor! ? 1.1 : 0.9)
                            .onTapGesture {
                                plotViewModel.connectionColor = color
                            }
                    }
                }
            }
            .padding()
            .background(.ultraThinMaterial)
            .cornerRadius(20)
        }
    }
}
