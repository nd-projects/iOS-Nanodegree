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

class ViewController: UIViewController {
    @IBOutlet var imagePickerView: UIImageView!
    @IBOutlet var cameraButton: UIBarButtonItem!
    @IBOutlet var topTextField: UITextField!
    @IBOutlet var bottomTextField: UITextField!
    @IBOutlet var toolbar: UIToolbar!
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

        initializeTextField(topTextField, defaultTextTop)
        initializeTextField(bottomTextField, defaultTextBottom)
    }

    @objc func keyboardWillShow(_ notification: Notification) {
        if bottomTextField.isEditing, view.frame.origin.y == 0 {
            view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }

    @objc func keyboardWillHide(_: Notification) {
        view.frame.origin.y = 0
    }

    @objc func shareMeme() {
        updateMeme()
        let activityViewController = UIActivityViewController(activityItems: [meme.memedImage],
                                                              applicationActivities: nil)
        activityViewController.isModalInPresentation = true
        activityViewController.completionWithItemsHandler = {
            (activityType: UIActivity.ActivityType?,
            completed: Bool,
            returnedItems: [Any]?,
            error: Error?) in
            if !completed {
                return
            }
            // TODO: - Do not save if the user chose "Save Image" as their action
            self.save()
        }

        self.present(activityViewController, animated: true)
    }

    // MARK: - Private functions
    private func initializeTextField(_ textField: UITextField, _ text: String) {
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth: -3.0
        ]

        textField.defaultTextAttributes = memeTextAttributes
        textField.text = text
        textField.autocapitalizationType = .allCharacters
        textField.textAlignment = .center
        textField.delegate = self
    }

    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        guard let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
            return 0
        }
        return keyboardSize.cgRectValue.height
    }

    private func subscribeToKeyboardNotifiactions() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(_:)),
                                               name: UIResponder.keyboardWillShowNotification,
                                               object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(_:)),
                                               name: UIResponder.keyboardWillHideNotification,
                                               object: nil)
    }

    private func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func updateMeme() {
        let memedImage = generateMemedImage()
        meme = Meme(topText: topTextField.text!,
                    bottomText: bottomTextField.text!,
                    originalImage: imagePickerView.image!,
                    memedImage: memedImage)
    }

    private func generateMemedImage() -> UIImage {
        toolbar.isHidden = true
        navigationController?.setToolbarHidden(true, animated: false)

        UIGraphicsBeginImageContext(view.frame.size)
        view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        toolbar.isHidden = false
        navigationController?.setToolbarHidden(false, animated: false)

        return memedImage
    }

    private func save() {
        UIImageWriteToSavedPhotosAlbum(self.meme.memedImage, nil, nil, nil)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    @IBAction func pickAnImage(_: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = .photoLibrary
        present(pickerController, animated: true, completion: nil)
    }

    @IBAction func takePhoto(_: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }

    func imagePickerController(_: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            imagePickerView.image = pickedImage
            navigationItem.rightBarButtonItem?.isEnabled = true
        }
    }

    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UINavigationControllerDelegate
extension ViewController: UINavigationControllerDelegate {}

// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
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
            break
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case topTextField:
            if textField.text == "" {
                textField.text = defaultTextTop
            }
        case bottomTextField:
            if textField.text == "" {
                textField.text = defaultTextBottom
            }
        default:
            break
        }

        textField.resignFirstResponder()

        return true
    }
}
