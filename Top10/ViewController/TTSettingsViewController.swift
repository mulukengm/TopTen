//
//  TTSettingsViewController.swift
//  Top10
//
//  Created by Muluken Gebremariam on 11/5/17.
//  Copyright © 2017 Keeple. All rights reserved.
//

import UIKit

class TTSettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var daysTableView: UITableView!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var darkThemeSwitch: UISwitch!
    @IBOutlet weak var bookmarksButton: UIButton!
    
    weak var delegate: TTSettingsViewControllerDelegate?
    var dates = [Date]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let isDarkThemeOn = UserDefaults.standard.bool(forKey: TTUserDefaultsKey.darkTheme)
        self.darkThemeSwitch.setOn(isDarkThemeOn, animated: false)
        
        dates = TTUtil.availableArticleDates()
        self.configureBackground()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK - IB actions
    @IBAction func closeButtonAction(_ sender: Any) {
        if delegate != nil {
            delegate?.settingsViewControllerDidCancel(self)
        }
    }
    
    @IBAction func bookmarksButtonAction(_ sender: Any) {
    }
    
    @IBAction func darkThemeSwitchValueChanged(_ sender: Any) {
        UserDefaults.standard.set(self.darkThemeSwitch.isOn, forKey: TTUserDefaultsKey.darkTheme)
    }
    
    // MARK - UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 83
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
                return UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
            }
            return cell
        }()
        
        let date = dates[indexPath.row]
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let currentYear = calendar.component(.year, from: Date())
        
        if year == currentYear {
            dateFormatter.dateFormat = "MM/dd"
        }
        else {
            dateFormatter.dateFormat = "MM/dd/yyyy"
        }

        let dateString = dateFormatter.string(from:date)
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeek = dateFormatter.string(from: date)

        cell.textLabel?.text = dateString
        cell.detailTextLabel?.text = dayOfWeek
        cell.textLabel?.textColor = UIColor.init(white: 1, alpha: 0.8)
        cell.detailTextLabel?.textColor = UIColor.init(white: 1, alpha: 0.8)

        cell.backgroundColor = UIColor.clear
        
        return cell
    }
    
    // MARK - UITableViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if delegate != nil {
            delegate?.settingsViewController(self, didSelectDate: self.dates[indexPath.row])
        }
    }
    
    // MARK: - UI helper methods
    func configureBackground () {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(blurEffectView)
        self.view.sendSubview(toBack: blurEffectView)
        
        self.view.backgroundColor = UIColor.clear
        
        self.navigationController?.navigationBar.isHidden = true
    }
}

protocol TTSettingsViewControllerDelegate: NSObjectProtocol {
    
    func settingsViewController(_ settingsViewController: TTSettingsViewController, didSelectDate date: Date)
    
    func settingsViewControllerDidCancel(_ settingsViewController: TTSettingsViewController)
    
}
