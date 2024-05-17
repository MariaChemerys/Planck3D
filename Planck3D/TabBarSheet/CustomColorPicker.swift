//
//  CustomColorPicker.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 17.05.2024.
//

import SwiftUI

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

