//
//  RainParticleEffectView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 25/10/24.
//

import SwiftUI
import SpriteKit

class RainScene: SKScene {
    let rainEmitterNode = SKEmitterNode(fileNamed: "Rain.sks")

    override func didMove(to view: SKView) {
        guard let rainEmitterNode = rainEmitterNode else { return }

        rainEmitterNode.speed = 1
        addChild(rainEmitterNode)
    }

    override func didChangeSize(_ oldSize: CGSize) {
        guard let rainEmitterNode = rainEmitterNode else { return }
        rainEmitterNode.particlePosition = CGPoint(x: size.width/2, y: size.height)
        rainEmitterNode.particlePositionRange = CGVector(dx: size.width, dy: size.height)
    }
}

class RainSceneFallLanding: SKScene {
    let rainEmitterNode = SKEmitterNode(fileNamed: "RainFallLanding.sks")

    override func didMove(to view: SKView) {
        guard let rainEmitterNode = rainEmitterNode else { return }
        rainEmitterNode.particleSize = .init(width: 50, height: 50)
        rainEmitterNode.particleLifetime = 2
        rainEmitterNode.particleLifetimeRange = 6
        rainEmitterNode.speed = 1
        addChild(rainEmitterNode)
    }

    override func didChangeSize(_ oldSize: CGSize) {
        guard let rainEmitterNode = rainEmitterNode else { return }
        rainEmitterNode.particlePosition = CGPoint(x: size.width/2, y: size.height)
        rainEmitterNode.particlePositionRange = CGVector(dx: size.width, dy: size.height)
    }
}

func rainingBG() -> some View {
    var scene: SKScene {
        let scene = RainScene()
        scene.scaleMode = .resizeFill
        scene.backgroundColor = .clear
        return scene
    }

    return ZStack {
        SpriteView(scene: scene, options: [.allowsTransparency])
            .ignoresSafeArea()
            .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity)
    }
}

extension View {
    public func rainFallLanding(viewWidth: CGFloat = UIScreen.main.bounds.width - 40, viewHeight: CGFloat = 300, cornerR: CGFloat = 0, opacity: Double = 1) -> some View {
        var scene: SKScene {
            let scene = RainSceneFallLanding()
            scene.scaleMode = .resizeFill
            scene.backgroundColor = .clear
            return scene
        }

        return ZStack {
            self.frame(width: viewWidth, height: viewHeight, alignment: .center)
            SpriteView(scene: scene, options: [.allowsTransparency])
                .frame(width: viewWidth - (2 * cornerR), height: 5, alignment: .center)
                .opacity(opacity)
                .offset(y: -4.2)
        }
    }
}

struct RainParticleEffectView: View {
    @State var opacity = 0.0
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            rainingBG()

            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .foregroundStyle(.orange)
                        .rainFallLanding(viewWidth: 300, viewHeight: 200, cornerR: 30, opacity: 0.7)

                    Text("Rain Particle")
                        .font(.system(size: 40))
                        .kerning(-0.5)
                        .bold()
                        .foregroundStyle(.black)
                }
            }
            .padding()
        }
    }
}

#Preview {
    RainParticleEffectView()
}
