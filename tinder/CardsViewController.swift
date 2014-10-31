//
//  CardsViewController.swift
//  tinder
//
//  Created by diane cronenwett on 10/30/14.
//  Copyright (c) 2014 dianesorg. All rights reserved.
//

import UIKit

var kTransitionDuration = 0.4

class CardsViewController: UIViewController, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning {

    @IBOutlet weak var cardImage: UIImageView!
    
    var isPresenting : Bool = true
    var cardInitialCenter: CGPoint!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }

   
    @IBAction func onDrag(sender: UIPanGestureRecognizer) {
        var translation = sender.translationInView(view)
        
//        if sender.state == UIGestureRecognizerState.Began {
//            cardInitialCenter = cardImage.center
//        }
//        cardImage.center.x = cardInitialCenter.x + translation.x
//        cardImage.center.y = cardInitialCenter.y + translation.y
        
        
        var location = sender.locationInView(cardImage)
        var imageHeight = cardImage.frame.height
        var screenSize = UIScreen.mainScreen().bounds
        
        var angle : CGFloat = 0
        
        
        if (location.y < imageHeight / 2) { // gesture is on top half of image
            angle = translation.x / screenSize.width * CGFloat(M_PI / 4)
        } else { // gesture is on bottom half of image
            angle = -translation.x / screenSize.width * CGFloat(M_PI / 4)
        }
    
        // screenwidth = 45 degrees
        cardImage.transform = CGAffineTransformMakeRotation(angle)
        
        if (sender.state == UIGestureRecognizerState.Ended) {
            if (translation.x < -50) {
                // Animate off screen to the left
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.cardImage.transform = CGAffineTransformIdentity
                    self.cardImage.frame.offset(dx: -screenSize.width, dy: 0)
                })
            } else if (translation.x > 50) {
                // Animate off screen to the right
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.cardImage.transform = CGAffineTransformIdentity
                    self.cardImage.frame.offset(dx: screenSize.width, dy: 0)
                })
            } else {
                // Restore to original center & transform
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.cardImage.transform = CGAffineTransformIdentity
                })
            }
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var profileViewController = segue.destinationViewController as ProfileViewController
        profileViewController.image = cardImage.image
        
        profileViewController.modalPresentationStyle = UIModalPresentationStyle.Custom
        profileViewController.transitioningDelegate = self
        
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = true
        return self
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        isPresenting = false
        return self
    }
    
    func transitionDuration(transitionContext: UIViewControllerContextTransitioning) -> NSTimeInterval {
        return kTransitionDuration
    }
    
    func animateTransition(transitionContext: UIViewControllerContextTransitioning) {
        println("animating transition")
        var containerView = transitionContext.containerView()
        
        var profileViewController = (isPresenting ?
            transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)! :
            transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)!) as ProfileViewController
        
        var cardViewController = (isPresenting ?
            transitionContext.viewControllerForKey(UITransitionContextFromViewControllerKey)! :
            transitionContext.viewControllerForKey(UITransitionContextToViewControllerKey)!) as CardsViewController
        
        var profileImageFrame = profileViewController.profileImage.frame
        var cardImageFrame = cardViewController.cardImage.frame
        
        var transitionImage = UIImageView(image: profileViewController.image)
        transitionImage.contentMode = UIViewContentMode.ScaleAspectFill
        transitionImage.clipsToBounds = true
        
        var backgroundView = UIView(frame: UIScreen.mainScreen().bounds)
        backgroundView.backgroundColor = UIColor.whiteColor()
        
        cardViewController.view.addSubview(backgroundView)
        cardViewController.view.addSubview(transitionImage)
        
        if (isPresenting) { // Displaying modal
            
            transitionImage.frame = cardImageFrame
//            backgroundView.alpha = 0
            
            UIView.animateWithDuration(kTransitionDuration, animations: { () -> Void in
                transitionImage.frame = profileImageFrame
//                backgroundView.alpha = 1
                }, completion: { (b: Bool) -> Void in
                    containerView.addSubview(profileViewController.view)
                    transitionImage.removeFromSuperview()
                    backgroundView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        } else { // Close modal
            profileViewController.view.removeFromSuperview()
            transitionImage.frame = profileImageFrame
//            backgroundView.alpha = 1
            
            UIView.animateWithDuration(kTransitionDuration, animations: { () -> Void in
                transitionImage.frame = cardImageFrame
//                backgroundView.alpha = 0
                }, completion: { (finished: Bool) -> Void in
                    transitionImage.removeFromSuperview()
                    backgroundView.removeFromSuperview()
                    transitionContext.completeTransition(true)
            })
        }
    }
    
    @IBAction func onCardImageTap(sender: UITapGestureRecognizer) {
        performSegueWithIdentifier(kProfileSegueID, sender: self)
    }
    
}
