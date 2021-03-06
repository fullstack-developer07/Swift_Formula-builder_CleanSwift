 //
 //  FBProfileInfoViewController.swift
 //  FormulaBuilderCS
 //
 //  Created by PFIdev on 2/11/17.
 //  Copyright (c) 2017 orgname. All rights reserved.
 //
 //  This file was generated by the Clean Swift XcovarTemplates so you can apply
 //  clean architecture to your iOS and Mac projects, see http://clean-swift.com
 //
 
 import UIKit
 import FZAccordionTableView
 import FormulaBuilderCore
 
 protocol FBProfileInfoViewControllerInput
 {
    func displayHerbs(viewModel: FBProfileInfo.Object.ViewModel)
    func displayNatures(viewModel: FBProfileInfo.Object.ViewModelItems)
    func displayFlavours(viewModel: FBProfileInfo.Object.ViewModelItems)
 }
 
 protocol FBProfileInfoViewControllerOutput
 {
    func fetchHerb(request: FBProfileInfo.Object.RequestHerb)
    func fetchFlavours(request: FBProfileInfo.Object.Request)
    func fetchNatures(request: FBProfileInfo.Object.Request)
 }
 
 class FBProfileInfoViewController: FBProfileBaseViewController
 {
    var output: FBProfileInfoViewControllerOutput!
    var router: FBProfileInfoRouter!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    @IBOutlet weak var lblChineseName: UILabel!
    @IBOutlet weak var lblChineseSimplifiedName: UILabel!
    @IBOutlet weak var lblTones: UILabel!
    
    @IBOutlet weak var createProfileView: UIView!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtDescription: UITextField!
    @IBOutlet weak var txtChineseName: UITextField!
    @IBOutlet weak var txtDescriptionLatin: UITextField!
    @IBOutlet weak var txtChineseNameTraditional: UITextField!
    @IBOutlet weak var txtAddTones: UITextField!
    @IBOutlet weak var txtFakeForKeyboardAlive: UITextField!
    @IBOutlet weak var btnAddTones: UIButton!
    @IBOutlet weak var btnAddLatin: UIButton!
    
    @IBOutlet weak var tv: FZAccordionTableView!
    
    var tCell : FBChannelTagsCell? = nil
    
    var natures: [String] = []
    var flavours: [String] = []
    var saveNatures: [String] = []
    var saveFlavours: [String] = []
    var flavoursAutoCompleteArray : [String] = []
    var naturesAutoCompleteArray : [String] = []
    var flavourContentText: String = "" // flavours, natures
    var natureContentText: String = ""
    
    var sectionLabels : [String]?
    var alternativeEnglishCommon : String = ""
    var alternativeLatinName : String = ""
    
    override func awakeFromNib() {
        super.awakeFromNib()
        FBProfileInfoConfigurator.sharedInstance.configure(viewController: self)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        configureInfo()
        configureTableView()
        setupInputAccessoryViewsForTextFields(txtFields: [txtName, txtDescription, txtChineseName, txtDescriptionLatin, txtChineseNameTraditional, txtFakeForKeyboardAlive])
        fetchAllObjects()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name:NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name:NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        refreshChannels()
    }
    
    func configureInfo() {
        let herb = profileMainViewController?.herb
        let formula = profileMainViewController?.formula
        let alternateHerb = profileMainViewController?.alternateHerb
        
        if let _ = herb
        {
            for alternateName in (herb?.alternateHerbs)!
            {
                profileMainViewController?.newAlternateNames.append(DisplayedAlternateHerb(with: alternateName))
            }
            saveFlavours = (herb?.flavours)!
            saveNatures = (herb?.natures)!
            flavourContentText = (herb?.flavours.joined(separator: ", "))!
            natureContentText = (herb?.natures.joined(separator: ", "))!
        }
        
        if (profileMainViewController!.profileViewType == .createFormula || profileMainViewController!.profileViewType == .createHerb) {
            createProfileView.isHidden = false
            txtName.placeholder = herb != nil ? "Add Herb Name" : "Add Formula Name"
            if herb == nil
            {
                btnAddTones.isHidden = false
                txtAddTones.isHidden = false
                btnAddLatin.isHidden = true
                txtDescriptionLatin.isHidden = true
            }
        } else {
            var displayedinfo : DisplayedProfileInfo?
            
            if (profileMainViewController!.profileViewType == .view) {
                if (herb != nil) {
                    displayedinfo = DisplayedProfileInfo(with: herb!)
                } else if (alternateHerb != nil) {
                    displayedinfo = DisplayedProfileInfo(with: alternateHerb!)
                } else {
                    displayedinfo = DisplayedProfileInfo(with: formula!)
                    lblTones.isHidden = false
                }
                
                createProfileView.isHidden = true
                lblName.text = displayedinfo?.name
                lblDescription.text = displayedinfo?.englishName
                lblChineseName.text = displayedinfo?.chineseSimplifiedName
                lblChineseSimplifiedName.text = displayedinfo?.chineseTraditionalName
                lblTones.text = displayedinfo?.pinyinTon
                
            } else {
                if (herb != nil) {
                    displayedinfo = DisplayedProfileInfo(with: herb!)
                } else if (alternateHerb != nil) {
                    displayedinfo = DisplayedProfileInfo(with: alternateHerb!)
                } else {
                    displayedinfo = DisplayedProfileInfo(with: formula!)
                }
                
                createProfileView.isHidden = false
                txtName.text = displayedinfo?.name
                txtDescription.text = displayedinfo?.englishName /// This is needed to be fixed after english name is defined.
                txtChineseName.text = displayedinfo?.chineseSimplifiedName
                txtChineseNameTraditional.text = displayedinfo?.chineseTraditionalName
                txtDescriptionLatin.text = displayedinfo?.latinName
                
                if herb == nil {
                    btnAddTones.isHidden = false
                    btnAddLatin.isHidden = true
                    txtDescriptionLatin.isHidden = true
                    txtAddTones.isHidden = false
                    txtAddTones.text = formula?.pinyinTon
                }
                
                let s : NSString = txtName.text! as NSString
                (profileMainViewController?.favoriteBarBtn?.customView as! UIButton).setTitleColor(s.length > 0 ? FBColor.hexColor_0076FF() : FBColor.hexColor_B4B4B4(), for: .normal)
            }
        }
    }
    
    func configureTableView() {
        tv.allowMultipleSectionsOpen = true
        tv.register(UINib(nibName: FBProfileAccordionViewTableHeaderView.kAccordionHeaderViewReuseIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: FBProfileAccordionViewTableHeaderView.kAccordionHeaderViewReuseIdentifier)
        tv.register(UINib(nibName: kTextCell, bundle: nil), forCellReuseIdentifier: kTextCell)
        tv.register(UINib(nibName: kChannelTagsCell, bundle: nil), forCellReuseIdentifier: kChannelTagsCell)
        tv.register(UINib(nibName: kAlternateNameCell, bundle: nil), forCellReuseIdentifier: kAlternateNameCell)
        tv.register(UINib(nibName: kAddAlternateCell, bundle: nil), forCellReuseIdentifier: kAddAlternateCell)
        tv.register(UINib(nibName: kTitleCell, bundle: nil), forCellReuseIdentifier: kTitleCell)
        tv.register(UINib(nibName: kAlternateNameViewCell, bundle: nil), forCellReuseIdentifier: kAlternateNameViewCell)
        if (profileMainViewController?.herb != nil || profileMainViewController?.profileViewType == .updateHerb || profileMainViewController?.profileViewType == .createHerb) {
            sectionLabels = ["Basic Information", "Alternate Names", "Actions", "Indications / Syndrome Patterns"]
        } else {
            sectionLabels = ["Actions", "Indications / Syndrome Patterns"]
        }
    }
    
    func fetchAllObjects() {
        if let herb = profileMainViewController?.herb {
            output.fetchHerb(request: FBProfileInfo.Object.RequestHerb(herb: herb))
            output.fetchFlavours(request: FBProfileInfo.Object.Request())
            output.fetchNatures(request: FBProfileInfo.Object.Request())
        }
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
            tv.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func refreshChannels() {
        let h = self.profileMainViewController?.herb
        guard h != nil, h!.channels.count > 0, tCell != nil else {
            return
        }
        
        tCell = nil
        tv.reloadRows(at: [IndexPath(row: 2, section: 0)], with: .none)
    }
 }
 
// MARK: Action Helpers
 extension FBProfileInfoViewController {
    func saveAlternateNames() {
        if profileMainViewController!.newAlternateNames.count == 0 {
            return
        }
        
        var indexPath = IndexPath(row: (profileMainViewController?.newAlternateNames.count)! + 2, section: 1)
        if let c = tv.cellForRow(at: indexPath) as? FBTextCell {
            alternativeEnglishCommon = c.txtContent.text!
        }
        
        indexPath = IndexPath(row: (profileMainViewController?.newAlternateNames.count)! + 3, section: 1)
        if let c = tv.cellForRow(at: indexPath) as? FBTextCell {
            alternativeLatinName = c.txtContent.text!
        }
        
        (profileMainViewController?.newAlternateNames)!.enumerated().forEach{ (index, item) in
            let indexPath = IndexPath(row: index + 1, section: 1)
            if let cell = tv.cellForRow(at: indexPath) as? FBAlternateNameCell
            {
                if cell.alternateName.text == ""
                {
                    return
                }
                var herbId = ""
                var herbName = ""
                if profileMainViewController?.profileViewType != .createHerb
                {
                    herbId = (profileMainViewController?.herb?.id)!
                    herbName = (profileMainViewController?.herb?.name)!
                }
                let alternateHerb = FBAlternateHerb(name: cell.alternateName.text!, id: item.id, readOnly: item.readOnly, herbName: herbName, herbID: herbId, pinyin: "", pinyinCode: "", simplifiedChinese: cell.simplifiedName.text!, traditionalChinese: cell.traditionalName.text!, preparation: "", englishCommons: [alternativeEnglishCommon], latinNames: [alternativeLatinName], sourceTextEnglish: "", sourceTextChinese: "", species: [], flavours: [], natures: [], channels: [], notes: [])
                profileMainViewController?.newAlternateNames[index] = DisplayedAlternateHerb(with: alternateHerb)
            }
        }
    }
    
    func addAlternateNameAction(indexpath: IndexPath) {
        let alternateName = DisplayedAlternateHerb()
        profileMainViewController?.newAlternateNames.append(alternateName)
        self.refreshTableView()
    }
    
    func expandAlternateNameAction(indexPath: IndexPath, alternateHerb: DisplayedAlternateHerb) {
        profileMainViewController?.newAlternateNames[indexPath.row - 1] = alternateHerb
        tv.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showDeleteWarning(indexPath: IndexPath) {
        let alternateHerb = profileMainViewController?.newAlternateNames[indexPath.row - 1]
        let alert = UIAlertController(title: "Remove \(alternateHerb!.name)?", message: "This action will also remove the preperation method for \(profileMainViewController!.herb!.name)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction.init(title: "Delete", style: .destructive, handler: { _ in
            if let alternateHerbId = alternateHerb?.id
            {
                if alternateHerb?.alternateHerbObj?.readOnly == false
                {
                    FBCoreWorker.shared.deleteAlternateHerb(id: alternateHerbId, completion: { error in
                        if error == nil {
                            self.profileMainViewController?.newAlternateNames.remove(at: indexPath.row - 1)
                            self.refreshTableView()
                        } else {
                            FBAlertHandler.shared.showAlert(with: self, text: error!.localizedDescription)
                        }
                    })
                }
            }else{
                self.profileMainViewController?.newAlternateNames.remove(at: indexPath.row - 1)
                self.refreshTableView()
            }
        }))
        present(alert, animated: true, completion: nil)
    }
    
    func navigateAction(alternateHerb: DisplayedAlternateHerb) {
        self.profileMainViewController?.topToolbarSwipeNavigation.setCurrentTabIndex(2, withAnimation: true)
    }
    
    func scrapeValues() {
        if (profileMainViewController?.herb != nil) {
            let englishCommmonCell = tv.cellForRow(at: IndexPath(row: 1, section: 1)) as! FBTextCell
            alternativeEnglishCommon = englishCommmonCell.txtContent.text!
            
            let latinCell = tv.cellForRow(at: IndexPath(row: 2, section: 1)) as! FBTextCell
            alternativeLatinName = latinCell.txtContent.text!
        }
    }
    
    func refreshTableView() {
        DispatchQueue.main.async {
            self.scrapeValues()
            self.tv.reloadData()
        }
    }
 }
 
// MARK: FBProfileInfoViewControllerInput
 extension FBProfileInfoViewController : FBProfileInfoViewControllerInput {
    func displayHerbs(viewModel: FBProfileInfo.Object.ViewModel){
        
    }
    
    func displayNatures(viewModel: FBProfileInfo.Object.ViewModelItems) {
        natures = viewModel.content
    }
    
    func displayFlavours(viewModel: FBProfileInfo.Object.ViewModelItems) {
        flavours = viewModel.content
    }
 }
 
// MARK: Button Handlers
 extension FBProfileInfoViewController {
    @IBAction func addNameBtnTapped(_ sender: Any) {
        
        let btn = sender as! UIButton
        if (!txtName.isFirstResponder) {
            txtName.becomeFirstResponder()
            btn.setImage(UIImage(named: "profile_add_selected") , for: .normal)
        } else {
            txtName.text = ""
            txtName.resignFirstResponder()
            btn.setImage(UIImage(named: "profile_add") , for: .normal)
        }
    }
    
    @IBAction func addDescriptionBtnTapped(_ sender: Any) {
        
        let btn = sender as! UIButton
        if (!txtDescription.isFirstResponder) {
            txtDescription.becomeFirstResponder()
            btn.setImage(UIImage(named: "profile_add_selected") , for: .normal)
        } else {
            txtDescription.text = ""
            txtDescription.resignFirstResponder()
            btn.setImage(UIImage(named: "profile_add") , for: .normal)
        }
    }
    
    @IBAction func addDescriptionLatinBtnTapped(_ sender: Any) {
        
        let btn = sender as! UIButton
        if (!txtDescriptionLatin.isFirstResponder) {
            txtDescriptionLatin.becomeFirstResponder()
            btn.setImage(UIImage(named: "profile_add_selected") , for: .normal)
        } else {
            txtDescriptionLatin.text = ""
            txtDescriptionLatin.resignFirstResponder()
            btn.setImage(UIImage(named: "profile_add") , for: .normal)
        }
    }
    
    @IBAction func addChineseNameBtnTapped(_ sender: Any) {
        
        let btn = sender as! UIButton
        if (!txtChineseName.isFirstResponder) {
            txtChineseName.becomeFirstResponder()
            btn.setImage(UIImage(named: "profile_add_selected") , for: .normal)
        } else {
            txtChineseName.text = ""
            txtChineseName.resignFirstResponder()
            btn.setImage(UIImage(named: "profile_add") , for: .normal)
        }
    }
    
    @IBAction func addChineseNameTraditionalBtnTapped(_ sender: Any) {
        
        let btn = sender as! UIButton
        if (!txtChineseNameTraditional.isFirstResponder) {
            txtChineseNameTraditional.becomeFirstResponder()
            btn.setImage(UIImage(named: "profile_add_selected") , for: .normal)
        } else {
            txtChineseNameTraditional.text = ""
            txtChineseNameTraditional.resignFirstResponder()
            btn.setImage(UIImage(named: "profile_add") , for: .normal)
        }
    }
    
    @IBAction func addTonesBtnTapped(_ sender: Any) {
        
        let btn = sender as! UIButton
        if (!txtAddTones.isFirstResponder) {
            txtAddTones.becomeFirstResponder()
            btn.setImage(UIImage(named: "profile_add_selected") , for: .normal)
        } else {
            txtAddTones.text = ""
            txtAddTones.resignFirstResponder()
            btn.setImage(UIImage(named: "profile_add") , for: .normal)
        }
    }
 }
 
// MARK: UITableViewDelegate, UITableViewDataSource
 extension FBProfileInfoViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (profileMainViewController?.herb != nil) {
            if (section == 0) {
                return 3 + flavoursAutoCompleteArray.count + naturesAutoCompleteArray.count
            } else if (section == 1) {
                if profileMainViewController?.profileViewType == .createHerb || profileMainViewController?.profileViewType == .updateHerb {
                    // addcell 1 + pinyin title cell 1 = 2, english common title, add english common, 
                    return (profileMainViewController?.newAlternateNames.count)! + 4
                } else {
                    // pinyin title cell 1
                    return (profileMainViewController?.newAlternateNames.count)! + 3
                }
            } else {
                return 0
            }
        } else {
            
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionLabels != nil ? sectionLabels!.count : 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let section = indexPath.section
        let row = indexPath.row
        
        if (profileMainViewController?.herb != nil && section == 0 && row == flavoursAutoCompleteArray.count + naturesAutoCompleteArray.count + 2) {
            if (tCell == nil) {
                tCell = tableView.dequeueReusableCell(withIdentifier: kChannelTagsCell) as? FBChannelTagsCell
                let herbData = profileMainViewController?.herb
                tCell?.configure(channels: herbData != nil ? herbData!.channels : [], profileViewType: profileMainViewController!.profileViewType)
            }
            
            tCell?.setNeedsLayout()
            tCell?.layoutIfNeeded()
            return tCell!.contentView.systemLayoutSizeFitting(UILayoutFittingCompressedSize).height + 1
        }
        
        if section == 1 && (profileMainViewController?.profileViewType == .createHerb || profileMainViewController?.profileViewType == .updateHerb) {
            guard row != 0 else {
                return 44
            }
            
            guard row != (profileMainViewController?.newAlternateNames.count)!+1 else {
                return 44
            }
            
            guard row < (profileMainViewController?.newAlternateNames.count)!+1 else {
                return FBTextCell.desiredHeight()
            }
            
            let expandFlag = (profileMainViewController?.newAlternateNames[row - 1].is_expandable)!
            return expandFlag ? 107 : 44
            
        } else if section == 1 && profileMainViewController?.profileViewType == .view {
            guard row != 0 else {
                return 40
            }
            
            guard row <= (profileMainViewController?.newAlternateNames.count)! else {
                return FBTextCell.desiredHeight()
            }
            
            return 75
        }
        
        return UITableViewAutomaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return FBProfileAccordionViewTableHeaderView.kDefaultAccordionHeaderViewHeight
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return self.tableView(tableView, heightForRowAt: indexPath)
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return self.tableView(tableView, heightForHeaderInSection:section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let row = indexPath.row
        var resCell : UITableViewCell?
        if (profileMainViewController?.herb != nil || profileMainViewController?.profileViewType == .updateHerb || profileMainViewController?.profileViewType == .createHerb) {
            let herbData = profileMainViewController?.herb
            if (section == 0) {
                if (row == 0) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: kTextCell, for: indexPath) as! FBTextCell
                    cell.configureTextCell(indexPath: indexPath,
                                           strTitle: "FLAVOUR",
                                           strSubTitle: flavourContentText,
                                           strPlaceholder: "Add Flavors", profileType:
                                           profileMainViewController!.profileViewType)
                    cell.cellDelegate = self
                    resCell = cell
                } else if (row == flavoursAutoCompleteArray.count + 1) {
                    let cell = tableView.dequeueReusableCell(withIdentifier: kTextCell, for: indexPath) as! FBTextCell
                    cell.configureTextCell(indexPath: indexPath,
                                           strTitle: "NATURE",
                                           strSubTitle: natureContentText,
                                           strPlaceholder: "Add Natures",
                                           profileType: profileMainViewController!.profileViewType)
                    cell.cellDelegate = self
                    resCell = cell
                } else if (row == flavoursAutoCompleteArray.count + naturesAutoCompleteArray.count + 2){
                    let cell = tableView.dequeueReusableCell(withIdentifier: kChannelTagsCell, for: indexPath) as! FBChannelTagsCell
                    cell.parentViewController = profileMainViewController
                    cell.configure(channels: herbData != nil ? herbData!.channels : [], profileViewType: profileMainViewController!.profileViewType)
                    resCell = cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: kTitleCell, for: indexPath) as! FBTitleCell
                    
                    if (flavoursAutoCompleteArray.count > 0 && row > 0 && row < flavoursAutoCompleteArray.count + 1) {
                        cell.configureCell(value: flavoursAutoCompleteArray[row - 1], autoComplete: true)
                    } else {
                        cell.configureCell(value: naturesAutoCompleteArray[row - flavoursAutoCompleteArray.count - 2], autoComplete: true)
                    }
                    resCell = cell
                }
            } else if section == 1 {
                if row == 0 {
                    let cell = tableView.dequeueReusableCell(withIdentifier: kTitleCell, for: indexPath) as! FBTitleCell
                    cell.configureCell(value: "PINYIN NAME")
                    resCell = cell
                } else if profileMainViewController?.profileViewType == .createHerb || profileMainViewController?.profileViewType == .updateHerb {
                    //expandable cell
                    if row == (profileMainViewController?.newAlternateNames.count)! + 1 {
                        let cell = tableView.dequeueReusableCell(withIdentifier: kAddAlternateCell, for: indexPath) as! FBAddAlternateCell
                        cell.vcdelegate = self
                        cell.indexPath = indexPath
                        resCell = cell
                    } else if (row == (profileMainViewController?.newAlternateNames.count)!+2) {
                        let cell = tableView.dequeueReusableCell(withIdentifier: kTextCell, for: indexPath) as! FBTextCell
                        cell.configureTextCell(indexPath: indexPath,
                                               strTitle: "ENGLISH COMMON NAME",
                                               strSubTitle: alternativeEnglishCommon,
                                               strPlaceholder: "Add Name",
                                               profileType: profileMainViewController!.profileViewType,
                                               isEnglish: true)
                        resCell = cell
                        
                    } else if (row == (profileMainViewController?.newAlternateNames.count)!+3) {
                        let cell = tableView.dequeueReusableCell(withIdentifier: kTextCell, for: indexPath) as! FBTextCell
                        cell.configureTextCell(indexPath: indexPath,
                                               strTitle: "LATIN NAME",
                                               strSubTitle: alternativeLatinName,
                                               strPlaceholder: "Add Name",
                                               profileType: profileMainViewController!.profileViewType,
                                               isEnglish: true)
                        resCell = cell
                        
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: kAlternateNameCell, for: indexPath) as! FBAlternateNameCell
                        cell.configureCell(displayAlternateName: (profileMainViewController?.newAlternateNames[indexPath.row - 1])!)
                        cell.indexPath = indexPath
                        cell.parentViewController = self
                        resCell = cell
                    }
                } else {
                    
                    if (row == (profileMainViewController?.newAlternateNames.count)!+1) {
                        let cell = tableView.dequeueReusableCell(withIdentifier: kTextCell, for: indexPath) as! FBTextCell
                        cell.configureTextCell(indexPath: indexPath,
                                               strTitle: "ENGLISH COMMON NAME",
                                               strSubTitle: alternativeEnglishCommon,
                                               strPlaceholder: "Add Name",
                                               profileType: profileMainViewController!.profileViewType,
                                               isEnglish: true)
                        resCell = cell
                        
                    } else if (row == (profileMainViewController?.newAlternateNames.count)!+2) {
                        let cell = tableView.dequeueReusableCell(withIdentifier: kTextCell, for: indexPath) as! FBTextCell
                        cell.configureTextCell(indexPath: indexPath,
                                               strTitle: "LATIN NAME",
                                               strSubTitle: alternativeLatinName,
                                               strPlaceholder: "Add Name",
                                               profileType: profileMainViewController!.profileViewType,
                                               isEnglish: true)
                        resCell = cell
                        
                    } else {
                        let cell = tableView.dequeueReusableCell(withIdentifier: kAlternateNameViewCell, for: indexPath) as! FBAlternateNameViewCell
                        let alternateHerb = self.profileMainViewController?.newAlternateNames[row - 1]
                        cell.configureCell(alternateHerb: alternateHerb!)
                        cell.parentViewController = self
                        resCell = cell
                    }
                }
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: kTextCell, for: indexPath) as! FBTextCell
            cell.configureTextCell(indexPath: indexPath,
                                   strTitle: "TEST", strSubTitle: "",
                                   strPlaceholder: "",
                                   profileType: profileMainViewController!.profileViewType)
            resCell = cell
        }
        return resCell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let accordionView = tableView.dequeueReusableHeaderFooterView(withIdentifier: FBProfileAccordionViewTableHeaderView.kAccordionHeaderViewReuseIdentifier) as! FBProfileAccordionViewTableHeaderView
        accordionView.configureAccordionView(title: sectionLabels![section], isEnabled: self.tableView(tableView, numberOfRowsInSection: section) > 0)
        return accordionView
    }
    
    func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row

        guard section == 0 else { return false }
        guard row != 0 && row != flavoursAutoCompleteArray.count + 1 && row != flavoursAutoCompleteArray.count + naturesAutoCompleteArray.count + 2 else { return false }
        
        return true
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        cell?.backgroundColor = UIColor.clear
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        let row = indexPath.row
        
        guard section == 0 else { return }
        guard row != 0 && row != flavoursAutoCompleteArray.count + 1 && row != flavoursAutoCompleteArray.count + naturesAutoCompleteArray.count + 2 else { return }
        
        var txtField: UITextField?
        if (flavoursAutoCompleteArray.count > 0 && row > 0 && row < flavoursAutoCompleteArray.count + 1) {
            saveFlavours.append(flavoursAutoCompleteArray[row - 1])
            flavourContentText = saveFlavours.joined(separator: ", ")
            flavoursAutoCompleteArray.removeAll()
            txtField = (tv.cellForRow(at: IndexPath(row: 0, section: 0)) as! FBTextCell).txtContent
        } else {
            saveNatures.append(naturesAutoCompleteArray[row - flavoursAutoCompleteArray.count - 2])
            natureContentText = saveNatures.joined(separator: ", ")
            naturesAutoCompleteArray.removeAll()
            txtField = (tv.cellForRow(at: IndexPath(row: flavoursAutoCompleteArray.count + 1, section: 0)) as! FBTextCell).txtContent
        }
        
        self.txtFakeForKeyboardAlive.becomeFirstResponder()
        self.refreshTableView()
        txtField?.perform(#selector(becomeFirstResponder), with: nil, afterDelay: 0.02)
    }
 }
 
