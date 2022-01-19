//
//  AddPetViewController.swift
//  myZooKeeper
//
//  Created by Ada on 2/3/21.
//

import UIKit
import Firebase
import FirebaseStorage
import FirebaseFirestore //

class AddPetViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var weightTextField: UITextField!
    @IBOutlet weak var petImageView: UIImageView!
    @IBOutlet weak var petSelectionButton: UIButton!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var imagePicker = UIImagePickerController()
    var selectedPetImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.delegate = self
        weightTextField.delegate = self
        navigationController?.navigationBar.tintColor = .white
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults.standard.bool(forKey: "isSignedIn") {
            return
        }
        
        let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
        if let walkthroughViewController = storyboard.instantiateViewController(withIdentifier: "WalkthroughViewController") as? WalkthroughViewController {
            
            present(walkthroughViewController, animated: true, completion: nil)
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if (nameTextField != nil) {
                weightTextField.becomeFirstResponder()
            } else {
                weightTextField.resignFirstResponder()
            }
                return true
        }
    
    
    @IBAction func SavePet(_ sender: UIButton) {
        /*
         Disbale the save button
         */
        saveButton.isEnabled = false
        uploadImage(image: selectedPetImage) { [self] (url) in
            if url != nil {
                var ref: DocumentReference? = nil
                let uid = Auth.auth().currentUser!.uid
                ref = Firestore.firestore().collection("pet_profiles").addDocument(data: [
                    "name": self.nameTextField.text!,
                    "weight": self.weightTextField.text!,
                    "userId": uid,
                    "petImageUrl": url!.absoluteString,
                    /*
                     Add created At
                     */
                    "createdAt": Date().timeIntervalSince1970
                ]) { err in
                    DispatchQueue.main.async {
                        self.saveButton.isEnabled = true
                    }
                    if let err = err {
                        print("Error adding document: \(err)")
                    } else {
                        /*
                         Show alert when adding a pet
                         */
                        let alert = UIAlertController(title: "Success", message: "Pet added successfully!", preferredStyle: .alert)
                        let okAction = UIAlertAction(title: "OK", style: .default) { action in
                            self.dismiss(animated: true, completion: nil)
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                print("Image upload error!")
            }
        }
    }
    
    func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            self.imagePicker.sourceType = .camera
            self.present(self.imagePicker, animated: true, completion: nil)
        } else {
            print("Camera source is not available.")
        }
    }
    
    func openGallery() {
        self.imagePicker.sourceType = .photoLibrary
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func petSelectionButtonTap(sender: UIButton) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Take using Camera", style: .default) { (action) in
            self.openCamera()
        }
        let galleryAction = UIAlertAction(title: "Choose from Photo Library", style: .default) { (action) in
            self.openGallery()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        imagePicker.delegate = self
        alert.addAction(cameraAction)
        alert.addAction(galleryAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    func uploadImage(image: UIImage, completion: @escaping ((_ url: URL?) -> ())) {
        let storageRef = Storage.storage().reference().child("petImages").child("\(Auth.auth().currentUser!.uid)").child("\(UUID().uuidString).png")
        let imageData = image.jpegData(compressionQuality: 0.1)

        let metadata = StorageMetadata()
        metadata.contentType = "image/png"
        storageRef.putData((imageData ?? imageData)!, metadata: metadata) { (url, error) in
            if error == nil {
                storageRef.downloadURL { (url, error) in
                    if error == nil {
                        completion(url)
                    } else {
                        completion(nil)
                    }
                }
            } else {
                completion(nil)
            }
        }
    }
}

extension AddPetViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        petImageView.image = image
        selectedPetImage = image!
    }
    
}


