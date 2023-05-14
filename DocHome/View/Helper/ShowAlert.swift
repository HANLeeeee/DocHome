//
//  Alert.swift
//  DocHome
//
//  Created by 최하늘 on 2023/05/15.
//

import Foundation
import UIKit

public func showAlert() -> UIAlertController {
    let alert = UIAlertController(title: "알림", message: "알림메시지", preferredStyle: .alert)
    let cancle = UIAlertAction(title: "확인", style: .default)
    alert.addAction(cancle)
    
    return alert
}
