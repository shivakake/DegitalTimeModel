//
//  AddTimeViewController.swift
//  TimeModule
//
//  Created by PGK Shiva Kumar on 24/11/22.
//

import UIKit

class AddTimeViewController: UIViewController {
    
    @IBOutlet weak var selectDateButton: UIButton!
    @IBOutlet weak var fromTimeButton: UIButton!
    @IBOutlet weak var toTimeButton: UIButton!
    @IBOutlet weak var taskNameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var scrollViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet var subTitlesLabels: [UILabel]!
    @IBOutlet weak var selectAccountView: UIView!
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    var timeModel : TimeDataModel?
    var timeLogic : TimeLogic?
    weak var delegate : TimeLogicDelegate?
    var listAPIStatus = 0
    let dateFormatter = DateFormatter()
    let timePicker = UIDatePicker()
    var timeFrom = ""
    let alert = CommonAlert()
    
    init(timeModel : TimeDataModel? , timeLogic : TimeLogic? , delegate :TimeLogicDelegate?) {
        self.timeModel = timeModel
        self.timeLogic = timeLogic
        self.delegate = delegate
        super.init(nibName: "AddTimeViewController", bundle: Bundle(for: AddTimeViewController.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(nibName: "AddTimeViewController", bundle: Bundle(for: AddTimeViewController.self))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStylesToLabels()
        assignValueToUI()
        configureTextFields()
        configureKeyBoardNotifications()
        setupUI()
        getTimeAccountsListAPI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func getTimeAccountsListAPI(){
        alert.callLoadermethod(view: self.view)
        timeLogic?.delegate = self
        timeLogic?.getTimeAccountsList()
    }
    
    func applyStylesToLabels() {
        
        taskNameTextField.showStyle(with: .content)
        descriptionTextView.showStyle(with: .content)
        for lable in subTitlesLabels{
            lable.showStyle(with: .small, color: .darkGray)
        }
        doneButton.showStyle(with: .subtitle,textColor: .white,bgColor: .black, needCircularCorners: true)
    }
    
    private func assignValueToUI(){
        if timeModel != nil{
            navigationItem.title = "Edit"
            fromTimeButton.setTitle(timeModel?.from, for: .normal)
            toTimeButton.setTitle(timeModel?.to, for: .normal)
            selectDateButton.setTitle(timeModel?.date, for: .normal)
            descriptionTextView.text = timeModel?.description
            taskNameTextField.text = timeModel?.name
        }else{
            navigationItem.title = "Add"
        }
    }
    
    private func configureKeyBoardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func configureTextFields(){
        taskNameTextField.delegate = self
        descriptionTextView.delegate = self
    }
    
    private func setupUI() {
        self.selectAccountView.isHidden = true
        let viewDate = Date().getFormattedStringFromDate(format: GlobalStrings.sharedInstance.dateFormatForUI)
        selectDateButton.setTitle(viewDate, for: .normal)
    }
    
    @IBAction func selectdateButtonTapped(_ sender: UIButton) {
        let datePicker = HomeDatePickerView()
        dateFormatter.dateFormat = GlobalStrings.sharedInstance.dateFormatForUI
        datePicker.getSelectedDate = { [weak self] selectedDate in
            guard let weakSelf = self else { return }
            let dateString = weakSelf.dateFormatter.string(from: selectedDate)
            weakSelf.selectDateButton.setTitle(dateString, for: .normal)
        }
        addViewThroughConstraints(for: datePicker, in: view)
    }
    
    @IBAction func formTimeButtonTapped(_ sender: UIButton) {
        showTimePicker(fromTimeButton)
    }
    
    @IBAction func toTimeButtonTapped(_ sender: UIButton) {
        showTimePicker(toTimeButton)
    }
    
    @IBAction func doneButtinTapped(_ sender : UIButton) {
        let name = taskNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
        let descriptionString = descriptionTextView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        let from = fromTimeButton.titleLabel?.text
        let to = toTimeButton.titleLabel?.text
        
        guard let date = selectDateButton.titleLabel?.text else { return }
        let finalDate = formattedDateFromString(dateString: date, withFormat: GlobalStrings.sharedInstance.dateFormatForAPI)
        timeLogic?.delegate = delegate
        
        if timeModel != nil {
            timeModel?.name = name
            timeModel?.description = descriptionString
            timeModel?.from = from
            timeModel?.date = finalDate
//            timeLogic?.editTimeDetails(name: name, description: descriptionString, from: from, to: to, date: date, timeId: timeModel?.id)
            timeLogic?.editTimeDetails(model: timeModel, timeId: timeModel?.id)
        } else {
            if name.count == 0{
                showAlert("Enter name for add time")
            }else{
                if descriptionString.count == 0{
                    showAlert("Enter Description for add time")
                }else{
                    if from == "From" {
                        showAlert("Enter from time for add time")
                    }else{
                        if to == "To" {
                            showAlert("Enter to time for add time")
                        }else{
                            timeLogic?.addNewTime(name: name, description: descriptionString, from: from, to: to, date: finalDate)
                        }
                    }
                }
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func keyBoardWillShow(notification : Notification) {
        
        if let keyBoardFrame : NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyBoardHeight = keyBoardFrame.cgRectValue.height
            self.scrollViewBottomConstraint.constant = keyBoardHeight
        }
    }
    
    @objc private func keyBoardWillHide() {
        scrollViewBottomConstraint.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func selectAccountButtonTapped(_ sender: UIButton) {
        print("select Account Button Tapped")
    }
    
    func showTimePicker(_ incomingButton: UIButton) {
        self.view.endEditing(true)
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        showActionSheetWithCustomView(alertTitle: "Schedule Time", customView: datePicker, actionTitle: "Done", prefferedActionStyle: UIAlertController.Style.actionSheet, iPadPopupSourceView: incomingButton, customViewHeight: 200, alertHeight: 320) {
            let strTime = datePicker.date.getFormattedStringFromDate(format: "hh:mm")
            incomingButton.setTitle(strTime, for: .normal)
        }
    }
    
    func formattedDateFromString(dateString: String, withFormat format: String) -> String? {
        
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "dd-MMM-yyyy"
        
        if let date = inputFormatter.date(from: dateString) {
            
            let outputFormatter = DateFormatter()
            outputFormatter.dateFormat = format
            
            return outputFormatter.string(from: date)
        }
        
        return nil
    }
}

extension AddTimeViewController: UITextViewDelegate {
    
    public func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach { (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return range.location <= 10000
    }
}

extension AddTimeViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location <= 100
    }
    
}

extension AddTimeViewController : TimeLogicDelegate {
    
    
    
    
    func getTimeAccountsListStatus(status: Int?) {
        
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            if status == 0 { 
                weakSelf.selectAccountView.isHidden = true
            } else {
                weakSelf.selectAccountView.isHidden = false
            }
            weakSelf.alert.removeLoaderMethod()
        }
    }

    func getTimeList() { }
    
    func getTimeDetails(timeModel: TimeDataModel?) { }
    
    func addNewTimeInQueue(duration: Double) { }
    func addNewTimeInQueue() { }
    
    func updateTimeStatusChange(dataStatus: String, index: Int) { }
    
    func updateAddTimeSuccess(status: Int, index: Int, duration: Double) { }
    func updateAddTimeSuccess(status: Int, index: Int) { }
    
    func editTimeInQueue(timeModel: TimeDataModel?, index: Int) { }
    
    func updateEditTimeSuccess(dataStatus: String, index: Int) { }
    
    func timeStatusChangeForQueue(index: Int) { }
    
    func updateDeleteTimeSuccess(status: Int?, index: Int) { }
    
    func showPoorInternet() { }
}
