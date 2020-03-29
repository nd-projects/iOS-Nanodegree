//
//  ViewController.swift
//  MemeMe
//
//  Copyright © 2020 nd-projects. All rights reserved.
//

import UIKit

struct Meme {
    var topText: String
    var bottomText: String
    var originalImage: UIImage
    var memedImage: UIImage
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate,
                    UITextFieldDelegate {

    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var toolbar: UIToolbar!
    var meme: Meme!
    var defaultTextTop: String = "TOP"
    var defaultTextBottom: String = "BOTTOM"

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifiactions()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action,
                                                            target: self,
                                                            action: #selector(shareMeme))
        navigationItem.rightBarButtonItem?.isEnabled = false

        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)

        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -3.0
        ]

        topTextField.defaultTextAttributes = memeTextAttributes
        topTextField.text = defaultTextTop
        topTextField.autocapitalizationType = .allCharacters
        topTextField.textAlignment = .center
        topTextField.delegate = self

        bottomTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.text = defaultTextBottom
        bottomTextField.autocapitalizationType = .allCharacters
        bottomTextField.textAlignment = .center
        bottomTextField.delegate = self
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        switch textField {
        case topTextField:
            if textField.text == defaultTextTop {
                textField.text = ""
            }
        case bottomTextField:
            if textField.text == defaultTextBottom {
                textField.text = ""
            }
        default:
            return
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()

        return true
    }

    @IBAction func pickAnImage(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }

    @IBAction func takePhoto(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            imagePickerView.image = pickedImage
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func subscribeToKeyboardNotifiactions() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing, view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }

    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        guard let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            print("Could not access keyboard height")
            return 0
        }
        return keyboardSize.cgRectValue.height
    }

    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func generateMemedImage() -> UIImage {
        toolbar.isHidden = true

        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        toolbar.isHidden = false

        return memedImage
    }

    @objc func shareMeme() {
        updateMeme()
        let activityViewController = UIActivityViewController(activityItems: [self.meme.memedImage],
                                                              applicationActivities: [])
        present(activityViewController, animated: true)
    }

    func updateMeme() {
        let memedImage = generateMemedImage()
        self.meme = Meme(topText: topTextField.text!,
                        bottomText: bottomTextField.text!,
                        originalImage: imagePickerView.image!,
                        memedImage: memedImage)
    }

}
