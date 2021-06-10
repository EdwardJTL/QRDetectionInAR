//
//  ViewController.swift
//  QRDetectionInAR
//
//  Created by Edward Luo on 2021-06-10.
//

import UIKit
import SceneKit
import ARKit
import Vision

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var ScanButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - Button Action
    @IBAction func ScanButtonPressed(_ sender: Any) {
        startQRDetection()
    }

    // MARK: - QR Detection Methods
    func startQRDetection() {
        guard let buffer = sceneView.session.currentFrame?.capturedImage else { return }
        let request = VNDetectBarcodesRequest(completionHandler: self.onQRDetected(request:error:))
        request.symbologies = [.qr]
        request.preferBackgroundProcessing = true
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: buffer, options: [:])
        do {
            try imageRequestHandler.perform([request])
        } catch {
            presentAlert(title: "Unable to detect QR Code")
        }
    }

    func onQRDetected(request: VNRequest, error: Error?) {
        let visionResults = request.results?.compactMap { $0 as? VNBarcodeObservation }
        if let result = visionResults?.first,
           let payload = result.payloadStringValue {
            presentAlert(title: "QR Code Detected", message: payload)
        } else {
            presentAlert(title: "No QR Code Detected")
        }
    }

    func presentAlert(title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Dismiss", style: .destructive, handler: nil))
        self.present(alert, animated: true) {}
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
}
