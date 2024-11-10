//
//  RainLightningScene.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 25/10/24.
//

import SwiftUI
import SpriteKit

class RainLightningScene: SKScene {

    static var shared = RainLightningScene()

    let rainEmitter = SKEmitterNode(fileNamed: "Rain2.sks")!

    override func didMove(to view: SKView) {
        self.backgroundColor = .black
        self.addChild(rainEmitter)

        rainEmitter.position.y = self.frame.maxY
        rainEmitter.particlePositionRange.dx = self.frame.width * 2.5
    }

}

struct DemoRainLightningScene: View {

    var rainLightningScene: SKScene {
        let scene = RainLightningScene.shared
        scene.size = UIScreen.screenSize
        scene.scaleMode = .fill
        return scene
    }

    var body: some View {
        SpriteView(scene: rainLightningScene)
            .frame(width: UIScreen.screenWidth,
                   height: UIScreen.screenHeight)
        ignoresSafeArea()
    }
}

private extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}

#Preview {
    DemoRainLightningScene()
}
