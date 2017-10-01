//
//  GameConfigController.swift
//  NumbersInTime
//
//  Created by miro on 22.04.17.
//  Copyright © 2017 Miroslav Juric. All rights reserved.
//

import UIKit

class GameConfigController: UITableViewController {

    let logoutNotification = Notification.Name.init(rawValue: "logoutAction")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(GameConfigController.logut),
                                               name: logoutNotification,
                                               object: nil)
        
        
    }
 
   @objc func logut() {
       
        do {
            try Game.sharedInstance.logout()
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            let startViewController = storyBoard.instantiateViewController(withIdentifier: "StartController") as! StartController
            self.present(startViewController, animated:true, completion:nil)            
            
        } catch  {
            
                let alert = UIAlertController(title: "Error", message: "Logout failed", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "ok", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
        }
                    
    }
      
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 5
    }
    
   
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0:
            let cell : HeaderCell = tableView.dequeueReusableCell(withIdentifier:"headerCell", for: indexPath) as! HeaderCell
            
            cell.playerName.text = Game.sharedInstance.userEmail
            return cell
            
        case 1:
            let cell : UserResultCell = tableView.dequeueReusableCell(withIdentifier:"userResultCell", for: indexPath) as! UserResultCell
            
           
            return cell

            
        default:
            return UITableViewCell()
        }
        
     }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0:
            return CGFloat(200)            
        case 1:
            return CGFloat(100)
        default:
            return CGFloat(50)
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
