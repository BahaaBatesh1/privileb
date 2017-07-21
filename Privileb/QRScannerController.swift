//
//  QRScannerController.swift
//  QRCodeReader
//
//  Created by Simon Ng on 13/10/2016.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import AVFoundation

class QRScannerController: UIViewController ,AVCaptureMetadataOutputObjectsDelegate{

    @IBOutlet var messageLabel:UILabel!
    
    @IBOutlet weak var loaderView: UIView!
    var offer_id:String!
    var branch_id:String!
    var user_id : String!
    var serial_number : String!

    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView:UIView?
    var loader: MaterialLoadingIndicator!
    var isScanning : Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let captureDevice = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            // Initialize the captureSession object.
            captureSession = AVCaptureSession()
            // Set the input device on the capture session.
            captureSession?.addInput(input)
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession?.addOutput(captureMetadataOutput)
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
            // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
            videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoPreviewLayer?.frame = view.layer.bounds
            view.layer.addSublayer(videoPreviewLayer!)
            

            // Start video capture.
            captureSession?.startRunning()
            
            
            // Move the message label and top bar to the front
            view.bringSubview(toFront: messageLabel)
            
            
            // Initialize QR Code Frame to highlight the QR code
            qrCodeFrameView = UIView()
            
            if let qrCodeFrameView = qrCodeFrameView {
                qrCodeFrameView.layer.borderColor = UIColor.green.cgColor
                qrCodeFrameView.layer.borderWidth = 2
                view.addSubview(qrCodeFrameView)
                view.bringSubview(toFront: qrCodeFrameView)
            }
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        // Do any additional setup after loading the view.
        
        loader = MaterialLoadingIndicator(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        loader.center = CGPoint(x: self.loaderView.frame.width/2, y: self.loaderView.frame.height/2)
        loader.circleShapeLayer.strokeColor = UIColor(red: 212, green: 172, blue: 92).cgColor
        self.loaderView.addSubview(loader)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView?.frame = CGRect.zero
            messageLabel.text = "No QR code is detected"
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            qrCodeFrameView?.frame = barCodeObject!.bounds
            
            if metadataObj.stringValue != nil {
                messageLabel.text = metadataObj.stringValue
                
                //here to trigger the service and take the variables from the qr code
                //var splittedArray = metadataObj.stringValue.components(separatedBy: ":")
                 user_id = metadataObj.stringValue
                 //serial_number = splittedArray[1]
                if(!isScanning){
                    callScan()
                }

            }
        }
    }
    
    
    @IBAction func onBack(_ sender: Any) {
        let _ = self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    func callScan() {
        isScanning = true
        let service = services_calls()
                loader.startAnimating()
                self.loaderView.isHidden = false
        
                service.scan_offer(user_id: self.user_id, scan_date: NSDate().getToDay(), offer_id: self.offer_id, branch_id: self.branch_id, serial_number: "") { (res, status) in
                    if status == "ok" {
                        if res?.status == 1 {
                            self.loader.stopAnimating()
                            self.loaderView.isHidden = true
                            let alertController = UIAlertController(title: "Success!", message: res?.message, preferredStyle: .alert)
                            let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                            alertController.addAction(ok)
                            self.present(alertController, animated: true, completion: nil)
                        }else{
                            self.isScanning = false
                            self.loader.stopAnimating()
                            self.loaderView.isHidden = true
                            let alertController = UIAlertController(title: "Failure!", message: res?.message, preferredStyle: .alert)
                            let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                            alertController.addAction(ok)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    }else{
                        self.isScanning = false
                        self.loader.stopAnimating()
                        self.loaderView.isHidden = true
                        let alertController = UIAlertController(title: "Connection error!", message: "Please check internet connection", preferredStyle: .alert)
                        let ok = UIAlertAction(title: "ok", style: .cancel, handler: nil)
                        alertController.addAction(ok)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
                }


}
