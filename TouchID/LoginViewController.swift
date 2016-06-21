//
//  LoginViewController.swift
//  TouchID


import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {
    @IBOutlet weak var backgroundImageView:UIImageView!
    @IBOutlet weak var loginView:UIView!
    @IBOutlet weak var emailTextField:UITextField!
    @IBOutlet weak var passwordTextField:UITextField!
    
    private var imageSet = ["cloud", "coffee", "food", "pmq", "temple"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Randomly pick an image
        let selectedImageIndex = Int(arc4random_uniform(5))
        
        // Apply blurring effect
        backgroundImageView.image = UIImage(named: imageSet[selectedImageIndex])
        let blurEffect = UIBlurEffect(style: .Dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        backgroundImageView.addSubview(blurEffectView)
        
        loginView.hidden = true
        
        authenticationWithTouchID()

    }
    
    func authenticationWithTouchID() {
        let localAuthContext = LAContext()
        let reasonText = "Authentication is required to sign in our app"
        var authError: NSError?
        if !localAuthContext.canEvaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, error: &authError) {
            print(authError?.localizedDescription)
            showLoginDialog()
            return
        }
        
        localAuthContext.evaluatePolicy(.DeviceOwnerAuthenticationWithBiometrics, localizedReason: reasonText) { (success, error) in
            if success {
                print("Successfully authenticated")
                NSOperationQueue.mainQueue().addOperationWithBlock {
                    self.performSegueWithIdentifier("showHomeScreen", sender: nil)
                }
            } else {
                if error != nil {
                    switch error!.code {
                    case LAError.AuthenticationFailed.rawValue:
                        print("Authentication failed")
                    case LAError.PasscodeNotSet.rawValue:
                        print("Passcode not set")
                    case LAError.SystemCancel.rawValue:
                        print("Authentication was cancelled by system")
                    case LAError.UserCancel.rawValue:
                        print("Authenticaion was cancelled by the user")
                    case LAError.TouchIDNotEnrolled.rawValue:
                        print("Authentication could not start because Touch ID has no enrolled fingers")
                    case LAError.TouchIDNotAvailable.rawValue:
                        print("Authentication could not start because Touch ID is not available")
                    case LAError.UserFallback.rawValue:
                        print("User tapped the fallback button (Enter Password)")
                    default:
                        print(error!.localizedDescription)
                    }
                    
                    NSOperationQueue.mainQueue().addOperationWithBlock {
                        self.showLoginDialog()
                    }
                    
                }
            }
        }
    }
    
    func showLoginDialog() {
        // Move the login view off screen
        loginView.hidden = false
        loginView.transform = CGAffineTransformMakeTranslation(0, -700)

        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .CurveEaseInOut, animations: {
            
            self.loginView.transform = CGAffineTransformIdentity
            
            }, completion: nil)
        
    }

}
