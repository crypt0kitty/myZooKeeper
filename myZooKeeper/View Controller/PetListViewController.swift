//
//  PetListViewController.swift
//  myZooKeeper
//
//  Created by Sandy Vasquez on 2/11/21.
//

import UIKit
import Firebase
import FirebaseFirestore
import SDWebImage

class PetListViewController: UIViewController {
    
    @IBOutlet weak var contentPetView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    var petList = [Pet]()
    var isLoading = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        getPetList()
    
    }
    
    private func getPetList() {
        guard !isLoading else { return }
        isLoading = true
        Firestore.firestore().collection("pet_profiles").getDocuments { [weak self] snapshot, error in
            guard let strongSelf = self else { return }
            strongSelf.isLoading = false
            if let error = error {
                print(error)
                return
            }
            DispatchQueue.main.async {
                strongSelf.handlePetList(snapshot: snapshot)
            }
            
        }
    }
    
    private func handlePetList(snapshot: QuerySnapshot?) {
        petList.removeAll()
        guard let documentSnapshot = snapshot, !documentSnapshot.isEmpty else {
            print("Error fetching pet list! May be empty list.")
            return
        }
        
        let petDocuments = documentSnapshot.documents
        
        petList = petDocuments.compactMap({ snapshot in
            Pet(snapshot: snapshot)
        })
        
        petList.sort { firstPet, secondPet in
            return firstPet.createdAt > secondPet.createdAt
        }
        
        self.tableView.reloadData()
    }
}

extension PetListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PetCardCell") as! PetCardCell
        cell.petName.text = petList[indexPath.row].petName
        cell.petWeight.text = petList[indexPath.row].petWeight
        /*
         Images should be loaded asynchrounsouly
         */
        if let petImage = URL(string: petList[indexPath.row].petImageUrl) {
            cell.petView.sd_setImage(with: petImage, completed: nil)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 270.0
    }
    
}
