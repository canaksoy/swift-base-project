
import UIKit
import FSPagerView

class FeedViewController: BaseViewController, FSPagerViewDelegate, FSPagerViewDataSource {
    
    var eventsData = [Event]()
    var challengesData = [Challenge]()
    
    var tableView = UITableView(frame: .zero, style: .grouped)
    var refreshControl:UIRefreshControl!
    
    var eventsPager : FSPagerView!
    
    var isLoading = false
    var isFirst = true
    var pageEnd = false
    
    var tView : helloView!
    var roonyView : UIView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
    }
    
    @objc open func goProfile() {
        let profileVC: UIViewController = storyboardMain.instantiateViewController(withIdentifier: "profile") as! ProfileViewController
        self.navigationController?.pushViewController(profileVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.setObserver(self, selector: #selector(self.refreshData), name: NSNotification.Name(rawValue: "refreshFeedNotif"), object: nil)

        loadUI()
        loadFeed()
    }
    
    func loadUI() {
        
        //self.navigationItem.titleView = helloView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        
        tView = helloView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 44))
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goProfile))
        tView.profile.addGestureRecognizer(tap)
        //self.view.addSubview(t)
        self.navigationItem.titleView = tView
        
        
        //self.view.addSubview(scrollView)
        //scrollView.autoPinEdgesToSuperviewEdges()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ChallengeTableViewCell.classForCoder(), forCellReuseIdentifier: "ChallengeTableViewCell")
        tableView.separatorStyle = .none
        tableView.contentInset = UIEdgeInsets(top: 6, left: 0, bottom: 40, right: 0)
        tableView.backgroundColor = UIColor.white
        tableView.keyboardDismissMode = .onDrag
        tableView.alpha = 0
