//
//  PlanDetailViewController.swift
//  ch10-1751044-stackView
//
//  Created by mac030 on 2022/05/07.
//

import UIKit

class PlanDetailViewController: UIViewController {
    
    @IBOutlet weak var saveBtn: UIButton!
    @IBOutlet weak var dateDatePicker: UIDatePicker!
    @IBOutlet weak var ownerLabel: UILabel!
    //    @IBOutlet weak var typePicker: UIPickerView!
    @IBOutlet weak var contentTextView: UITextView!
    
    @IBOutlet weak var s1: UITextView!
    @IBOutlet weak var s2: UITextView!
    @IBOutlet weak var s3: UITextView!
    @IBOutlet weak var s4: UITextView!
    
    @IBOutlet weak var recordTextView: UITextView!
    
    @IBOutlet weak var btm: NSLayoutConstraint!
    var plan: Plan? // 나중에 PlanGroupViewController로부터 데이터를 전달받는다
    var saveChangeDelegate: ((Plan)-> Void)?
    
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //버튼 둥글게
        //        saveBtn.layer.cornerRadius = saveBtn.layer.frame.size.width/2
        
        
        //        typePicker.dataSource = self
        //        typePicker.delegate = self
        
        plan = plan ?? Plan(date: Date(), withData: true)
        dateDatePicker.date = plan?.date ?? Date()
        
        
        dateDatePicker.setValue(UIColor.darkGray, forKey: "textColor")
    
        dateDatePicker.setValue(false, forKey: "highlightsToday")
        if #available(iOS 14.0, *) {
            
            dateDatePicker.preferredDatePickerStyle = .wheels
            dateDatePicker.tintColor = UIColor.white
          
 
            
        }
        
        ownerLabel.text = plan?.owner // plan!.owner과 차이는? optional chainingtype
        
        
        //        // typePickerView 초기화
        //        if let plan = plan{
        //            typePicker.selectRow(plan.kind.rawValue, inComponent: 0, animated: false)
        //        }
        //
        contentTextView.text = plan?.content
        
        s1.text = plan?.content2
        s2.text = plan?.content3
        s3.text = plan?.content4
        s4.text = plan?.content5
        
        recordTextView.text = plan?.content6
        
        
        
        
        // 키보드가 나타나면 keyboardWillShow 함수를 호출한다
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),
                                               name: UIResponder.keyboardWillShowNotification, object: nil
        )
        // 키보드가 사라지면 keyboardWillHide 함수를 호출한다
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification,object: nil
        )
        
        
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardHeight = keyboardFrame.cgRectValue.height // 키보드의 높이를 구한다
            
            btm.constant = keyboardHeight // 스택뷰의 하단 여백을 높인다
        }
    }
    @objc private func keyboardWillHide(_ notification: Notification) {
        btm.constant = 218 // 스택뷰의 하단 여백을 원래대로 설정한다
    }
    
    @objc func dismissKeyboard(sender: UITapGestureRecognizer){
        contentTextView.resignFirstResponder()
        s1.resignFirstResponder()
        s2.resignFirstResponder()
        s3.resignFirstResponder()
        s4.resignFirstResponder()
        recordTextView.resignFirstResponder()
        
    }
    
    
    
    
    @IBAction func gotoBack(_ sender: UIButton) {
        
        if let saveChangeDelegate = saveChangeDelegate{
            plan!.date = dateDatePicker.date
            plan!.owner = ownerLabel.text // 수정할 수 없는 UILabel이므로 필요없는 연산임
            //            plan!.kind = Plan.Kind(rawValue: typePicker.selectedRow(inComponent: 0))!
            plan!.content = contentTextView.text
            
            plan!.content2 = s1.text
            plan!.content3 = s2.text
            plan!.content4 = s3.text
            plan!.content5 = s4.text
            plan!.content6 = recordTextView.text
            
            saveChangeDelegate(plan!)
            
        }
        //dismiss(animated: true, completion: nil)
        navigationController?.popViewController(animated: true)
        
    }
}


//extension PlanDetailViewController:UIPickerViewDelegate, UIPickerViewDataSource{
//    func numberOfComponents(in pickerView: UIPickerView) -> Int {
//        return 1
//    }
//    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
//        return Plan.Kind.count // Plan.swift파일에서 count를 확인하라
//    }
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) ->
//    String? {
//        let type = Plan.Kind(rawValue: row) // 정수를 해당 Kind 타입으로 변환하는 것이다.
//        return type!.toString()
//    }
//
//}


