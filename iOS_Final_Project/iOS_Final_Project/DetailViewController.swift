//
//  DetailViewController.swift
//  iOS_Final_Project
//
//  Copyright © 2018 Team TCH. All rights reserved.
//

import UIKit
import Photos

class DetailViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textView: UITextView!
    
    @IBOutlet weak var btn_photoLibrary: UIButton!
    @IBOutlet weak var btn_camera: UIButton!
    
    
    var text : String = ""
    var refToSourceVC : ViewController!
    
    public func setText(t: String){
        text = t
        if isViewLoaded {
            textView.text = t
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        textView.text = text
        
        textView.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refToSourceVC.newRowText = textView.text
        
    }
    
    @IBAction func photoLibraryAction(_ sender: UIButton) {
        //open the photo library
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        //show photolibrary on click
        present(picker,animated: true,completion: nil)
    }
    
    //generic method to show a popup with one ok button
    func showPopup(message: String, title: String){
        // create the alert
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func cameraAction(_ sender: UIButton) {
        //if the camera exists
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            //open the camera
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.sourceType = .camera
            //show camera on click
            present(picker,animated: true,completion: nil)
        }
        else{
            showPopup(message: "Looks like the camera isn't available right now. Try the Photo Library instead.", title: "Uh-Oh")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //change below "" to "hello from <insert location here>
        //image click should probably go here too
        let fullString1 = NSMutableAttributedString(attributedString: textView.attributedText)
        
        //setting up the image attachment
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = info[UIImagePickerControllerOriginalImage] as? UIImage; dismiss(animated: true, completion: nil)
        imageAttachment.bounds = CGRect(x:0, y:0, width:200, height:200);
        
        //setting the image as an attachment in a NSAttributedString
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        //appended the NSAttributedString to the NSMutableAttributedString
        fullString1.append(imageString)
        
        //image doesn't save after leaving page right now
        //NSString needs to be converted to binary and saved. No clue how to do it
        
        
        //---------
        
        //get geolocation and set it to show on textview
        if let URL = info[UIImagePickerControllerReferenceURL] as? URL {
            print("We got the URL as \(URL)")
            let opts = PHFetchOptions()
            opts.fetchLimit = 1
            let getResults = PHAsset.fetchAssets(withALAssetURLs: [URL], options: opts)
            let asset = getResults.firstObject
            
            
            let lat = Double((asset?.location?.coordinate.latitude)!)
            let lng = Double((asset?.location?.coordinate.longitude)!)
            let message = "\nI'm right here!\nAdd details here:"
            
            
            
            //using geolocation data to print location of photo
            let fullString2 = NSMutableAttributedString(string: message)
            
            //setting text with hyperlink
            fullString2.addAttribute(NSAttributedStringKey.link, value: "http://www.google.com/maps/place/\(String(describing: lat)),\(String(describing: lng))", range: NSMakeRange(0, message.count-18))
            //currently experiementing with these settings
            //fullString2.addAttribute(NSAttributedStringKey.underlineStyle, value: NSUnderlineStyle.styleNone, range: NSMakeRange(0, location.count))
            //fullString2.addAttribute(NSAttributedStringKey.underlineColor, value: UIColor.clear, range: NSMakeRange(0, location.count))
            
            //textView.attributedText = fullString2
            
            //appends the second NSMutableAttributedString to the first
            fullString1.append(fullString2)
        }
        
        
        textView.attributedText = fullString1
        
        
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL, options: [:])
        return false
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
