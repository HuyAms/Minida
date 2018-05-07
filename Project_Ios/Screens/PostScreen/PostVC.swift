//
//  PostVC.swift
//  Project_Ios
//
//  Created by Huy Trinh on 29.4.2018.
//  Copyright © 2018 Huy Trinh. All rights reserved.
//

import UIKit
import CoreML
import Vision
import ImageIO

protocol PostVCProtocol: class {
    
    func showLoading()
    
    func hideLoading()
    
    func onUploadImageSuccess(imgPath: String)
    
    func onPostSuccess()
    
    func onValidateDataSuccess()
    
    func onShowError(error: AppError)
}

class PostVC: UIViewController, PostVCProtocol {
    
    //MARK: Outlet
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var itemImgView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var descriptionLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var postBtn: UIButton!
    @IBOutlet weak var categoryLbl: UILabel!
    @IBOutlet weak var categoryBtn: UIButton!
    @IBOutlet weak var itemNameTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    
    let minidaPickerView = MinidaPickerView()
    var categories: [String] = ["clothing", "accessories", "devices", "homeware", "vehicles", "others"]
    var presenter: PostPresenterProtocol?
    var categorySelectedRow: Int?
    var itemImg: UIImage?
    let nc = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        self.presenter = PostPresenter(view: self)
        delegateTextField()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(PostVC.dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
    
        let imgTapGesture = UITapGestureRecognizer(target: self
            , action: #selector(PostVC.imageTap(_:)))
        itemImgView.addGestureRecognizer(imgTapGesture)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillDisappear(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillAppear(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
    }

   
    //MARK: Action
    @IBAction func categoryBtnWasPressed(_ sender: Any) {
        showCategoryPicker()
    }
    

    @IBAction func closeBtnWasPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func postBtnWasPressed(_ sender: Any) {
        let itemName = itemNameTextField.text ?? ""
        let itemDescription = descriptionTextField.text ?? ""
        let itemPrice = priceTextField.text ?? ""
        var itemCategory: String = ""
        if let categorySelectedRow = self.categorySelectedRow {
            itemCategory = categories[categorySelectedRow]
        }
        
        presenter?.validateData(itemName: itemName, itemDescription: itemDescription, itemPrice: itemPrice, itemCategory: itemCategory)
    }
    
    //MARK: ML
    func updateClassifications(for image: UIImage) {
        
        let orientation = CGImagePropertyOrientation(rawValue: UInt32(image.imageOrientation.rawValue))
        guard let ciImage = CIImage(image: image) else { fatalError("Unable to create \(CIImage.self) from \(image).") }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: orientation!)
            do {
                try handler.perform([self.classificationRequest])
                
            } catch {
                print("Failed to perform classification.\n\(error.localizedDescription)")
            }
        }
    }
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                return
            }
            let classifications = results as! [VNClassificationObservation]
            
