//
//  AddNotesVC.swift
//  Aviation
//
//  Created by Zestbrains on 19/11/21.
//

import UIKit
import Speech
import AVFoundation
import Toaster

class AddNotesVC : UIViewController {
    
    //MARK: - OUTLETS
    @IBOutlet weak var viewScreenData: UIView! {
        didSet {
            viewScreenData.roundCornersWithMask(corners: [.topLeft, .topRight], radius: 20.0)
        }
    }
    
    @IBOutlet weak var txtDate: AppCommonTextField!
    @IBOutlet weak var txtTime: AppCommonTextField!
            
    @IBOutlet weak var collectionTags: UICollectionView!
    
    @IBOutlet weak var txtNotes: UITextView!
    
    @IBOutlet weak var txtPrivateNotes: UITextView!
    
    @IBOutlet weak var SpeechView: UIControl!
    @IBOutlet weak var lblSpeakingWord: UILabel!
    
    @IBOutlet weak var lblLastEditedDate: UILabel!
    @IBOutlet weak var txtTag: AppCommonTextField!
    
    @IBOutlet weak var viewDownloadButtons: UIView!
    @IBOutlet weak var btnSave: UIButton!
    
    //MARK: - VARIABLES
    var studentID : Int = 0
    var notesModel : ModelStudentNotes!
    var isFromEdit : Bool = false

    //SpeechWords
    var audioEngine = AVAudioEngine()
    var speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_IN"))
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    var isFinalSearch : Bool = false
    var searchText : String = ""

    var recordingForPrivateNote : Bool = false
    
    //TAGS
    private let createNoteVM = CreateNoteViewModel()
    
    var datePicker :UIDatePicker = UIDatePicker()
    
    
    //MARK: - VIEW DID LOAD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setPickers()
        setInitalData()
        
        collectionTags.registerCell(type: TagsCVC.self)

        collectionTags.setDefaultProperties(vc: self)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }

    
    //MARK: - BUTTON ACTIONS
    
    @IBAction func btnBackClicks(_ sender: Any) {
        self.popTo()
    }
        
    @IBAction func btnSaveAndExportClicks(_ sender: Any) {
        addDataInModel()
        
        createEditNote()
    }
    
    @IBAction func btnSaveClicks(_ sender: Any) {
        addDataInModel()
        
        createEditNote()
    }
    
    @IBAction func btnDownloadClicks(_ sender: Any) {
        addDataInModel()
        
        createEditNote(isDownload: true)

    }
    
    @IBAction func btnNotesSpeechClicks(_ sender: Any) {
        recordingForPrivateNote = false
        self.requestSpeechAuthorization()
    }

    @IBAction func btnPrivateNotesSpeechClicks(_ sender: Any) {
        recordingForPrivateNote = true
        self.requestSpeechAuthorization()
    }

    
    @IBAction func btnCloseSpeechView(_ sender: Any) {
        
        self.SpeechView.isHidden = true
        self.lblSpeakingWord.text = "Listening.."
        self.cancelRecording()
        
    }
    
    @IBAction func btnCloseSpeech(_ sender: Any) {
        
        stopRecordingAndSetLabels()
        
    }
}

//MARK: - GENERAL METHODS
extension  AddNotesVC {
    
    func setPickers() {

        let datePicker = UIDatePicker()
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }

        datePicker.datePickerMode = .dateAndTime
        datePicker.addTarget(self, action: #selector(dateChanged(sender:)), for: .valueChanged)
        txtDate.inputView = datePicker
        datePicker.maximumDate = Date()
        
        let timePicker = UIDatePicker()
        timePicker.locale = Locale(identifier: "en_GB")
        if #available(iOS 14, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }
        timePicker.datePickerMode = .time
        timePicker.addTarget(self, action: #selector(timeChanged(sender:)), for: .valueChanged)
        txtTime.inputView = timePicker
        
        txtNotes.delegate = self
        txtTag.delegate = self
        txtPrivateNotes.delegate = self
    }

    @objc func dateChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy hh:mm a"
        txtDate.text = dateFormatter.string(from: sender.date)
    }

