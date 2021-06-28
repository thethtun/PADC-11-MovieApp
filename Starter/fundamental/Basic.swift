//
//  Basic.swift
//  Starter
//
//  Created by Aung Ko Ko Thet on 05/12/2020.
//

import Foundation

var colorList = ["red","green","blue"]
var regionList : Set = ["Yangon","Mandalay","Naypyitaw"]
var townshipList : [String:[String]] = ["Yangon" : ["Tamwe", "Yankin","Insein"]]

var doOnNext:((String)->String)={_ ->String in ""}

public func main(){
    var name = "Aung Ko"
    name = "Ko Thet"
    
    colorList.append("orange")
    
    let townships = townshipList["Yangon"] ?? []
    debugPrint(townships)
    
    for (key,value) in townshipList.enumerated(){
        
    }
    
    for color in colorList{
        debugPrint(color)
    }
    
    var indexForWhile = 0
    while indexForWhile < 3 {
        debugPrint(colorList[indexForWhile])
        indexForWhile += 1
    }
    
    var indexForRepeatWhile = 0
    repeat{
        debugPrint(indexForRepeatWhile)
        indexForRepeatWhile+=1
    }while indexForRepeatWhile < 3
    
    doOnNext = { name -> String in
        debugPrint("Hello \(name)")
        return "Hello \(name)"
    }
    
    decrease(doDecrease: {
        
    }, total: 10)
}

func increment(amount:Int)->()->Int{

    func doProcess()->Int{
        return amount
    }
    
    return doProcess
}

func decrease(doDecrease:()->Void,total:Int)->Void{
    debugPrint("decrease")
}
