//
//  Favorites.swift
//  App Project 3
//
//  Created by Wade on 12/3/18.
//  Copyright © 2018 Wade Murdock. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


struct favorites: Decodable {
    let Name:String?
    let Poketype:String?
    let id:Int?
}


/*{"Name":"Example","Poketype":"Normal","id":1}*/
class Favorites: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var tblFavorites:UITableView!
    
    var favoritesArray = [favorites]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        // Set Background
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        if self.subType == "normal" {
            backgroundImage.image = UIImage(named: "\(self.subType)_bg.jpg")
        }
        else{
            backgroundImage.image = UIImage(named: "batch_batch_\(self.subType)_bg.jpg")
        }
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        self.view.insertSubview(backgroundImage, at: 0)
        
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(openAddFavsView))
        self.navigationItem.rightBarButtonItem = addButton
        
        tblFavorites.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getDataFromAPI()
    }
    
    @objc func openAddFavsView() {
        //performSegue(withIdentifier: "ToAddFav", sender: UIBarButtonItem.self)
        let favsVC = self.storyboard?.instantiateViewController(withIdentifier: "PickFavVC") as! PickFavVC
        favsVC.subType = self.subType
        favsVC.pi_ip = self.pi_ip
        let nav = UINavigationController(rootViewController: favsVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    var subType = "" // Value passed in from Fighting.swift `override func prepare` (`vc.subType`)
    var pi_ip = ""
    func getDataFromAPI() {
        let jsonUrlString = "http://\(self.pi_ip):5000/favs?Poketype=\(subType)"
        print("Favorites pi_ip: " + pi_ip)
        print("Favorites jsonUrlString: " + jsonUrlString)
        self.title = subType.capitalized + " Favorites"
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            
            do {
                // Get fighting JSON data
                // let fighting_json = try JSONDecoder().decode(fighting.self, from: data)
                let fav = try JSONDecoder().decode([favorites].self, from: data)
                self.favoritesArray = fav
                print(self.favoritesArray)
                DispatchQueue.main.async {
                    self.tblFavorites.reloadData()
                }
                
            }catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
    }
    
    //MARK:- UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print(subType)
        var cell = tableView.dequeueReusableCell(withIdentifier: "favorites")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "favorites")
        }
        cell?.selectionStyle = .none
        
        tableView.backgroundColor = .clear
        cell?.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        
        let favorite = favoritesArray[indexPath.row]
        cell?.textLabel?.text = favorite.Name
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            myIndex = indexPath.row
            var response_string = ""
            let alertController = UIAlertController(title: "HTTP DELETE Credentials", message: "Enter the required credentials for making an HTTP DELETE request.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addTextField { (textField : UITextField) -> Void in
                textField.placeholder = "Username"
            }
            alertController.addTextField { (textField : UITextField) -> Void in
                textField.isSecureTextEntry = true
                textField.placeholder = "Password"
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                print("Cancel")
            }
            let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
                let username = alertController.textFields?.first?.text as! String
                let pw = alertController.textFields?[1].text as! String
                print(username)
                print(pw)
                let move_name = self.favoritesArray[indexPath.row].Name
                let params = ["Name": move_name as! String, "Poketype": self.subType as! String]
                let headers = ["Content-Type": "application/json"]
                Alamofire.request("http://\(self.pi_ip):5000/favs/delete", method: .delete, parameters: params).authenticate(user: username, password: pw).responseJSON { response in
                    debugPrint(response)
                    if response.data != nil {
                        do {
                            let json = try JSON(data: response.data!)
                            let name = json["Error"].string
                            if name != nil {
                                response_string = name!
                            }
                        }
                        catch let error as NSError{
                            //error
                        }
                    }
                    if response_string != "Unauthorized Access" && response_string != "Name not passed for deletion"{
                        self.tblFavorites.beginUpdates()
                        self.favoritesArray.remove(at: indexPath.row)
                        self.tblFavorites.deleteRows(at: [indexPath as IndexPath], with: .fade)
                        self.tblFavorites.endUpdates()
                    }
                    else if response_string == "Unauthorized Access"{
                        tableView.dataSource!.tableView!(tableView, commit: .delete, forRowAt: indexPath)
                    }
                }
                /*
                 if response_string != "Unauthorized Access"{
                 self.tblFavorites.beginUpdates()
                 self.favoritesArray.remove(at: indexPath.row)
                 self.tblFavorites.deleteRows(at: [indexPath as IndexPath], with: .fade)
                 self.tblFavorites.endUpdates()
                 }
                 */
            }
            alertController.addAction(cancelAction)
            alertController.addAction(okAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    /*
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     if  segue.destination is PickFavVC {
     if let vc = segue.destination as? PickFavVC {
     vc.subType = subType
     vc.pi_ip = self.pi_ip
     }
     }
     }
     */
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
