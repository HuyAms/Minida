//
//  MinidaPickerView.swift
//  Project_Ios
//
//  Created by iosdev on 29.4.2018.
//  Copyright © 2018 Dat Truong. All rights reserved.
//

import UIKit

protocol MinidaPickerDelegate {
        
    func minidaPickerViewClosed()
    
    func minidaPickerViewDone(selectedRow: Int)
    
}

protocol MinidaPickerDataSource {
    
    func minidaPickerView(_ minidaPickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    
    func minidaPickerView(_ minidaPickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    
    func numberOfComponents(in minidaPickerView: UIPickerView) -> Int
    
}

class MinidaPickerView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet weak var pickerView: UIPickerView!
    
    var categories: [String] = ["clothes", "devices", "accessories", "homewares", "vehicles", "others"]
    var delegate: MinidaPickerDelegate?
    var datasource: MinidaPickerDataSource?
    var selectedRow = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    func selectRow(row: Int, inComponent: Int, animated: Bool) {
        pickerView.selectRow(row, inComponent: inComponent, animated: animated)
        selectedRow = row
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return datasource?.numberOfComponents(in: pickerView) ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return datasource?.minidaPickerView(pickerView, numberOfRowsInComponent: component) ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return datasource?.minidaPickerView(pickerView, titleForRow: row, forComponent: component)
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedRow = row
    }
    
    func dismiss() {
        dismiss(animated: false, completion: nil)
    }
    

    @IBAction func closeBtnWasPressed(_ sender: Any) {
        delegate?.minidaPickerViewClosed()
    }
    
    @IBAction func doneBtnWasPressed(_ sender: Any) {
        delegate?.minidaPickerViewDone(selectedRow: selectedRow)
    }
}
