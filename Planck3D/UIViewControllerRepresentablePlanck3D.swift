//
//  UI2ViewControllerRepresentablePlanck3D.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 09.05.2024.
//

import SwiftUI

struct UIViewControllerRepresentablePlanck3D: View {
    
    // View Properties
    @State private var showSheet: Bool = false
    @State private var activeTab: Tab = .plot
    
    var body: some View {
        ZStack (alignment: .bottom){
            PlanckDistributionUIViewControllerRepresentable()
            
            // Tab Bar
            TabBar()
                .frame(height: 49)
                .background(.ultraThickMaterial)
        }
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
                        if activeTab == .plot {
                            Text("x axis range")
                            Text("y axis range")
                            Text("z axis range")
                        }
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .presentationDetents([.height(60), .medium, .large])
            .presentationCornerRadius(25)
            .presentationBackground(.regularMaterial)
            .presentationBackgroundInteraction(.enabled(upThrough: .large))
            .interactiveDismissDisabled()
            // Add it inside Sheet View
            .bottomMaskForSheet()
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

#Preview {
    UIViewControllerRepresentablePlanck3D()
}
