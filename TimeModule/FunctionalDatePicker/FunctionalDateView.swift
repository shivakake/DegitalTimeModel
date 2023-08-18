//
//  FunctionalDateView.swift
//  WenoiUI
//
//  Created by Roushil Singla on 30/11/22.
//

import UIKit

public class FunctionalDateView: UIView {

    enum DateShiftRange {
        case previous, next
    }
    
    @IBOutlet weak var dateButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    
    var selectedDate = Date()
    var maximumDate: Date?
    var minimumDate: Date?
    
    var isDoneButtonHidden = true
    var dateFormatForUserView = "dd-MMM-yy"
    var dateFormatToCompare = "yyyyMMdd"
    
    public var onUpdateDate: ((Date) -> Void)?
    
    public weak var controller: UIViewController?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        let bundle = Bundle.init(for: FunctionalDateView.self)
        if let viewsToAdd = bundle.loadNibNamed("FunctionalDateView", owner: self, options: nil),
            let contentView = viewsToAdd.first as? UIView {
            addSubview(contentView)
            contentView.frame = self.bounds
            contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        }
    }

    @IBAction func onDateClicked(_ sender: UIButton) {
        let datePicker = DatePickerViewController()
        datePicker.setDateRange(selectedDate: selectedDate, minimumDate: maximumDate, maximumDate: minimumDate)
        datePicker.getSelectedDate = { [weak self] pickerDate in
            guard let _self = self else { return }
            _self.selectedDate = pickerDate
            _self.dateButton.setTitle("  " + pickerDate.getFormattedStringFromDate(format: _self.dateFormatForUserView), for: .normal)
            _self.handleArrowForDates()
            if _self.isDoneButtonHidden {
                _self.onUpdateDate?(pickerDate)
            }
        }
        
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: datePicker)
        presentationController.sourceView = dateButton
        presentationController.sourceRect = dateButton.bounds
        presentationController.permittedArrowDirections = [.down, .up, .left, .right]
        controller?.present(datePicker, animated: true)
    }
    
    @IBAction func onLeftArrowClicked(_ sender: UIButton) {
        updateDateRange(moveTo: .previous)
    }
    
    @IBAction func onRightArrowClicked(_ sender: UIButton) {
        updateDateRange(moveTo: .next)
    }
    
    @IBAction func onDoneClicked(_ sender: UIButton) {
        onUpdateDate?(selectedDate)
    }
    
    public func setDateRange(selectedDate: Date?, minimumDate: Date?, maximumDate: Date?, hideDoneButton: Bool, formatForComparingDate: String = "yyyyMMdd") {
        self.selectedDate = selectedDate ?? Date()
        self.minimumDate = minimumDate
        self.maximumDate = maximumDate
        dateButton.setTitle("  " + self.selectedDate.getFormattedStringFromDate(format: dateFormatForUserView), for: .normal)
        doneButton.isHidden = hideDoneButton
        isDoneButtonHidden = hideDoneButton
        dateFormatToCompare = formatForComparingDate
        handleArrowForDates()
    }
    
    func handleArrowForDates() {
        
        rightButton.isEnabled = true
        leftButton.isEnabled = true
        
        let strSelectedDate = selectedDate.getFormattedStringFromDate(format: dateFormatToCompare)
        let strMaxDate = maximumDate?.getFormattedStringFromDate(format: dateFormatToCompare)
        let strMinDate = minimumDate?.getFormattedStringFromDate(format: dateFormatToCompare)
        
        
        if strSelectedDate == strMaxDate {
            rightButton.isEnabled = false
        }
        if strSelectedDate == strMinDate {
            leftButton.isEnabled = false
        }
    }
    
    private func updateDateRange(moveTo range: DateShiftRange) {
        var components = DateComponents()
        components.day = range == .previous ? -1 : 1
        let date = Calendar.current.startOfDay(for: selectedDate)
        let changedDate = Calendar.current.date(byAdding: components, to: date)
        selectedDate = changedDate ?? Date()
        dateButton.setTitle("  " + selectedDate.getFormattedStringFromDate(format: dateFormatForUserView), for: .normal)
        handleArrowForDates()
        if isDoneButtonHidden {
            onUpdateDate?(selectedDate)
        }
    }
}
