//
//  PostStudentInfoTableViewController.swift
//  On the Map
//
//  Created by user on 5/18/22.
//

import UIKit
import CoreLocation
import MapKit

    var studentInfo = StudentInfo()
    var coordinates: CLLocationCoordinate2D!
    
class PostStudentInfoTableViewController: UITableViewController {
    @IBOutlet var locationTextField: UITextField!
//    @IBOutlet var firstname: UITextField!
//    @IBOutlet var lastname: UITextField!
 
    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UDClient.getUserInfo { data, error in
            guard let data = data else {
                return
            }
            userInfo.user = data
            
           
            
            
        }

       
    }
    
    
    
    @IBAction func takeLocationAndFindOnMap(_ sender:UIButton){
        geocoding(true)
        sender.isEnabled = false
    
       
            if locationTextField?.text == ""{
                let alertController = UIAlertController(title: "OOPs", message: "field must not be empty", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                present(alertController, animated: true)
                self.geocoding(false)
                sender.isEnabled = true
                return
                
            }
        
       
        studentInfo.firstName = userInfo.user.firstName
        studentInfo.lastName = userInfo.user.lastName
        studentInfo.uniqueKey = UDClient.Auth.uniqueKey
        studentInfo.mapString = locationTextField.text ?? ""
        
        guard let locationString = locationTextField.text else {
            return
        }
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(locationString) { placemark, error in
            guard let placemark = placemark else{
                let alertController = UIAlertController(title: "Operation Failed", message: "Please check network connectivity or type in a valid location", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default))
                self.present(alertController, animated: true)
                print(error!.localizedDescription)
                self.geocoding(false)
                sender.isEnabled = true
                return
                }
            
            guard let location = placemark[0].location else{
                print("no placemark here")
                return
            }
            
            studentInfo.longitude = location.coordinate.longitude
            studentInfo.latitude = location.coordinate.latitude
            coordinates = location.coordinate
            self.activityMonitor.stopAnimating()
            
            let takeUrlVc = self.storyboard?.instantiateViewController(withIdentifier: "urlLinkView") as! UrlLinkViewController
            
            self.present(takeUrlVc, animated: true)
        }
        
        
        
        
    }
    
    
    func geocoding(_ ongoing:Bool){
        if ongoing {
            activityMonitor.startAnimating()
        }else{
            activityMonitor.stopAnimating()
        }
       locationTextField.isEnabled = !ongoing
      
        
    }
   

    
}
