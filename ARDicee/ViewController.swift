//
//  ViewController.swift
//  ARDicee
//
//  Created by Cullen Mooney on 1/29/18.
//  Copyright © 2018 Cullen Mooney. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // this shows us the feature points that are looking for plane detection
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // units of measure are meters!
        //let cube = SCNBox (width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        
//        let sphere = SCNSphere (radius: 0.2)
//
//        // making the cube's material the color red
//        let material = SCNMaterial()
//        material.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")
//
//        sphere.materials = [material]
//
//        // a node is a point in 3d space
//        let node = SCNNode()
//
//        // for the z axis --> positive is going towards you, negative away
//        node.position = SCNVector3(x: 0, y: 0.1, z: -0.5)
//
//        node.geometry = sphere
//
//        // adding our node to the rootnode of the 3d scene
//        sceneView.scene.rootNode.addChildNode(node)
       
        
        // helps make the object look more 3d
        sceneView.autoenablesDefaultLighting = true
        
        // Create a new scene
//        let diceScene = SCNScene(named: "art.scnassets/diceCollada.scn")!
//
//        // the name is the identity in the attributes tab
//        // recursively --> goes down the tree to find the name
//        if let diceNode = diceScene.rootNode.childNode(withName: "Dice", recursively: true) {
//
//            diceNode.position = SCNVector3(x: 0, y: 0, z: -0.1)
//
//            sceneView.scene.rootNode.addChildNode(diceNode)
//        }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // allows us to place dice on a horizontal plane
        configuration.planeDetection = .horizontal

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    // when it detects a horizontal plane, it will call this method
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // we want to check if the anchor is a horizontal plane
        if anchor is ARPlaneAnchor {
            //if the anchor is of type ARplaneanchor then we will change its type to that
            let planeAnchor = anchor as! ARPlaneAnchor
            
            // only use x and z for this method
            let plane = SCNPlane(width: CGFloat(planeAnchor.extent.x), height: CGFloat(planeAnchor.extent.z))
            
            let planeNode = SCNNode()
            
            planeNode.position = SCNVector3(x: planeAnchor.center.x, y: 0, z: planeAnchor.center.z)
            
            // our plane is currently vertical and we need to rotate 90deg to make it horizontal
            // -float.pi/2 is the radians of 90degrees clockwise, not counterclockwise
            // we want to rotate along x axis so it is 1
            planeNode.transform = SCNMatrix4MakeRotation(-Float.pi/2, 1, 0, 0)
            
            let gridMaterial = SCNMaterial()
            
            gridMaterial.diffuse.contents = UIImage(named : "art.scnassets/grid.png")
            
            plane.materials = [gridMaterial]
            
            planeNode.geometry = plane
            
            node.addChildNode(planeNode)
        } else {
            return
        }
    }
    
}
