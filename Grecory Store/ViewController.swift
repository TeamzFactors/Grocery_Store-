//
//  ViewController.swift
//  Grecory Store
//
//  Created by Sunchai Trabdee on 09/11/2022.
//

import UIKit
import GRDB
import AVFoundation
import ViewAnimator

class ViewController: UIViewController {
    
    var review = [String:[String]]()
    var artiImg = [String]()
    
    var dbPath : String = ""
    var dbResourcePath : String = ""
    var config = Configuration()
    let fileManager = FileManager.default
    
    @IBOutlet weak var ImgShow: UIImageView!
    @IBOutlet weak var switchView: UIView!
    @IBOutlet weak var label1: UILabel!
    
    @IBAction func SoundOnOff(_ sender: Any) {
        if player.isPlaying {
                player.pause()
            } else {
                player.play()
                player.numberOfLoops = -1
            }
    }
    
    @IBAction func btnback(_ sender: Any) {
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let log = storyBoard.instantiateViewController(identifier: "login") as! Login
        self.present(log, animated: true, completion: nil)
    }
    //เปลี่ยนสีพื้นหลัง
    @IBAction func BGColor(_ sender: Any) {
        let sw:UISwitch = sender as! UISwitch
        if sw.isOn == true {
            switchView.backgroundColor = UIColor.systemOrange
        }
        else {
            switchView.backgroundColor = UIColor.black
        }
    }

    var player:AVAudioPlayer = AVAudioPlayer()
    var pictureshow = ["Store.png", "ผัก.jpg", "ผลไม้.jpg", "เนื้อ.jpg", "น้ำอัดลม.jpg"]
    var images = [UIImage]()
    
    var userName:[String]=[]
    //เรียกใช้จากค่า Session ต้องประกาศใช้ก่อนทุกครั้ง
    var defaults = UserDefaults.standard
    @IBOutlet weak var WelUser: UILabel!
    //ปุ่มไปหน้าแนะนำรายการสินค้า
    @IBAction func btnToP4(_ sender: Any) {
        let storyBoard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let arti = storyBoard.instantiateViewController(identifier: "Facts") as! Page_4
        arti.groName = "AllType"
        arti.Namegro = review["AllType"]!
        arti.groImage = artiImg
        self.present(arti, animated: true, completion: nil)
    }
    
    func connect2DB(){
             config.readonly = true

             do{
              dbPath = try fileManager
                 .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                 .appendingPathComponent("Statistic.sqlite")
                 .path
                 if !fileManager.fileExists(atPath: dbPath) {
                     dbResourcePath = Bundle.main.path(forResource: "Statistic", ofType: "sqlite")!
                     try fileManager.copyItem(atPath: dbResourcePath, toPath: dbPath)
                 }
             }catch{
                 print("An error has occured")
             }
           }
    
    func readdbArticle(){
        do {

        let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)
            var shop = [String]()
            
            try dbQueue.inDatabase { db in
                let row1 = try Row.fetchCursor(db, sql: "SELECT Type FROM infor")
                while let row = try row1.next() {
                    shop.append(row["Type"])
                    review.updateValue(shop, forKey: "AllType")
                }
            }
        } catch {
            print(error.localizedDescription)
           }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connect2DB()
        readdbArticle()
        
        artiImg = ["snack.jpeg", "drink.jpeg", "vegetable.jpeg", "fruit.jpeg", "meat.jpeg", "seafood.jpeg", "starchy.png", "legume.jpeg", "dairy.jpeg", "noodles.jpeg"]
        
        print(review)
        
        let animation = AnimationType.zoom(scale: 100)
        view.animate(animations: [animation])
        
        print(defaults.object(forKey: "savedUser") as! [String])
        //รับค่าจาก Session ไว้ในโครงสร้าง Array userName
        userName=defaults.object(forKey: "savedUser") as! [String]
        //ดึงเฉพาะตำแหน่งที่ 1 คือ member_name
        print(userName[1])
        WelUser.text="Welcome : "+userName[1]
        label1.font = UIFont(name: "benjamin", size: 20.0)
        
        //รูปภาพขยับเองอัตโนมัติ
        for k in 0..<pictureshow.count {
            images.append(UIImage(named: pictureshow[k])!)
        }
        ImgShow.animationImages = images
        ImgShow.animationDuration = 10.0
        ImgShow.startAnimating()
        
        //เล่น background music
        do {
            let audioPath = Bundle.main.path(forResource: "Reunited", ofType: "mp3")
            try player = AVAudioPlayer(contentsOf: NSURL(fileURLWithPath: audioPath!)as URL)
        }
        catch {
            //PROCESS ERROR
        }
        
        let session = AVAudioSession.sharedInstance()
        
        do {
            try session.setCategory(AVAudioSession.Category.playback)
        }
        catch {
            print("An error has occured")
        }
        
        player.play()
        player.numberOfLoops = -1
    }
}
