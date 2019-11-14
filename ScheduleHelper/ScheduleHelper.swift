//
//  ScehduleView.swift
//  scheDuleViewController
//
//  Created by Haya on 11/1/19.
//  Copyright © 2019 Haya. All rights reserved.
//

import UIKit
import FSCalendar
class ScheduleView: UIViewController,FSCalendarDelegate,FSCalendarDataSource {
    var pickerHours = UIDatePicker()
    var txtField:UITextField!
    var calendarView:FSCalendar!
    var selectDate:String!
    var selectedTime:String!
    var selectedDate:String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        calendarView = FSCalendar(frame: CGRect(x: 0, y: 70, width: self.view.layer.bounds.width, height: self.view.layer.bounds.height - 500))
        calendarView.delegate = self
        self.view.addSubview(calendarView)
        
        let textFieldView = UIView(frame: CGRect(x: 0, y: calendarView.layer.bounds.height + 60, width: self.view.layer.bounds.width, height: 200))
        
        self.view.addSubview(textFieldView)
        txtField = UITextField(frame: CGRect(x: 20, y: 10, width: self.view.layer.bounds.width - 40, height: 30))
        txtField.borderStyle = .roundedRect
        txtField.placeholder = "Add time"
        txtField.textAlignment = .center
        textFieldView.addSubview(txtField)
        let okButton = UIButton(frame: CGRect(x: (textFieldView.bounds.width - 200 )/2, y: txtField.layer.bounds.height + 20, width: 200, height: 40))
        okButton.setTitle("ok", for: .normal)
        okButton.layer.cornerRadius = 10
        okButton.backgroundColor = UIColor.gray
        textFieldView.addSubview(okButton)
        okButton.addTarget(self, action:#selector(handleRegister), for: .touchUpInside)
        setTimePicker()
    }
    /// @brief this method is use to select date in a calendar
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        selectDate = self.formatter.string(from: date)
        //  self.configureVisibleCells()
    }
    func setTimePicker()
    {
        self.pickerHours.datePickerMode = UIDatePicker.Mode.time
        txtField.inputView = self.pickerHours
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        pickerHours.addTarget(self, action: #selector(datePickerValueChanged(_:)), for: .valueChanged)
        // Adding Button ToolBar
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(ScheduleView.doneClick1))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(ScheduleView.cancelClick1))
        toolBar.setItems([cancelButton, spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        txtField.inputAccessoryView = toolBar
    }
    @objc func doneClick1() {
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateStyle = .none
        dateFormatter1.timeStyle = .medium
        txtField.text = dateFormatter1.string(from: pickerHours.date)
        txtField.resignFirstResponder()
    }
    fileprivate let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
        
        
    }()
    var sDate:Date!
    func minimumDate(for calendar: FSCalendar) -> Date {
        return Date()
    }
    
    @objc func cancelClick1() {
        txtField.resignFirstResponder()
    }
    
    @objc func handleRegister(_ sender: UIDatePicker){
        self.txtField.resignFirstResponder()
        
        if selectDate != nil && selectedTime != nil {
            selectDate = selectDate + " " + selectedTime
            showToast(message: selectDate, controller: self)
        }
        else{
            
            showToast(message: "Please add date and time both", controller: self)
            
            
        }
        
        selectedTime = ""
        self.txtField.text = ""
        
        
    }
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
        let selectedDate: String = dateFormatter.string(from: sender.date)
        
        print("Selected value \(selectedDate)")
        txtField.text = selectedDate
        selectedTime = selectedDate
        // selectDate = selectedDate
    }
    
    func showToast(message: String, controller: UIViewController) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = UIColor.black
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 10;
        toastContainer.clipsToBounds  =  true
        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font.withSize(12.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0
        toastContainer.addSubview(toastLabel)
        controller.view.addSubview(toastContainer)
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false
        
        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])
        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: controller.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: controller.view, attribute: .trailing, multiplier: 1, constant: -65)
        let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: controller.view, attribute: .bottom, multiplier: 1, constant: -75)
        controller.view.addConstraints([c1, c2, c3])
        
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseIn, animations: {
            toastContainer.alpha = 1.0
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                toastContainer.alpha = 0.0
            }, completion: {_ in
                toastContainer.removeFromSuperview()
            })
        })
    }
    
}

