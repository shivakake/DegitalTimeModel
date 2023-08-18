//
//  TimeViewController.swift
//  TimeModule
//
//  Created by PGK Shiva Kumar on 24/11/22.
//

import UIKit

class TimeViewController: UIViewController {
    
    @IBOutlet weak var datePickerView: FunctionalDateView!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var timeListTableView: UITableView!
    @IBOutlet weak var noDataFoundLabel: UILabel!
    
    let timeLogic : TimeLogic = TimeLogic()
    let functionalDatePicker = FunctionalDateView()
    var todayDate = ""
    let alert = CommonAlert()
    var selectedDate = Date()
    var maximumDate = Date()
    var timeDuration : Double?
    var deletableTime: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationButtons()
        navigationItem.title = "Time"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if timeLogic.timeListArray.count == 0{
            totalTimeLabel.text = "00.00"
        }else{
        }
    }
    
    private func setupUI() {
        searchBar.delegate = self
        setupListTableView()
        getTimesListFromAPI()
        noDataFoundLabel.isHidden = true
        noDataFoundLabel.showStyle(with: .content, color: .systemGray)
        setupFunctionalDatePicker()
    }
    
    func setupFunctionalDatePicker() {
        datePickerView.controller = self
        datePickerView.setDateRange(selectedDate: selectedDate, minimumDate: nil, maximumDate: maximumDate, hideDoneButton: true)
        
        datePickerView.onUpdateDate = { [weak self] selectedDate in
            guard let _self = self else { return }
            _self.selectedDate = selectedDate
            _self.getTimesListFromAPI()
        }
    }
    
    private func setupListTableView() {
        timeListTableView.register(UINib(nibName: "TimeTableViewCell", bundle: Bundle(for: TimeTableViewCell.self)), forCellReuseIdentifier: "TimeTableViewCell")
        timeListTableView.dataSource = self
        timeListTableView.delegate = self
        timeListTableView.separatorStyle = .none
    }
    
    private func setNavigationButtons() {
        let plusButttonImage = UIImage(systemName: FunctionsHelper.sharedInstance.getCustomImage(customImage: .plus))
        let newNoteBarButtonItem = UIBarButtonItem(image: plusButttonImage, style: UIBarButtonItem.Style.plain, target: self, action: #selector(newTimeBarButtonTapped(_:)))
        navigationItem.rightBarButtonItems = [newNoteBarButtonItem]
    }
    
    @objc func newTimeBarButtonTapped(_ sender: UIButton) {
        let controller = AddTimeViewController(timeModel: nil, timeLogic: self.timeLogic, delegate: self)
        // Here how to get status without hitting list api , if user went to add
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    private func getTimesListFromAPI() {
        alert.callLoadermethod(view: self.view)
        timeLogic.delegate = self
        let strDate = selectedDate.getFormattedStringFromDate(format: "yyyy-MM-dd")
        timeLogic.getTimesList(toDate: strDate, fromDate: strDate, text: "")
    }
}

extension TimeViewController: UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return timeLogic.timeListArray.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = timeListTableView.dequeueReusableCell(withIdentifier: "TimeTableViewCell", for: indexPath) as? TimeTableViewCell{
            cell.configureCell(time: timeLogic.timeListArray[indexPath.row])
            return cell
        }
        return UITableViewCell()
    }
    
    
}
extension TimeViewController : UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let controller = TimeDetailsViewController(nibName: "TimeDetailsViewController", bundle:nil)
        controller.delegate = self
        controller.timeLogic = self.timeLogic
        self.timeLogic.delegate = self
        if let time = timeLogic.timeListArray[indexPath.row].duration {
            guard let deleteDouble = Double(time) else { return }
            self.deletableTime = deleteDouble
        }
        timeLogic.getTimeDetails(timeId: timeLogic.timeListArray[indexPath.row].id)
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension TimeViewController : UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //        self.timeLogic.getTimesList(toDate: "", fromDate: "", text: searchText)
        getTimesListFromAPI()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension TimeViewController : TimeLogicDelegate {
    
    func getTimeList() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.alert.removeLoaderMethod()
            weakSelf.noDataFoundLabel.isHidden = !weakSelf.timeLogic.timeListArray.isEmpty
            weakSelf.timeListTableView.reloadData()
            weakSelf.totalTimeLabel.text = weakSelf.timeLogic.displayTotalTimeDuration
        }
    }
    
    func getTimeDetails(timeModel: TimeDataModel?) {
        if timeModel == nil {
            showAlert("No Time Details Found !")
        }else {
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                let controller = TimeDetailsViewController(nibName: "TimeDetailsViewController", bundle:nil)
                controller.timeModel = timeModel
                controller.delegate = self
                controller.timeLogic = weakSelf.timeLogic
                weakSelf.timeLogic.delegate = self
                weakSelf.navigationController?.pushViewController(controller, animated: true)
            }
        }
    }
    
    func timeStatusChangeForQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.timeListTableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        }
    }
    
    func updateDeleteTimeSuccess(status: Int?, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            if status == 1{
                weakSelf.timeListTableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
                weakSelf.totalTimeLabel.text = weakSelf.timeLogic.displayTotalTimeDuration
            } else {
                weakSelf.timeListTableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
            }
        }
    }
    
    func updateTimeStatusChange(dataStatus: String, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.timeListTableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        }
    }
    
    
    func addNewTimeInQueue() {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.noDataFoundLabel.isHidden = true
            let indexpath = IndexPath(row: 0, section: 0)
            weakSelf.timeListTableView.beginUpdates()
            weakSelf.timeListTableView.insertRows(at: [indexpath], with: .automatic)
            weakSelf.timeListTableView.endUpdates()
            
        }
    }
    //    func addNewTimeInQueue(duration: Double) {
    //        guard let timeFromUI = self.totalTimeLabel.text else { return }
    //        let addingTimeString = timeFromUI.replacingOccurrences(of: ":", with: ".")
    //        guard let addingTimeDouble = Double(addingTimeString) else { return }
    //        let totalDuration = addingTimeDouble + duration
    //        let finalDuration = String(format: "%.2f", totalDuration)
    //        DispatchQueue.main.async { [weak self] in
    //            guard let weakSelf = self else { return }
    //            weakSelf.totalTimeLabel.text = finalDuration
    //            weakSelf.noDataFoundLabel.isHidden = true
    //            let indexpath = IndexPath(row: 0, section: 0)
    //            weakSelf.timeListTableView.beginUpdates()
    //            weakSelf.timeListTableView.insertRows(at: [indexpath], with: .automatic)
    //            weakSelf.timeListTableView.endUpdates()
    //        }
    //    }
    
    
    //    func updateAddTimeSuccess(status: Int, index: Int) {
    //        let indexpath = IndexPath(row: index, section: 0)
    //        DispatchQueue.main.async { [weak self] in
    //            guard let weakSelf = self else { return }
    //
    //            if status == 1 {
    //                weakSelf.timeListTableView.reloadRows(at: [indexpath], with: .automatic)
    //
    ////                guard let timeFromUI = weakSelf.totalTimeLabel.text else { return }
    ////                let totalTimeString = timeFromUI.replacingOccurrences(of: ":", with: ".")
    ////                guard let totalTimeDouble = Double(totalTimeString) else { return }
    ////                let finalTime = totalTimeDouble + duration
    ////                let finalDuration = String(format: "%.2f", finalTime)
    ////                weakSelf.totalTimeLabel.text = finalDuration
    //                weakSelf.totalTimeLabel.text = weakSelf.timeLogic.displayTotalTimeDuration
    //
    //            } else {
    //                weakSelf.timeListTableView.deleteRows(at: [indexpath], with: .automatic)
    //                weakSelf.noDataFoundLabel.isHidden = !weakSelf.timeLogic.timeListArray.isEmpty
    //            }
    //        }
    //    }
    
    func updateAddTimeSuccess(status: Int, index: Int) {
        let indexpath = IndexPath(row: index, section: 0)
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            if status == 1 {
                weakSelf.timeListTableView.reloadRows(at: [indexpath], with: .automatic)
                weakSelf.totalTimeLabel.text = weakSelf.timeLogic.displayTotalTimeDuration
            } else {
                weakSelf.timeListTableView.deleteRows(at: [indexpath], with: .automatic)
                weakSelf.noDataFoundLabel.isHidden = !weakSelf.timeLogic.timeListArray.isEmpty
            }
        }
    }
    
    func editTimeInQueue(timeModel: TimeDataModel?, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            let indexPath = IndexPath(row: index, section: 0)
            weakSelf.timeLogic.timeListArray[index].name = timeModel?.name
            weakSelf.timeLogic.timeListArray[index].created = timeModel?.created
            weakSelf.timeLogic.timeListArray[index].datastatus = timeModel?.datastatus
            weakSelf.timeListTableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
    
    func updateEditTimeSuccess(dataStatus: String, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.timeLogic.timeListArray[index].datastatus = dataStatus
            weakSelf.timeListTableView.reloadRows(at: [IndexPath(item: index, section: 0)], with: .automatic)
        }
    }
    
    func getTimeAccountsListStatus(status: Int?) { }
    
    func showPoorInternet() { }
    
}
/*
 func addNewTimeInQueue() {
 DispatchQueue.main.async { [weak self] in
 guard let weakSelf = self else { return }
 weakSelf.noDataFoundLabel.isHidden = true
 let indexpath = IndexPath(row: 0, section: 0)
 weakSelf.timeListTableView.beginUpdates()
 weakSelf.timeListTableView.insertRows(at: [indexpath], with: .automatic)
 weakSelf.timeListTableView.endUpdates()
 
 weakSelf.getTimesListFromAPI()
 }
 }
 */
