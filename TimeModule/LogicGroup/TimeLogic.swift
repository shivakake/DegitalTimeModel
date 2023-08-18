//
//  TimeLogic.swift
//  TimeModule
//
//  Created by PGK Shiva Kumar on 24/11/22.
//

import Foundation
import NixelQueue

enum TimeServiceAPIName : String {
    
    case timesMainListAPI = "times"
    case timeDetailsAPI = "time"
    case newTimeAPI = "newtime"
    case editTimeAPI = "edittime"
    case approveTimeAPI = "approvetime"
    case draftTimeAPI = "drafttime"
    case completeTimeAPI = "completetime"
    case deleteTimeAPI = "deletetime"
    case timeAccountsListAPI = "timeaccounts"
}

protocol TimeLogicDelegate : AnyObject {
    
    func getTimeList()
    func getTimeDetails(timeModel: TimeDataModel?)
    func updateTimeStatusChange(dataStatus : String, index: Int)
    func timeStatusChangeForQueue(index : Int)
    //    func addNewTimeInQueue(duration: Double)
    func addNewTimeInQueue()
//    func updateAddTimeSuccess(status: Int , index: Int)
    func updateAddTimeSuccess(status: Int , index: Int)
    func editTimeInQueue(timeModel : TimeDataModel? , index : Int)
    func updateEditTimeSuccess(dataStatus : String ,index : Int)
    func updateDeleteTimeSuccess(status: Int? ,index: Int)
    func getTimeAccountsListStatus(status : Int?)
    func showPoorInternet()
}

public class TimeLogic {
    
    public init() { }
    
    weak var delegate: TimeLogicDelegate? {
        didSet {
            ClsQueueManager.shared.setQueueManagerDelegate(to: self)
            ClsQueueManager.shared.setInternetValue(value: 1)
        }
    }
    
    var timeListArray : [TimeDataModel] = []
    var statusFilter = "live"
    var searchText = ""
    var displayTotalTimeDuration = "00:00"
    var calculatedTimeDuration : Double = 0
    
    func getCurrentDate()-> String {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let currentDate = formatter.string(from: date)
        return currentDate
    }
    
