//
//  SignUp.swift
//  Grecory Store
//
//  Created by Sunchai Trabdee on 09/11/2022.
//

import UIKit
import GRDB

class SignUp: UIViewController {
    
    var dbPath : String = ""
    var dbResourcePath : String = ""
    var config = Configuration()
    let fileManager = FileManager.default
    
    @IBOutlet weak var txtnameUser: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtpass: UITextField!
    @IBOutlet weak var txtRePass: UITextField!
    @IBOutlet weak var txtCode: UITextField!
    
    @objc func tap(sender: UITapGestureRecognizer){
        print("tapped")
        view.endEditing(true)
    }
    
    @IBAction func textEmail(_ sender: Any) {
        if (txtEmail.text?.isValidEmail())! == false{
            alertWithTitle(title: "EMAIL ERROR!", message: "Please enter a valid email address")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
        connect2DB()
        readDB4memberID()
    }
    
    func alertWithTitle(title: String!, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
            if title=="EMAIL ERROR!"{
                self.txtEmail.becomeFirstResponder()
            }
            else if title=="MEMID ERROR!"{
                self.txtCode.becomeFirstResponder()
            }
            else if title=="MEMNAME ERROR!"{
                self.txtnameUser.becomeFirstResponder()
            }
            else if title=="PASSWORD ERROR!"{
                self.txtpass.becomeFirstResponder()
            }
            else if title=="REPASSWORD ERROR!"{
                self.txtRePass.becomeFirstResponder()
            }
            else{
                print("An error has occured")
            }
        });
        alert.addAction(action)
        self.present(alert, animated: true, completion:nil)
    }
    
    @IBAction func ConPass(_ sender: Any) {
        if txtpass.text != txtRePass.text{
            alertWithTitle(title: "REPASSWORD ERROR!", message: "Passwords do not match")
        }
    }
    
    func checkTextfieldisEmpty(){
        if txtnameUser.text!.isEmpty {
            alertWithTitle(title: "PROGRESS ERROR!", message: "Please fill in Username")
        }
        else if txtpass.text!.isEmpty {
            alertWithTitle(title: "PROGRESS ERROR!", message: "Please fill in Password")
        }
        else if txtRePass.text!.isEmpty {
            alertWithTitle(title: "PROGRESS ERROR!", message: "Please fill in Repassword")
        }
        else if txtEmail.text!.isEmpty {
            alertWithTitle(title: "PROGRESS ERROR!", message: "Please fill in Email")
        }
    }
    
    @IBAction func BTN_SignIn(_ sender: Any) {
        checkTextfieldisEmpty()
        let memid:Int = Int(txtCode.text!)!
        
        do {
            config.readonly=false
            let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)
            
            try dbQueue.write {
                db in
                try db.execute(sql: "INSERT INTO register (member_id, member_name, mem_passw, email, active) VALUES (?, ?, ?, ?, ?)",
                               arguments: [memid, txtnameUser.text, txtpass.text, txtEmail.text, 1])
            } //try dbQueue.write
            
            try dbQueue.write {
                db in
                
                try db.execute(sql: "update masterctrl set member_id = (?)",
                               arguments: [memid+1])
            } //try dbQueue.write
            
            if txtpass.text != txtRePass.text{
                alertWithTitle(title: "REPASSWORD ERROR!", message: "Passwords do not match")
            }else{
                alertWithTitle(title: "Registration Information", message: "saved successfully")
            }
        } catch {
                print(error.localizedDescription)
            }
        }

    func readDB4memberID(){
        do {
            //อันนี้คือตัวแสดงลำดับเลขสมาชิกในหน้า Sign-up โดยการอ่านข้อมูลใน Table ที่ชื่อว่า masterctrl จากนั้นก็ให้เลือกอ่าน column ที่ชื่อ member_id เพื่อดึงข้อมูลออกมา
            
        let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)
            try dbQueue.inDatabase { db in
                let rows = try Int.fetchOne(db, sql:
                "SELECT member_id FROM masterctrl")
                txtCode.text=rows?.description
            }
        } catch {

            print(error.localizedDescription)
           }
    }

    //ในส่วนนี้เป็นการเข้าถึงตัว database
    func connect2DB(){
      config.readonly = true

      do{
       dbPath = try fileManager
          .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
          .appendingPathComponent("account_GRDB.sqlite")
          .path
          if !fileManager.fileExists(atPath: dbPath) {
              dbResourcePath = Bundle.main.path(forResource: "account_GRDB", ofType: "sqlite")!
              try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
          }
      }catch{
          print("An error has occured")
      }
    }
    
    @IBAction func Resetbtn(_ sender: Any) {
        txtnameUser.text? = ""
        txtEmail.text? = ""
        txtpass.text? = ""
        txtRePass.text? = ""
        
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
    extension String {
        func isValidEmail() -> Bool {
            // here, `try!` will always succeed because the pattern is valid
            let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
        }
    }
