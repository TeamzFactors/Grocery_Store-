//
//  Page 2.swift
//  Grecory Store
//
//  Created by Sunchai Trabdee on 18/11/2565 BE.
//

import UIKit
import GRDB
import ViewAnimator

class Page_2: UITableViewController, UISearchBarDelegate {
    
    var dbPath : String = ""
    var dbResourcePath : String = ""
    var config = Configuration()
    let fileManager = FileManager.default
    
    var pdid:[String]=[]
    var pdtype:[String]=[]
    var pdname:[String]=[]
    var pdprice:[String]=[]
    var pdpiece:[String]=[]
    var find: [String]!
    
    @IBOutlet weak var SearchBar1: UISearchBar!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = 70
        let animation = AnimationType.from(direction: .left, offset: 200.0)
        view.animate(animations: [animation])
        
        connect2DB()
        readDBProduct()
        
        find = pdname
        
        SearchBar1.delegate = self
    }
    
    func readDBProduct(){
        do {
            
            let dbQueue = try DatabaseQueue(path: dbPath, configuration: config)
            
            try dbQueue.inDatabase { db in
                
                let rows = try Row.fetchCursor(db, sql: "SELECT Product_Id, Product_type, Product_name, Product_price, Product_piece FROM Product")
                //เอาข้อมูลจาก database ลงในตัวแปรที่สร้างไว้
                while let row = try rows.next() {
                    pdid.append(row["Product_Id"])
                    pdtype.append(row["Product_type"])
                    pdname.append(row["Product_name"])
                    pdprice.append(row["Product_price"])
                    pdpiece.append(row["Product_piece"])
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return find.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "showproduct", for: indexPath) as! Cell
        
        cell.nameshow.text = find[indexPath.row]
        
        if indexPath.row % 2 == 0 {
            cell.backgroundColor = UIColor.systemYellow
        }
        else{
            cell.backgroundColor = UIColor.systemCyan
        }
        
        return cell
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        find = []
        
        if searchText == "" {
            find = pdname
        }
        for product in pdname{
            if product.lowercased().contains(searchText.lowercased()){
                find.append(product)
            }
        }
        self.tableView.reloadData()
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    //ส่งข้อมูลผ่านทาง segue ไปยังหน้า Page_2_Extra
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let rowData = self.tableView.indexPathForSelectedRow?.row
        
        if segue.identifier == "datatoQr"{
            let send = segue.destination as! Page_2_Extra
            send.qrId = pdid
            send.qrtype = pdtype
            send.qrname = pdname
            send.qrprice = pdprice
            send.qrpiece = pdpiece
            send.counts = rowData!
        }
    }
}
