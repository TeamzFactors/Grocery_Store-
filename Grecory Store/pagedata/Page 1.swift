//
//  Page 1.swift
//  Grecory Store
//
//  Created by Sunchai Trabdee on 18/11/2565 BE.
//

import UIKit
import GRDB
import ViewAnimator

class Page_1: UIViewController {
    
    var dbPath : String = ""
    var dbResourcePath : String = ""
    var config = Configuration()
    let fileManager = FileManager.default
    
    @IBOutlet weak var CodePd: UITextField!
    @IBOutlet weak var TypePd: UITextField!
    @IBOutlet weak var NamePd: UITextField!
    @IBOutlet weak var PricePd: UITextField!
    @IBOutlet weak var PiecePd: UITextField!
    
    @IBOutlet weak var add1: UIButton!
    @IBOutlet weak var reset1: UIButton!
    @IBOutlet weak var p2: UIButton!
    @IBOutlet weak var p3: UIButton!
    
    @objc func tap(sender: UITapGestureRecognizer){
            print("tapped")
            view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
        connect2DB()
        
        add1.titleLabel?.font =  UIFont(name: "Lulu", size: 20)
        reset1.titleLabel?.font =  UIFont(name: "Lulu", size: 20)
        p2.titleLabel?.font =  UIFont(name: "benjamin", size: 20)
        p3.titleLabel?.font =  UIFont(name: "benjamin", size: 20)
        
        let animation = AnimationType.from(direction: .left, offset: 200.0)
        view.animate(animations: [animation])
    }
    
    @IBAction func Addbtn(_ sender: UIButton) {
        checkTextfieldisEmpty()
        
        do {
            config.readonly=false
            let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)
            
            try dbQueue.write {
                db in
                try db.execute(sql: "INSERT INTO Product (Product_Id, Product_type,Product_name,Product_price,Product_piece) VALUES (?, ?, ?, ?, ?)",arguments: [CodePd.text,TypePd.text,NamePd.text,PricePd.text,PiecePd.text])
            }
        } catch {
            print(error.localizedDescription)
           }
        
        func checkTextfieldisEmpty(){
            if CodePd.text!.isEmpty {
                alertWithTitle(title: "PROCESS ERROR!", message: "Please fill in Product Code")
            }
            else if TypePd.text!.isEmpty {
                alertWithTitle(title: "PROCESS ERROR!", message: "Please fill in Product Type")
            }
            else if NamePd.text!.isEmpty {
                alertWithTitle(title: "PROCESS ERROR!", message: "Please fill in Product Name")
            }
            else if PricePd.text!.isEmpty {
                alertWithTitle(title: "PROCESS ERROR!", message: "Please fill in Product Price")
            }
            else if PiecePd.text!.isEmpty {
                alertWithTitle(title: "PROCESS ERROR!", message: "Please fill in Quantity to be added")
            }
        }
        
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
                alertWithTitle(title: "Added to Storage", message: "success!")
        
        sender.forbtnbig {
            print("")
        }
    }
    
    func connect2DB(){
         config.readonly = true

         do{
          dbPath = try fileManager
             .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
             .appendingPathComponent("Store.sqlite")
             .path
             if !fileManager.fileExists(atPath: dbPath) {
                 dbResourcePath = Bundle.main.path(forResource: "Store", ofType: "sqlite")!
                 try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
             }
         }catch{
             print("An error has occured")
         }
       }
    
    @IBAction func BTNrelist(_ sender: UIButton) {
        CodePd.text? = ""
        TypePd.text? = ""
        NamePd.text? = ""
        PricePd.text? = ""
        PiecePd.text? = ""
        
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

    @IBAction func btnlist(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "Showlist") as? Page_2
        self.navigationController?.pushViewController(vc!, animated: true)
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
