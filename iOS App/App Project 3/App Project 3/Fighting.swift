//
//  Fighting.swift
//  App Project 3
//
//  Created by Wade on 10/6/18.
//  Copyright © 2018 Wade Murdock. All rights reserved.
//

import Foundation
import UIKit

struct fighting : Decodable {
    let damage_relations: damage_relations_fighting?
}

struct damage_relations_fighting : Decodable {
    let double_damage_from: [double_damage_from_fighting]?
    let double_damage_to: [double_damage_to_fighting]?
    let half_damage_from: [half_damage_from_fighting]?
    let half_damage_to: [half_damage_to_fighting]?
    let no_damage_from: [no_damage_from_fighting]?
    let no_damage_to: [no_damage_to_fighting]?
}

struct double_damage_from_fighting : Decodable {
    let name: String?
}

struct double_damage_to_fighting : Decodable {
    let name: String?
}

struct half_damage_from_fighting : Decodable {
    let name: String?
}

struct half_damage_to_fighting : Decodable {
    let name: String?
}

struct no_damage_from_fighting : Decodable {
    let name: String?
}

struct no_damage_to_fighting : Decodable {
    let name: String?
}

//codementor codable
struct detailData : Decodable {
    let damage_relations: damageRelations?
}

struct damageRelations : Decodable {
      let double_damage_from: [doubleDamageFrom]?
}

struct doubleDamageFrom:Decodable {
    let name: String?
}



class Fighting: UIViewController {
    @IBOutlet var double_damage_from_fighting_Label: UILabel!
    @IBOutlet var double_damage_to_fighting_Label: UILabel!
    @IBOutlet var half_damage_from_fighting_Label: UILabel!
    @IBOutlet var half_damage_to_fighting_Label: UILabel!
    @IBOutlet var no_damage_from_fighting_Label: UILabel!
    @IBOutlet var no_damage_to_fighting_Label: UILabel!
    
    var subType = "" // Value passed in from ViewController.swift `func tableview` (`detailVc.subType`)
    var pi_ip = ""
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
        self.view.insertSubview(backgroundImage, at: 0)
        
        // Set Title
        self.title = subType.capitalized
        
        // Set Pokeapi URL variable
        let jsonUrlString = "https://pokeapi.co/api/v2/type/\(subType)/"
        guard let url = URL(string: jsonUrlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else { return }
            
            do {
                // Get fighting JSON data
                let fighting_json = try JSONDecoder().decode(fighting.self, from: data)
                let detail_json = try JSONDecoder().decode(detailData.self, from: data)
                
                print("Fighting pi_ip: " + self.pi_ip)

                // Create Array: Double Damage From
                let double_damage_from_fighting_array = fighting_json.damage_relations?.double_damage_from?.compactMap({ $0.name?.capitalized }) ?? ["Bad data"]
                
                // Create Array: Double Damage To
                let double_damage_to_fighting_array = fighting_json.damage_relations?.double_damage_to?.compactMap({ $0.name?.capitalized }) ?? ["Bad data"]
                
                // Create Array: Half Damage From
                let half_damage_from_fighting_array = fighting_json.damage_relations?.half_damage_from?.compactMap({ $0.name?.capitalized }) ?? ["Bad data"]
                
                // Create Array: Half Damage To
                let half_damage_to_fighting_array = fighting_json.damage_relations?.half_damage_to?.compactMap({ $0.name?.capitalized }) ?? ["Bad data"]
                
                // Create Array: No Damage From
                let no_damage_from_fighting_array = fighting_json.damage_relations?.no_damage_from?.compactMap({ $0.name?.capitalized }) ?? ["Bad data"]
                
                // Create Array: No Damage To
                let no_damage_to_fighting_array = fighting_json.damage_relations?.no_damage_to?.compactMap({ $0.name?.capitalized }) ?? ["Bad data"]
                
                DispatchQueue.main.async {
                    
                    // Print Label: Double Damage From
                    self.double_damage_from_fighting_Label.text = double_damage_from_fighting_array.joined(separator: ", ")
                    
                    // Print Label: Double Damage To
                    self.double_damage_to_fighting_Label.text = double_damage_to_fighting_array.joined(separator: ", ")
                    
                    // Print Label: Half Damage From
                    self.half_damage_from_fighting_Label.text = half_damage_from_fighting_array.joined(separator: ", ")
                    
                    // Print Label: Half Damage To
                    self.half_damage_to_fighting_Label.text = half_damage_to_fighting_array.joined(separator: ", ")
                    
                    // Print Label: No Damage From
                    self.no_damage_from_fighting_Label.text = no_damage_from_fighting_array.joined(separator: ", ")
                    
                    // Print Label: No Damage To
                    self.no_damage_to_fighting_Label.text = no_damage_to_fighting_array.joined(separator: ", ")
                    
                }
                
            } catch let jsonErr {
                print("Error serializing json:", jsonErr)
            }
            }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if  segue.destination is Favorites {
            if let vc = segue.destination as? Favorites {
                vc.subType = subType
                vc.pi_ip = pi_ip
            }
        }
    }
    
}
