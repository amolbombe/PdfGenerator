//
//  ViewController.swift
//  SoESign
//
//  Created by Amol Bombe on 11/07/17.
//  Copyright © 2017 softcell. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIPopoverPresentationControllerDelegate {
  var imagePicker: UIImagePickerController?
  var filePath = ""
  
  @IBOutlet weak var docImageView: UIImageView!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "showPDF" {
      if let pdfVC = segue.destination as? PdfViewController {
        pdfVC.filePath = filePath
      }
    }
  }

  @IBAction func takePhotoButtonTapped(_ sender: UIButton) {
    imagePicker =  UIImagePickerController()
    imagePicker?.delegate = self
    let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .alert)

    alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
      self.openCamera()
    }))

    alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
      self.openGallary()
    }))

    alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))

    self.present(alert, animated: true, completion: nil)
  }

  @IBAction func eSignDocumentTapped(_ sender: UIButton) {
    performSegue(withIdentifier: "showPDF", sender: self)
  }

  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
    docImageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    writePdfInFile()
    self.dismiss(animated: true, completion: nil)
  }

  func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
  }

  func writePdfInFile() {
    //    webView?.pdfView.delegate = self
    var documentsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
    //    let data = Data(base64Encoded: (pdfData?.byteCode)!, options: .ignoreUnknownCharacters)
    let data = (UIImagePNGRepresentation(docImageView.image!))!

    let mutableData = NSMutableData(data: data)
    for _ in 0..<2 {
    UIGraphicsBeginPDFContextToData(mutableData, docImageView.bounds, nil)
    UIGraphicsBeginPDFPage()
    let pdfContext = UIGraphicsGetCurrentContext()

    if (pdfContext == nil)
    {
      return
    }

    let font = UIFont(name: "Helvetica Bold", size: 14.0)

    let textRect = CGRect(x: 20, y: docImageView.bounds.size.height - 50, width: docImageView.bounds.size.width, height: 50)
    let paragraphStyle:NSMutableParagraphStyle = NSMutableParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
    paragraphStyle.alignment = NSTextAlignment.left
    paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping

    let textColor = UIColor.black

    let textFontAttributes = [
      NSFontAttributeName: font!,
      NSForegroundColorAttributeName: textColor,
      NSParagraphStyleAttributeName: paragraphStyle
    ]

    let text:NSString = "eSigned By Softcell \n\(Date())" as NSString

    text.draw(in: textRect, withAttributes: textFontAttributes)

    docImageView.layer.render(in: pdfContext!)
      
    }
    UIGraphicsEndPDFContext()
    
    var objcBool:ObjCBool = true
    documentsPath = documentsPath.appending("/GoNoGoPDFs")
    let isExist = FileManager.default.fileExists(atPath: documentsPath, isDirectory: &objcBool)

    // If the folder with the given path doesn't exist already, create it
    if isExist == false{
      do{
        try FileManager.default.createDirectory(atPath: documentsPath, withIntermediateDirectories: true, attributes: nil)
      }catch{
        print("Something went wrong while creating a new folder")
      }
    } else {
      
      do{
        try FileManager.default.removeItem(atPath: documentsPath)
      }catch{
        print("Something went wrong while deleting a new folder")
      }
      do{
        try FileManager.default.createDirectory(atPath: documentsPath, withIntermediateDirectories: true, attributes: nil)
      }catch{
        print("Something went wrong while creating a new folder")
      }
    }
    
    let pdfPath = documentsPath.appending("/eSignDoc.pdf")
    var objectiveBool:ObjCBool = true
    let isPdfExist = FileManager.default.fileExists(atPath: documentsPath, isDirectory: &objectiveBool)
    
    // If the folder with the given path doesn't exist already, create it
    if isPdfExist == false{
      do{
        try FileManager.default.removeItem(atPath: documentsPath)
      }catch{
        print("Something went wrong while creating a new folder")
      }
    }
    
    //    _ = FileManager.default.createFile(atPath: pdfPath, contents: data, attributes: nil)
    debugPrint(pdfPath, terminator: "")
    mutableData.write(toFile: pdfPath, atomically: true)
    
    filePath = pdfPath
  }

  func openCamera()
  {
    if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera))
    {
      imagePicker?.sourceType = UIImagePickerControllerSourceType.camera
      imagePicker?.allowsEditing = true
      self.present(imagePicker!, animated: true, completion: nil)
    }
    else
    {
      let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
  
  func openGallary() {
    imagePicker?.sourceType = UIImagePickerControllerSourceType.photoLibrary
    imagePicker?.allowsEditing = true
    self.present(imagePicker!, animated: true, completion: nil)
  }
  
  func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
    return .none
  }
  
  func prepareForPopoverPresentation(_ popoverPresentationController: UIPopoverPresentationController) {
    
  }
}

