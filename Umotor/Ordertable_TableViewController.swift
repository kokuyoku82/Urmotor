//
//  Ordertable_TableViewController.swift
//  Umotor
//
//  Created by SIX on 2016/10/25.
//  Copyright © 2016年 SIX. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class Ordertable_TableViewController: UITableViewController {

    @IBOutlet weak var Button: UIBarButtonItem!
    var OrderList = [AnyObject]()
//    var CustommerPic = [AnyObject]()
    var loggedInUser: AnyObject?
    var OrderDict : NSDictionary?
    let databaseDriverOrderRef = FIRDatabase.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()

        if revealViewController() != nil{
            Button.target = revealViewController()
            Button.action = #selector(SWRevealViewController.revealToggle(_:))
            view.addGestureRecognizer(revealViewController().panGestureRecognizer())
        }// burger side bar menu
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
        self.databaseDriverOrderRef.child("Call_Moto").observe( .value, with: {(snapshot) in
            self.OrderList = [AnyObject]()
            self.OrderDict = snapshot.value as? NSDictionary
            for(UserID, orderdetails) in self.OrderDict!{
                print(UserID)
                print(orderdetails)
                if(self.loggedInUser?.uid != UserID as? String)
                {
                        let waittdetails = (orderdetails as AnyObject).object(forKey: "wait") as? NSDictionary
                    
                            for(_,CustomOrder) in waittdetails!{
                                
                                let UserCallpic = (CustomOrder as! NSDictionary).object(forKey: "callcaruser")
                                self.OrderList.append(CustomOrder as AnyObject)

                            }
                }
            self.tableView?.reloadData()
            }
            
        
        
        
        })
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.OrderList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order_List", for: indexPath) as! Order_TableViewCell
        let Star_point_value = self.OrderList[indexPath.row]["startpoint"] as? String
        let End_point_value = self.OrderList[indexPath.row]["endpoint"] as? String
        let User_picture = self.OrderList[indexPath.row]["picture"] as? String
        let imageURL = NSURL(string: User_picture!)
        let imageData = NSData(contentsOf: imageURL as! URL)
        let Time_point_value = self.OrderList[indexPath.row]["time"] as? Double
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date = NSDate(timeIntervalSince1970: Time_point_value!)
        cell.Custom_pic.image = UIImage(data: imageData! as Data)
        cell.Start_point.text = Star_point_value
        cell.Time_point.text = dateFormatter.string(from: date as Date)
        cell.End_point.text = End_point_value
        
        // Configure the cell...

        return cell
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        self.performSegue(withIdentifier: "Map_detail", sender: self.OrderList[indexPath.row])
//        let viewControllerMap = storyboard?.instantiateViewController(withIdentifier: "order")
//        self.navigationController?.pushViewController(viewControllerMap!, animated: true)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        super.prepare(for: segue, sender: sender)
        if segue.identifier == "Map_detail"{
            if let indxPath = tableView.indexPathForSelectedRow{
        let navVC = segue.destination as! Order_Map_LocationViewController
//        let chatVc = navVC.viewControllers.first as! Order_Map_LocationViewController
//        navVC.Start_latitude = "\((sender as? NSDictionary)?.object(forKey: "startlatitude") as AnyObject)" as AnyObject?// 3;
//        navVC.Start_longitude = (sender as? NSDictionary)?.object(forKey: "startlongitude") as AnyObject
//        navVC.End_latitude = (sender as? NSDictionary)?.object(forKey: "endlatitude") as AnyObject
//        navVC.End_longitude = (sender as? NSDictionary)?.object(forKey: "endlongitude") as AnyObject
//        navVC.regandata = sender as AnyObject?
                navVC.Start_latitude = self.OrderList[indxPath.row]["startlatitude"] as AnyObject?// 3;
                        navVC.Start_longitude = self.OrderList[indxPath.row]["startlongitude"] as AnyObject?
                        navVC.End_latitude = self.OrderList[indxPath.row]["endlatitude"] as AnyObject?
                        navVC.End_longitude = self.OrderList[indxPath.row]["endlongitude"] as AnyObject?
                        navVC.regandata = self.OrderList[indxPath.row] as AnyObject?

        }
        }
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
