//
//  PickFavVC.swift
//  App Project 3
//
//  Created by Wade on 12/5/18.
//  Copyright © 2018 Wade Murdock. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

struct moves_struct : Decodable {
    let moves: [individual_move]?
}
struct individual_move : Decodable {
    let name: String?
}
var myIndex = 0


class PickFavVC: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var possibleFavsArray = [individual_move]()
    
    @IBOutlet weak var AllTbl: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Background
        let backgroundImage = UIImageView(frame: UIScreen.main.bounds)
        if self.subType == "normal" {
            backgroundImage.image = UIImage(named: "\(self.subType)_bg.jpg")
        }
        else{
            backgroundImage.image = UIImage(named: "batch_batch_\(self.subType)_bg.jpg")
        }
        backgroundImage.contentMode = UIViewContentMode.scaleAspectFill
        view.insertSubview(backgroundImage, at: 0)
        
        
        getDataFromAPI()
        self.AllTbl.delegate = self
        self.navigationItem.title = title
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancel))
        //   self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: makeBackButton())
        AllTbl?.dataSource = self
        
    }
    
    @objc func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    var subType = ""
    var pi_ip = ""
    func getDataFromAPI() {
        let jsonUrlString = "https://pokeapi.co/api/v2/type/\(subType)/"
        print(jsonUrlString)
        self.title = "Add " + subType.capitalized + " Favorite"
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            guard let data = data else { return }
            
            do {
                let add_fav = try JSONDecoder().decode(moves_struct.self, from: data)
                let moves_array = add_fav.moves?.compactMap({ $0.name?.capitalized }) ?? ["Bad data"]
                
                self.possibleFavsArray = moves_array.map {  individual_move(name: $0) }
                DispatchQueue.main.async {
                    self.AllTbl.reloadData()
                }
                
            }catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return possibleFavsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MoveCell") as? MoveCell else { return UITableViewCell() }
        
        tableView.backgroundColor = .clear
        cell.backgroundColor = .clear
        tableView.tableFooterView = UIView()
        
        cell.MoveCell_label.text = possibleFavsArray[indexPath.row].name?.capitalized
        cell.MoveCell_label.text = correctMoveName(not_corrected: cell.MoveCell_label.text)
        
        return cell
    }
    
    func correctMoveName(not_corrected: String?) -> String?{
        var corrected = not_corrected
        corrected = corrected?.replacingOccurrences(of: "10-000-000", with: "10,000,000")
        corrected = corrected?.replacingOccurrences(of: "10-000-000", with: "10,000,000")
        corrected = corrected?.replacingOccurrences(of: "-", with: " ")
        corrected = corrected?.replacingOccurrences(of: "  Physical", with: " (Physical)")
        corrected = corrected?.replacingOccurrences(of: "  Special", with: " (Special)")
        corrected = corrected?.replacingOccurrences(of: "Roar Of Time", with: "Roar of Time")
        corrected = corrected?.replacingOccurrences(of: "Light Of Ruin", with: "Light of Ruin")
        corrected = corrected?.replacingOccurrences(of: "  Special", with: " (Special)")
        corrected = corrected?.replacingOccurrences(of: "Guardian Of Alola", with: "Guardian of Alola")
        corrected = corrected?.replacingOccurrences(of: "Double Edge", with: "Double-Edge")
        corrected = corrected?.replacingOccurrences(of: "Self Destruct", with: "Self-Destruct")
        corrected = corrected?.replacingOccurrences(of: "Soft Boiled", with: "Soft-Boiled")
        corrected = corrected?.replacingOccurrences(of: "Mud Slap", with: "Mud-Slap")
        corrected = corrected?.replacingOccurrences(of: "Lock On", with: "Lock-On")
        corrected = corrected?.replacingOccurrences(of: "Will O Wisp", with: "Will-O-Wisp")
        corrected = corrected?.replacingOccurrences(of: "Wake Up Slap", with: "Wake-Up Slap")
        corrected = corrected?.replacingOccurrences(of: "U Turn", with: "U-turn")
        corrected = corrected?.replacingOccurrences(of: "X Scissor", with: "X-Scissor")
        corrected = corrected?.replacingOccurrences(of: "V Create", with: "V-create")
        corrected = corrected?.replacingOccurrences(of: "Trick Or Treat", with: "Trick-or-Treat")
        corrected = corrected?.replacingOccurrences(of: "Freeze Dry", with: "Freeze-Dry")
        corrected = corrected?.replacingOccurrences(of: "Double Edge", with: "Double-Edge")
        corrected = corrected?.replacingOccurrences(of: "Topsy Turvy", with: "Topsy-Turvy")
        corrected = corrected?.replacingOccurrences(of: "Baby Doll Eyes", with: "Baby-Doll Eyes")
        corrected = corrected?.replacingOccurrences(of: "Power Up Punch", with: "Power-Up Punch")
        corrected = corrected?.replacingOccurrences(of: "All Out Pummeling", with: "All-Out Pummeling")
        corrected = corrected?.replacingOccurrences(of: "Savage Spin Out", with: "Savage Spin-Out")
        corrected = corrected?.replacingOccurrences(of: "Never Ending Nightmare", with: "Never-Ending Nightmare")
        corrected = corrected?.replacingOccurrences(of: "Soul Stealing 7 Star Strike", with: "Soul-Stealing 7-Star Strike")
        corrected = corrected?.replacingOccurrences(of: "Multi Attack", with: "Multi-Attack")
        
        return corrected
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        var response_string = ""
        myIndex = indexPath.row
        let alertController = UIAlertController(title: "HTTP POST Credentials", message: "Enter the required credentials for making an HTTP POST request.", preferredStyle: UIAlertControllerStyle.alert)
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
            let move_name = self.correctMoveName(not_corrected: self.possibleFavsArray[indexPath.row].name)
            let params = ["Name": move_name, "Poketype": self.subType]
            let headers = ["Content-Type": "application/json"]
            print("PickFavVC pi_ip: " + self.pi_ip)
            Alamofire.request("http://\(self.pi_ip):5000/favs", method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers).authenticate(user: username, password: pw).responseJSON { response in
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
                if response_string != "Unauthorized Access" && response_string != "Entry Already Exists"{
                    self.presentingViewController?.dismiss(animated: true, completion: nil)
                }
                else if response_string == "Unauthorized Access"{
                    tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.none)
                    tableView.delegate!.tableView!(tableView, didSelectRowAt: indexPath)
                }
                else if response_string == "Entry Already Exists"{
                    let alreadyExistsAlert = UIAlertController(title: "Entry Already Exists", message: "\n\"" + self.correctMoveName(not_corrected: self.possibleFavsArray[indexPath.row].name)! + "\" already exists in the table\n\"\(self.subType.capitalized) Favorites\"", preferredStyle: UIAlertControllerStyle.alert)
                    let dismissAction = UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
                        print("Dismiss")
                    }
                    alreadyExistsAlert.addAction(dismissAction)
                    self.present(alreadyExistsAlert, animated: true, completion: nil)
                }
            }
        }
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func makeBackButton() -> UIButton {
        let backButtonImage = UIImage(named: "backbutton")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIButton(type: .custom)
        backButton.setImage(backButtonImage, for: .normal)
        backButton.tintColor = .blue
        backButton.setTitle("  Back", for: .normal)
        backButton.setTitleColor(.blue, for: .normal)
        backButton.addTarget(self, action: #selector(self.backButtonPressed), for: .touchUpInside)
        return backButton
    }
    
    
    @objc func backButtonPressed() {
        dismiss(animated: true, completion: nil)
        //        navigationController?.popViewController(animated: true)
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
