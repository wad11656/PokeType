//
//  ViewController.swift
//  App Project 3
//
//  Created by Wade on 9/30/18.
//  Copyright © 2018 Wade Murdock. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    final let url = URL(string: "https://pokeapi.co/api/v2/type/")
    private var results = [Movetype]()
    @IBOutlet var tableView: UITableView!
    static var sequeIdentifiers = ["Normal", "Fighting", "Flying", "Poison", "Ground", "Rock", "Bug", "Ghost", "Steel", "Fire", "Water", "Grass", "Electric", "Psychic", "Ice", "Dragon", "Dark", "Fairy", "Unknown", "Shadow"]
    
    var pi_ip = "192.168.159.225"
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "IP", style:
            UIBarButtonItemStyle.plain, target: self, action:
            #selector(showIPAlert))
        
        
        downloadJson()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let selectionIndexPath = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectionIndexPath, animated: false)
        }
    }
    
    @objc func showIPAlert(){
        let ipAlert = UIAlertController(title: "Enter Raspberry Pi IP Address", message: "\nCurrent IP: " + pi_ip, preferredStyle: UIAlertControllerStyle.alert)
        ipAlert.addTextField { (textField : UITextField) -> Void in
            textField.placeholder = "IP Address"
        }
        
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default) { (result : UIAlertAction) -> Void in
            if(ipAlert.textFields?.first?.text != ""){
                self.pi_ip = ipAlert.textFields?.first?.text as! String
            }
            print("ViewController pi_ip: " + self.pi_ip)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (result : UIAlertAction) -> Void in
            print("Cancel")
        }
        ipAlert.addAction(cancelAction)
        ipAlert.addAction(okAction)
        self.present(ipAlert, animated: true, completion: nil)
        
    }

    func downloadJson() {
        guard let downloadURL = url else { return }
        
        URLSession.shared.dataTask(with: downloadURL) { data, urlResponse, error in
            guard let data = data, error == nil, urlResponse != nil else {
                print("something is wrong")
                return
            }
            print("downloaded")
            do
            {
                let decoder = JSONDecoder()
                let downloaded_movetypes = try decoder.decode(Results.self, from: data)
                self.results = downloaded_movetypes.results
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            } catch {
                print("something wrong after downloaded")
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return results.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovetypeCell") as? MovetypeCell else { return UITableViewCell() }
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.init(red: 195.0/255.0, green: 253.0/255.0, blue: 198.0/255.0, alpha: 1)
        cell.selectedBackgroundView = backgroundView
        
        cell.Name_Label.text = results[indexPath.row].name.capitalized
        
        let img_name = ViewController.sequeIdentifiers[indexPath.row].lowercased() + ".png"
        
        print(img_name)
        
        cell.Img_View.image = UIImage(named: img_name)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //performSegue(withIdentifier: sequeIdentifiers[indexPath.row], sender: self)
        let detailVc = self.storyboard?.instantiateViewController(withIdentifier: "Fighting")  as! Fighting
        detailVc.pi_ip = pi_ip
        detailVc.subType = ViewController.sequeIdentifiers[indexPath.row].lowercased()
        self.navigationController?.pushViewController(detailVc, animated: true)
    }
    
    
    
}

@IBDesignable extension UIButton {
    
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable var cornerRadius: CGFloat {
        set {
            layer.cornerRadius = newValue
        }
        get {
            return layer.cornerRadius
        }
    }
    
    @IBInspectable var borderColor: UIColor? {
        set {
            guard let uiColor = newValue else { return }
            layer.borderColor = uiColor.cgColor
        }
        get {
            guard let color = layer.borderColor else { return nil }
            return UIColor(cgColor: color)
        }
    }
}


