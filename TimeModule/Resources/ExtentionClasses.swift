//
//  ExtentionClasses.swift
//  DigitalHorizonTaksThree
//
//  Created by PGK Shiva Kumar on 30/08/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// This function will present an alert with custom view inside it
    /// - Warning: The difference between customViewHeight and alertHeight  should be 120 for proper alignment (customViewHeight < alertHeight)
    /// - Parameter alertTitle: The title of an Alert
    /// - Parameter customView: The customView that has to be shown inside alert
    /// - Parameter actionTitle: The name of alert action
    /// - Parameter prefferedActionStyle: The style of an alert
    /// - Parameter iPadPopupSourceView: (for iPad) Selected view where popup will point at
    /// - Parameter iPadPopupButton: (for iPad) Selected bar button where popup will point at
    /// - Parameter customViewHeight: Height of the custom view (Default 330)
    /// - Parameter alertHeight: Height of an alert (Default 450)
    
    func showActionSheetWithCustomView(alertTitle: String, customView: UIView, actionTitle: String, prefferedActionStyle: UIAlertController.Style ,iPadPopupSourceView sourceView: UIView? = UIView(), iPadPopupButton barButton: UIBarButtonItem? = UIBarButtonItem(), customViewHeight: CGFloat? = 330, alertHeight: CGFloat? = 450, onDoneCompletion: (() -> Void)?) {
        
        let alertController = UIAlertController(title: alertTitle, message: nil, preferredStyle: prefferedActionStyle)
        alertController.view.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 45).isActive = true
        customView.rightAnchor.constraint(equalTo: alertController.view.rightAnchor, constant: -5).isActive = true
        customView.leftAnchor.constraint(equalTo: alertController.view.leftAnchor, constant: 5).isActive = true
        let height = Device.isPhone ? customViewHeight! : (customViewHeight! + 5)
        customView.heightAnchor.constraint(equalToConstant: height).isActive = true
        
        alertController.view.translatesAutoresizingMaskIntoConstraints = false
        alertController.view.heightAnchor.constraint(equalToConstant: alertHeight!).isActive = true
        
        if !Device.isPhone {
            alertController.view.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width/1.5).isActive = true
        }
        
        let doneAction = UIAlertAction(title: actionTitle, style: .default) { _ in
            onDoneCompletion?()
        }
        
        let cancelAction = UIAlertAction(title: actionTitle, style: .cancel, handler: { _ in
            onDoneCompletion?()
        })
        
        alertController.addAction(Device.isPhone ? cancelAction: doneAction)
        
        if let popoverController = alertController.popoverPresentationController {
            if sourceView != nil {
                popoverController.sourceView = sourceView
            } else {
                popoverController.barButtonItem = barButton
            }
        }
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    func showAlertToast(message: String, timer: Double = 2) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(timeInterval: timer, target: self, selector: #selector(dismissAlert), userInfo: nil, repeats: false)
    }
    
    @objc func dismissAlert() {
        dismiss(animated: true, completion: nil)
    }
    
    func addViewThroughConstraints(for customView: UIView) {
        view.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        customView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    func addViewThroughConstraints(for customView: UIView, in mainView: UIView) {
        mainView.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        customView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
    }
    
    func showAlert(_ message : String) {
        
        let message = message
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        self.present(alert, animated: true)
        let duration: Double = 2
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + duration) {
            alert.dismiss(animated: true)
        }
    }
    
    func showAlertWithActions(_ alertMessage : String , _ alertTitle : String ){
        let dialogMessage = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: { (action) -> Void in
        })
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
        }
        dialogMessage.addAction(ok)
        dialogMessage.addAction(cancel)
        self.present(dialogMessage, animated: true, completion: nil)
    }
    
    func hideKeyBoardTappedAround(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyBoard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyBoard(){
        view.endEditing(true)
    }
    
    
}

extension UIImageView {
    
    //    func makeImageCircle(_ incomingImage : UIImageView , _ imageBorder : CGFloat? , _ borderColor : UIColor? , _ imageRadius : CGFloat?){
    //        incomingImage.layer.masksToBounds = false
    //        if imageRadius == nil || imageRadius == 0{
    //            self.layer.cornerRadius = self.layer.frame.size.height / 2
    //        }else{
    //            self.layer.cornerRadius = imageRadius ?? 0.0
    //        }
    //        if imageBorder != nil{
    //            incomingImage.layer.borderWidth = imageBorder ?? 0.0
    //            if borderColor != nil{
    //                incomingImage.layer.borderColor = borderColor?.cgColor
    //            }
    //        }
    //        incomingImage.clipsToBounds = true
    //    }
}
extension UIView {
    
    func makeCardView(_ incomingView : UIView){
        incomingView.layer.cornerRadius = 10
        incomingView.layer.shadowColor = UIColor.gray.cgColor
        incomingView.layer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        incomingView.layer.shadowRadius = 4.0
        incomingView.layer.shadowOpacity = 0.5
    }
    