//        if #available(iOS 11.0, *) {
//            tableView.contentInsetAdjustmentBehavior = .never
//        }
        //tableView.emptyDataSetSource = self
        //tableView.emptyDataSetDelegate = self
        self.view.addSubview(tableView)
        tableView.autoPinEdgesToSuperviewEdges()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: UIControl.Event.valueChanged)
        if #available(iOS 10.0, *) {
            tableView.refreshControl = refreshControl
        } else {
            // Fallback on earlier versions
            tableView.addSubview(refreshControl)
        }
        
        let notifTypeString = UserDefaults.standard.string(forKey: "notifType")
        
        if (notifTypeString == nil || notifTypeString == "") {
            
        } else {
            self.goNotif()
        }
    }
    
    @objc func refreshData() {
        
        pageEnd = false
        isLoading = false
        isFirst = true
        
        self.challengesData = [Challenge]()
        self.eventsData = [Event]()
        self.tableView.reloadData()
        
        loadFeed()
        
    }
    
    func loadFeed() {
        
        if (isLoading == true) {
            return
        }
        
        isLoading = true
        
        let parameters = [
            "token" : AppCache.sharedInstance.token,
            "auth": AppCache.sharedInstance.auth,
            "last_id" : self.challengesData.last?.id ?? 0
            ] as [String : Any]
        
        API.sharedInstance.get(url: "feed", params: parameters as [String : AnyObject]) { (json, error) in
            
            self.isLoading = false
            self.refreshControl.endRefreshing()
            
            if let e = error {
                print(e)
                ShowErrorMessage.statusLine(message: e.localizedDescription)
            } else {
                guard json["status"].boolValue == true else {
                    self.stopAnimating()
                    let mesage = json["messages"].stringValue
                    ShowErrorMessage.statusLine(message: mesage)
                    return
                }
                
                let challenges_array = json["data"]["challenges"].arrayValue
                let events_array = json["data"]["events"].arrayValue
                
                if (challenges_array.count==0) {
                    self.pageEnd = true
                }
                
                for i in 0..<challenges_array.count {
                    self.challengesData.append(Challenge(json: challenges_array[i]))
                }
                
                self.eventsData = [Event]()
                for i in 0..<events_array.count {
                    self.eventsData.append(Event(json: events_array[i]))
                }
                
                self.isFirst = false
                self.tableView.reloadData()
                self.tableView.fadeIn()
                
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func goProfileLeft(_ button:UIButton) {
        
        let user = self.challengesData[button.tag].challengeUsers.first?.user
        
        baseGoUser(user: user!)
    }
    
    @objc func goProfileRight(_ button:UIButton) {
        
        let user = self.challengesData[button.tag].challengeUsers.last?.user
        
        baseGoUser(user: user!)
        
    }
    
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return eventsData.count
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "EventCollectionViewCell", at: index) as! EventCollectionViewCell
        cell.backgroundColor = UIColor.clear
        
        let event = eventsData[index]
        
        cell.imageView?.sd_setImage(with: URL(string: event.header_image!))
        cell.imageView?.backgroundColor = UIColor.grayLight
        cell.imageView?.contentMode = .scaleAspectFill
        cell.imageView?.clipsToBounds = true
        cell.imageView?.layer.masksToBounds = true
        cell.imageView?.layer.cornerRadius = 10
        
        cell.isHighlighted = false
        
        cell.contentView.layer.shadowRadius = 4
        cell.contentView.layer.shadowOpacity = 0.3
        cell.contentView.layer.shadowOffset = CGSize(width: 0, height: 2)
        
        cell.setCell(event: event)
        
        return cell
        
    }
    
    func pagerView(_ pagerView: FSPagerView, didSelectItemAt index: Int) {
        
        pagerView.deselectItem(at: index, animated: true)
        
        let event = eventsData[index]
        
        let eventVC = storyboardMain.instantiateViewController(withIdentifier: "eventdetail") as! EventDetailViewController
        eventVC.event = event
        self.navigationController?.pushViewController(eventVC, animated: true)
    }

    @objc func goDiscover() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setSelectedTab(index: 1)
    }
    
    @objc func goNotif() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.setSelectedTab(index: 4)
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
extension FeedViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (challengesData != nil) {
            return challengesData.count
        } else {
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let challenge = self.challengesData[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChallengeTableViewCell", for: indexPath) as! ChallengeTableViewCell
        cell.setCell(challenge: challenge)
//        cell.leftUserPhoto.button.addTarget(self, action: #selector(goProfileLeft(_:)), for: .touchUpInside)
//        cell.rightUserPhoto.button.addTarget(self, action: #selector(goProfileRight(_:)), for: .touchUpInside)
//        cell.leftUserPhoto.button.tag = indexPath.row
//        cell.rightUserPhoto.button.tag = indexPath.row
        cell.leftUserPhoto.button.isHidden = true
        cell.rightUserPhoto.button.isHidden = true
        cell.selectionStyle = .none
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let challenge = self.challengesData[indexPath.row]
        
        let challengeVC = storyboardMain.instantiateViewController(withIdentifier: "challengedetail") as! ChallengeDetailViewController
        challengeVC.challenge = challenge
        self.navigationController?.pushViewController(challengeVC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        if (isFirst == false && challengesData.count == 0) {
         
            roonyView = UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: 500))
            roonyView.backgroundColor = UIColor.clear
            //roonyView.alpha = 0
            
            let imgRoony = UIImageView()
            imgRoony.image = #imageLiteral(resourceName: "roony")
            imgRoony.contentMode = .scaleAspectFit
            roonyView.addSubview(imgRoony)
            imgRoony.autoPinEdge(.top, to: .top, of: roonyView, withOffset: 20)
            imgRoony.autoSetDimension(.width, toSize: 110)
            imgRoony.autoSetDimension(.height, toSize: 155)
            imgRoony.autoAlignAxis(.vertical, toSameAxisOf: roonyView)
            
            let titleLabel = UILabel()
            titleLabel.font = AppFont.ExtraBold.pt20
            titleLabel.text = "Selam!".localized()
            titleLabel.textAlignment = .center
            roonyView.addSubview(titleLabel)
            titleLabel.autoPinEdge(.top, to: .bottom, of: imgRoony, withOffset: 10)
            titleLabel.autoSetDimension(.width, toSize: 300)
            titleLabel.autoSetDimension(.height, toSize: 30)
            titleLabel.autoAlignAxis(.vertical, toSameAxisOf: roonyView)
            
            let subtitleLabel = UILabel()
            subtitleLabel.font = AppFont.ExtraLight.pt12
            subtitleLabel.text = "".localized()
            subtitleLabel.textAlignment = .center
            subtitleLabel.numberOfLines = 0
            roonyView.addSubview(subtitleLabel)
            subtitleLabel.autoPinEdge(.top, to: .bottom, of: titleLabel, withOffset: 0)
            subtitleLabel.autoPinEdge(.left, to: .left, of: roonyView, withOffset: 40)
            subtitleLabel.autoPinEdge(.right, to: .right, of: roonyView, withOffset: -40)
            subtitleLabel.autoSetDimension(.height, toSize: 80)
            subtitleLabel.autoAlignAxis(.vertical, toSameAxisOf: roonyView)
            
            let joinButton = RedButton()
            joinButton.title = "DEMO".localized()
            joinButton.addTarget(self, action: #selector(self.goNotif), for: .touchUpInside)
            roonyView.addSubview(joinButton)
            joinButton.autoPinEdge(.top, to: .bottom, of: subtitleLabel, withOffset: 20)
            joinButton.autoPinEdge(.left, to: .left, of: roonyView, withOffset: 20)
            joinButton.autoPinEdge(.right, to: .right, of: roonyView, withOffset: -20)
            joinButton.autoSetDimension(.height, toSize: 50)
            
            let subtitleLabel2 = UILabel()
            subtitleLabel2.font = AppFont.ExtraLight.pt12
            subtitleLabel2.text = "Bla bla".localized()
            subtitleLabel2.textAlignment = .center
            subtitleLabel2.numberOfLines = 0
            roonyView.addSubview(subtitleLabel2)
            subtitleLabel2.autoPinEdge(.top, to: .bottom, of: joinButton, withOffset: 10)
            subtitleLabel2.autoPinEdge(.left, to: .left, of: roonyView, withOffset: 40)
            subtitleLabel2.autoPinEdge(.right, to: .right, of: roonyView, withOffset: -40)
            subtitleLabel2.autoSetDimension(.height, toSize: 60)
            subtitleLabel2.autoAlignAxis(.vertical, toSameAxisOf: roonyView)
            
            let listButton = SteelBorderButton()
            listButton.title = "LOREM".localized()
            listButton.addTarget(self, action: #selector(self.goDiscover), for: .touchUpInside)
            roonyView.addSubview(listButton)
            listButton.autoPinEdge(.top, to: .bottom, of: joinButton, withOffset: 80)
            listButton.autoPinEdge(.left, to: .left, of: roonyView, withOffset: 20)
            listButton.autoPinEdge(.right, to: .right, of: roonyView, withOffset: -20)
            listButton.autoSetDimension(.height, toSize: 50)
            
            return roonyView
            
        } else {
            return UIView()
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (isFirst == false && challengesData.count == 0) {
            return 500
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return bannerH + 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView=UIView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: bannerH+20))
        headerView.backgroundColor = UIColor.clear
        
        eventsPager = FSPagerView(frame: CGRect(x: 0, y: 0, width: screenSize.width, height: bannerH))
        eventsPager.dataSource = self
        eventsPager.delegate = self
        //bannerView.infiniteDataSource = self
        //bannerView.infiniteDelegate = self
        //bannerView.register(BannerCollectionViewCell.self, forCellWithReuseIdentifier: "BannerCollectionViewCell")
        eventsPager.register(EventCollectionViewCell.self, forCellWithReuseIdentifier: "EventCollectionViewCell")
        eventsPager.backgroundColor = UIColor.clear
        //annerView.showsHorizontalScrollIndicator = false
        //bannerView.isPagingEnabled = true
        //eventsPager.isInfinite = true
        eventsPager.automaticSlidingInterval = 10.0
        eventsPager.itemSize = CGSize(width: screenSize.width-40, height: bannerH-20)
        eventsPager.interitemSpacing = 10
        eventsPager.clipsToBounds = true
        headerView.addSubview(eventsPager)
        
        return headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if(pageEnd == false ) {
            if (isLoading == false) {
                if ((indexPath.row + 1) % (self.challengesData.count) == 0) {
                    self.loadFeed()
                }
            }
        }
    }

}
