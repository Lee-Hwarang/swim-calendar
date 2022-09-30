//
//  ViewController.swift
//  ch09-tavleView-student
//
//  Created by apple on 2022/04/27.
//

import UIKit
import FSCalendar

class PlanGroupViewController: UIViewController {
    
    
    @IBOutlet weak var planGroupTableView: UITableView!
    @IBOutlet weak var fsCalendar: FSCalendar!
    @IBOutlet weak var addBtn: UIButton!
    
    var planGroup: PlanGroup!
    var selectedDate: Date? = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        Owner.loadOwner(sender: self)
        planGroupTableView.dataSource = self
        planGroupTableView.delegate = self
        
        fsCalendar.dataSource = self
        fsCalendar.delegate = self
        
        fsCalendar.appearance.headerMinimumDissolvedAlpha = 0.0
       
       
        fsCalendar.appearance.headerDateFormat = "M월"
        fsCalendar.appearance.headerTitleFont = UIFont.systemFont(ofSize: 24)
        
     


        
        planGroup = PlanGroup(parentNotification: myNotification)
        planGroup.queryData(date: Date())
        


        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        label.textColor = UIColor(red: 47/255, green: 72/255, blue: 225/255, alpha: 1)

        label.font = UIFont(name: "MysticalWoodsSmoothScript", size: 20)


        label.text = "Swim Calendar"
        navigationItem.titleView = label
        


       

       

        
//                
//                let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))
//                imageView.contentMode = .scaleAspectFit
//
//                let image = UIImage(named: "그림6.png")
//                imageView.image = image
//                navigationItem.titleView = imageView

        

        
        
        let leftBarButtonItem = UIBarButtonItem(title: "-", style: .plain, target: self, action: #selector(editingPlans1))
        navigationItem.leftBarButtonItem = leftBarButtonItem
       
        
        
        
    }
    
   
    
    
    override func viewDidAppear(_ animated: Bool) {
        Owner.loadOwner(sender: self)
        print("loadOwner")
    }
    
    //    @IBAction func editingPlans(_ sender: UIButton) {
    //        if planGroupTableView.isEditing == true{
    //            planGroupTableView.isEditing = false
    //            sender.setTitle("-", for: .normal)
    //
    //        }else{
    //            planGroupTableView.isEditing = true
    //            sender.setTitle("저장", for: .normal)
    //
    //        }
    //
    //    }
    
    
    @IBAction func addingPlans(_ sender: UIButton) {
        performSegue(withIdentifier: "AddPlan", sender: self)
    }
    
    
    
    
    func myNotification(plan: Plan?, dbAction: DbAction?){
        planGroupTableView.reloadData()
        fsCalendar.reloadData()
    }
    
    func receivingNotification(plan: Plan?, action: DbAction?){
        // 데이터가 올때마다 이 함수가 호출되는데 맨 처음에는 기본적으로 add라는 액션으로 데이터가 온다.
        self.planGroupTableView.reloadData()  // 속도를 증가시키기 위해 action에 따라 개별적 코딩도 가능하다.
        fsCalendar.reloadData()
    }
}
extension PlanGroupViewController: UITableViewDataSource, UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return planGroup.getPlans(date: selectedDate).count
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: .value1, reuseIdentifier: "")
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlanTableViewCell") as! PlanTableViewCell
        
        // planGroup는 대략 1개월의 플랜을 가지고 있다. 그중에서 선택된 날짜의 데이터만 테이블에 보인다.
        
        let plan = planGroup.getPlans(date:selectedDate)[indexPath.row]
        
        
        // 0, 1, 2순서가 맞아야 한다. 안맞으면 스트로보드에서 다시 맞도록 위치를 바꾸어야 한다
        
        cell.date.text = plan.date.toStringDateTime()
        cell.name.text = plan.owner
        cell.comment.text = plan.content
        
        
        cell.date.font = UIFont(name: "NA.ttf", size: 20)
        cell.name.font = UIFont(name: "NanumSquare_acL.ttf", size: 20)
        cell.comment.font = UIFont(name: "NanumSquare_acL.ttf", size: 20)
        
        
        
        //선택시 회색으로 변하지 않게
        let background = UIView()
        background.backgroundColor = .clear
        cell.selectedBackgroundView = background
        
        return cell
        
    }
    
   
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.textLabel?.textColor = UIColor(displayP3Red: 100, green: 100, blue: 0, alpha: 1)
//        cell.detailTextLabel.font = UIFont(name: "NanumSquare_acL.ttf", size: 20)
//        cell.detailTextLabel.textColor = [UIColor whiteColor];
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete{
            
            
            let plan = self.planGroup.getPlans(date:selectedDate)[indexPath.row]
            let title = "Delete\(plan.content)"
            let message = "Are you sure you want to delete this item?"
            let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (action:UIAlertAction) -> Void in
                // 선택된 row의 플랜을 가져온다
                let plan = self.planGroup.getPlans(date:self.selectedDate)[indexPath.row]
                // 단순히 데이터베이스에 지우기만 하면된다. 그러면 꺼꾸로 데이터베이스에서 지워졌음을 알려준다
                self.planGroup.saveChange(plan: plan, action: .Delete)
            })
            
            
            alertController.addAction(cancelAction)
            alertController.addAction(deleteAction)
            present(alertController, animated: true, completion: nil) //여기서 waiting 하지 않는다
        }
    }
    
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to
                    destinationIndexPath: IndexPath) {
        // 이것은 데이터베이스에 까지 영향을 미치지 않는다. 그래서 planGroup에서만 위치 변경
        let from = planGroup.getPlans(date:selectedDate)[sourceIndexPath.row]
        let to = planGroup.getPlans(date:selectedDate)[destinationIndexPath.row]
        planGroup.changePlan(from: from, to: to)
        tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
    }
}

