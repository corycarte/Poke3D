//
//  ViewController.swift
//  Poke3D
//
//  Created by Cory Carte on 12/29/22.
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
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        sceneView.autoenablesDefaultLighting = true;
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARImageTrackingConfiguration() // Looking for images, not planes within the world.
        
        // Create references to all images in "Pokemon Cards" directory
        if let imageToTrack = ARReferenceImage.referenceImages(inGroupNamed: "Pokemon Cards", bundle: Bundle.main) {
            configuration.trackingImages = imageToTrack
            configuration.maximumNumberOfTrackedImages = 5
            
            print("Images loaded successfully")
        }

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func getPokemon(_ anchor: ARImageAnchor) -> String? {
        guard let imageName = anchor.referenceImage.name else {
            print("Unable to get reference image name")
            return nil;
        }
        
        switch(imageName) {
        case "Oddish-Card":
            return "oddish"
        case "Eevee-Card":
            return "eevee"
        default:
            print("Unknown image \(imageName) detected")
            return nil
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
        
        // First, check that Anchor is ARImageAnchor
        if let imageAnchor = anchor as? ARImageAnchor {
            // Use image anchor reference size
            let plane = SCNPlane(width: imageAnchor.referenceImage.physicalSize.width, height: imageAnchor.referenceImage.physicalSize.height)
            
            plane.firstMaterial?.diffuse.contents = UIColor(white: 1.0, alpha: 0.15)
            
            let planeNode = SCNNode(geometry: plane) // Create node with plane geometery
            
            planeNode.eulerAngles.x = -.pi / 2 // Rotate plane to be flat against card
            
            node.addChildNode(planeNode)
            if let cardName = getPokemon(imageAnchor) {
                if let pokeScene = SCNScene(named: "art.scnassets/\(cardName).scn") {
                    if let pokeNode = pokeScene.rootNode.childNodes.first {
                        pokeNode.eulerAngles.x = .pi/2
                        planeNode.addChildNode(pokeNode)
                    }
                }
            }
        }
        
        
        return node
    }
}