/*
 @IBAction func selectDateButton(_ sender: Any) {
 let datePicker = HomeDatePickerView()
 datePicker.getSelectedDate = { [weak self] selectedDate in
 guard let weakSelf = self else { return }
 //MARK: For the view perpous date format is dd-MMM-yyyy , for logic yyyy-MM-dd
 
 weakSelf.todayDate = selectedDate.getFormattedStringFromDate(format: "yyyy-MM-dd")
 weakSelf.getTimesListFromAPI()
 }
 addViewThroughConstraints(for: datePicker, in: view)
 }
 
 @IBAction func previousDateButtonTapped(_ sender: Any) {
 let now = Calendar.current.dateComponents(in: .current, from: Date())
 
 // Create the start of the day in `DateComponents` by leaving off the time.
 let today = DateComponents(year: now.year, month: now.month, day: now.day)
 let dateToday = Calendar.current.date(from: today)!
 print(dateToday.timeIntervalSince1970)
 
 // Add 1 to the day to get tomorrow.
 // Don't worry about month and year wraps, the API handles that.
 let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! - 1)
 let dateYesterday = Calendar.current.date(from: tomorrow)!
 self.todayDate = dateYesterday.getFormattedStringFromDate(format: "yyyy-MM-dd")
 self.getTimesListFromAPI()
 }
 
 @IBAction func nextDateButtonTapped(_ sender: Any) {
 
 let now = Calendar.current.dateComponents(in: .current, from: Date())
 
 // Create the start of the day in `DateComponents` by leaving off the time.
 let today = DateComponents(year: now.year, month: now.month, day: now.day)
 let dateToday = Calendar.current.date(from: today)!
 print(dateToday.timeIntervalSince1970)
 
 // Add 1 to the day to get tomorrow.
 // Don't worry about month and year wraps, the API handles that.
 let tomorrow = DateComponents(year: now.year, month: now.month, day: now.day! + 1)
 let dateTomorrow = Calendar.current.date(from: tomorrow)!
 self.todayDate = dateTomorrow.getFormattedStringFromDate(format: "yyyy-MM-dd")
 self.getTimesListFromAPI()
 print(dateTomorrow.timeIntervalSince1970)
 }
 */
