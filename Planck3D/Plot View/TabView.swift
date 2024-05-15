//
//  TabView.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 12.05.2024.
//

import SwiftUI

struct TabView: View {
    @State private var activeTab: Tab = .plot
    var body: some View {
        VStack {
            TabBar()
                .frame(height: 49)
                .background(.ultraThickMaterial)
            Spacer()
            
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
    TabView()
}