    func makeImageCircle(_ incomingImage : UIImageView , _ imageBorder : CGFloat? , _ borderColor : UIColor? , _ imageRadius : CGFloat?){
        incomingImage.layer.masksToBounds = false
        if imageRadius == nil || imageRadius == 0{
            self.layer.cornerRadius = self.layer.frame.size.height / 2
        }else{
            self.layer.cornerRadius = imageRadius ?? 0.0
        }
        if imageBorder != nil{
            incomingImage.layer.borderWidth = imageBorder ?? 0.0
            if borderColor != nil{
                incomingImage.layer.borderColor = borderColor?.cgColor
            }
        }
        incomingImage.clipsToBounds = true
    }
    
    //    func tapGestureToImage(_ toImage : UIImageView){
    //        let imageTappedGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped(action:)))
    //        toImage.isUserInteractionEnabled = true
    //        toImage.makeImageCircle(toImage, 1, .black, nil)
    //        toImage.contentMode = .scaleToFill
    //        toImage.addGestureRecognizer(imageTappedGesture)
    //    }
    //    @objc func profileImageTapped(action : UITapGestureRecognizer){
    //        let imageTappedAlert = UIAlertController(title: "Choose Profile", message: "", preferredStyle: UIAlertController.Style.alert)
    //        imageTappedAlert.addAction(UIAlertAction(title: "Okay", style: .default, handler: { action in
    //            self.pickerHandlerMethod()
    //        }))
    //        imageTappedAlert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { action in }))
    //        self.present(imageTappedAlert, animated: true, completion: nil)
    //    }
    
    func addViewThroughConstraints(for customView: UIView, in mainView: UIView) {
        mainView.addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
        customView.leadingAnchor.constraint(equalTo: mainView.leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: mainView.trailingAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
    }
}

extension UIButton {
    
    func makeButtonCornerRadius(_ incomingButton : UIButton , incomingRadiusValue : CGFloat?){
        if incomingRadiusValue == nil || incomingRadiusValue == 0{
            incomingButton.layer.cornerRadius = incomingButton.layer.frame.size.height / 2
        }else{
            incomingButton.layer.cornerRadius = incomingRadiusValue ?? 0.0
        }
    }
}

extension UIImage {
    
    func toString() -> String? {
        let pngData = self.pngData()
        //let jpegData = self.jpegData(compressionQuality: 0.75)
        return pngData?.base64EncodedString(options: .lineLength64Characters)
    }
}

//extension UITextView {
//    func letfPadding(_ amount : CGFloat){
//        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
//        self
//    }
//}

extension UITextField {
    
    func leftPadding(_ amount:CGFloat){
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func rightPadding(_ amount:CGFloat) {
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    func setIconToTextField(icon incomingImage : UIImage) {
        
        self.leftViewMode = UITextField.ViewMode.always
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = incomingImage
        imageView.image = image
        imageView.tintColor = .darkGray
        self.leftView = imageView
    }
    
    func allow_MaxCharacters(limit: Int, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        //        if let char = string.cString(using: String.Encoding.utf8) {
        //            let isBackSpace = strcmp(char, "\\b")
        //            if isBackSpace == -92 { //  || isBackSpace == -42 // -92
        //                return true
        //            }
        //        }
        let charsLimit = limit
        let startingLength = self.text!.count //testField.text?.characters.count ?? 0
        let lengthToAdd = string.count
        let lengthToReplace =  range.length
        let newLength = startingLength + lengthToAdd - lengthToReplace
        return newLength <= charsLimit
    }
    
    func allow_Alphabets(shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let set = NSCharacterSet(charactersIn: "ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz ").inverted
        return string.rangeOfCharacter(from: set) == nil
    }
    
    func allow_MobileNumber_withREGEX(text: String) -> Bool {
        
        let isBackSpace = strcmp(text, "\\b")
        if (isBackSpace == -92) {
            return true
        }
        if self.text?.count == 0 {
            if text == "6" || text == "7" || text == "8" || text == "9" {
                return true
            }else {
                return false
            }
        }else if self.text!.count > 9 {
            return false
        }
        return true
    }
    
    func isValidEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9-]+\\.{1}[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self.text)
    }
    
    func isValidMobile(setCount: Int) -> Bool {
        if (self.text?.count)! >= setCount {
            return true
        }else{
            return false
        }
    }
    
    func isValidTF() -> Bool {
        if self.text != nil && self.text != "" {
            return true
        }else{
            return false
        }
    }
    
    func isValidPassword_Regex(minChars: Int, isUppercase: Bool, isLowerCase: Bool, isDigit: Bool, isSymbol: Bool) -> Bool {
        // least one uppercase,
        // least one lowercase
        // least one digit
        // least one symbol
        //  min characters total
        
        let password = self.text!.trimmingCharacters(in: CharacterSet.whitespaces)
        var passwordRegx = ""
        //        passwordRegx = "^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[#?!@$%^&<>*~:`-]).{\(minChars),}$"
        if isUppercase {
            passwordRegx += "(?=.*?[A-Z])"
        }
        if isLowerCase {
            passwordRegx += "(?=.*?[a-z])"
        }
        if isDigit {
            passwordRegx += "(?=.*?[0-9])"
        }
        if isSymbol {
            passwordRegx += "(?=.*?[#?!@$%^&<>*~:`-])"
        }
        
        passwordRegx += ".{\(minChars),}$"
        
        let passwordCheck = NSPredicate(format: "SELF MATCHES %@",passwordRegx)
        return passwordCheck.evaluate(with: password)
        
    }
    
