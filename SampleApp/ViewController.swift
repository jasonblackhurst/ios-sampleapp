//
//  ViewController.swift
//  SampleApp
//
//  Created by jason blackhurst on 11/7/16.
//  Copyright © 2016 Jason Blackhurst. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var lowerBoundField: IntegerField!
    @IBOutlet var upperBoundField: IntegerField!
    @IBOutlet var randomNumberLabel: UILabel!
    
    @IBAction func generateRandomNumber(sender: UIButton) {
        let minNumber = lowerBoundField.text?.integer
        let maxNumber = upperBoundField.text?.integer
        if minNumber == maxNumber || minNumber! > maxNumber! {
            randomNumberLabel.text = "Nope!"
            return
        }
        
        let diceRoll = UInt64.random(lower: UInt64(minNumber!), upper: UInt64(maxNumber!))
        randomNumberLabel.text = "Result: \(diceRoll)"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Looks for single or multiple taps.
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        lowerBoundField.text = "0"
        upperBoundField.text = "100"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
 
    //Copy pasta from: http://stackoverflow.com/questions/24126678/close-ios-keyboard-by-touching-anywhere-using-swift
    //Calls this function when the tap is recognized.
    func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
}


//Copy pasta from : http://stackoverflow.com/questions/24007129/how-does-one-generate-a-random-number-in-apples-swift-language

public func arc4random<T: ExpressibleByIntegerLiteral>(_ type: T.Type) -> T {
    var r: T = 0
    arc4random_buf(&r, MemoryLayout<T>.size)
    return r
}

public extension UInt64 {
    public static func random(lower: UInt64 = min, upper: UInt64 = max) -> UInt64 {
        var m: UInt64
        let u = upper - lower
        var r = arc4random(UInt64.self)
        
        if u > UInt64(Int64.max) {
            m = 1 + ~u
        } else {
            m = ((max - (u * 2)) + 1) % u
        }
        
        while r < m {
            r = arc4random(UInt64.self)
        }
        
        return (r % u) + lower
    }
}


public extension Int64 {
    public static func random(lower: Int64 = min, upper: Int64 = max) -> Int64 {
        let (s, overflow) = Int64.subtractWithOverflow(upper, lower)
        let u = overflow ? UInt64.max - UInt64(~s) : UInt64(s)
        let r = UInt64.random(upper: u)
        
        if r > UInt64(Int64.max)  {
            return Int64(r - (UInt64(~lower) + 1))
        } else {
            return Int64(r) + lower
        }
    }
}

private let _wordSize = __WORDSIZE

public extension UInt32 {
    public static func random(lower: UInt32 = min, upper: UInt32 = max) -> UInt32 {
        return arc4random_uniform(upper - lower) + lower
    }
}

public extension Int32 {
    public static func random(lower: Int32 = min, upper: Int32 = max) -> Int32 {
        let r = arc4random_uniform(UInt32(Int64(upper) - Int64(lower)))
        return Int32(Int64(r) + Int64(lower))
    }
}

public extension UInt {
    public static func random(lower: UInt = min, upper: UInt = max) -> UInt {
        switch (_wordSize) {
        case 32: return UInt(UInt32.random(lower: UInt32(lower), upper: UInt32(upper)))
        case 64: return UInt(UInt64.random(lower: UInt64(lower), upper: UInt64(upper)))
        default: return lower
        }
    }
}

public extension Int {
    public static func random(lower: Int = min, upper: Int = max) -> Int {
        switch (_wordSize) {
        case 32: return Int(Int32.random(lower: Int32(lower), upper: Int32(upper)))
        case 64: return Int(Int64.random(lower: Int64(lower), upper: Int64(upper)))
        default: return lower
        }
    }
}

//End Copy pasta from : http://stackoverflow.com/questions/24007129/how-does-one-generate-a-random-number-in-apples-swift-language



//Copy pasta from: http://stackoverflow.com/questions/24115141/swift-converting-string-to-int

class IntegerField: UITextField {
    override func awakeFromNib() {
        super.awakeFromNib()
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        keyboardType = .numberPad
        textAlignment = .right
        editingChanged()
    }
    func editingChanged() {
        text = Formatter.decimal.string(from: string.numbers.integer as NSNumber)
    }
}

struct Formatter {
static let decimal = NumberFormatter(numberStyle: .decimal)
}
extension UITextField {
    var string: String { return text ?? "" }
}
extension String {
    var numbers: String { return components(separatedBy: Numbers.characterSet.inverted).joined() }
    var integer: Int { return Int(numbers) ?? 0 }
}
struct Numbers { static let characterSet = CharacterSet(charactersIn: "0123456789") }
extension NumberFormatter {
    convenience init(numberStyle: NumberFormatter.Style) {
        self.init()
        self.numberStyle = numberStyle
    }
}


//End Copy pasta from: http://stackoverflow.com/questions/24115141/swift-converting-string-to-int

