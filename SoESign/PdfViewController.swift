//
//  PdfViewController.swift
//  SoESign
//
//  Created by Amol Bombe on 11/07/17.
//  Copyright © 2017 softcell. All rights reserved.
//

import UIKit

class PdfViewController: UIViewController {
    @IBOutlet weak var webView: UIWebView!

    var filePath = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        loadPDF(path: filePath)
    }
  
  func loadPDF(path: String) {
    let filePath = path
    print("filePath \(filePath)")
    let url = URL(fileURLWithPath: filePath)
    print("url \(url)")
    let urlRequest = URLRequest(url: url)
        webView?.loadRequest(urlRequest)
  }
}
