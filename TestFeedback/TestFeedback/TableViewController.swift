//
//  TableViewController.swift
//
//
//
//  Copyright © 2017 Winjit. All rights reserved.
//

import UIKit
import MessageUI

/// this class is for giving rating feedback to the app and submitting it .
class TableViewController: UITableViewController, UITextViewDelegate, UITextFieldDelegate {
    
    
    //MARK:- Global Variables
    var strDesignRating:String?
    var strContentRating:String?
    var strTechnicleRating:String?
    
    var strEmail:String?
    var strComments:String?
    var strPriority:String?
    
    var strCompleteMessageBody:String?
    var keyboardHeight : CGFloat?
    var kToMail = "tushar.jogadia@rblbank.com"
    let image = UIImage(named: "back_ic")
    
    //MARK:- IBOutlets
    
    @IBOutlet weak var lblComments: UILabel!
    @IBOutlet weak var vwDesign: HCSStarRatingView!
    @IBOutlet weak var vwContent: HCSStarRatingView!
    @IBOutlet weak var vwTechnicle: HCSStarRatingView!
    @IBOutlet weak var vwTextComments: UITextView!
    
    @IBOutlet var btnBack: UIButton!
    
    @IBOutlet var viwTop: UIView!
    @IBOutlet var lblFeedbackandRating: UILabel!
    
    @IBOutlet var lblDesign: UILabel!
    @IBOutlet var lblAppPleasing: UILabel!
    @IBOutlet var lblContent: UILabel!
    
    @IBOutlet var lblTechnical: UILabel!
    @IBOutlet var lblGoodQuality: UILabel!
    @IBOutlet var lblSaeamlesly: UILabel!
    @IBOutlet var btnSubmit: RMButton!
    
    
    //MARK:- View lifecylce
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.btnSubmit.setButton(buttonType: .BlueButtonCorner)
        self.btnSubmit.setTitle(RMLocalise.Submit, for: .normal)
        lblFeedbackandRating.text = RMLocalise.RateUs
        vwTextComments.placeholderText = "Comments"
        lblComments.text = RMLocalise.Comments
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = .clear
    }
    
    //MARK:- IBActions
    
    /// function to get called on click of back button
    ///
    /// - Parameter sender: uibutton as sender
    @IBAction func btnBackClicked(sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        self.resetFeedbackView()
    }
    
    /// function to send email as per feedback given by user
    ///
    /// - Parameter sender: UIButton as sender
    @IBAction func btnSubmitClicked(sender: UIButton) {
        
        strDesignRating = "\(vwDesign.value)"
        strContentRating = "\(vwContent.value)"
        strTechnicleRating = "\(vwTechnicle.value)"
        strComments = vwTextComments.text
        
        
        UserDefaults.standard.set(-1, forKey: RMConstant.remindMeLater)
        strCompleteMessageBody = RMLocalise.ShareYourExperience + "  \n 1." + RMLocalise.Design + " :" + "\(String(describing: strDesignRating!)) " + RMLocalise.Stars + " \n" + "2." + RMLocalise.Contents + ": " + "\(String(describing: strContentRating!)) " + RMLocalise.Stars + " \n" + "3." + RMLocalise.Design  + ": " + "\(String(describing: strTechnicleRating!)) " + RMLocalise.Stars + " \n" + RMLocalise.Design  + ": " + "\(String(describing: strComments!))\n"
        resetFeedbackView ()
        RMUtility.sharedInstance.sendEmail(toRecipients: [""], subject: RMLocalise.FeedbackMobankIOS, body: strCompleteMessageBody!, attachment: nil, onView: self, showOnSelf: true)
        
        
    }
    
    /// this method iscalled when star values gets changed
    ///
    /// - Parameter sender: <#sender description#>
    @IBAction func didChangeValue (sender : HCSStarRatingView)
    {
        NSLog("Changed rating to %.1f", sender.value);
    }
    
    
    
    //MARK:- Custom Methods
    
    /// function to reset feedback given
    func resetFeedbackView () {
        
        
        vwTextComments.text = ""
        
        let btnLow = UIButton.init(type:UIButtonType.custom)
        btnLow.tag = 0
        
        vwDesign.value = 0.0
        vwContent.value = 0.0
        vwTechnicle.value = 0.0
        
    }
    
    //MARK:- textView Delegate methods
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        
        textView.placeholderText = RMLocalise.Comments
        
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        return true;
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        tableView.isScrollEnabled = true
        return true
    }
    
    
}
