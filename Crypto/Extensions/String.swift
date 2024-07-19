//
//  String.swift
//  Crypto
//
//  Created by parth kanani on 17/07/24.
//

import Foundation

extension String
{
    var removingHTMLOccurances: String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}
