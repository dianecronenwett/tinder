    //
//  ProfileViewController.swift
//  tinder
//
//  Created by diane cronenwett on 10/30/14.
//  Copyright (c) 2014 dianesorg. All rights reserved.
//

import UIKit

    
var kProfileSegueID = "profileSegue"

class ProfileViewController: UIViewController {
    
    var image : UIImage!
    
    @IBOutlet weak var profileImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        profileImage.image = image
    }
    
    @IBAction func onDoneButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
