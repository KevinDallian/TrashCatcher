//
//  ViewController.swift
//  NanoChallenge3
//
//  Created by Kevin Dallian on 17/07/23.
//

import Foundation
import UIKit
import Combine
import DeviceDiscoveryUI

class DeviceDiscoveryViewController: UIViewController {
    
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var pinchView: UITextView!
    
    var deviceManager = LocalDeviceManager(applicationService: "trashCatcher", didReceiveMessage: { data in
        guard let string = String(data: data, encoding: .utf8) else { return }
    }, errorHandler: { error in
        NSLog("ERROR: \(error)")
    })
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("connect to ios")
        connectIOS()
        deviceManager.didReceiveMessage = messageReceivedFromManager(_:)
    }
    
    func connectIOS() async {
        let parameters = NWParameters.applicationService
                
        // Create the view controller for the endpoint picker.
        if let devicePickerController =
            DDDevicePickerViewController(browseDescriptor: NWBrowser.Descriptor.applicationService(name: "trashCatcher"), parameters: parameters){

            // Show the network device picker as a full-screen, modal view.
            devicePickerController.modalTransitionStyle = UIModalTransitionStyle.coverVertical
            show(devicePickerController, sender: nil)

            let endpoint: NWEndpoint
            do {
                endpoint = try await devicePickerController.endpoint
            } catch {
                // The user canceled the endpoint picker view.
                return
            }
            deviceManager.connect(to: endpoint)
        } else {
        }
    }
    
    func connectIOS() {
        Task {
            await connectIOS()
        }
    }
    
    func messageReceivedFromManager(_ data: Data) {
        let message = String(data: data, encoding: .utf8)
        
        if let floatValue = Float(message!) {
            textView.text = String(floatValue)
        }else{
            pinchView.text = message
        }
    }
    
}

