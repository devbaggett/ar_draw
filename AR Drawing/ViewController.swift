//
//  ViewController.swift
//  AR Drawing
//
//  Created by Devin Baggett on 5/24/18.
//  Copyright © 2018 devbaggett. All rights reserved.
//

import UIKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var draw: UIButton!
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.sceneView.showsStatistics = true
        self.sceneView.session.run(configuration)
        self.sceneView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // delegate function that helps us draw. gets called every time view is about to render a scene; neverending loop; gets called 60x/second
    func renderer(_ renderer: SCNSceneRenderer, willRenderScene scene: SCNScene, atTime time: TimeInterval) {
        guard let pointOfView = sceneView.pointOfView else {return}
        let transform = pointOfView.transform
        // get orientation of camera
        let orientation = SCNVector3(-transform.m31,-transform.m32,-transform.m33)
        // current location of camera; 3d vector xyz
        let location = SCNVector3(transform.m41,transform.m42,transform.m43)
        // get position from location and orientation
        let currentPositionOfCamera = orientation + location
//        print(orientation.x, orientation.y, orientation.z)
        DispatchQueue.main.async {
            if self.draw.isHighlighted {
                // when button is being pressed
                let sphereNode = SCNNode(geometry: SCNSphere(radius: 0.02))
                sphereNode.position = currentPositionOfCamera
                self.sceneView.scene.rootNode.addChildNode(sphereNode)
                sphereNode.geometry?.firstMaterial?.diffuse.contents = UIColor.blue
            } else {
                let pointer = SCNNode(geometry: SCNSphere(radius: 0.01))
                pointer.name = "pointer"
                
                // delete every pointer except first
                self.sceneView.scene.rootNode.enumerateChildNodes { (node, _) in
                    // stops drawing from being erased when button is let go of
                    if node.name == "pointer" {
                        node.removeFromParentNode()
                    }
                }
                
                pointer.position = currentPositionOfCamera
                self.sceneView.scene.rootNode.addChildNode(pointer)
                pointer.geometry?.firstMaterial?.diffuse.contents = UIColor.red
            }
        }
        
        
    }


}

func +(left: SCNVector3, right: SCNVector3) -> SCNVector3 {
    return SCNVector3Make(left.x + right.x, left.y + right.y, left.z + right.z)
}