    func getExactString(range: NSRange, string: String) -> String {
        
        if let text = self.text, let textRange = Range(range, in: text) {
            let updatedText = text.replacingCharacters(in: textRange,
                                                       with: string)
            return updatedText
        }else {
            return ""
        }
    }
    
    func allow_below_IntAmount(string: String, amount: Int) -> Bool {
        
        let totalText = self.text!+string
        if let total = Int(totalText) {
            if total <= 100 {
                return true
            }else {
                return false
            }
        }else {
            return false
        }
    }
}

extension UITextField {
    
    @IBInspectable var placeHolderColor: UIColor? {
        get {
            return self.placeHolderColor
        }
        set {
            self.attributedPlaceholder = NSAttributedString(string:self.placeholder != nil ? self.placeholder! : "", attributes:[NSAttributedString.Key.foregroundColor: newValue!])
        }
    }
}

extension String {
    
    var numberValue:NSNumber? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.number(from: self)
    }
    
    func isValidEmailCondition() -> Bool {
        // here, `try!` will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
    
    public func fetchDateFromString(format: String?) -> Date {
        
        //* Formatting String into Date
        let dateFormatter        = DateFormatter()
        dateFormatter.dateFormat = format ?? "yyyy-MM-dd"
        let date                 = dateFormatter.date(from: self)
        return date ?? Date()
    }
    
    public func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    
}
extension Date {
    
    ///* Return formatted date in String from Fetched Date */
    public func getFormattedStringFromDate(format: String?) -> String {
        
        //* Formatting the Date into String
        let formatter           = DateFormatter()
        formatter.dateFormat    = format ?? "M/d/YY HH:mm a"
        let dateString          = formatter.string(from: self)
        return dateString
    }
}


let imageCache = NSCache<AnyObject, AnyObject>()
public extension UIImageView {
    
    func loadImageUsingCache(image: String) {
        
        self.image = UIImage(named: "default")
        
        if let cachedImage = imageCache.object(forKey: image as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        guard let url = URL(string: image) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            guard let data = data else { return }
            DispatchQueue.main.async {
                guard let downloadedImage = UIImage(data: data) else { return }
                imageCache.setObject(downloadedImage, forKey: image as NSString)
                self.image = downloadedImage
            }
        }.resume()
    }
}

extension String {
    
    func setMinTailingDigits() -> String {
               let formatter = NumberFormatter()
               formatter.minimumFractionDigits = 2
               return formatter.string(from: Double(self)! as NSNumber)!
           }
    
    /// Get UIcolor from hex string value
    public var color: UIColor {
        let hex = trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        if #available(iOS 13, *) {
            guard let int = Scanner(string: hex).scanInt32(representation: .hexadecimal) else { return #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) }
            
            let a, r, g, b: Int32
            switch hex.count {
            case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
            case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
            case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
            default:    (a, r, g, b) = (255, 0, 0, 0)
            }
            
            return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
            
        } else {
            var int = UInt32()
            
            Scanner(string: hex).scanHexInt32(&int)
            let a, r, g, b: UInt32
            switch hex.count {
            case 3:     (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)  // RGB (12-bit)
            case 6:     (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                    // RGB (24-bit)
            case 8:     (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)       // ARGB (32-bit)
            default:    (a, r, g, b) = (255, 0, 0, 0)
            }
            
            return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(a) / 255.0)
        }
    }
    
    /// Fetch Date From String during the sorting of products from date
    
    
    /// Validation of Email
    public var isValidEmail: Bool {
        let regularExpressionForEmail = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let testEmail = NSPredicate(format:"SELF MATCHES %@", regularExpressionForEmail)
        return testEmail.evaluate(with: self)
    }
    
    /// Validation of Mobile
    public var isValidPhone: Bool {
        let regularExpressionForPhone = "^\\d{3}-\\d{3}-\\d{4}$"
        let testPhone = NSPredicate(format:"SELF MATCHES %@", regularExpressionForPhone)
        return testPhone.evaluate(with: self)
    }
}


extension UIColor {
    public var hexValue: String {
        let components = self.cgColor.components
        let r: CGFloat = components?[0] ?? 0.0
        let g: CGFloat = components?[1] ?? 0.0
        let b = ((components?.count ?? 0) > 2 ? components?[2] : g) ?? 0
        
        let hexString = String.init(format: "#%02lX%02lX%02lX", lroundf(Float(r * 255)), lroundf(Float(g * 255)), lroundf(Float(b * 255)))
        return hexString
    }
}

public extension UIView {
    
    func addViewThroughConstraints(for customView: UIView) {
        addSubview(customView)
        customView.translatesAutoresizingMaskIntoConstraints = false
        customView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        customView.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        customView.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true
        customView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
}

extension Sequence where Element: AdditiveArithmetic {
    func sum() -> Element { reduce(.zero, +) }
}

