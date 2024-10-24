//
//  ViewExtension.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 09/02/2023.
//

import SwiftUI

extension View {
    // MARK: Vertical Center
    func vCenter() -> some View {
        self.frame(maxHeight: .infinity, alignment: .center)
    }
    
    // MARK: Vertical Top
    func vTop() -> some View {
        self.frame(maxHeight: .infinity, alignment: .top)
    }
    
    // MARK: Vertical Bottom
    func vBottom() -> some View {
        self.frame(maxHeight: .infinity, alignment: .bottom)
    }
    
    // MARK: Horizontal Center
    func hCenter() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    // MARK: Horizontal Leading
    func hLeading() -> some View {
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    // MARK: Horizontal Trailing
    func hTrailing() -> some View {
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }

    
    func getWidth() -> CGFloat {
        return UIScreen.main.bounds.width
    }
    func getHeight() -> CGFloat {
        return UIScreen.main.bounds.height
    }

    /// Disable with opacity extension
    @ViewBuilder
    func disableWithOpacity(_ status: Bool) -> some View {
        self.disabled(status)
            .opacity(status ? 0.6 : 1)
    }


    func timerButtonStyle(isValid: Bool = true) -> some View {
        self
            .font(.title2)
            .padding()
            .background(Color.primary.opacity(isValid ? 1.0 : 0.2))
            .foregroundColor(Color.gray)
            .cornerRadius(10)
            .shadow(radius: 5)
    }
    
    func getSafeArea() -> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return .zero }

        guard let safeArea = screen.windows.first?.safeAreaInsets else { return .zero }

        return safeArea
    }
}

extension UIView {
    var viewBeforeWindow: UIView? {
        if let superview, superview is UIWindow {
            return self
        }
        return superview?.viewBeforeWindow
    }

    var allSubviews: [UIView] {
        return subviews.flatMap { [$0] + $0.subviews}
    }
    
    var parentController: UIViewController? {
        sequence(first: self) { view in
            view.next
        }
        .first { responder in
            return responder is UIViewController
        } as? UIViewController
    }

    var parentVC: UIViewController? {
        sequence(first: self) { $0.next }
            .first(where: { ($0 is UIViewController) }) as? UIViewController
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}


extension CGFloat {
    static func random() -> CGFloat {
        return CGFloat(arc4random())/CGFloat(UInt32.max)
    }
}

extension UIImage {
    func getAverageColor(completion: @escaping (UIColor) -> Void) {
        guard let inputImage = CIImage(image: self) else {
            return
        }

        let extentVector = CIVector(x: inputImage.extent.origin.x, y: inputImage.extent.origin.y, z: inputImage.extent.size.width, w: inputImage.extent.size.height)

        guard let filter = CIFilter(name: "CIAreaAverage", parameters: [
            kCIInputImageKey: inputImage,
            kCIInputExtentKey: extentVector
        ])
        else { return }

        guard let outputImage = filter.outputImage else { return }

        var bitmap = [UInt8](repeating: 0, count: 4)
        let context = CIContext(options: [.workingColorSpace: kCFNull])
        context.render(outputImage, toBitmap: &bitmap, rowBytes: 4, bounds: .init(x: 0, y: 0, width: 1, height: 1), format: .RGBA8, colorSpace: nil)
        completion(UIColor(red: CGFloat(bitmap[0])/255, green: CGFloat(bitmap[1])/255, blue: CGFloat(bitmap[2])/255, alpha: 1))
    }
}
