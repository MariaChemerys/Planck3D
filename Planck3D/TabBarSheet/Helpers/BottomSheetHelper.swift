//
//  BottomSheetHelper.swift
//  Planck3D
//
//  Created by Mariia Chemerys on 11.05.2024.
//

import SwiftUI

extension View {
    @ViewBuilder
    // Default Tab Bar Height = 49
    func bottomMaskForSheet(_ height: CGFloat = 49) -> some View {
        self
            .background(SheetRootViewFinder(height: height))
    }
}

// Helpers
fileprivate struct SheetRootViewFinder: UIViewRepresentable {
    var height: CGFloat
    
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    func makeUIView(context: Context) -> some UIView {
        return .init()
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            guard !context.coordinator.isMasked else { return }
            
            if let rootView = uiView.viewBeforeWindow {
                let safeArea = rootView.safeAreaInsets
                // Update its Height so that it would create an empty space in the bottom
                rootView.frame = .init(
                    origin: .zero,
                    size: .init(
                        width: rootView.frame.width,
                        height: rootView.frame.height - (height + safeArea.bottom)
                    )
                )
                
                rootView.clipsToBounds = true
                for view in rootView.subviews {
                    // Removing Shadows
                    view.layer.shadowColor = UIColor.clear.cgColor
                    
                    if view.layer.animationKeys() != nil {
                        if let cornerRadiusView = view.allSubviews.first(where: {
                            $0.layer.animationKeys()?.contains("cornerRadius") ?? false}) {
                            cornerRadiusView.layer.maskedCorners = []
                        }
                    }
                }
                
                context.coordinator.isMasked = true
            }
        }
    }
    
    class Coordinator: NSObject {
        // Status
        var isMasked: Bool = false
    }
}

fileprivate extension UIView {
    var viewBeforeWindow: UIView? {
        if let superview, superview is UIWindow {
            return self
        }
        
        return superview?.viewBeforeWindow
    }
    
    // Retrieving All Subviews from an UIView
    var allSubviews: [UIView] {
        return subviews.flatMap { [$0] + $0.subviews }
    }
}
