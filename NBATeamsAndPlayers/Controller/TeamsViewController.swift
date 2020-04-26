//
//  ViewController.swift
//  NBATeamsAndPlayers
//
//  Created by Silvia Silvestro on 25/04/2020.
//  Copyright © 2020 Silvia Silvestro. All rights reserved.
//

import UIKit
import Foundation

class TeamsViewController: UIViewController {
    
    // MARK: - Variables
    
    @IBOutlet var tableView: UITableView!
    var teams = [NSDictionary]()
    var playerID = Int()
    
    // MARK: - viewDidLoad()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        // MARK: - Request
        
        let headers = [
            "x-rapidapi-host": "free-nba.p.rapidapi.com",
            "x-rapidapi-key": "4822149a1amsh10f1bc65148aeb3p1ad44cjsnc0b6b100c0af"
        ]

        let request = NSMutableURLRequest(url: NSURL(string: "https://free-nba.p.rapidapi.com/teams?page=0")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
            
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers

        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
                    do {
                        let str = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String : AnyObject]
                        for valArray in str["data"] as! [NSDictionary] {
                            self.teams.append(valArray)
                        }
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                    catch {
                        print("json error: \(error)")
                    }
                })

                dataTask.resume()
            
            }
    
 // MARK: - Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let playerVC = segue.destination as! PlayersViewController
        playerVC.id = teams[self.playerID]
    }
    
    
}

    // MARK: - TableViewExtension

extension TeamsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.playerID = indexPath.row
        self.tableView.deselectRow(at: indexPath, animated: true)
        self.performSegue(withIdentifier: "FirstSegue", sender: nil)
    }
    
}

extension TeamsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teams.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = ((self.teams[indexPath.item]["full_name"]) as! String)
        
        return cell
    }
    
    
}
