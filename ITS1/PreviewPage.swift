//
//  PreviewPage.swift
//  ITS1
//
//  Created by admin on 7/18/20.
//  Copyright © 2020 Nixon. All rights reserved.
//

import UIKit

struct InputData {
    
    var first_name : String
    var last_name : String
    var gender : String
    var id : Int
    var dateOfBirtdh : String
    var email : String
    var convertedDate : Date
    init (first_name: String, last_name : String, gender : String, id : Int, dateOfBirtdh : String, email : String, convertedDate : Date) {
        self.first_name = first_name
        self.last_name = last_name
        self.gender = gender
        self.id = id
        self.dateOfBirtdh = dateOfBirtdh
        self.email = email
        self.convertedDate = convertedDate
    }

    
}

private let reuseIdentifier = "cell"

protocol PopUpViewDelegate : class {
    
    func incresingData ()
    func decresingData ()
    func sortMaleData ()
    func sortFemaleData ()
    
}

class PreviewPage: UIViewController, PopUpViewDelegate {
    
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var collectionView: UICollectionView!
        
    @IBOutlet weak var button : UIButton!
    
    @IBOutlet weak var updateButton: UIButton!
    
    @IBAction func updatingData(_ sender: Any) {
        
        loadingProgress()
        updateData(url: url!)
        
    }
    
    var newData = [InputData]()
       
    let url = URL(string: "https://my.api.mockaroo.com/persons.json?key=f43efc60")
    
    var refreshControl = UIRefreshControl()
    
    var popUpViewController = PopUpViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadingProgress()
        
        setupGestures()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        
        updateData(url: url!)
        
        refreshControl.tintColor = .red
        refreshControl.attributedTitle = NSAttributedString(string: "Reload")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        collectionView.refreshControl = refreshControl
        
    }

    
    func loadingProgress() {
        
        collectionView.isHidden = true
        collectionView.alpha = 0
        button.isHidden = true
        button.alpha = 0
        updateButton.isHidden = true
        updateButton.alpha = 0
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .red
        activityIndicator.startAnimating()
        UIView.animateKeyframes(withDuration: 0, delay: 5, options: .autoreverse, animations: {
            self.collectionView.alpha = 1
            self.button.alpha = 1
            self.updateButton.alpha = 1
        }) { (finished) in
            self.activityIndicator.stopAnimating()
            self.collectionView.isHidden = false
            self.button.isHidden = false
            self.updateButton.isHidden = false
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowDetail" {
            if let indexPath = self.collectionView.indexPathsForSelectedItems?[0] {
                let tableRequest = segue.destination as! TableViewController
                
                tableRequest.array.append("First name : " + newData[indexPath.row].first_name)
                tableRequest.array.append("Last name : " + newData[indexPath.row].last_name)
                tableRequest.array.append("Gender : " + newData[indexPath.row].gender)
                tableRequest.array.append("Id : " + String(newData[indexPath.row].id))
                tableRequest.array.append("Date of birtdh : " + newData[indexPath.row].dateOfBirtdh)
                tableRequest.array.append("Email : " + newData[indexPath.row].email)
                
            }
        }
    }
        
    func updateData(url : URL) {
        
        guard let url = self.url else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        
        let session = URLSession.shared
        session.dataTask(with: url) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            guard let data =  data else {return}
            print(data)
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                guard let jsonObject = json as? [[String : Any]] else { return }
                
                for eachData in jsonObject {
                    
                    let first_name = eachData["first_name"] as! String
                    let last_name = eachData["last_name"] as! String
                    let gender = eachData["gender"] as! String
                    let id = eachData["id"] as! Int
                    let dateOfBirtdh = eachData["dateOfBirtdh"] as! String
                    let email = eachData["email"] as! String
                    guard let convertedDate = dateFormatter.date(from: dateOfBirtdh) else { return }
                    
                    self.newData.append(InputData(first_name: first_name, last_name: last_name, gender: gender, id: id, dateOfBirtdh: dateOfBirtdh,  email: email, convertedDate: convertedDate))
                    
                }
            }catch {
                print(error)
            }
            DispatchQueue.main.async {
                (self.newData).sort(by: { $0.convertedDate > $1.convertedDate })
                self.collectionView.reloadSections([0])
            }
        }.resume()
        
        
    }
    
    @objc func refresh(){
        
        DispatchQueue.main.async {
            for obj in self.newData {
                print(obj.convertedDate)
            }
            self.collectionView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    //-----------------
    func incresingData(){
        print("Delegate is working")
        DispatchQueue.main.async {
            (self.newData).sort(by: { $0.convertedDate > $1.convertedDate })
            for obj in self.newData {
                print(obj.convertedDate)
            }
            self.collectionView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    func decresingData(){
        print("Delegate is working")
        DispatchQueue.main.async {
            (self.newData).sort(by: { $0.convertedDate < $1.convertedDate })
            for obj in self.newData {
                print(obj.convertedDate)
            }
            self.collectionView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    func sortMaleData(){
        print("Delegate is working")
        
        var counter : Int = 0
        
        print(self.newData.count)
        
        while counter < newData.count {
            if newData[counter].gender == "Female" {
                newData.remove(at: counter)
            } else {
                counter += 1
            }
        }
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    func sortFemaleData(){
        print("Delegate is working")
        
        var counter : Int = 0
        
        print(self.newData.count)
        
        while counter < newData.count {
            if newData[counter].gender == "Male" {
                newData.remove(at: counter)
            } else {
                counter += 1
            }
        }
        
        DispatchQueue.main.async {
            //
            self.collectionView.reloadData()
        }
        refreshControl.endRefreshing()
    }
    
    
    //-----------------
    
    private func setupGestures() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapped))
        tapGesture.numberOfTouchesRequired = 1
        button.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapped() {
        
        let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let popVC = storyboard.instantiateViewController(withIdentifier: "popVC")as! PopUpViewController
        
        popVC.modalPresentationStyle = UIModalPresentationStyle.popover
        
        let presentationController = popVC.popoverPresentationController
        
        presentationController?.delegate = self
        presentationController?.sourceView = self.button
        presentationController?.sourceRect = CGRect(x: self.button.bounds.midX, y: self.button.bounds.maxY , width: 0, height: 0)
        popVC.preferredContentSize = CGSize(width: 250, height: 250)
        
        popVC.dataToSort = newData
        popVC.delegate = self
        
        self.present(popVC, animated: true, completion: nil)
        
        
    }
    
}

extension PreviewPage: UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate  {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return newData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
        
        cell.imageView.image = UIImage(named: newData[indexPath.row].gender)
        cell.nameOfPerson.text = newData[indexPath.row].first_name
        let todayDate = Date()
        let birthday = newData[indexPath.row].convertedDate
        let calendar = Calendar.current
        
        let ageComponents = calendar.dateComponents([.year], from: birthday, to: todayDate)
        let age = ageComponents.year!
        cell.personalAge.text =  "Age : " + String(age)
        
        return cell
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        
        return UIModalPresentationStyle.none
    }
    
}


