//
//  DatePickerViewController.swift
//  WenoiUI
//
//  Created by Roushil Singla on 30/11/22.
//

import UIKit

class DatePickerViewController: UIViewController {

    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet public weak var datePickerView: UIDatePicker!
    
    public var getSelectedDate: ((Date) -> Void)?
    public var onDismissView: (() -> Void)?
    let style = StyleLibrary()
    
    var selectedDate = Date()
    var maximumDate: Date?
    var minimumDate: Date?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: "DatePickerViewController", bundle: Bundle(for: DatePickerViewController.self))
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datePickerView.maximumDate = Date()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        datePickerView.tintColor = style.appColor
        saveButton.showStyle(with: .content, textColor: .white, bgColor: style.appColor, needCircularCorners: true)
    }
    
    @IBAction func onSaveButtonTapped(_ sender: UIButton) {
        getSelectedDate?(datePickerView.date)
        dismiss(animated: true)
    }

    public func setDateRange(selectedDate: Date?, minimumDate: Date?, maximumDate: Date?) {
        self.selectedDate = selectedDate ?? Date()
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
    }
}
