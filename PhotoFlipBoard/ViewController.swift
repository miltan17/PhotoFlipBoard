//
//  ViewController.swift
//  PhotoFlipBoard
//
//  Created by Miltan on 3/31/17.
//  Copyright © 2017 Milton. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    
    var imageDictionary:Dictionary<Int, Any> = [:]
    
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var previewLayer: AVCaptureVideoPreviewLayer?
    
    var frontCamera = false
    
    var stillImageOutput: AVCaptureStillImageOutput = AVCaptureStillImageOutput()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        selectCamera(frontCamera)
        
        if captureDevice != nil{
            beginSession()
        }
    }
    
    private func beginSession(){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.cameraView.layer.addSublayer(previewLayer!)
        previewLayer?.frame = self.cameraView.layer.frame
        captureSession.startRunning()
        
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput){
            captureSession.addOutput(stillImageOutput)
        }
    }
    
    private func selectCamera(_ front: Bool){
        let devices = AVCaptureDevice.devices()
        do{
            try captureSession.removeInput(AVCaptureDeviceInput(device: captureDevice))
        }catch{
            print(error.localizedDescription);
        }
        
        for device in devices! {
            if((device as AnyObject).hasMediaType(AVMediaTypeVideo)){
                if front{
                    callForFrontCamera(device)
                    break
                }else{
                    callForBackCamera(device)
                }
            }
        }
    }
    
    private func callForFrontCamera(_ device: Any){
        if (device as AnyObject).position == AVCaptureDevicePosition.front{
            captureDevice = device as? AVCaptureDevice
            addInput()
        }
    }
    
    private func callForBackCamera(_ device: Any){
        if (device as AnyObject).position == AVCaptureDevicePosition.back{
            captureDevice = device as? AVCaptureDevice
            
            addInput()
        }
    }
    
    private func addInput(){
        do{
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDevice))
        }catch{
            print(error.localizedDescription)
        }
    }
    
    @IBAction func activeFlash(_ sender: Any) {
        if captureDevice!.hasTorch{
            do{
                try captureDevice!.lockForConfiguration()
                captureDevice!.torchMode = captureDevice!.isTorchActive ? AVCaptureTorchMode.off
                : AVCaptureTorchMode.on
                
                captureDevice!.unlockForConfiguration()
            }catch{
                print("Error in flash")
            }
        }
        print(imageDictionary)
    }
    
    @IBAction func capturePicture(_ sender: Any) {
        for i in 1...10{
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(1)) {
                if let videoConnection = self.stillImageOutput.connection(withMediaType: AVMediaTypeVideo){
                    self.stillImageOutput.captureStillImageAsynchronously(from: videoConnection, completionHandler: { (imageDataSampleBuffer, error) in
                        let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                        let image = UIImage(data: imageData!)
                        
                        self.imageDictionary[i] = image
                    })
                }
            }
        }
        
        let delayInSeconds = 4.0
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayInSeconds) {
            self.changetoAlbumVC()
        }
    }
    
    func changetoAlbumVC(){
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "nextView") as! AlbumViewController
        nextViewController.imageDictionary = imageDictionary
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    func delayWithSeconds(_ seconds: Double, completion: @escaping () -> ()) {
        DispatchQueue.main.asyncAfter(deadline: .now() + seconds) {
            completion()
        }
    }

    @IBAction func setCamera(_ sender: Any) {
        //switch camera to front/back
        frontCamera = !frontCamera
        captureSession.beginConfiguration()
        let inputs = captureSession.inputs as! [AVCaptureInput]
        for oldInput: AVCaptureInput in inputs{
            captureSession.removeInput(oldInput)
        }
        selectCamera(frontCamera)
        captureSession.commitConfiguration()
    }
}

