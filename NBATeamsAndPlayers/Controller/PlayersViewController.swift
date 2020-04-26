//
//  PlayersViewController.swift
//  NBATeamsAndPlayers
//
//  Created by Silvia Silvestro on 25/04/2020.
//  Copyright © 2020 Silvia Silvestro. All rights reserved.
//

import UIKit

class PlayersViewController: UIViewController {
    
        // MARK: - Variables
    
        @IBOutlet weak var tableView: UITableView!
        var id = NSDictionary()
        var players = [NSDictionary]()
        var count = 0
        var pages = 33
        var selected = Int()
    
        // MARK: - viewDidLoad()
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            tableView.delegate = self
            tableView.dataSource = self
            var fulfilledUrls: Array<String> = []
            let headers = [
                "x-rapidapi-host": "free-nba.p.rapidapi.com",
                "x-rapidapi-key": "4822149a1amsh10f1bc65148aeb3p1ad44cjsnc0b6b100c0af"
            ]
            let group = DispatchGroup()
            for url in getUrls(tot: pages) {
                group.enter()
                
                sendRequest(url: url, headers: headers, whenFinished: {
                    () in
                    fulfilledUrls.append(url)
                    group.leave()
                })
            }
            group.wait()
            DispatchQueue.main.async {
                self.players = self.cleanArray(array: self.players)
                self.tableView.reloadData()
            }
            
        }
    
        // MARK: - Functions
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let detailsVC = segue.destination as! PlayerDetailsViewController
        detailsVC.id = players[selected]["id"] as! Int
    }
    
        
        func getUrls(tot: Int) -> [String] {
            var urls = [String]()
            for i in 0...tot {
                urls.append("https://free-nba.p.rapidapi.com/players?page=\(i)&per_page=100")
            }
            return urls
        }
    
    
        func sendRequest(url: String, headers: [String:String], whenFinished: @escaping () -> Void) {
            let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,cachePolicy: .useProtocolCachePolicy,timeoutInterval: 10.0)
                    request.httpMethod = "GET"
                    request.allHTTPHeaderFields = headers

                    let session = URLSession.shared
                    let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data,response,error) -> Void in
                        do {
                            let str = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! [String:AnyObject]
                            for valArray in str["data"] as! [NSDictionary] {
                                self.players.append(valArray)
                            }
                            whenFinished()
                        } catch {
                            print(error)
                        }
                    })
                    dataTask.resume()
                
        }
    
    
        func cleanArray(array: [NSDictionary]) -> [NSDictionary] {
            var temp = [NSDictionary]()
            for val in array {
                if val["team"] as! NSDictionary == self.id {
                    temp.append(val)
                }
            }
            return temp
        }
    }

    // MARK: - Table View Extensions

extension PlayersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selected = indexPath.row
        self.tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "SecondSegue", sender: nil)
    }
}

extension PlayersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell2", for: indexPath)
        if players.count == 0 {
            cell.textLabel?.text = "Caricamento"
        } else {
            cell.textLabel?.text = players[indexPath.item]["last_name"] as! String
        }
        return cell
    }
}
