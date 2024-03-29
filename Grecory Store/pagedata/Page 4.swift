//
//  Page 4.swift
//  Grecory Store
//
//  Created by Sunchai Trabdee on 18/11/2565 BE.
//

import UIKit
import GRDB
import ViewAnimator

class Page_4: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var groName:String = ""
    var Namegro = [String]()
    var groImage = [String]()
    var groLink : [String] = []
    var groVideo : [String] = []
    
    var dbPath : String = ""
    var dbResourcePath : String = ""
    var config = Configuration()
    let fileManager = FileManager.default
    
    let groPaint:[UIColor] = [.orange, .magenta, .systemGreen, .purple, .red, .systemMint, .brown, .gray, .black, .systemYellow]
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return Namegro.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        cell.transform = CGAffineTransform(translationX: 0, y: cell.contentView.frame.height)
        
                UIView.animate(
                    withDuration: 0.5,
                    delay: 0.5 * Double(indexPath.row),
                    usingSpringWithDamping: 0.5,
                    initialSpringVelocity: 0.1,
                    options: [.curveEaseInOut],
                    animations: {
                        cell.alpha = 1
                        cell.transform = CGAffineTransform(translationX: 0, y: 0)
                })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showinfor", for: indexPath) as! Cell_2
        
        cell.inforimg.image = UIImage.init(named: groImage[indexPath.row])
        cell.infortext.text = Namegro[indexPath.row]
        cell.infortext.textColor = groPaint[indexPath.row]
        cell.backgroundColor = UIColor.systemGray6
        
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        connect2DB()
        readdbArticle()
        
        self.tableView.rowHeight = 175

        print(groName)
        print(groImage)
        
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

            try dbQueue.inDatabase { db in
                
                let rows = try Row.fetchCursor(db, sql: "select History, Benefit from infor")
                while let row = try rows.next() {
                    groLink.append(row["History"])
                    groVideo.append(row["Benefit"])
                }
            }
        } catch {
            print(error.localizedDescription)
           }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        let rowData = self.tableView.indexPathForSelectedRow?.row
        
        if segue.identifier == "information" {
            let store = segue.destination as! Page_4_Extra
            store.grocery1 = groLink[rowData!]
            store.grocery2 = groVideo[rowData!]
            store.allofhistory = self.Namegro
            store.historyrow = rowData!
        }
    }
}
