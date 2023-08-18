//
//  FunctionsHelper.swift
//  DayOneTask
//
//  Created by PGK Shiva Kumar on 30/08/22.
//

import Foundation
import UIKit

class FunctionsHelper {
    
    static let sharedInstance : FunctionsHelper = FunctionsHelper()
    private init() { }
    
    let date = Date()
    let formatter = DateFormatter()
    
    func getCustomImage(customImage incomingEnum : SystemImageNames) -> String {
        
        var finalString = ""
        
        switch incomingEnum {
        
        case .plus:
            finalString = "plus"
        case .locationcircle :
            finalString = "location.circle"
        case .linehorizontal3decrease:
            finalString = "line.horizontal.3.decrease"
        case .ellipsis:
            finalString = "ellipsis"
        case .squareandpencil:
            finalString = "square.and.pencil"
        case .envelopeopen:
            finalString = "envelope.open"
        case .docbadgeellipsis:
            finalString = "doc.badge.ellipsis"
        case .binxmark:
            finalString = "bin.xmark"
        case .checkmarkcircle:
            finalString = "checkmark.circle"
        case .circlefill:
            finalString = "circle.fill"
        case .person:
            finalString = "person"
        case .sliderhorizontal3:
            finalString = "slider.horizontal.3"
        }
        return finalString
    }
    
    func getStatusString(statusString incomingString : StatusString) -> String {
        
        var finalString = ""
        
        switch incomingString {
        
        case .active:
            finalString = "active"
        case .complete :
            finalString = "complete"
        case .draft:
            finalString = "draft"
        case .error:
            finalString = "error"
        case .inactive:
            finalString = "inactive"
        case .live:
            finalString = "live"
        case .queue:
            finalString = "queue"
            
        }
        return finalString
    }
    
    func showDate() -> String{
        formatter.dateFormat = "yyyy-MM-dd"
        let result = formatter.string(from: date)
        return result
    }
    
    func minutesToHoursAndMinutes(_ minutes: Int) -> (hours: Int , leftMinutes: Int) {
        return (minutes / 60, (minutes % 60))
    }
}

public enum SystemImageNames {
    
    case plus
    case linehorizontal3decrease
    case locationcircle
    case ellipsis
    case squareandpencil
    case envelopeopen
    case docbadgeellipsis
    case binxmark
    case checkmarkcircle
    case circlefill
    case person
    case sliderhorizontal3
    
}

public enum StatusString {
    
    case active
    case live
    case draft
    case complete
    case inactive
    case error
    case queue
    
}


