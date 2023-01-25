import Foundation
import UIKit

protocol KeyboardHandler  {
    func keyboardWillShow(notification: NSNotification)
    func keyboardWillHide(notification: NSNotification)
}

@objc protocol KeyboardDisplayer {
    func showKeyboard(notification: NSNotification)
    func hideKeyboard(notification: NSNotification)
}

extension KeyboardHandler where Self: UIViewController {
    func addObservers(showSelector: Selector, hideSelector: Selector) {
        NotificationCenter.default.addObserver(self, selector: showSelector, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: hideSelector, name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }

    func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
