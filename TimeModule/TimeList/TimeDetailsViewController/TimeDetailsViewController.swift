//
//  TimeDetailsViewController.swift
//  TimeModule
//
//  Created by PGK Shiva Kumar on 24/11/22.
//

import UIKit

class TimeDetailsViewController: UIViewController {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var startTimelabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var accountLabel: UILabel!
    @IBOutlet weak var timeStatusImageView: UIImageView!
    @IBOutlet weak var createdDateLabel: UILabel!
    @IBOutlet weak var updatedDateLabel: UILabel!
    @IBOutlet var subTitlesLabel: [UILabel]!
    @IBOutlet weak var taskNameLabel: UILabel!
    
    var timeLogic : TimeLogic?
    var timeModel : TimeDataModel?
    weak var delegate : TimeLogicDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        applyStylesToLabels()
        updateUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationItem.title = "Times Details"
        timeLogic?.delegate = self
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func updateUI() {
        dateLabel.text = timeModel?.date
        startTimelabel.text = timeModel?.from
        endTimeLabel.text = timeModel?.to
        durationLabel.text = timeModel?.duration
        accountLabel.text = timeModel?.accountname
        taskNameLabel.text = timeModel?.name
        setStatusNavigation(status: timeModel?.datastatus?.lowercased() ?? "active")
    }
    
    func applyStylesToLabels() {
        
        dateLabel.showStyle(with: .content)
        startTimelabel.showStyle(with: .content)
        endTimeLabel.showStyle(with: .content)
        durationLabel.showStyle(with: .content)
        accountLabel.showStyle(with: .content)
        createdDateLabel.showStyle(with: .meta)
        updatedDateLabel.showStyle(with: .meta)
        taskNameLabel.showStyle(with: .largeTitle)
        for lable in subTitlesLabel{
            lable.showStyle(with: .small, weight: .regular, color: .darkGray)
        }
    }
    
    func goToEditPage() {
        let controller = AddTimeViewController(timeModel: timeModel, timeLogic: timeLogic, delegate: self)
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func setStatusNavigation(status: String){
        
        var moreBarButtonItem = UIBarButtonItem()
        
        let moreImage = FunctionsHelper.sharedInstance.getCustomImage(customImage: .ellipsis)
        
        let editAction = UIAction(title: "Edit", image: UIImage(systemName: FunctionsHelper.sharedInstance.getCustomImage(customImage: .squareandpencil))) { [unowned self] _ in
            goToEditPage()
        }
        
        let draftAction = UIAction(title: "Draft", image: UIImage(systemName: FunctionsHelper.sharedInstance.getCustomImage(customImage: .envelopeopen))) { [unowned self] _ in
            timeLogic?.draftTime(timeId: timeModel?.id ?? "")
        }
        
        let completeAction = UIAction(title: "Complete", image: UIImage(systemName: FunctionsHelper.sharedInstance.getCustomImage(customImage: .docbadgeellipsis))) { [unowned self] _ in
            timeLogic?.completeTime(timeId: timeModel?.id ?? "")
        }
        
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: FunctionsHelper.sharedInstance.getCustomImage(customImage: .binxmark))) { [unowned self] _ in
            timeLogic?.delegate = delegate
            if let duration = timeModel?.duration {
                let durationStr = duration.replacingOccurrences(of: ":", with: ".")
                guard let durationDouble = Double(durationStr) else { return }
                timeLogic?.deleteTime(timeId: timeModel?.id ?? "" , duration: durationDouble)
            }
            navigationController?.popViewController(animated: true)
        }
        
        let approveAction = UIAction(title: "Approve", image: UIImage(systemName: FunctionsHelper.sharedInstance.getCustomImage(customImage: .checkmarkcircle))) { [unowned self] _ in
            timeLogic?.approveTime(timeId: timeModel?.id ?? "")
        }
        
        switch status.lowercased() {
        
        case "active" ,"live":
            timeStatusImageView.tintColor = .systemGreen
            moreBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: moreImage), primaryAction: nil, menu: UIMenu(title: "", children: [editAction , draftAction , completeAction , deleteAction]))
            
        case "draft" :
            timeStatusImageView.tintColor = .systemYellow
            moreBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: moreImage), primaryAction: nil, menu: UIMenu(title: "", children: [editAction , deleteAction , approveAction]))
            
        case "complete" :
            timeStatusImageView.tintColor = .systemBlue
            moreBarButtonItem = UIBarButtonItem(title: "", image: UIImage(systemName: moreImage), primaryAction: nil, menu: UIMenu(title: "", children: [approveAction]))
            
        case "inactive" :
            timeStatusImageView.tintColor = .systemGray
            
        case "error" :
            timeStatusImageView.tintColor = .systemRed
            
        case "queue" :
            timeStatusImageView.tintColor = .systemPurple
            
        default:
            break
        }
        navigationItem.rightBarButtonItems = [moreBarButtonItem]
    }
}


extension TimeDetailsViewController : TimeLogicDelegate {

    func timeStatusChangeForQueue(index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.setStatusNavigation(status: "queue")
            weakSelf.delegate?.timeStatusChangeForQueue(index: index)
        }
    }
    
    func getTimeDetails(timeModel: TimeDataModel?) {
        self.timeModel = timeModel
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.updateUI()
        }
    }
    
    func updateTimeStatusChange(dataStatus: String, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.setStatusNavigation(status: dataStatus)
            weakSelf.delegate?.updateTimeStatusChange(dataStatus: dataStatus, index: index)
        }
    }
    
    func editTimeInQueue(timeModel: TimeDataModel?, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.dateLabel.text = timeModel?.date
            weakSelf.startTimelabel.text = timeModel?.from
            weakSelf.endTimeLabel.text = timeModel?.to
            weakSelf.durationLabel.text = timeModel?.duration
            weakSelf.accountLabel.text = timeModel?.accountname
            weakSelf.taskNameLabel.text = timeModel?.name
            weakSelf.setStatusNavigation(status: "queue")
            weakSelf.delegate?.editTimeInQueue(timeModel: timeModel, index: index)
        }
    }
    
    func updateEditTimeSuccess(dataStatus: String, index: Int) {
        DispatchQueue.main.async { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.setStatusNavigation(status: dataStatus)
            weakSelf.delegate?.updateEditTimeSuccess(dataStatus: dataStatus, index: index)
        }
    }
    
    func showPoorInternet() { }
    
    func updateDeleteTimeSuccess(status: Int?, index: Int) { }
    
    func getTimeAccountsListStatus(status: Int?) { }
    
    func getTimeList() { }
    
    func addNewTimeInQueue(duration: Double) { }
    func addNewTimeInQueue() { }
    
    func updateAddTimeSuccess(status: Int, index: Int, duration: Double) { }
    func updateAddTimeSuccess(status: Int, index: Int) { }
}
