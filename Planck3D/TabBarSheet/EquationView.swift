//
//  Info Content.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 17.05.2024.
//
import UIKit
import SwiftUI
import SwiftMath

struct EquationView: UIViewRepresentable {

    var equation: String
    var fontSize: CGFloat
    
    func makeUIView(context: Context) -> MTMathUILabel {
        let view = MTMathUILabel()
        return view
    }
    
    func updateUIView(_ uiView: MTMathUILabel, context: Context) {
        uiView.latex = equation
        uiView.fontSize = fontSize
        uiView.font = MTFontManager().termesFont(withSize: fontSize)
        uiView.textAlignment = .center
        uiView.labelMode = .text
    }
}
