//
//  Extension+UIStoryboard.swift
//  tawkiOSTest
//
//  Created by Apple on 28/09/22.
//

import Foundation
import UIKit

// MARK: - UIStoryboard Extension
public extension UIStoryboard {

    /// Get main storyboard for application
    static var main: UIStoryboard? {
        let bundle = Bundle.main
        guard let name = bundle.object(forInfoDictionaryKey: "UIMainStoryboardFile") as? String else { return nil }
        return UIStoryboard(name: name, bundle: bundle)
    }

    /// Instantiate a UIViewController using its class name
    /// - Parameter name: UIViewController type
    /// - Returns: The view controller corresponding to specified class name
    func instantiateViewController<T: UIViewController>(withClass name: T.Type) -> T? {
        return instantiateViewController(withIdentifier: String(describing: name)) as? T
    }

}
