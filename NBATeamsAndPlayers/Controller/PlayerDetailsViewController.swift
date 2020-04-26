//
//  PlayerDetailsViewController.swift
//  NBATeamsAndPlayers
//
//  Created by Silvia Silvestro on 25/04/2020.
//  Copyright © 2020 Silvia Silvestro. All rights reserved.
//

import UIKit

class PlayerDetailsViewController: UIViewController, UITableViewDelegate {
    
        // MARK: - Variables
    
    @IBOutlet weak var tableview: UITableView!
    var id = Int()
    var playerDetails: [String : AnyObject]?
    
        // MARK: - viewDidLoad()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableview.dataSource = self
        tableview.delegate = self
        sendRequest(id: self.id)
    }
    
        // MARK: - Function
    
    func sendRequest(id: Int) {
        let headers = [
            "x-rapidapi-host": "free-nba.p.rapidapi.com",
            "x-rapidapi-key": "4822149a1amsh10f1bc65148aeb3p1ad44cjsnc0b6b100c0af"
        ]
        
        let request = NSMutableURLRequest(url: NSURL(string: "https://free-nba.p.rapidapi.com/players/\(id)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            do {
                let str = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String: AnyObject]
                self.playerDetails = str
                DispatchQueue.main.async {
                    self.tableview.reloadData()
                    print(self.playerDetails?["id"] as? Int)
                }
            }
            catch {
                print("json error: \(error)")
            }
        })
        
        dataTask.resume()
    }
}

    // MARK: - Table View Extensions

extension PlayerDetailsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell3", for: indexPath)
        
        switch indexPath.row {
        case 0:
            cell.textLabel?.text = String(self.id)
        case 1:
            cell.textLabel?.text = (self.playerDetails?["last_name"]) as? String
        case 2:
            cell.textLabel?.text = (self.playerDetails?["first_name"]) as? String
        case 3:
            cell.textLabel?.text = (self.playerDetails?["height_inches"]) as? String
        case 4:
            cell.textLabel?.text = (self.playerDetails?["height_feet"]) as? String
        case 5:
            cell.textLabel?.text = (self.playerDetails?["position"]) as? String
        case 6:
            cell.textLabel?.text = (self.playerDetails?["weight_pounds"]) as? String
        case 7 :
            cell.textLabel?.text = (self.playerDetails?["team"]?["full_name"]) as? String
        default:
            cell.textLabel?.text = "Caricamento"
        }
        
        return cell
    }
    
    
}