extension PlanGroupViewController{ // PlanGroupViewController.swift
    // prepare함수에서 PlanDetailViewController에게 전달한다
    func saveChange(plan: Plan?){
        if planGroupTableView.indexPathForSelectedRow != nil{
            planGroup.saveChange(plan: plan!, action: .Modify)
        }else{
            // 이경우는 나중에 사용할 것이다.
            planGroup.saveChange(plan: plan!, action: .Add)
        }
    }
}


extension PlanGroupViewController{ // PlanGroupViewController.swift
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowPlan"{
            let planDetailViewController = segue.destination as! PlanDetailViewController
            
            planDetailViewController.saveChangeDelegate = saveChange
            planDetailViewController.plan = planGroup.getPlans(date:selectedDate)[planGroupTableView.indexPathForSelectedRow!.row].clone()
            
            
            
        }
        if segue.identifier == "AddPlan"{
            
            let planDetailViewController = segue.destination as! PlanDetailViewController
            planDetailViewController.saveChangeDelegate = saveChange
            
            // 빈 plan을 생성하여 전달한다
            planDetailViewController.plan = Plan(date:nil, withData: false)
            planGroupTableView.selectRow(at: nil, animated: true, scrollPosition: .none)
            print("AddPlan@@")
            
            
        }
    }
}


extension PlanGroupViewController{
    @IBAction func editingPlans1(_ sender: UIBarButtonItem) {
        if planGroupTableView.isEditing == true{
            planGroupTableView.isEditing = false
            //sender.setTitle("Edit", for: .normal)
            sender.title = "-"
        }else{
            planGroupTableView.isEditing = true
            //sender.setTitle("Done", for: .normal)
            sender.title = "저장"
        }
        
    }
}


extension PlanGroupViewController{
    @IBAction func addingPlans1(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "AddPlan", sender: self)
        print("addplan2")
    }
    
}

extension PlanGroupViewController: FSCalendarDelegate, FSCalendarDataSource,FSCalendarDelegateAppearance {
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        // 날짜가 선택되면 호출된다
        selectedDate = date
        planGroup.queryData(date: date)
    }
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
        // 스와이프로 월이 변경되면 호출된다
        selectedDate = calendar.currentPage
        planGroup.queryData(date: calendar.currentPage)
    }
    // 이함수를 fsCalendar.reloadData()에 의하여 모든 날짜에 대하여 호출된다.
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        
        let plans = planGroup.getPlans(date:date)
        if plans.count > 0 {
            
            return "\(plans.count)명" // date에 해당한 plans의 갯수를 뱃지로 출력한다
        }
        return nil
    }
    
    
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillDefaultColorFor date: Date) -> UIColor? {
        
        
        let plans = planGroup.getPlans(date:date)
        if plans.count > 0 {
            return  UIColor(displayP3Red: 10/255, green: 96/255, blue: 255/255, alpha: 1)
        }
       
        
        return nil
        
    }
    
    
}



