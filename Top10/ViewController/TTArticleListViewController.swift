//
//  TTArticleListViewController.swift
//  Top10
//
//  Created by Muluken Gebremariam on 11/1/17.
//  Copyright © 2017 Keeple. All rights reserved.
//

import UIKit
import GameKit //TODO
import Alamofire

class TTArticleListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, TTSettingsViewControllerDelegate {
    
    private var articlesListContext = 0
    let dragEffectFactor : CGFloat = 0.5
    let colorLayer = CAGradientLayer()
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var weekdayLabel: UILabel!
    @IBOutlet weak var topImageView: UIImageView!
    @IBOutlet weak var articlesTableView: UITableView!
    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var settingsButton: UIButton!
    
    var articles = [TTArticle]() {
        didSet {
            self.errorLabel.isHidden = self.articles.count > 0
            
            self.loadTopImage()
            self.updateTopImageViewOverlayColor()
            self.articlesTableView.reloadData();
        }
    }
    
    var date = Date()  {
        didSet {
            self.loadArticles()
            self.updateDateLabels()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.errorLabel.isHidden = true
        self.topImageView.isUserInteractionEnabled = false
        self.overlayView.isUserInteractionEnabled = false

        articlesTableView.backgroundColor = UIColor.clear
        articlesTableView.estimatedRowHeight = 354
        articlesTableView.rowHeight = UITableViewAutomaticDimension
        articlesTableView.register(TTArticleTableViewCell.nib, forCellReuseIdentifier: TTArticleTableViewCell.identifier)
        self.articlesTableView.contentInset = UIEdgeInsetsMake(self.topImageView.frame.size.height * 0.85, 0.0, 0.0, 0.0);
        self.articlesTableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topImageView.frame.size.height * 0.85, 0.0, 0.0, 0.0);
        
        setUpTopImageView()
        self.definesPresentationContext = true
        self.date = Date()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let isDarkThemeOn = UserDefaults.standard.bool(forKey: TTUserDefaultsKey.darkTheme)
        self.view.backgroundColor = isDarkThemeOn ? UIColor.black : UIColor.white
        self.articlesTableView.separatorColor = isDarkThemeOn ? UIColor.darkGray : UIColor.init(white: 0.8, alpha: 1)
        self.articlesTableView.reloadData()
        
        if self.articles.count == 0  {
            self.loadArticles()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.articlesTableView.delaysContentTouches = true;
        self.articlesTableView.canCancelContentTouches = true;
        self.articlesTableView.autoresizingMask = [.flexibleHeight, .flexibleHeight];
        self.articlesTableView.contentInset = UIEdgeInsetsMake(self.topImageView.frame.size.height * 0.85, 0.0, 0.0, 0.0);
        self.articlesTableView.scrollIndicatorInsets = UIEdgeInsetsMake(self.topImageView.frame.size.height * 0.85, 0.0, 0.0, 0.0);
        self.articlesTableView.addObserver(self, forKeyPath: "contentOffset", options: [.new, .old], context: &articlesListContext)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - IButton actions
    @IBAction func settingsButtonAction(_ sender: Any) {
        
        let controller: TTSettingsViewController? = (storyboard?.instantiateViewController(withIdentifier: "TTSettingsViewController") as? TTSettingsViewController)
        controller?.modalTransitionStyle = .crossDissolve
        controller?.modalPresentationStyle = .currentContext
        controller?.delegate = self
        
        let navigationController = UINavigationController(rootViewController: controller!)
        navigationController.modalTransitionStyle = .crossDissolve
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.hidesBottomBarWhenPushed = true

        self.present(navigationController, animated: true, completion: nil)
    }
    
    // MARK: - UITableViewDataSource methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return articles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let article = articles[indexPath.row] as TTArticle
        let cell = tableView.dequeueReusableCell(withIdentifier: TTArticleTableViewCell.identifier, for: indexPath) as! TTArticleTableViewCell
        cell.backgroundColor = UIColor.white
        setUpArticleCell(cell: cell, article: article, indexPath: indexPath, date: self.date)
        cell.selectionStyle = .none
        return cell
    }

    // MARK: - UITableViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let controller: TTArticlePageViewController? = (storyboard?.instantiateViewController(withIdentifier: "TTArticlePageViewController") as? TTArticlePageViewController)
        controller?.articles = self.articles
        controller?.articleIndex = indexPath.row
        controller?.date = self.date
        navigationController?.pushViewController(controller!, animated: true)
    }
    
