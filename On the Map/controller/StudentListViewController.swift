//
//  StudentListViewController.swift
//  On the Map
//
//  Created by user on 5/12/22.
//

import UIKit



class StudentListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var previousBtn: UIBarButtonItem!
    
    @IBOutlet var studentTable: UITableView!
    
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    
 
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationData.studentsLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "datacell"
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! StudentListTableViewCell
        cell.studentName.text = StudentLocationData.studentsLocations[indexPath.row].firstName +  " " + StudentLocationData.studentsLocations[indexPath.row].lastName
        return cell
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        studentTable.reloadData()
      
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        studentTable.reloadData()
        
    }
    
     func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         
         print(StudentLocationData.studentsLocations[indexPath.row].firstName)
         let url = URL(string: StudentLocationData.studentsLocations[indexPath.row].mediaURL)
         
         if let url = url{
             UIApplication.shared.open(url) { success in
                 if !success {
                     let alertController = UIAlertController(title: "Invalid Url", message: "", preferredStyle: .alert)
                     alertController.addAction(UIAlertAction(title: "Ok", style: .default))
                     DispatchQueue.main.async {
                         self.present(alertController, animated: true)
                     }
                 }
             }
         }else{
             let alertController = UIAlertController(title: "Invalid url", message: nil, preferredStyle: .alert)
             alertController.addAction(UIAlertAction(title: "OK", style: .default))
             DispatchQueue.main.async{
                 self.present(alertController, animated: true)
             }
         }
       
            
        
           
         
         
         
         studentTable.deselectRow(at: indexPath, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
  
    
    
    @IBAction func previous(_ sender: UIButton) {
        if skip != 0{
            
            skip -= limit
            
            UDClient.getStudentLocations(limit: limit, skip: skip) { data, error in
                guard let data = data else {
                    DispatchQueue.main.async {
                        self.displayFailureMessageToUser(error!.localizedDescription, errorTitle: "Failed")
                    }
                    
                    return
                }
                
                StudentLocationData.studentsLocations = data.results
                DispatchQueue.main.async{
                    self.studentTable.reloadData()
                }
                
            }
        }
        
      
    }
    
    @IBAction func next(_ sender: Any) {
        nextBtn.isEnabled = false
        
        skip += limit
        
        
        
        UDClient.getStudentLocations(limit: limit, skip: skip) { data, error in
            guard let data = data else {
                DispatchQueue.main.async {
                    self.displayFailureMessageToUser(error!.localizedDescription, errorTitle: "Failed")
                }
                
                return
            }
            
            StudentLocationData.studentsLocations = data.results
            DispatchQueue.main.async{
                self.studentTable.reloadData()
                
                self.nextBtn.isEnabled = true 
            }
            
            
        }
        
    }
    
    
    @IBAction func logout(_ sender: Any) {
       
        UDClient.deleteSession { data, error in
            
            guard let data = data else {
                return
            }
            
            UDClient.Auth.sessionId = data.session.id
            
            
            
        let vc = self.storyboard?.instantiateViewController(withIdentifier: String(describing: Login_ViewController.self)) as! Login_ViewController
        
        vc.modalPresentationStyle = .fullScreen
            
            self.present(vc, animated: true)
            
            
            
        
            }

        }
    
    
    func displayFailureMessageToUser(_ message: String, errorTitle:String ){
        let alertController = UIAlertController(title: errorTitle, message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        present(alertController, animated: true, completion: nil)
        
    }
}
