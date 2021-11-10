//
//  BaseNetworkAgent.swift
//  Starter
//
//  Created by Thet Htun on 8/19/21.
//

import Foundation
import Alamofire
import RxSwift


protocol MDBErrorModel : Decodable {
    var message : String { get }
}

class MDBCommonResponseError : MDBErrorModel {
    var message: String {
        return statusMessage
    }
    
    let statusMessage : String
    let statusCode : Int
    
    enum CodingKeys: String, CodingKey {
        case statusMessage = "status_message"
        case statusCode = "status_code"
    }
}

enum MDBResult<T> {
    case success(T)
    case failure(String)
}


class BaseNetworkAgent: NSObject {
    
    
    func handleError<T, E: MDBErrorModel>(
        _ response: DataResponse<T, AFError>,
        _ error: (AFError),
        _ errorBodyType : E.Type) -> String {
        
        
        var respBody : String = ""
        
        var serverErrorMessage : String?
        
        var errorBody : E?
        if let respData = response.data {
            respBody = String(data: respData, encoding: .utf8) ?? "empty response body"
            
            errorBody = try? JSONDecoder().decode(errorBodyType, from: respData)
            serverErrorMessage = errorBody?.message
        }
        
        /// 2 - Extract debug info
        let respCode : Int = response.response?.statusCode ?? 0
        
        let sourcePath = response.request?.url?.absoluteString ?? "no url"
        
        
        /// 1 - Essential debug info
        print(
            """
             ======================
             URL
             -> \(sourcePath)
             
             Status
             -> \(respCode)
             
             Body
             -> \(respBody)

             Underlying Error
             -> \(String(describing: error.underlyingError))
             
             Error Description
             -> \(error.errorDescription!)
             ======================
            """
        )
        
        /// 4 - Client display
        return serverErrorMessage ?? error.errorDescription ?? "undefined"
        
    }
    
}
