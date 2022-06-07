//
//  UrlLinkViewController.swift
//  On the Map
//
//  Created by user on 5/16/22.
//

import UIKit
import MapKit

class UrlLinkViewController: UIViewController {

    @IBOutlet weak var activityMonitor: UIActivityIndicatorView!
    
    @IBOutlet var urlLinkTextField: UITextField!{
        didSet{
            urlLinkTextField.attributedPlaceholder = NSAttributedString(string: "Enter you url here", attributes: [NSAttributedString.Key.foregroundColor : UIColor.white])
        }
        }
    @IBOutlet var mapView: MKMapView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       
        let annotation = MKPointAnnotation()
        
        if let coordinates = coordinates{
            annotation.coordinate = coordinates
            mapView.addAnnotation(annotation)
            
            let region = MKCoordinateRegion(center: annotation.coordinate, latitudinalMeters: 250, longitudinalMeters: 250)
            self.mapView.setRegion(region, animated: true)
        // Do any additional setup after loading the view.
    }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
            
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func cancel(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    @IBAction func shareLocation(_ sender: UIButton) {
        
        if urlLinkTextField.text == "" {
            let alertController = UIAlertController(title: "OOPs", message: "Field must not be empty. Please provide your URL", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .default))
            self.present(alertController, animated: true)
            return
        }
        sender.isEnabled = false
        activityMonitor.startAnimating()
        studentInfo.mediaURL = urlLinkTextField.text!
        UDClient.postStudentInfo(studentInfo) { data, error in
            if let error = error {
                self.displayFailureMessageToUser(error.localizedDescription)
                return
            }
            
            UDClient.getStudentLocations(limit: limit, skip: skip) { data, error in
                guard let data = data else {
                    return
                }

                StudentLocationData.studentsLocations = data.results
            }
            
            
            let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: MapViewTabBarController.self)) as! MapViewTabBarController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
            
            self.activityMonitor.stopAnimating()
            sender.isEnabled = true
            }
        
            

        
        
        
    }
    
    func displayFailureMessageToUser(_ message: String ){
        let alertController = UIAlertController(title: "Request Failed", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    
}