    //MARK:- Notes List
    public func getTimesList(toDate : String? , fromDate : String? , text : String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        self.searchText = text ?? ""
        
        let objectHashMapData = [
            "person" : GlobalStrings.sharedInstance.memberId,
            "ref" : GlobalStrings.sharedInstance.communityId,
            "text" : self.searchText,
            "from" : fromDate ?? "",
            "to" : toDate ?? "",
            "account" : "none"
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "time", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: TimeServiceAPIName.timesMainListAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    //MARK:- Notes Details
    public func getTimeDetails(timeId : String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref" : timeId ?? ""
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: timeId ?? "", strObjType: "time", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: TimeServiceAPIName.timeDetailsAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
    
    //MARK:- Draft Notes
    public func draftTime(timeId : String) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref" : timeId,
            "verify" : strId
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: timeId, strObjType: "time", strVerifyId: strId, strStatus: "queue", strOperation: "draft", strApiName: TimeServiceAPIName.draftTimeAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = timeListArray.firstIndex(where: {$0.id == timeId}) {
            timeListArray[firstIndex].datastatus = "queue"
            delegate?.timeStatusChangeForQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func approveTime(timeId : String) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref" : timeId,
            "verify" : strId
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: timeId, strObjType: "time", strVerifyId: strId, strStatus: "queue", strOperation: "approve", strApiName: TimeServiceAPIName.approveTimeAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = timeListArray.firstIndex(where: {$0.id == timeId}) {
            timeListArray[firstIndex].datastatus = "queue"
            delegate?.timeStatusChangeForQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func completeTime(timeId : String) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref" : timeId,
            "verify" : strId
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: timeId, strObjType: "time", strVerifyId: strId, strStatus: "queue", strOperation: "complete", strApiName: TimeServiceAPIName.completeTimeAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = timeListArray.firstIndex(where: {$0.id == timeId}) {
            timeListArray[firstIndex].datastatus = "queue"
            delegate?.timeStatusChangeForQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func addNewTime(name : String? , description : String? , from : String? , to : String? , date : String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "name" : name ?? "",
            "description" : description ?? "",
            "from" : from ?? "",
            "to" : to ?? "",
            "date" : date ?? "",
            "account" : "none",
            "ref" : GlobalStrings.sharedInstance.communityId,
            "verify" : strId
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "time", strVerifyId: strId, strStatus: "queue", strOperation: "addNewTime", strApiName: TimeServiceAPIName.newTimeAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        timeListArray.insert(TimeDataModel(created: getCurrentDate() , datastatus: "queue", date: date, description: description, from: from, id: strId, name: name ,to: to , verifyId: strId), at: 0)
        
        //        if let fromTime = from , let toTime = to {
        //            let fromStr = fromTime.replacingOccurrences(of: ":", with: ".")
        //            let toStr = toTime.replacingOccurrences(of: ":", with: ".")
        //            guard let formDouble = Double(fromStr) else { return }
        //            guard let toDouble = Double(toStr) else { return }
        //            let duration = toDouble - formDouble
        //            print(duration)
        //
        //            let decimalValue = duration.truncatingRemainder(dividingBy: 1)
        //            let wholeValue = duration - decimalValue
        //            let convertedDecimalValue = (decimalValue * 60)/100
        //            let timeDoubleValue = wholeValue + convertedDecimalValue
        //
        //            delegate?.addNewTimeInQueue(duration: timeDoubleValue)
        //        }
        delegate?.addNewTimeInQueue()
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func editTimeDetails(model: TimeDataModel? , timeId : String?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "name" : model?.name ?? "",
            "description" : model?.description ?? "",
            "from" : model?.from ?? "",
            "to" : model?.to ?? "",
            "date" : model?.date ?? "",
            "account" : "none",
            "ref" : timeId ?? "" ,
            "verify" : strId
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: timeId ?? "", strObjType: "time", strVerifyId: strId, strStatus: "queue", strOperation: "editTime", strApiName: TimeServiceAPIName.editTimeAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = timeListArray.firstIndex(where: { $0.id == timeId }) {
            delegate?.editTimeInQueue(timeModel: model , index : firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func deleteTime(timeId : String , duration: Double?) {
        
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref" : timeId,
            "verify" : strId
        ] as NSDictionary
        
        let objectHashMapExtraData = [
            "duration" : duration ?? 0.0
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: timeId, strObjType: "time", strVerifyId: strId, strStatus: "queue", strOperation: "deleteTime", strApiName: TimeServiceAPIName.deleteTimeAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: objectHashMapExtraData, arrFiles: [], blIsDirect: false, blEncrypt: false, strEncryptionKey: "")
        
        if let firstIndex = timeListArray.firstIndex(where: {$0.id == timeId}) {
            timeListArray[firstIndex].datastatus = "queue"
            delegate?.timeStatusChangeForQueue(index: firstIndex)
        }
        ClsQueueManager.shared.handleObject(headerQueue: objHeaderQueue)
    }
    
    public func getTimeAccountsList(){
        let timeStamp      = Int(NSDate().timeIntervalSince1970)
        let strId          = String(timeStamp)
        
        let objectHashMapData = [
            "ref" : GlobalStrings.sharedInstance.communityId,
            "status" : "active",
            "group" : "none"
        ] as NSDictionary
        
        let objHeaderQueue = ClsHeaderQueue(strObjectId: strId, strObjType: "time", strVerifyId: strId, strStatus: "queue", strOperation: "", strApiName: TimeServiceAPIName.timeAccountsListAPI.rawValue, isFileUploading: false, strFilePath: "", strFileName: "", objHashMapData: objectHashMapData, objHashMapExtra: [:], arrFiles: [], blIsDirect: true, blEncrypt: false, strEncryptionKey: "")
        
        ClsQueueManager.shared.doDirectOperation(headerQueue: objHeaderQueue)
    }
}

extension TimeLogic : QueueManagerDelegate {
    
    public func onOperationResult(objResponseDict: NSDictionary, objHeaderQueue: ClsHeaderQueue, blIsVerify: Bool) {
        
        switch objHeaderQueue.strApiName {
        
        case TimeServiceAPIName.timesMainListAPI.rawValue:
            handleResponseForMainTimeList(responseDict: objResponseDict)
            
        case TimeServiceAPIName.timeDetailsAPI.rawValue:
            handleResponseForTimeDetails(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case TimeServiceAPIName.approveTimeAPI.rawValue , TimeServiceAPIName.draftTimeAPI.rawValue , TimeServiceAPIName.completeTimeAPI.rawValue:
            handleResponseForChangingTimeStatus(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case TimeServiceAPIName.newTimeAPI.rawValue:
            handleResponseForNewTime(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case TimeServiceAPIName.editTimeAPI.rawValue:
            handleResponseForEditTime(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case TimeServiceAPIName.deleteTimeAPI.rawValue:
            handleResponseForDeleteTime(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
            
        case TimeServiceAPIName.timeAccountsListAPI.rawValue:
            handleResponseForTimeAccountsList(responseDict: objResponseDict, objHeaderQueue: objHeaderQueue)
        default:
            break
        }
    }
    
    //MARK:- API Response
    
    func handleResponseForMainTimeList(responseDict: NSDictionary) {
        timeListArray.removeAll()
        if responseDict.count > 0 {
            calculatedTimeDuration = 0
            let status = responseDict["status"] as? Int
            if status == 1 {
                let dataList = responseDict["list"] as? NSArray
                for data in dataList ?? [] {
                    let list = data as? NSDictionary
                    let account = list?["account"] as? String
                    let accountname = list?["accountname"] as? String
                    let created = list?["created"] as? String
                    let datastatus = list?["datastatus"] as? String
                    let date = list?["date"] as? String
                    let description = list?["description"] as? String
                    let duration = list?["duration"] as? String
                    let from = list?["from"] as? String
                    let id = list?["id"] as? String
                    let name = list?["name"] as? String
                    let to = list?["to"] as? String
                    let updated = list?["updated"] as? String
                    
                    
                    if let dblDuration = Double(duration ?? "") {
                        calculatedTimeDuration += dblDuration
                    }
                    
                    timeListArray.append(TimeDataModel(account: account, accountname: accountname, created: created, datastatus: datastatus, date: date, description: description, duration: duration, from: from, id: id, name: name, to: to, updated: updated))
                }
                updateTimeDurationForUI()
                delegate?.getTimeList()
            } else {
                delegate?.getTimeList()
            }
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func updateTimeDurationForUI() {
        let dec = "\(calculatedTimeDuration)".split(whereSeparator: { $0 == "."})
        let hour = Int(dec.first ?? "0") ?? 0
        let min = ((Int(dec.last ?? "00") ?? 0) * 60) / 100
        let hourToDisplay = hour < 10 ? "0\(hour)" : "\(hour)"
        let minToDisplay = min < 10 ? "0\(min)" : "\(min)"
        displayTotalTimeDuration = hourToDisplay + ":" + minToDisplay.prefix(2)
    }
    
    func handleResponseForTimeDetails(responseDict: NSDictionary , objHeaderQueue: ClsHeaderQueue) {
        
        if responseDict.count > 0 {
            var timeData : TimeDataModel?
            let status = responseDict["status"] as? Int
            if status == 1 {
                let account = responseDict["account"] as? String
                let accountname = responseDict["accountname"] as? String
                let created = responseDict["created"] as? String
                let datastatus = responseDict["datastatus"] as? String
                let date = responseDict["date"] as? String
                let description = responseDict["description"] as? String
                let duration = responseDict["duration"] as? String
                let from = responseDict["from"] as? String
                let name = responseDict["name"] as? String
                let to = responseDict["to"] as? String
                let updated = responseDict["updated"] as? String
                
                timeData = TimeDataModel(account: account, accountname: accountname, created: created, datastatus: datastatus, date: date, description: description, duration: duration, from: from,id: objHeaderQueue.strObjectId , name: name, to: to, updated: updated)
                
                delegate?.getTimeDetails(timeModel: timeData)
            } else {
                delegate?.getTimeDetails(timeModel: nil)
            }
        } else {
            delegate?.showPoorInternet()
        }
    }
    
    func handleResponseForChangingTimeStatus(responseDict: NSDictionary , objHeaderQueue : ClsHeaderQueue) {
        
        let status = responseDict["status"] as? Int ?? 0
        let datastatus = responseDict["datastatus"] as? String
        let id = objHeaderQueue.strObjectId ?? ""
        let dataStatus = status == 1 ? datastatus?.lowercased() : "error"
        
        if let firstIndex = timeListArray.firstIndex(where: { $0.id == id}) {
            if (statusFilter == dataStatus || statusFilter == "error" || statusFilter == "live") && statusFilter != "complete" {
                timeListArray[firstIndex].datastatus = dataStatus
            } else {
                self.timeListArray.remove(at: firstIndex)
            }
            delegate?.updateTimeStatusChange(dataStatus: dataStatus ?? "", index: firstIndex)
        }
    }
    
    func handleResponseForNewTime(responseDict: NSDictionary , objHeaderQueue : ClsHeaderQueue) {
        
        let status = responseDict["status"] as? Int ?? 0
        let id = responseDict["id"] as? String
        let dataStatus = responseDict["datastatus"] as? String
        
        if let firstIndex = timeListArray.firstIndex(where: { $0.id == objHeaderQueue.strObjectId ?? ""}){
            if status == 1 {
                if let fromTime = objHeaderQueue.objHashMapData?["from"] as? String, let toTime = objHeaderQueue.objHashMapData?["to"] as? String {
                    let fromStr = fromTime.replacingOccurrences(of: ":", with: ".")
                    let toStr = toTime.replacingOccurrences(of: ":", with: ".")
                    guard let fromDouble = Double(fromStr) else { return }
                    guard let toDouble = Double(toStr) else { return }
                    let duration = toDouble - fromDouble
                    calculatedTimeDuration += duration
                    updateTimeDurationForUI()
                }

                timeListArray[firstIndex].id = id
                timeListArray[firstIndex].datastatus = dataStatus
            }else{
                timeListArray.remove(at: firstIndex)
            }
            delegate?.updateAddTimeSuccess(status: status , index: firstIndex)
        }
    }
    
    func handleResponseForEditTime(responseDict: NSDictionary , objHeaderQueue: ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        let datastatus = responseDict["datastatus"] as? String
        let id = objHeaderQueue.strObjectId ?? ""
        let dataStatus = status == 1 ? datastatus?.lowercased() : "error"
        if let firstIndex = timeListArray.firstIndex(where: { $0.id == id}) {
            if (statusFilter == dataStatus || statusFilter == "error" || statusFilter == "live") && statusFilter != "complete" {
                timeListArray[firstIndex].datastatus = dataStatus
            }else {
                timeListArray.remove(at: firstIndex)
            }
            delegate?.updateEditTimeSuccess(dataStatus: dataStatus ?? "", index: firstIndex)
        }
    }
    
    func handleResponseForDeleteTime(responseDict: NSDictionary , objHeaderQueue : ClsHeaderQueue) {
        let status = responseDict["status"] as? Int ?? 0
        if let firstIndex = timeListArray.firstIndex(where: {$0.id == objHeaderQueue.strObjectId ?? ""}) {
            if status == 1 {
                timeListArray.remove(at: firstIndex)
                let duration = objHeaderQueue.objHashMapExtra?["duration"] as? Double ?? 0.0
                calculatedTimeDuration -= duration
                if calculatedTimeDuration == -1 , calculatedTimeDuration < -1{
                    displayTotalTimeDuration = "00.00"
                }else{
                }
                updateTimeDurationForUI()
            } else {
                timeListArray[firstIndex].datastatus = "error"
            }
            delegate?.updateDeleteTimeSuccess(status: status, index: firstIndex)
        }
    }
    
    func handleResponseForTimeAccountsList(responseDict: NSDictionary , objHeaderQueue : ClsHeaderQueue) {
        if responseDict.count > 0 {
            let status = responseDict["status"] as? Int ?? 0
            if status == 1 {
                delegate?.getTimeAccountsListStatus(status: status)
            } else {
                delegate?.getTimeAccountsListStatus(status: status)
            }
        } else {
            delegate?.showPoorInternet()
        }
    }
}
