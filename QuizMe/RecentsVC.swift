//
//  ViewController.swift
//  QuizMe
//
//  Created by Vasili Papastrat on 10/14/15.
//  Copyright © 2015 Vasili Papastrat. All rights reserved.
//

import UIKit

class RecentsVC: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return UIBarPosition.TopAttached
    }
    
    func setUpNavBar(){
        let navBar = UINavigationBar(frame: CGRectMake(0, 20, self.view.frame.size.width, 44))
        navBar.backgroundColor = UIColor.whiteColor()
        navBar.delegate = self
        let navItem = UINavigationItem()
        navItem.title = "QuizMe"
        //navItem.titleView = UIImageView(image: UIImage(named: "QMlittle.png"))
        let signOutBT = UIBarButtonItem(title:"Sign Out", style: UIBarButtonItemStyle.Plain, target:self,action:nil)
        navItem.rightBarButtonItem = signOutBT
        navBar.items = [navItem]
        self.view.addSubview(navBar)
    }
*/
}