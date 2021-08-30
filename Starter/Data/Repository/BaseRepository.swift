//
//  BaseRepository.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation
import CoreData
import RealmSwift
import RxSwift

class BaseRepository: NSObject {
    
    var coreData = CoreDataStack.shared
    
    let realmInstance = MovieDBRealm.shared
    
    override init() {
        super.init()
    }
    
    /// Source @ https://stackoverflow.com/questions/2262704/iphone-core-data-production-error-handling
    func handleCoreDataError(_ anError: Error?) -> String {
        if let anError = anError,
           (anError as NSError).domain == "NSCocoaErrorDomain" {
            
            let nsError = anError as NSError
            
            var errors: [AnyObject] = []

            // multiple errors?
            if nsError.code == NSValidationMultipleErrorsError {
                errors = nsError.userInfo[NSDetailedErrorsKey] as? [AnyObject] ?? [AnyObject]()
            } else {
                errors = [nsError].compactMap { $0 }
            }
            
            
            return errors.reduce("Reason(s):\n") { (result, error) -> String in
                guard let error = error as? Error else {
                    return ""
                }
                let entityName = ((error as NSError).userInfo["NSValidationErrorObject"] as? NSManagedObject)?.entity.name ?? "Undefined entity name"
                let attributeName = (error as NSError).userInfo["NSValidationErrorKey"] as? String ?? "Undefined attribute name"
                var msg: String = ""
                switch (error as NSError).code {
                case NSValidationMissingMandatoryPropertyError:
                    msg = "The attribute '\(attributeName)' mustn't be empty."
                case NSManagedObjectConstraintMergeError:
                    let conflictKey : String = ((error as NSError).userInfo["conflictList"] as! [NSConstraintConflict])[0].constraintValues.keys.reduce("") { "\($0): \($1)" }
                    msg = "Given attribute(s) \(conflictKey) is/are in conflict with existing data"
                case NSValidationRelationshipLacksMinimumCountError:
                    msg = "The relationship '\(attributeName)' doesn't have enough entries."
                case NSValidationRelationshipExceedsMaximumCountError:
                    msg = "The relationship '\(attributeName)' has too many entries."
                case NSValidationRelationshipDeniedDeleteError:
                    msg = "To delete, the relationship '\(attributeName)' must be empty."
                case NSValidationNumberTooLargeError:
                    msg = "The number of the attribute '\(attributeName)' is too large."
                case NSValidationNumberTooSmallError:
                    msg = "The number of the attribute '\(attributeName)' is too small."
                case NSValidationDateTooLateError:
                    msg = "The date of the attribute '\(attributeName)' is too late."
                case NSValidationDateTooSoonError:
                    msg = "The date of the attribute '\(attributeName)' is too soon."
                case NSValidationInvalidDateError:
                    msg = "The date of the attribute '\(attributeName)' is invalid."
                case NSValidationStringTooLongError:
                    msg = "The text of the attribute '\(attributeName)' is too long."
                case NSValidationStringTooShortError:
                    msg = "The text of the attribute '\(attributeName)' is too short."
                case NSValidationStringPatternMatchingError:
                    msg = "The text of the attribute '\(attributeName)' doesn't match the required pattern."
                default:
                    msg = String(format: "Unknown error (code %i).", (error as NSError).code)
                }
                
                return "\(result)\(String(describing: entityName)):\(msg)\n"
            }
            
        } else {
            return "undefined error : CoreData Error Nil"
        }
       
    }
}
