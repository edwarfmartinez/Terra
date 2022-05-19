//
//  ViewController.swift
//  Terra
//
//  Created by EDWAR FERNANDO MARTINEZ CASTRO on 2/05/22.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKNavigationDelegate  {
    
    //var webView1 : WKWebView!
    var url = String()
    @IBOutlet weak var imageView: UIImageView!
    
    
    
//    override func loadView() {
//
//        //webView = WKWebView()
//        webView.navigationDelegate = self
//        //view = webView
//
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !url.isEmpty {
            let url1 = URL(string: url.replacingOccurrences(of: "http", with: "https"))!
            
            let data = try? Data(contentsOf: url1) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
            imageView.image = UIImage(data: data!)
        }
       
        
        
        
        //        if url.isEmpty{
        //            print(Error.self)
        //        }
        //        else {
        //            let castedUrl = URL(string: url.replacingOccurrences(of: "http", with: "https"))!
        //            webView.load(URLRequest(url: castedUrl))
        //            webView.allowsBackForwardNavigationGestures = true
        //            print(castedUrl)
        //        }
        
    }
    
    
}

