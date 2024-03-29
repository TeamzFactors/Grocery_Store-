//
//  Page 3.swift
//  Grecory Store
//
//  Created by Sunchai Trabdee on 18/11/2565 BE.
//

import UIKit
import ViewAnimator

class Page_3: UIViewController {
    
    @IBOutlet weak var netWeight: UITextField!
    @IBOutlet weak var fat: UITextField!
    @IBOutlet weak var carbo: UITextField!
    @IBOutlet weak var protein: UITextField!
    @IBOutlet weak var energy: UITextView!
    @IBOutlet weak var percent: UITextView!
    @IBOutlet weak var energyPiece: UITextView!
    @IBOutlet weak var perPrice: UISlider!
    @IBOutlet weak var per: UILabel!
    
    @IBOutlet weak var Popup1: UIButton!//ปุ่ม pull down
    @IBOutlet weak var p2s: UIButton!
    @IBOutlet weak var reset2: UIButton!
    @IBOutlet weak var calculation: UIButton!
    
    @objc func tap(sender: UITapGestureRecognizer){
            print("tapped")
            view.endEditing(true)
    }
    
    var net1:Float = 0
    var carbohydate:Float = 0
    var totalfat:Float = 0
    var totalprotein:Float = 0
    var energy1:Float = 0
    var percent1:Float = 0
    var Allenergy:Float = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
        setPopupButton()
        
        p2s.titleLabel?.font =  UIFont(name: "benjamin", size: 20)
        calculation.titleLabel?.font =  UIFont(name: "Lulu", size: 18)
        reset2.titleLabel?.font =  UIFont(name: "Lulu", size: 20)
        
        let animation = AnimationType.from(direction: .left, offset: 200.0)
        view.animate(animations: [animation])
    }
    //ฟังก์ชั่นปุ่ม Pull down
    func setPopupButton(){
        let options = {(action : UIAction) in
            print(action.title)}
        //กำหนดให้ตัว pull down แต่ละปุ่ม แสดงชื่อตัวเลข
        Popup1.menu = UIMenu(children : [
            UIAction(title: "one", state: .on, handler: options),
            UIAction(title: "two", handler: options),
            UIAction(title: "three", handler: options),
            UIAction(title: "four", handler: options),
            UIAction(title: "five", handler: options),
            UIAction(title: "six", handler: options),
            UIAction(title: "seven", handler: options),
            UIAction(title: "eight", handler: options),
            UIAction(title: "nine", handler: options),
            UIAction(title: "ten", handler: options)])
        
        Popup1.showsMenuAsPrimaryAction = true
        Popup1.changesSelectionAsPrimaryAction = true
    }
    
    @IBAction func piece(_ sender: UISlider) {
        let piece1 = String(format: "%.1f", sender.value)
        per.text = "\(piece1)"
    }
    
    //ฟังก์ชั่นในส่วนของการคำนวณ
    func calculate() {
        //ส่วนกรอกข้อมูล
        let piece1 = perPrice.value
        net1 = Float(netWeight.text!)!
        carbohydate = Float(carbo.text!)!
        totalfat = Float(fat.text!)!
        totalprotein = Float(protein.text!)!
        
        //ส่วนการคำนวณ
        totalfat = totalfat * 9
        totalprotein = totalprotein * 4
        carbohydate = carbohydate * 4
        energy1 = totalfat + totalprotein + carbohydate
        percent1 = Float(energy1 * 100) * piece1 / 2000
        Allenergy = energy1 * piece1
        
        energy.text = "\(Int(energy1)) kcal"
        percent.text = "\(Int(percent1)) %"
        energyPiece.text = "\(Int(Allenergy)) kcal"
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        calculate()
        
        print(energy1)
        print(percent1)
        print(Allenergy)
        
        sender.pulsate()
        
        func alertWithTitle(title: String!, message: String) {
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
                        if title=="ERROR"{
                            print("error!")
                        }
                    });
                    alert.addAction(action)
                    self.present(alert, animated: true, completion:nil)
                }
                alertWithTitle(title: "SUCCESS!", message: "calculation complete")
    }
    
    @IBAction func btnP2(_ sender: Any) {
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let p2 = storyBoard.instantiateViewController(identifier: "Showlist") as! Page_2
        self.present(p2, animated: true, completion: nil)
    }
    
    @IBAction func btnReset(_ sender: UIButton) {
        Popup1.setTitle("one", for: UIControl.State())
        perPrice.value = 1
        per.text = "1"
        netWeight.text? = ""
        fat.text? = ""
        carbo.text? = ""
        protein.text? = ""
        energy.text? = ""
        percent.text? = ""
        energyPiece.text? = ""
        
        sender.gulshake()
        
        func alertWithTitle(title: String!, message: String) {
                    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
                    let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
                        if title=="ERROR"{
                            print("error!")
                        }
                    });
                    alert.addAction(action)
                    self.present(alert, animated: true, completion:nil)
                }
                alertWithTitle(title: "Reset Information", message: "success!")
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
