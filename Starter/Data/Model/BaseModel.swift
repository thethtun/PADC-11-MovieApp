//
//  BaseModel.swift
//  Starter
//
//  Created by Thet Htun on 7/21/21.
//

import Foundation

open class BaseModel: NSObject {
    
    var networkAgent : MovieDBNetworkAgentProtocol = MovieDBNetworkAgent.shared
    var coreData = CoreDataStack.shared
    
}
