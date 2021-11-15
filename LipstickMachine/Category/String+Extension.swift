//
//  String+Extension.swift
//  PipixiaTravel
//
//  Created by admin on 2017/7/25.
//  Copyright © 2017年 easyto. All rights reserved.
//

import Foundation

extension String {
    
//    MARK: 字符串类型转换
    func toFloat() -> CGFloat {
    
        var cgFloat: CGFloat = 0
        
        if let doubleValue = Double(self)
        {
        cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }
    
    func toInt() -> Int {
        var cgInt: Int = 0
        if let doubleValue = Double(self)
        {
            cgInt = Int(doubleValue)
        }
        return cgInt
    }
    
    func toDouble() -> Double {
        var cgInt: Double = 0.0
        
        if let doubleValue = Double(self)
        {
            cgInt = Double(doubleValue)
        }
        return cgInt
    }
    
    func toData() -> Data? {
        let strData = self.data(using: String.Encoding.utf8)
        
        return strData
    }
    
    func toLong() -> CLong {
        var cLong: CLong = 0
        if let longValue = CLong(self)
        {
            cLong = CLong(longValue)
        }
        return cLong
    }
    
    func toLongLong() -> CLongLong {
        var cLong: CLongLong = 0
        if let longValue = CLongLong(self)
        {
            cLong = CLongLong(longValue)
        }
        return cLong
    }
    
    func hexStringToInt() -> Int {
        let str = self.uppercased()
        var sum = 0
        for i in str.utf8 {
            sum = sum * 16 + Int(i) - 48 // 0-9 从48开始
            if i >= 65 {                 // A-Z 从65开始，但有初始值10，所以应该是减去55
                sum -= 7
            }
        }
        return sum
    }
    
    func StringToFloat(str:String)->(CGFloat) {
        let string = str
        var cgFloat:CGFloat = 0
        if let doubleValue = Double(string)
        {
            cgFloat = CGFloat(doubleValue)
        }
        return cgFloat
    }

    // 获取参数
    func getParas() -> [String: String] {
        var dic = [String:String]()
        let pairs = self.components(separatedBy: "&")
        for value in pairs {
                let paraAry = value.components(separatedBy: "=")
                if  paraAry.count == 2 {
                    dic[paraAry[0]] = paraAry[1]
                }
            }
        return dic
    }
    
    // 获取字符串里的数字
    func getNumber() -> String {
        let scanner = Scanner(string: self)
        scanner.scanUpToCharacters(from: CharacterSet.decimalDigits, into: nil)
        var number :Int = 0
        
        scanner.scanInt(&number)
        
        print(number)
        return String(number)
    }
}

extension String {
    func sepratoryBy(sepratory:String) -> Array<Any>? {
        let array = self.components(separatedBy: sepratory)
        return array
    }
    
    // 删除对应的字符串
    func removeString(string: String) -> String {
        let index = self.index(string.startIndex, offsetBy: string.count)
        let subString = self.substring(from: index)
        return subString
    }
    
    // 字符串转data
    func convertToData() -> Data {
        let data: Data? = self.data(using: String.Encoding(rawValue: String.Encoding.utf8.rawValue))
        return data!
    }
    
    // 字符串转字典
    func convertToDic() -> NSDictionary? {
        let data = self.convertToData()
        
        let dic: NSDictionary? = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        
        if dic == nil {
            return nil
        }
        
        return dic! as NSDictionary
    }
    
    func removeFloatAllZero() -> String {
        let testNumber: String = self
        let outNumber = "\(Float(testNumber) ?? 0.0)"
        return outNumber
    }
    
    func isNull() -> Bool {
        if self.isEmpty {
            return true
        } else {
            return false
        }
    }
    
    func nsRange(from range: Range<String.Index>) -> NSRange {
        let from = range.lowerBound.samePosition(in: utf16)
        let to = range.upperBound.samePosition(in: utf16)
        return NSMakeRange(utf16.distance(from: utf16.startIndex, to: from!), utf16.distance(from: from!, to: to!))
    }
}

//    MARK: 字符串类型判断
extension NSString {
    
    /// 字符串是否是空的判断
    func isNil() -> Bool {
        if self.length == 0 {
            return true
        }
        
        return false
    }

    /// 是否是电话号码
    func iPhoneNum() -> Bool {
        if self.isNil() == true {
            return false
        }
        
        if self.isMobileNumber() == false {
            return false
        }
        
        return true
    }
    
    // 是否是电话号码
    func isMobileNumber() -> Bool {
        let mobileNoRegex: String = "^1[0-9]\\d{9}$"
        let ret: Bool = isValidate(regex:mobileNoRegex)
        return ret
    }
    
    private func isValidate(regex: String) -> Bool {
        let pre = NSPredicate(format: "SELF MATCHES %@", regex)
        return pre.evaluate(with: self)
    }
    
    // 字符串转data
    func convertToData() -> Data {
        let data: Data? = self.data(using: String.Encoding.utf8.rawValue)
        return data!
    }
    
    // 字符串转字典
    func convertToDic() -> NSDictionary? {
        let data = self.convertToData()
        let dic: NSDictionary? = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
        
        if dic == nil {
            return nil
        }
        
        return dic! as NSDictionary
    }
}

// 字符判断
extension String {
    // 获取lable的宽度
    public func getTextWidth(height:CGFloat, fontSize: CGFloat) -> CGSize {
        let maxSize = CGSize(width: kScreenWidth, height: height)
        let attributes = NSDictionary(object: UIFont.systemFont(ofSize: fontSize), forKey: NSAttributedString.Key.font as NSCopying)
        
        let size = self.boundingRect(
            with: maxSize,
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: attributes as? [NSAttributedString.Key : Any],
            context: nil
        )
        
        return (size.size)
    }
}

// 字符判断
extension NSString {
    // 获取lable的宽度
    public func getTextWidth(height:CGFloat, fontSize:CGFloat) -> CGSize {
        let maxSize = CGSize(width: kScreenWidth, height: height)
        let attributes = NSDictionary(object: UIFont.systemFont(ofSize: fontSize), forKey: NSAttributedString.Key.font as NSCopying)
        
        let size = self.boundingRect(
            with: maxSize,
            options: NSStringDrawingOptions.usesLineFragmentOrigin,
            attributes: attributes as? [NSAttributedString.Key : Any],
            context: nil
        )
        
        return (size.size)
    }
}