    @objc func timeChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        
        let fullStr = dateFormatter.string(from: sender.date)
        let strHours = fullStr.components(separatedBy: ":").first
        let strMin = fullStr.components(separatedBy: ":").last
        txtTime.text = "\(strHours ?? "0") Hours \(strMin ?? "00") Minutes"
    }

}

//MARK: - UITextFieldDelegate METHODS
extension  AddNotesVC : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == txtTag {
            if !(textField.text!.isEmpty) &&  !(createNoteVM.arrTags.contains(where: {$0.lowercased() == textField.text!})) {
                
                createNoteVM.arrTags.append(textField.text!)
                collectionTags.reloadData()
                textField.text = ""
            }
        }
    }
}


//MARK: - SPEECH TO TEXT FUNCTIONS
extension AddNotesVC  {
    
    func setSpeechSearch() {
        
        self.SpeechView.isHidden = false
        //self.recordAndRecognizeSpeech()
        
        do{
            //self.lblSearingWords.text = ""
            try self.startRecording()
                        
        } catch(let error) {
            print("error is \(error.localizedDescription)")
        }
    }
    
    //MARK: - Check Authorization Status
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                    case .authorized:
                        self.isFinalSearch = false
                        self.setSpeechSearch()
                    case .denied:
                    showAlertWithTitleFromVC(vc: self, title: "Request Denied", andMessage: "User denied access to speech recognition, Please allow speech recognition from settings", buttons: ["Cancel", "Open Settings"]) { index in
                        
                        if index == 1 {
                            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                                return
                            }
                            
                            if UIApplication.shared.canOpenURL(settingsUrl) {
                                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                    print("Settings opened: \(success)") // Prints true
                                })
                            }
                        }
                    }
                    
                    case .restricted:
                    showAlertWithTitleFromVC(vc: self, andMessage: "Speech recognition restricted on this device")

                    case .notDetermined:
                    
                    self.requestSpeechAuthorization()
                    
                    //showAlertWithTitleFromVC(vc: self, andMessage: "Speech recognition not yet authorized")
                    @unknown default:
                        return
                }
            }
        }
    }
    
    func startRecording() throws {
        
        recognitionTask?.cancel()
        self.recognitionTask = nil

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        let inputNode = audioEngine.inputNode
        inputNode.removeTap(onBus: 0)
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { print("Unable to create a SFSpeechAudioBufferRecognitionRequest object")
            return
        }
        recognitionRequest.shouldReportPartialResults = true

        if #available(iOS 13, *) {
            if speechRecognizer?.supportsOnDeviceRecognition ?? false{
                recognitionRequest.requiresOnDeviceRecognition = true
            }
        }

        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest) { result, error in
            
            if let result = result {
                DispatchQueue.main.async {
                    let transcribedString = result.bestTranscription.formattedString
                    print("transcribedString" , transcribedString)
                    self.lblSpeakingWord.text = self.searchText + (transcribedString)
                    
                    if result.isFinal {
                        self.searchText += (transcribedString)
                        self.isFinalSearch = true
                        self.setSearchString()
                    }
                    
                    print(result.isFinal)
                }
            }
            
            if error != nil {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
//                self.recognitionRequest = nil
//                self.recognitionTask = nil
            }
        }
    }
    
    func stopRecordingAndSetLabels() {
        if self.searchText != "" {
            self.cancelRecording()
            
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                
                if !self.isFinalSearch {
                    self.setSearchString()
                }
            }
            
        } else {
            self.SpeechView.isHidden = true
            self.lblSpeakingWord.text = "Listening.."
            self.cancelRecording()
        }
    }
    
    func setSearchString() {
        
        self.SpeechView.isHidden = true
        
        if recordingForPrivateNote {
            txtPrivateNotes.text = searchText
            
        }else {
            txtNotes.text = searchText
            DispatchQueue.main.asyncAfter(deadline: .now()) {
                self.getTags()
            }
        }
        
        self.searchText = ""
        self.lblSpeakingWord.text = "Listening.."
        //self.cancelRecording()
    }

    
    func cancelRecording() {
        searchText = ""
        recognitionTask?.finish()
        recognitionTask = nil
        
        // stop audio
        self.recognitionRequest?.endAudio()
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        self.recognitionRequest = nil
        
        
        audioEngine = AVAudioEngine()
        speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en_IN"))
        recognitionRequest = nil
        recognitionTask = nil
        self.isFinalSearch = false
        searchText = ""

    }
    
}


