//
//  Copyright © 2018 Vasilica Costescu. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    @IBOutlet var contentView: UIView!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var textView: UITextView!        
    @IBOutlet var resetButton: UIButton!
    
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var takePhotoButton: UIButton!
    
    private let imagePickerController = UIImagePickerController()
    fileprivate let sentimentAnalysisService = SentimentAnalysisService()
    fileprivate var currentSentiment = Sentiment.neutral
    private var faceRectangles = [UIView]()
    
    //MARK: - Life Cycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerForKeyboardNotifications()        
        renderTextView()
        resetUI()
        imagePickerController.delegate = self
    }
    
    //MARK: - IBActions
    
    @IBAction func takePhoto(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            imagePickerController.sourceType = .camera
            imagePickerController.cameraDevice = .front
        }
        
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func resetState(_ sender: UIButton) {
        resetUI()
        currentSentiment = .neutral
        removeFacesView()
    }
    
    //MARK: - UI Initial Setup
    
    private func renderTextView() {
        textView.layer.borderWidth = 2.0
        textView.layer.borderColor = UIColor.gray.cgColor
        textView.layer.cornerRadius = 5.0
    }
    
    private func resetUI() {
        textView.text = ""
        photoImageView.image = UIImage(named: "backgroundImage")
        takePhotoButton.isHidden = false
    }

    //MARK: - Keyboard Notifications
    private func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: .UIKeyboardDidShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: .UIKeyboardDidHide, object: nil)
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height, right: 0.0)
        
        scrollView.contentInset = contentInsets
        scrollView.scrollIndicatorInsets = contentInsets
        
        var rect = view.frame
        rect.size.height -= keyboardSize.size.height
        if (!rect.contains(resetButton.frame.origin)) {
            scrollView.scrollRectToVisible(resetButton.frame, animated: true)
        }
    }
    
    @objc func keyboardDidHide(notification: Notification) {
        let contentInset: UIEdgeInsets = .zero
        scrollView.contentInset = contentInset
        scrollView.scrollIndicatorInsets = contentInset
    }
    
    //MARK: - Using Vision framework for face recognition
    
    fileprivate func detectFace(from image: UIImage) {
        //create face detection request
        
        //create request handler
        
        //perform face detection
    }
    
    private func handleFaceDetectionResults(request: VNRequest, error: Error?) {
        //handle results
        
    }
    
    //MARK: - Helper methods to draw box around face
    
    private func addFaceRectangleView(frame: CGRect) {
        let faceView = UIImageView(frame: frame)
        
        faceView.layer.borderColor = UIColor.yellow.cgColor
        faceView.layer.borderWidth = 2
        faceView.backgroundColor = UIColor.clear
        
        faceView.image = UIImage(named: currentSentiment.imageName)
        
        photoImageView.addSubview(faceView)
        faceRectangles.append(faceView)
    }
    
    private func transformRectInView(visionRect: CGRect , view: UIView) -> CGRect {
        
        let size = CGSize(width: visionRect.width * view.bounds.width,
                          height: visionRect.height * view.bounds.height)
        let origin = CGPoint(x: visionRect.minX * view.bounds.width,
                             y: (1 - visionRect.minY) * view.bounds.height - size.height)
        return CGRect(origin: origin, size: size)
    }
    
    private func removeFacesView() {
        for faceView in faceRectangles {
            faceView.removeFromSuperview()
        }
        faceRectangles = []
    }
}

//MARK: - UITextViewDelegate Methods

extension ViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        guard let text = textView.text else {
            currentSentiment = .neutral
            return
        }
        
        if text.last == " " {
            currentSentiment = sentimentAnalysisService.predictSentiment(from: text)
        }
    }
}

//MARK: - UIImagePickerControllerDelegate Methods

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let imageSelected = info[UIImagePickerControllerEditedImage] as? UIImage {
            photoImageView.image = imageSelected
            takePhotoButton.isHidden = true
            
            detectFace(from: imageSelected)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
