//
//  Login.swift
//  Grecory Store
//
//  Created by Sunchai Trabdee on 09/11/2022.
//

import UIKit
import GRDB
import SnapKit
import Firebase
import GoogleSignIn

class Login: UIViewController {
    
    var dbPath : String = ""
    var dbResourcePath : String = ""
    var config = Configuration()
    let fileManager = FileManager.default
    //ใช้เก็บค่า Session พิเศษ รับค่าเป็น Array user
    var defaults = UserDefaults.standard
    var user:[String]=[]
    
    @IBOutlet weak var txtCode: UITextField!
    @IBOutlet weak var txtpass: UITextField!
    @IBOutlet weak var First: UIImageView!
    @IBOutlet weak var Second: UIImageView!
    @IBOutlet weak var Third: UIImageView!
    
    //ตกแต่ง font สำหรับปุ่ม login และปุ่ม sign up
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    
    //กำหนด วัน/เดือน/ปี ในรูปแบบ Date Picker โดยใช้ Textfield
    @IBOutlet weak var setDater: UITextField!
    
    @objc func tap(sender: UITapGestureRecognizer){
            print("tapped")
            view.endEditing(true)
    }
    
    @IBAction func btnLogin(_ sender: Any) {
        checkTextfieldisEmpty()
        readDB4memberID(memid: Int(txtCode.text!)!, mempass: txtpass.text!)
        
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
                alertWithTitle(title: "Can't Login!", message: "User ID or Password isn't right")
    }
    
    func checkTextfieldisEmpty(){
        if txtpass.text!.isEmpty {
            alertWithTitle(title: "PROGRESS ERROR!", message: "Please fill in Password")
        }
    }
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string.rangeOfCharacter(from: NSCharacterSet.decimalDigits) != nil {
           return true
        } else {
           return false
        }
    }
    
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
    
    func alertWithTitle(title: String!, message: String) {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel,handler: {_ in
                if title=="ERROR"{
                    self.txtpass.becomeFirstResponder()
                }
            });
            alert.addAction(action)
            self.present(alert, animated: true, completion:nil)
        }
    
    func readDB4memberID(memid:Int,mempass:String){
        do {

        let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)
            try dbQueue.inDatabase { db in

                //Select all data from the table named tablename residing in SQLite
                //เลือกตัวฟิลที่ชื่อ member_id,member_name,mem_passw จาก table ที่ชื่อ register ซึ่งภายในต้องมีค่าอยู่ 1 ค่า ที่มีactive=1

               let rows = try Row.fetchCursor(db, sql: "SELECT member_id,member_name,mem_passw FROM register where active=1 and member_id = (?) and mem_passw = (?)",
               arguments: [memid,mempass])

                while let row = try rows.next() {
                     if memid == row["member_id"] &&
                            mempass == row["mem_passw"] {
                        //Goto N1
                        alertWithTitle(title: "Register Complete", message: "sign-in success")
                        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                        let mvc = storyBoard.instantiateViewController(identifier: "BeforeMenu") as! N1
                        user.append(row["member_id"])
                        user.append(row["member_name"])
                        user.append(row["mem_passw"])
                        defaults.set(user, forKey: "savedUser")

                        self.view.window?.rootViewController = mvc
                    }
                    else if memid == row["member_id"] &&
                    mempass != row["mem_passw"] {
                            alertWithTitle(title: "ERROR!", message: "WRONG PASSWORD")
                        }
                     else{
                        alertWithTitle(title: "ERROR!", message: "WRONG USER ID")
                    }
                }
            }
        } catch {
            print(error.localizedDescription)
           }
    }
    
    lazy var box1 = UIView()
    lazy var box2 = UIView()
    
    let datePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap)))
        
        connect2DB()
        readDB4memberID(memid: 0, mempass: "")
        
        createDatePicker() //ฟังก์ชั่นในการสร้างตัววันที่
        //กำหนด textfiled ที่ชื่อ setDater แสดงตัวข้อมูลวันที่
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        setDater.text = formatter.string(from: date)
        setDater.textColor = .blue
        //ตกแต่งปุ่ม
        button1.titleLabel?.font =  UIFont(name: "Mitr-Medium", size: 22)
        view.addSubview(button1)
        button2.titleLabel?.font =  UIFont(name: "Mitr-Regular", size: 18)
        view.addSubview(button2)
        
        self.view.addSubview(box1)
        box1.backgroundColor = .green
        box1.snp.makeConstraints { (make) -> Void in
        make.height.equalTo(75)
        make.width.equalTo(400)
        make.top.equalTo(self.view)
    }
        
        self.view.addSubview(box2)
        box2.backgroundColor = .green
        box2.snp.makeConstraints { (make) -> Void in
        make.height.equalTo(20)
        make.width.equalTo(400)
        make.bottom.equalTo(self.view)
    }
        //ส่วนนี้คือส่วนที่ทำให้รูปภาพขยับแบบ Gif โดยเรียกใช้ฟังก์ชั่น gifImageWithName ที่อยู่ใน ImageGif
        let cartGif = UIImage.gifImageWithName("cart")
        First.image = cartGif
        
        let saleGif = UIImage.gifImageWithName("sale")
        Second.image = saleGif
        Second.layer.cornerRadius = Second.frame.size.width / 2
        Second.clipsToBounds = true
        
        let runGif = UIImage.gifImageWithName("run")
        Third.image = runGif
    }
    //ตกแต่งตัว toolbar ตรงที่แสดงวันที่
    func createToolbar() -> UIToolbar{
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let btnDone = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(PressbtnDone))
        toolbar.setItems([btnDone], animated: true)
        
        return toolbar
    }
    //ฟังก์ชั่นในการสร้างตัววันที่
    func createDatePicker(){
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        setDater.inputView = datePicker
        setDater.inputAccessoryView = createToolbar()
    }
    
    @objc func PressbtnDone(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        
        self.setDater.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    //ปุ่ม google sign in
    @IBAction func btngoogle(_ sender: Any) {
        googleSignIn()
    }
    func googleSignIn(){
           guard let clientID = FirebaseApp.app()?.options.clientID else { return }
           
           // Create Google Sign In configuration object.
           let config = GIDConfiguration(clientID: clientID)
        
           // Start the sign in flow!
           GIDSignIn.sharedInstance.signIn(with: config, presenting: (UIApplication.shared.windows.first?.rootViewController)!) { user, error in

             if let error = error {
               print(error.localizedDescription)
               return
             }

             guard
               let authentication = user?.authentication,
               let idToken = authentication.idToken
             else {
               return
             }

               let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                               accessToken: authentication.accessToken)

               // Authenticate with Firebase using the credential object
               Auth.auth().signIn(with: credential) { (authResult, error) in
                   if let error = error {
                       print("authentication error \(error.localizedDescription)")
                       return
                   }
                   print(authResult ?? "none")
               }
           }
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
