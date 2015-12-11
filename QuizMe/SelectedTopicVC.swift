//
//  SelectedTopicVC.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 12/9/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class SelectedTopicVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    //MARK: - Data members
    var topic = ""
    var results = [QmSet]() //stores search results
    var filteredResults = [QmSet]()//filtered sets
    var favorites = [Int]()
    
    //MARK: - IBOutlets
    @IBOutlet var tvTable: UITableView!
    let searchBar : UISearchBar = UISearchBar(frame: CGRectMake(0,0,120,20))
    @IBOutlet var aiSpinner: UIActivityIndicatorView!
    
    //MARK: - UIViewController functions
    override func viewDidLoad() {
        super.viewDidLoad()
        let leftNavBarButton = UIBarButtonItem(customView: searchBar)
        self.navigationItem.rightBarButtonItem = leftNavBarButton
        self.navigationItem.title = topic
        searchBar.delegate = self
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "favoriteToggled:", name: "Favorite_key", object: nil)
        getSets()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - General
    /**
    inFavorites
    tells you whether or not a given set is favorited
    PARAMETERS:
        pid of set
    RETURNS:
        true if yes, false if no
    **/
    func inFavorites(pid:Int) -> Bool{
        for el in favorites{
            if el == pid{
                return true
            }
        }
        return false
    }
    
    //MARK: - Database interaction
    /**
    favoriteToggled
    **/
    func favoriteToggled(notification:NSNotification){
        var info = [[String: AnyObject]]()
        info.append(notification.userInfo as! [String:String])
        let isFavorited = info[0]["fav"] as! String
        let pid = Int(info[0]["pid"] as! String)
        var url : String
        if isFavorited == "true"{
            url = UNFAVORITE_SET_PHP
        }else{
            url = FAVORITE_SET_PHP
            favorites.append(pid!) //assuming favoriting will be successful
        }
        let send_this = "uid=\(UID)&pid=\(pid!)"
        let request = getRequest(send_this, urlString: url)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in  //all this happens once request has been completed, in another queue
            if error != nil{
                print("Error with creating login")
                return
            }
            
        }
        task.resume()
    }
    /**
    GetSets
    Fetches user defined sets from server
    **/
    func getSets(){
        aiSpinner.startAnimating()
        results.removeAll()
        filteredResults.removeAll()
        let send_this = "topic='\(topic)'"
        let request = getRequest(send_this, urlString: GET_SETS_FROM_TOPIC_PHP)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            (data, response, error) in  //all this happens once request has been completed, in another queue
            if error != nil{
                print("Error with creating login")
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
            if let data = data{
                do{
                    if let json = try NSJSONSerialization.JSONObjectWithData(data, options: [NSJSONReadingOptions.MutableContainers,NSJSONReadingOptions.AllowFragments]) as? NSArray{
                        for dic in json{
                            if case let id as String = dic["pid"]{
                                if case let pname as String = dic["name"]{
                                    if case let topic as String = dic["topic"]{
                                        if case let priv as String = dic["private"]{
                                            if case let maker as String = dic["creator"]{
                                                let temp = QmSet(pid: Int(id)!, name: pname, topic: topic, privat: priv,cr:Int(maker)!)
                                                self.results.append(temp)
                                                self.filteredResults.append(temp)
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                }//end of do
                catch let e as NSError {
                    print(e)
                }
                
            }
                self.aiSpinner.stopAnimating()
                self.tvTable.reloadData()
            })//end of block
        }
        task.resume()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let indexPath = tvTable.indexPathForSelectedRow
        if let nextView = segue.destinationViewController as? SelectedSetVC{
            nextView.set = filteredResults[indexPath!.row]
            tvTable.deselectRowAtIndexPath(indexPath!, animated: true)
        }
    }
    

    // MARK: - UITableView functions
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("Set") as! FavoritesTVC?
        if(cell == nil){
            cell = FavoritesTVC(style:UITableViewCellStyle.Default, reuseIdentifier:"Set")
        }
        cell!.textLabel?.text = filteredResults[indexPath.row].name
        cell!.pid = filteredResults[indexPath.row].pid
        if inFavorites(filteredResults[indexPath.row].pid){
            //cell!.btFavorite.imageView?.image = UIImage(named: "star.png")//if favorited, show gold star
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
            cell!.favorited = true
        }
        return cell!
    }
    // MARK: - UISearchbar functions
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == ""{
            resetFilteredResults()
        }else{
            filterSearch(searchText)
        }
        tvTable.reloadData()
    }
    /**
    filterSearch
    Filters the sets stored in 'results' and stores results of filtering in
    'filteredResults'
    PARAMETERS:
        search string from search bar
    **/
    func filterSearch(searchText : String){
        filteredResults = results.filter({( qmset: QmSet) -> Bool in
            if qmset.name.rangeOfString(searchText) != nil{
                return true
            }else{
                return false
            }
        })
    }
    /**
    resetFilterdResults
    Fills filtered results with all results
    **/
    func resetFilteredResults(){
        filteredResults.removeAll()
        for element in results{
            filteredResults.append(element)
        }
    }
}
