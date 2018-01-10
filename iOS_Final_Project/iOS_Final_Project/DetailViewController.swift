//
//  DetailViewController.swift
//  iOS_Final_Project
//
//  Copyright © 2018 Team TCH. All rights reserved.
//

import UIKit

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
    
    @IBAction func cameraAction(_ sender: UIButton) {
        //open the camera
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        //show camera on click
        present(picker,animated: true,completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //change below "" to "hello from <insert location here>
        //image click should probably go here too
        let fullString = NSMutableAttributedString(attributedString: textView.attributedText)
        let imageAttachment = NSTextAttachment()
        imageAttachment.image = info[UIImagePickerControllerOriginalImage] as? UIImage; dismiss(animated: true, completion: nil)
        let imageString = NSAttributedString(attachment: imageAttachment)
        
        fullString.append(imageString)
        fullString.append(NSAttributedString(string: ""))
        //image doesn't save after leaving page right now
        //NSString needs to be converted to binary and saved. No clue how to do it
        textView.attributedText = fullString
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
