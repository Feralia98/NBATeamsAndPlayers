//
//  ViewController.swift
//  NBATeamsAndPlayers
//
//  Created by Silvia Silvestro on 25/04/2020.
//  Copyright © 2020 Silvia Silvestro. All rights reserved.
//

import UIKit

class TeamsViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    
    let teams = ["A", "B", "C"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }


}

extension TeamsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
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
        
        cell.textLabel?.text = teams[indexPath.row]
        
        return cell
    }
    
    
}
