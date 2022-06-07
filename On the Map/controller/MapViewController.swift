//
//  MapViewController.swift
//  On the Map
//
//  Created by user on 5/12/22.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet var mapView: MKMapView!
   
    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
       
        StudentLocationData.studentsLocations.forEach { StudentLocation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: Double(StudentLocation.latitude), longitude: Double(StudentLocation.longitude))
            annotation.subtitle = "\(StudentLocation.mediaURL)"
            annotation.title = "\(StudentLocation.firstName) \(StudentLocation.lastName)"

          
            mapView.addAnnotation(annotation)
            
            
        }
        
      
        
       
        self.mapView.delegate = self
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let identifier = "pin"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil{
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        }else{
            annotationView?.annotation = annotation
        }
        return annotationView
    }
    
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let urlString = view.annotation?.subtitle else{
            return
        }
        
        if let url = urlString{
            let mediaUrl = URL(string: url)
            guard let mediaUrl = mediaUrl else {
                let alert = UIAlertController(title: "Invalid Url", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default))
                DispatchQueue.main.async{
                    self.present(alert, animated: true)
                }
                return
            }

            UIApplication.shared.open(mediaUrl) { success in
                if !success {
                    let alertController = UIAlertController(title: "Invalid Url", message: nil, preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                    DispatchQueue.main.async{
                        self.present(alertController, animated: true)
                    }
                }
            }
        }
    }
    
   
    
    @IBAction func postOrPutSession(_ sender: Any) {
        let vc =  self.storyboard?.instantiateViewController(withIdentifier: String(describing: PostStudentInfoTableViewController.self)) as! PostStudentInfoTableViewController
        present(vc, animated: true)
    }
    
    
    @IBAction func logout(_ sender: Any) {
       
        UDClient.deleteSession { data, error in
            
            guard let data = data else {
                debugPrint(error!)
                return
            }
            
            
            
            
        let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: Login_ViewController.self)) as! Login_ViewController
        
        vc.modalPresentationStyle = .fullScreen
        
            self.present(vc, animated: true)
            
            
        
            }

        }
    
  
    
        
    }


    
    
    
 