// MARK: FZAccordionTableViewDelegate
 extension FBProfileInfoViewController : FZAccordionTableViewDelegate {
    func tableView(_ tableView: FZAccordionTableView, willOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
    }
    
    func tableView(_ tableView: FZAccordionTableView, didOpenSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        let accordionView = header as! FBProfileAccordionViewTableHeaderView
        accordionView.disclosure_Icon.image = UIImage(named: "arrow_up")
    }
    
    func tableView(_ tableView: FZAccordionTableView, willCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        
    }
    
    func tableView(_ tableView: FZAccordionTableView, didCloseSection section: Int, withHeader header: UITableViewHeaderFooterView?) {
        let accordionView = header as! FBProfileAccordionViewTableHeaderView
        accordionView.disclosure_Icon.image = UIImage(named: "arrow_down")
    }
    
    func tableView(_ tableView: FZAccordionTableView, canInteractWithHeaderAtSection section: Int) -> Bool {
        return true
    }
 }
 
// MARK: UITextFieldDelegate
 extension FBProfileInfoViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField == txtName) {
            var s : NSString = txtName.text! as NSString
            s = s.replacingCharacters(in: range, with: string) as NSString
            (profileMainViewController?.favoriteBarBtn?.customView as! UIButton).setTitleColor(s.length > 0 ? FBColor.hexColor_0076FF() : FBColor.hexColor_B4B4B4(), for: .normal)
        }
        return true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let btn = self.view.viewWithTag(textField.tag + 1) as! UIButton
        btn.setImage(UIImage(named: "profile_add_selected") , for: .normal)
        return true
    }
 }
 
