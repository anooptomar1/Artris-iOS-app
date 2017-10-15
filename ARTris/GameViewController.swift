//
//  ViewController.swift
//  ARTris
//
//  Created by Alireza Alidousti on 2017-10-04.
//  Copyright © 2017 ARTris. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class GameViewController: UIViewController, ARSCNViewDelegate {
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var movementView: UIView! {
        didSet {
            let swipeHandler = #selector(self.swipeHandler(byReactingTo:))
            let supportedDirections: [UISwipeGestureRecognizerDirection] = [.right, .left, .up, .down]
            for direction in supportedDirections {
                let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: swipeHandler)
                swipeRecognizer.direction = direction
                movementView.addGestureRecognizer(swipeRecognizer)
            }
        }
    }
    
    var tB = (pos: (0,0,0), 0)
    @objc func swipeHandler(byReactingTo swipeRecognizer: UISwipeGestureRecognizer){
        switch swipeRecognizer.direction {
        case .right:
            tB = (pos: (tB.pos.0 + 1, tB.pos.1, tB.pos.2), 0)
        case .down:
            tB = (pos: (tB.pos.0, tB.pos.1, tB.pos.2 + 1), 0)
        case .up:
            tB = (pos: (tB.pos.0, tB.pos.1, tB.pos.2 - 1), 0)
        case .left:
            tB = (pos: (tB.pos.0 - 1, tB.pos.1, tB.pos.2), 0)
        default:
            break
        }
        blocks.blocks = [tB]
    }
    
    @IBOutlet weak var rotationView: UIView!
    
    let scale: CGFloat = 0.1
    var grid: Grid!
    var blocks: Blocks!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = self
        sceneView.scene = SCNScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        grid = Grid(w: 10, h: 20, l: 10,
                    parent: sceneView.scene.rootNode, scale: scale,
                    color: UIColor.gray.withAlphaComponent(0.1))
        blocks = Blocks(parent: sceneView.scene.rootNode, scale: scale)
        grid.draw()
        blocks.blocks = [tB]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }
}

