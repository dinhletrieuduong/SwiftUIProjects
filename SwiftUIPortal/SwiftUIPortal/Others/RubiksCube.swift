//
//  RubiksCube.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 11/8/24.
//

import SwiftUI
import SceneKit

struct RubiksCubeDemoView: View {
    var body: some View {
        GeometryReader { proxy in
            SceneKitView(scene: createScene(), size: proxy.size)
                .ignoresSafeArea()
        }
    }

    func createScene() -> SCNScene {
        let scene = SCNScene()
        let color: [UIColor] = [.red, .white, .blue, .orange, .yellow]
        let squareSize: CGFloat = 1
        let chamferRadius: CGFloat = 0.1

        for i in -1...1 {
            for j in -1...1 {
                for k in -1...1 {
                    let box = SCNBox(width: squareSize, height: squareSize, length: squareSize, chamferRadius: chamferRadius)
                    let material = SCNMaterial()
                    material.diffuse.contents = color.randomElement()
                    material.specular.contents = UIColor.white
                    box.materials = [material]
                    let node = SCNNode(geometry: box)
                    node.position = SCNVector3(x: Float(i), y: Float(j), z: Float(k))
                    scene.rootNode.addChildNode(node)

                }
            }
        }

        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 10)
        scene.rootNode.addChildNode(cameraNode)

        return scene
    }
}

struct SceneKitView: UIViewRepresentable {
    let scene: SCNScene
    let size: CGSize

    func makeUIView(context: Context) -> SCNView {
        let view = SCNView(frame: .init(origin: .zero, size: size), options: nil)
        view.scene = scene
        view.autoenablesDefaultLighting = true
        view.backgroundColor = .black
        return view
    }

    func updateUIView(_ uiView: SCNView, context: Context) {

    }
}