    // MARK: - TTSettingsViewControllerDelegate methods
    func settingsViewController(_ settingsViewController: TTSettingsViewController, didSelectDate date: Date) {
        self.date = date
        
        let isDarkThemeOn = UserDefaults.standard.bool(forKey: TTUserDefaultsKey.darkTheme)
        self.view.backgroundColor = isDarkThemeOn ? UIColor.black : UIColor.white
        self.articlesTableView.separatorColor = isDarkThemeOn ? UIColor.darkGray : UIColor.init(white: 0.8, alpha: 1)
        self.articlesTableView.reloadData();
        self.loadArticles()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func settingsViewControllerDidCancel(_ settingsViewController: TTSettingsViewController) {
        let isDarkThemeOn = UserDefaults.standard.bool(forKey: TTUserDefaultsKey.darkTheme)
        self.view.backgroundColor = isDarkThemeOn ? UIColor.black : UIColor.white
        self.articlesTableView.separatorColor = isDarkThemeOn ? UIColor.darkGray : UIColor.init(white: 0.8, alpha: 1)
        self.articlesTableView.reloadData();
        self.loadArticles()
        
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - KVO
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context == &articlesListContext {
            if let changeDictionary = change as? [NSKeyValueChangeKey: NSValue] {
                let oldOffset = changeDictionary[NSKeyValueChangeKey.oldKey]?.cgSizeValue
                let newOffset = changeDictionary[NSKeyValueChangeKey.newKey]?.cgSizeValue

                let yOffsetDelta = (newOffset?.height)! - (oldOffset?.height)!
                self.tableViewDidScrollBy(yOffsetChange:yOffsetDelta);
            }
        }
        else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
    }
    
    // MARK: - API
    func fetchMostViewedNYTimesArticles(section : String, timePeriod: Int ) {
        
        var resultArticles = [TTArticle]()
        let apiClient = TTAPIClient.sharedInstance
        let topStoriesPath = NYTimesAPI.apiPath + "/" + NYTimesAPI.mostViewedArticlesPath + "/" + section + ".json?api-key=\(NYTimesAPI.apiKey)"
        
        
        apiClient.sendGetRequest(path:topStoriesPath){
            guard $0.result.isSuccess else {
                self.showErrorLabel()
                return
            }
            
            guard let responseJSON = $0.result.value as? [String: Any] else {
                self.showErrorLabel()
                return
            }
            
            print(responseJSON)

            if let articlesJSON = responseJSON["results"] as? [[String: Any]] {
                var includedSections: Set<String> = Set()
                for case let result in articlesJSON {
                    if let article = TTArticle(dict: result) {
                        if(!includedSections.contains(article.section!)) {
                            includedSections.insert(article.section!)
                            resultArticles.append(article)
                        }
                    }
                }

                self.articles = Array(resultArticles.prefix(TTData.articlesLimit))
                TTUtil.saveArticlesToHistory(self.articles, date: Date())

                // TODO: Uncomment the next line to test history
                self.populateHistoryWithTodaysArticles()
            }
            else {
                self.showErrorLabel()
            }
        }
    }
    
    // MARK: - Data helper methods
    func loadArticles() {
        self.topImageView.image = UIImage.init(named: "topTenLogoWhiteAlphaSmall")
        self.topImageView.contentMode = .center
        if let savedArticles = TTUtil.articles(forDate: self.date) {
            self.articles = savedArticles
        }
        else {

            if Calendar.current.isDateInToday(self.date) {
               self.fetchMostViewedNYTimesArticles(section: "home", timePeriod: 1)
            }
        }
    }
    
    func loadTopImage(){
        if let firstArticle = self.articles.first {
            if let urlString = firstArticle.frontImageUrl {
                if let url = URL(string: urlString) {
                    self.topImageView.contentMode = .scaleAspectFill
                    downloadImage(url: url)
                }
            }
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    func downloadImage(url: URL) {
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                self.topImageView.image = UIImage(data: data)
            }
        }
    }
    
    // TODO: Remove. This is only to test if history works.
    func populateHistoryWithTodaysArticles() {
        for i in stride(from: -1, through: -6, by: -1) {
            let date = Calendar.current.date(byAdding: .day, value: i, to:Date())
            let shuffled = GKMersenneTwisterRandomSource().arrayByShufflingObjects(in: self.articles)
            TTUtil.saveArticlesToHistory(shuffled as! [TTArticle], date: date!)
        }
    }
    
    // MARK: - View helper methods
    func setUpArticleCell(cell: TTArticleTableViewCell, article: TTArticle, indexPath: IndexPath, date:Date) {
        
        let sectionColor = TTUtil.colorFor(section: article.section!)
        
        cell.numberLabel.text = "\(indexPath.row + 1)"
        cell.sectionLabel.text = article.section
        cell.titleLabel.text = article.title
        cell.abstractLabel.text = article.abstract
        
        let isDarkThemeOn = UserDefaults.standard.bool(forKey: TTUserDefaultsKey.darkTheme)
        cell.titleLabel.textColor = isDarkThemeOn ? UIColor.white : UIColor.darkText
        cell.abstractLabel.textColor = isDarkThemeOn ? UIColor.lightGray : UIColor.darkGray
        
        cell.sectionLabel.textColor = sectionColor
        cell.sectionLabel.backgroundColor = UIColor.clear
        
        cell.numberLabel.textColor = TTUtil.isArticleRead(article, date: date) ? UIColor.white : sectionColor
        cell.numberLabel.backgroundColor = TTUtil.isArticleRead(article, date: date) ? sectionColor : UIColor.clear
        cell.numberLabel.layer.borderColor = sectionColor.cgColor
        cell.numberLabel.layer.cornerRadius = cell.numberLabel.frame.size.width / 2
        cell.numberLabel.layer.borderWidth = 2.0
        cell.numberLabel.layer.masksToBounds = true
        
        cell.backgroundColor = UIColor.clear
    }
    
    func showErrorLabel() {
        self.errorLabel.isHidden = false
    }
    
    func hideErrorLable() {
        self.errorLabel.isHidden = true
    }
    
    func updateDateLabels(){
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let currentYear = calendar.component(.year, from: Date())
        
        if year == currentYear {
            dateFormatter.dateFormat = "MMMM d"
        }
        else {
            dateFormatter.dateFormat = "MMMM d, yyyy"
        }
        
        let dateString = dateFormatter.string(from:date)
        dateFormatter.dateFormat = "EEEE"
        let dayOfWeek = dateFormatter.string(from: date)
        
        self.dateMonthLabel.text = dateString
        self.weekdayLabel.text = dayOfWeek
    }
    
    func updateTopImageViewOverlayColor(){
        if let firstArticle = self.articles.first {
            if let section = firstArticle.section {
                let overlayColor = TTUtil.colorFor(section: section)
                self.colorLayer.colors = [overlayColor.cgColor, overlayColor.withAlphaComponent(0.4)]
            }
        }
    }
    
    func setUpTopImageView(){

        let overlayColor = TTColor.color6
        
        self.colorLayer.startPoint = CGPoint(x:0.0, y:1.0)
        self.colorLayer.endPoint = CGPoint(x:1.5, y:-1.0)
        self.colorLayer.colors = [overlayColor.cgColor, overlayColor.cgColor]
        self.colorLayer.frame = CGRect(x: 0, y: 0, width: self.overlayView.frame.size.width, height: self.overlayView.frame.size.height)

        let colorLayerPath = UIBezierPath()
        colorLayerPath.move(to: CGPoint(x: 0, y: self.view.frame.size.height * -0.4))
        colorLayerPath.addLine(to: CGPoint(x: 0, y: self.topImageView.frame.size.height * 0.7))
        colorLayerPath.addLine(to: CGPoint(x: self.topImageView.frame.size.width, y: self.topImageView.frame.size.height))
        colorLayerPath.addLine(to: CGPoint(x: self.topImageView.frame.size.width, y: self.view.frame.size.height * -0.4))
        colorLayerPath.close()
        
        let imageMaskPath = UIBezierPath()
        imageMaskPath.move(to: CGPoint(x: 0, y: self.view.frame.size.height * -0.4))
        imageMaskPath.addLine(to: CGPoint(x: 0, y: self.topImageView.frame.size.height * 0.7 - 2))
        imageMaskPath.addLine(to: CGPoint(x: self.topImageView.frame.size.width, y: self.topImageView.frame.size.height - 2))
        imageMaskPath.addLine(to: CGPoint(x: self.topImageView.frame.size.width, y: self.view.frame.size.height * -0.4))
        imageMaskPath.close()
        
        let colorMaskLayer = CAShapeLayer()
        colorMaskLayer.path = colorLayerPath.cgPath
        colorMaskLayer.strokeColor = UIColor.clear.cgColor
        colorMaskLayer.fillColor = UIColor.black.cgColor
        colorMaskLayer.fillRule = kCAFillRuleNonZero
        
        let maskLayer = CAShapeLayer()
        maskLayer.path = imageMaskPath.cgPath
        maskLayer.strokeColor = UIColor.clear.cgColor
        maskLayer.fillColor = UIColor.black.cgColor
        maskLayer.fillRule = kCAFillRuleNonZero

        self.overlayView.layer.addSublayer(colorLayer)
        self.colorLayer.mask = colorMaskLayer
        self.topImageView.layer.mask = maskLayer

        self.overlayView.backgroundColor = UIColor.clear

    }
    
    func tableViewDidScrollBy(yOffsetChange: CGFloat){
        // push imageView
        var topImageViewFrame = self.topImageView.frame;
        topImageViewFrame.origin.y -= (yOffsetChange * self.dragEffectFactor)
        self.topImageView.frame = topImageViewFrame
        
        // push overlay view
        var imageOverlayViewFrame = self.overlayView.frame;
        imageOverlayViewFrame.origin.y -= (yOffsetChange * self.dragEffectFactor)
        self.overlayView.frame = imageOverlayViewFrame
        
        //push dateMonthLabel
        var dateMonthLabelFrame = self.dateMonthLabel.frame;
        dateMonthLabelFrame.origin.y -= (yOffsetChange * self.dragEffectFactor)
        self.dateMonthLabel.frame = dateMonthLabelFrame
        
        //push dateMonthLabel
        var weekdayLabelFrame = self.weekdayLabel.frame;
        weekdayLabelFrame.origin.y -= (yOffsetChange * self.dragEffectFactor)
        self.weekdayLabel.frame = weekdayLabelFrame
    }
}

