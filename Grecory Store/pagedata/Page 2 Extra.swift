//
//  Page 2 Extra.swift
//  Grecory Store
//
//  Created by Sunchai Trabdee on 18/11/2565 BE.
//

import UIKit
import CoreImage
import CoreImage.CIFilterBuiltins

class Page_2_Extra: UIViewController, UIScrollViewDelegate {
    
    var counts = 0
    var qrId = [" "]
    var qrtype = [" "]
    var qrname = [" "]
    var qrprice = [" "]
    var qrpiece = [" "]
    
    var Shopimg = ["001.jpg", "002.jpg", "003.jpg", "004.jpg", "005.jpeg", "006.jpg", "007.jpg"]
    
    @IBOutlet weak var qrview: UIImageView!
    @IBOutlet weak var ShowPic: UIScrollView!
    @IBOutlet weak var PicShow: UIPageControl!
    @IBOutlet weak var thank: UILabel!
    @IBOutlet weak var QRcode: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        QRcode.titleLabel?.font =  UIFont(name: "Silkscreen-Regular", size: 18)
        view.addSubview(QRcode)
        
        for i in 0..<Shopimg.count{
            let pic = UIImageView()
            pic.contentMode = .scaleToFill
            pic.image = UIImage(named: Shopimg[i])
            let xPos = CGFloat(i)*self.view.bounds.size.width
            pic.frame = CGRect(x: xPos, y: 0, width: view.frame.size.width, height: ShowPic.frame.size.height)
            ShowPic.contentSize.width = view.frame.size.width*CGFloat(i+1)
            ShowPic.addSubview(pic)
        }
        func scrollVdS(_ scrollView: UIScrollView){
            let page2 = scrollView.contentOffset.x/scrollView.frame.width
            PicShow.currentPage = Int(page2)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        thank.center.x = view.center.x // Place it in the center x of the view.
        thank.center.x -= view.bounds.width // Place it on the left of the view with the width = the bounds'width of the view.
        // animate it from the left to the right
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseOut], animations: { [self] in
            thank.center.x += view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    //ปุ่มสร้าง Qr code ขึ้นมา
    @IBAction func GenQr(_ sender: UIButton) {
        let id = qrId[counts]
        let type = qrtype[counts]
        let name = qrname[counts]
        let price = qrprice[counts]
        let piece = qrpiece[counts]
        let combined = "Code : \(id)\nType : \(type)\nName : \(name)\nPrice : \(price)\nQuantity : \(piece)"
        qrview.image = generateQRCode(from: combined)
        
        sender.sulflash()
    }
    
    //ฟังก์ชั่นในการสร้าง Qrcode
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    private func generateQRCode(from string: String) -> UIImage {
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        if let qrCodeImage = filter.outputImage {
            if let qrCodeCGImage = context.createCGImage(qrCodeImage, from: qrCodeImage.extent) {
                return UIImage(cgImage: qrCodeCGImage)
            }
        }
        return UIImage(systemName: "xmark") ?? UIImage()
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
