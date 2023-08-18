//
//  TimeTableViewCell.swift
//  TimeModule
//
//  Created by PGK Shiva Kumar on 24/11/22.
//

import UIKit

class TimeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cellBGView: UIView!
    @IBOutlet weak var fromTimeLabel: UILabel!
    @IBOutlet weak var taskLabel: UILabel!
    @IBOutlet weak var toTimeLabel: UILabel!
    @IBOutlet weak var timeStatusImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCell()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupCell() {
        
        if let backGround = cellBGView {
            self.customView(incomingView: backGround) { (backGround) in
                backGround.styleWithShadow()
            }
        }
        if let status = timeStatusImageView {
            status.layer.cornerRadius = status.layer.frame.size.height / 2
        }
        applyTextStyle()
        self.selectionStyle = .none
    }
    
    private func applyTextStyle() {
        
        if let title = taskLabel {
            self.customView(incomingView: title) { (titleLabel) in
                if let titleLabelText = titleLabel as? UILabel{
                    titleLabelText.showStyle(with: .content, color: .black)
                }else{
                    title.showStyle(with: .content, color: .black)
                }
            }
        }
        if let dateAndTime = toTimeLabel {
            dateAndTime.showStyle(with: .meta, weight: .regular, color: .darkGray)
        }
        if let dateAndTime = fromTimeLabel {
            dateAndTime.showStyle(with: .meta, weight: .regular, color: .darkGray)
        }
    }
    
    func configureCell(time: TimeDataModel) {
        
        if let title = taskLabel {
            title.text = time.name ?? "Not Available"
        }
        if let dateAndTime = toTimeLabel {
            dateAndTime.text = time.to ?? "Not Available"
        }
        if let dateAndTime = fromTimeLabel {
            dateAndTime.text = time.from ?? "Not Available"
        }
        if let statusImage = timeStatusImageView {
            statusImage.image = UIImage(systemName: FunctionsHelper.sharedInstance.getCustomImage(customImage: .circlefill)) ?? UIImage()
            if let statusString = time.datastatus?.lowercased(){
                switch statusString {
                case "active" , "live":
                    statusImage.tintColor = .systemGreen
                case "complete":
                    statusImage.tintColor = .systemBlue
                case "draft":
                    statusImage.tintColor = .systemYellow
                case "error":
                    statusImage.tintColor = .systemRed
                case "inactive":
                    statusImage.tintColor = .systemGray
                case "queue":
                    statusImage.tintColor = .systemPurple
                default:
                    break
                }
            }else{
                statusImage.tintColor = .systemTeal
            }
        }
    }
}

private extension TimeTableViewCell {
    
    private func customView(incomingView: UIView , completionHandler: (UIView) -> Void){
        completionHandler(incomingView)
    }
}
