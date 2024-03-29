//
//  Page 4 Extra.swift
//  Grecory Store
//
//  Created by Sunchai Trabdee on 19/11/2565 BE.
//

import UIKit
import WebKit

class Page_4_Extra: UIViewController, WKUIDelegate {

    var grocery1:String = ""
    var grocery2:String = ""
    var allofhistory:Array = [String]()
    var historyrow:Int = 0
    
    @IBOutlet weak var article: WKWebView!
    @IBOutlet weak var youtube: WKWebView!
    @IBOutlet weak var allhistory: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        allhistory.text = allofhistory[historyrow]

        let myURL1 = URL(string: grocery1)
        let myURL2 = URL(string: grocery2)
        let myRequest1 = URLRequest(url: myURL1!)
        let myRequest2 = URLRequest(url: myURL2!)
        article.load(myRequest1)
        youtube.load(myRequest2)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
