//
//  Login ViewController.swift
//  On the Map
//
//  Created by user on 5/9/22.
//

import UIKit


    var limit:Int = 100
    var skip:Int = 0
class Login_ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var networkActivity: UIActivityIndicatorView!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var OAuthButton: UIButton!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func login(_ sender: UIButton) {
        loggingIn(true)
        UDClient.postToGetSession(username: emailTextField.text!, password: passwordTextField.text!) { data, error in
            
            if let error = error{
                self.displayFailureMessageToUser(error.localizedDescription, errorTitle: "Login Failed")
                self.loggingIn(false)
         
                
            }
            guard let data = data else{
                self.loggingIn(false)
                return
            }
            
            UDClient.Auth.sessionId = data.session.id
            UDClient.Auth.uniqueKey = data.account.key
            self.loggingIn(false)
            UDClient.getStudentLocations(limit:limit, skip: skip) { data, error in
                guard let data = data else {
                    DispatchQueue.main.async{
                        self.displayFailureMessageToUser(error!.localizedDescription, errorTitle: "Error Fetching Data")
                    }
                    return
                }
                StudentLocationData.studentsLocations = data.results
               
                
                DispatchQueue.main.async {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "MapViewTabBarController") as! MapViewTabBarController
                    vc.modalPresentationStyle = .fullScreen
                    self.present(vc, animated: true)
                    
                }
               
               
            }
            
        }
        
        
        
    }
    
    
    
    func loggingIn(_ ongoing:Bool){
        if ongoing {
            networkActivity.startAnimating()
        }else{
            networkActivity.stopAnimating()
        }
       emailTextField.isEnabled = !ongoing
       passwordTextField.isEnabled = !ongoing
      OAuthButton.isEnabled = !ongoing
        loginButton.isEnabled = !ongoing
        
    }
    
    
    
    func displayFailureMessageToUser(_ message: String, errorTitle:String ){
        let alertController = UIAlertController(title: errorTitle, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
        
    }
    
    
    

  
    
}
