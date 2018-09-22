//
//  ViewController.swift
//  Slide
//
//  Created by LetsNurture on 20/09/16.
//  Copyright © 2016 LetsNurture. All rights reserved.
//

import UIKit
import MapKit
var viewController = ViewController()
class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Register to receive notification
        NotificationCenter.default.addObserver(self, selector: #selector(siriNotification), name: NSNotification.Name(rawValue: "SiriNotify"), object: nil)
        let mymantra1 = UserDefaults(suiteName: "group.letsnurture.siriExample")
     
        print(mymantra1?.value(forKey: "Siri"))
        if mymantra1?.value(forKey: "Siri") != nil{
           siriNotification()

        }
      
       }
        func siriNotification()  {
        let mymantra1 = UserDefaults(suiteName: "group.letsnurture.siriExample")
        mymantra1?.removeObject(forKey: "Siri")
        let controller = storyBoard.instantiateViewController(withIdentifier: "parkingVC") as! parkingVC
        self.navigationController?.pushViewController(controller, animated: true)
        
        }
    override func viewWillAppear(_ animated: Bool) {

 
    }
    
    
    func RequestNotification()  {
        let mymantra1 = UserDefaults(suiteName: "group.letsnurture.siriExample")
        mymantra1?.removeObject(forKey: "Request")
        let controller = storyBoard.instantiateViewController(withIdentifier: "parkingVC") as! parkingVC
        self.navigationController?.pushViewController(controller, animated: true)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