//MARK: - COLLECTIONVIEW METHODS
extension  AddNotesVC : UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if createNoteVM.arrTags.count == 0 {
            collectionView.setEmptyMessage("No tags found!")
        }else {
            collectionView.restore()
        }
        
        return createNoteVM.arrTags.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagsCVC", for: indexPath) as?  TagsCVC {
            
            cell.lblTags.text = createNoteVM.arrTags[indexPath.row]
            cell.isShowRemoveBtn = true
            cell.deleteCloser = { sender in
                self.createNoteVM.arrTags.remove(at: indexPath.row)
                collectionView.reloadData()
            }

            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: collectionView.frame.size.height))
        
        lbl.numberOfLines = 1
        lbl.font = Font(.installed(.Regular), size: .standard(.h513)).instance
        
        lbl.text = createNoteVM.arrTags[indexPath.row]
        lbl.sizeToFit()
        lbl.frame.size.height = collectionView.frame.size.height
        
        let spacing : CGFloat = 20
        let deleteBtnSize : CGFloat = collectionView.frame.size.height //collectionView.frame.size.height - if there is remove button show
        
        return CGSize(width: lbl.frame.size.width + (spacing * 2) + deleteBtnSize , height: collectionView.frame.size.height)
    }
}

//MARK: - UITextViewDelegate
extension AddNotesVC : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if textView == txtNotes {
            
            if !textView.text!.isEmpty {
                self.getTags()
            }
        }
    }
}

//MARK: - APIs Call
extension  AddNotesVC {
    
    func getTags() {
        
        createNoteVM.strNote = txtNotes.text ?? ""
        createNoteVM.getTags { response in
            //success
            print(response)
            self.collectionTags.reloadData()
            
        } failure: { error in
            //error
        }
    }
 
    private func createEditNote(isDownload : Bool = false) {
        
        createNoteVM.AddEditNoteAPI { success in
            
            if isDownload {
                downloadDocument(strFile: success["data"]["pdf_url"].stringValue, strFileName: "Aviation_Note_\(Date().timeIntervalSince1970).pdf")
            }else {
                Toast(text: success["message"].stringValue).show()
                self.popTo()
            }
        } failure: { errorResponse in
            //fails
        }
    }
    
}


//MARK: - GENERAL METHODS
extension  AddNotesVC {
        
    private func addDataInModel() {
        createNoteVM.vc = self
        
        createNoteVM.studentID = studentID
        
        createNoteVM.strNote = txtNotes.text ?? ""
        
        createNoteVM.strPrivateNote = txtPrivateNotes.text ?? ""
        
        createNoteVM.strNoteDateTime = txtDate.text ?? ""
        
        createNoteVM.strTotalTime = txtTime.text ?? ""
    }
 
    private func setInitalData() {
        
        if isFromEdit {
            viewDownloadButtons.isHidden = true
            btnSave.isHidden = false
            lblLastEditedDate.isHidden = false
            
            self.bindData()
        }else {
            viewDownloadButtons.isHidden = false
            btnSave.isHidden = true
            lblLastEditedDate.isHidden = true
        }
    }
        
    private func bindData() {
        
        viewScreenData.isHidden = false
        
        if let obj = notesModel {
            
            txtDate.text = getStrDateFromDate(date: (obj.datetime ?? ""), fromFormat: "yyyy-MM-dd HH:mm:ss", toFormat: "dd MMM yyyy, hh:mm a")
            
            txtTime.text = obj.totalHours
            
            createNoteVM.arrTags.removeAll()
            createNoteVM.arrTags = obj.tags.components(separatedBy: ",")
            collectionTags.reloadData()
            
            txtNotes.text = obj.note
            txtPrivateNotes.text = obj.privateNote
            
            studentID = obj.studentId
            createNoteVM.studentID = obj.studentId
            createNoteVM.noteID = obj.id
            
            lblLastEditedDate.text = getStrDateFromDate(date: (obj.updated_at ?? ""), toFormat: "dd MMM yyyy, hh:mm a") 
        }
    }
        
}