            if classifications.isEmpty {
                
            } else {
                // Display top classifications ranked by confidence in the UI.
                let topClassifications = classifications.prefix(1)
                let descriptions = topClassifications.map { classification -> String in
                    // Formats the classification for display; e.g. "(0.37) cliff, drop, drop-off".
                    let categoryIdentifier = Int(classification.identifier)!
                    self.minidaPickerViewDone(selectedRow: categoryIdentifier)
                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                }
                print("Classification:\n" + descriptions.joined(separator: "\n"))
            }
        }
    }
    
    //MARK: Helper
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @objc func keyboardWillAppear(_ notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame:CGRect = (userInfo[UIKeyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset:UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 40
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillDisappear(_ notification: NSNotification) {
        let contentInset:UIEdgeInsets = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }

    func showCategoryPicker() {
        minidaPickerView.modalPresentationStyle = .custom
        minidaPickerView.delegate = self
        minidaPickerView.datasource = self
        present(minidaPickerView, animated: false, completion: nil)
        minidaPickerView.selectRow(row: categorySelectedRow ?? 0, inComponent: 0, animated: false)
    }
    
    func delegateTextField() {
        itemNameTextField.delegate = self
        priceTextField.delegate = self
        descriptionTextField.delegate = self
    }
    
    @objc func imageTap(_ sender: UITapGestureRecognizer) {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else {
            presentPhotoPicker(sourceType: .photoLibrary)
            return
        }
        
        let photoSourcePicker = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo".localized, style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo".localized, style: .default) { [unowned self] _ in
            self.presentPhotoPicker(sourceType: .photoLibrary)
        }
        
        photoSourcePicker.addAction(takePhoto)
        photoSourcePicker.addAction(choosePhoto)
        photoSourcePicker.addAction(UIAlertAction(title: "Cancel".localized, style: .cancel, handler: nil))
        
        present(photoSourcePicker, animated: true)
    }
    
    func presentPhotoPicker(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    
    //MARK: Protocol
    
    func showLoading() {
        showLoadingIndicator()
    }
    
    func hideLoading() {
        hideLoadingIndicator()
    }
    
    func onPostSuccess() {
        nc.post(name: NSNotification.Name("postSuccess"), object: nil)
        dismiss(animated: true, completion: nil)
    }
    
    func onValidateDataSuccess() {
        var imageData: Data?
        
        if let imgFile = itemImg {
            imageData = UIImageJPEGRepresentation(imgFile, 1.0)!
        }
        
        presenter?.upLoadPicture(imgData: imageData)
    }
    
    func onShowError(error: AppError) {
        errorLbl.isHidden = false
        errorLbl.text = error.description
        errorLbl.shake()
    }
    
    func onUploadImageSuccess(imgPath: String) {
        let itemName = itemNameTextField.text ?? ""
        let itemDescription = descriptionTextField.text ?? ""
        let itemPrice = priceTextField.text ?? ""
        var itemCategory: String = ""
        if let categorySelectedRow = self.categorySelectedRow {
            itemCategory = categories[categorySelectedRow]
        }
        
        presenter?.performUploadItem(itemName: itemName, itemDescription: itemDescription, itemPrice: itemPrice, itemCategory: itemCategory, itemPictureUrl: imgPath)
    }
}

extension PostVC: MinidaPickerDataSource, MinidaPickerDelegate {
   

    func minidaPickerView(_ minidaPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categories.count
    }

    func minidaPickerView(_ minidaPickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categories[row].localized
    }

    func numberOfComponents(in minidaPickerView: UIPickerView) -> Int {
        return 1
    }
    
    func minidaPickerViewClosed() {
        minidaPickerView.dismiss()
    }
    
    func minidaPickerViewDone(selectedRow: Int) {
        categorySelectedRow = selectedRow
        categoryBtn.setTitle(categories[selectedRow].localized, for: .normal)
        minidaPickerView.dismiss()
        errorLbl.isHidden = true
    }
}

extension PostVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    // MARK: - Handling Image Picker Selection
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        picker.dismiss(animated: true)
        
        itemImg = info[UIImagePickerControllerOriginalImage] as? UIImage
        itemImgView.image = itemImg
        guard let image = itemImg else {
            print("no image to classify")
            return
        }
        updateClassifications(for: image)
        errorLbl.isHidden = true
    }
}

extension PostVC: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        errorLbl.isHidden = true
    }
}

extension PostVC {
    func setupUI() {
        postBtn.setTitle("Post".localized, for: .normal)
        titleLbl.text = "Post".localized
        nameLbl.text = "Name".localized
        descriptionLbl.text = "Description".localized
        priceLbl.text = "Price".localized
        categoryLbl.text = "Category".localized
        categoryBtn.setTitle("Choose Category".localized, for: .normal)
        itemNameTextField.placeholder = "Name".localized
        descriptionTextField.placeholder = "Description".localized
        priceTextField.placeholder = "Price".localized
    }
}