// MARK: FBTextCellDelegate
extension FBProfileInfoViewController: FBTextCellDelegate {
    func textFieldBeginEdit(txtField: UITextField, indexPath: IndexPath) {
        self.tv.scrollToRow(at: indexPath, at: .top, animated: false)
    }
    
    func textFieldEditing(txtField: UITextField, indexPath: IndexPath) {
        let generateAutoCompleteString : ((_ all: [String], _ alreadyExist: [String], _ searchText: String) -> [String]) = { (all : [String]?, already: [String]?, s : String) -> [String] in
            guard let autoCompletedValues = all?.filter({ (v) -> Bool in
                return (v.lowercased().range(of: s.lowercased()) != nil) && (!already!.contains(v))
            }) else {
                return []
            }
            
            return autoCompletedValues.count > 0 ? autoCompletedValues.chunk(5).first! : autoCompletedValues
        }

        let section = indexPath.section
        let row = indexPath.row
        let text = txtField.text!
        let filterText = text.components(separatedBy: ",").last!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard section == 0 else { return }
        if (row == 0) {
            flavoursAutoCompleteArray = generateAutoCompleteString(flavours, saveFlavours, filterText)
            flavourContentText = text
        } else {
            naturesAutoCompleteArray = generateAutoCompleteString(natures, saveNatures, filterText)
            natureContentText = text
        }
        
        self.txtFakeForKeyboardAlive.becomeFirstResponder()
        refreshTableView()
        txtField.perform(#selector(becomeFirstResponder), with: nil, afterDelay: 0.01)
    }
    
    func keyboardDismissOnTextCell(txtField: UITextField) {

    }
}
