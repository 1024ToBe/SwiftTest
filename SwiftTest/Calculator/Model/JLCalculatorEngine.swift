//
//  JLCalculatorEngine.swift
//  SwiftTest
//
//  Created by jolly on 2024/6/3.
//

import UIKit

class JLCalculatorEngine: NSObject {
    let funArr:CharacterSet = ["+","-","*","/","%","^"]
    func calculatEquation(equation:String)->Double{
        //以运算符进行分割 获取到所有数字
        let elementArr = equation.components(separatedBy: funArr)
        //设置一个运算标记游标
        var tip = 0
        //运算结果
        var result:Double = Double(elementArr[0])!
        //遍历计算表达式
        for char in equation{
            switch char{
            case "+":
                tip+=1
                if elementArr.count>tip{
                    result+=Double(elementArr[tip])!
                }
            case "-":
                tip+=1
                if elementArr.count>tip{
                    result-=Double(elementArr[tip])!
                }
            case "*":
                tip+=1
                if elementArr.count>tip{
                    result*=Double(elementArr[tip])!
                }
            case "/":
                tip+=1
                if elementArr.count>tip{
                    result/=Double(elementArr[tip])!
                }
            case "%":
                tip+=1
                if elementArr.count>tip{
                    result=Double(Int(result) % Int (elementArr[tip])!)
                }
            case "^":
                tip+=1
                if elementArr.count>tip{
                    let tmp = result
                    for _ in 1..<Int(elementArr[tip])!{
                        result*=tmp
                    }
                }
            default:
                break
            }
        }
        return result
    }
}
