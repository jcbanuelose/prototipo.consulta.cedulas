//
//  ViewController.swift
//  prototipo.consulta.cedulas
//
//  Created by Habil on 10/02/15.
//  Copyright (c) 2015 Habil. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableData = []
    @IBOutlet weak var redditListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        getRedditJSON("http://www.reddit.com/.json")
    }
    
    func getRedditJSON(whichReddit : String){
        let mySession = NSURLSession.sharedSession();
        let url: NSURL = NSURL(string: whichReddit);
        let networkTask = mySession.dataTaskWithURL(url, completionHandler : {data, response, error -> Void in
            var err: NSError?
            var theJSON = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSMutableDictionary
            let results : NSArray = theJSON["data"]!["children"] as NSArray
            dispatch_async(dispatch_get_main_queue(), {
                self.tableData = results
                self.redditListTableView!.reloadData()
            })
        })
        networkTask.resume()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int {
        return tableData.count
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell! {
        let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "MyTestCell")
        let redditEntry : NSMutableDictionary = self.tableData[indexPath.row] as NSMutableDictionary
        cell.textLabel.text = redditEntry["data"]!["title"] as String
        cell.detailTextLabel.text = redditEntry["data"]!["author"] as String
        return cell
    }
}