
import UIKit
import CHIPageControl
import NVActivityIndicatorView
import SwiftyStoreKit
import FBSDKCoreKit

class ProViewController: UIViewController, UIScrollViewDelegate, NVActivityIndicatorViewable {

    var proView : UIView!
    var scrollViewPro : UIScrollView!
    var pageControlPro = CHIPageControlJaloro()
    var textView = UITextView()
    
    var priceBG = UIView()
    var selectedBox = UIView()
    
    var subs1month = UILabel()
    var subs1monthsub = UILabel()
    var subs1price = UILabel()
    var subs1promo = UILabel()
    
    var subs2month = UILabel()
    var subs2monthsub = UILabel()
    var subs2price = UILabel()
    var subs2promo = UILabel()
    
    var subs3month = UILabel()
    var subs3monthsub = UILabel()
    var subs3price = UILabel()
    var subs3promo = UILabel()
    
    var selectedIndex = 1
    
    func startLoading() {
        startAnimating(nil, message: nil, type: NVActivityIndicatorType.ballClipRotate, color: UIColor.pinkred, padding: 10, displayTimeThreshold: nil, minimumDisplayTime: 100)
        
    }
    
    func stopLoading() {
        stopAnimating()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.black

//        proView = UIView()
//        proView.backgroundColor = UIColor.black.withAlphaComponent(0.95)
//        UIApplication.topViewController()?.view.addSubview(proView)
//        //UIApplication.shared.keyWindow?.rootViewController?.view.addSubview(proView)
//        proView.autoPinEdgesToSuperviewEdges()
        
        let whiteView = UIView()
        whiteView.backgroundColor = UIColor.white
        whiteView.layer.cornerRadius = 10
        whiteView.clipsToBounds = true
        self.view.addSubview(whiteView)
        whiteView.autoSetDimension(.height, toSize: 450)
        whiteView.autoSetDimension(.width, toSize: screenSize.width-40)
        whiteView.autoCenterInSuperview()
        
        let logo = UIImageView(image: #imageLiteral(resourceName: "logoRooners"))
        logo.contentMode = .scaleAspectFit
        whiteView.addSubview(logo)
        logo.autoPinEdge(.top, to: .top, of: whiteView, withOffset: 20)
        logo.autoSetDimension(.width, toSize: 120)
        logo.autoSetDimension(.height, toSize: 20)
        logo.autoAlignAxis(.vertical, toSameAxisOf: whiteView)
        
        let imgPro = UIImageView(image: #imageLiteral(resourceName: "pro"))
        imgPro.contentMode = .scaleAspectFit
        whiteView.addSubview(imgPro)
        imgPro.autoPinEdge(.left, to: .right, of: logo, withOffset: 5)
        imgPro.autoPinEdge(.top, to: .top, of: logo, withOffset: 2)
        imgPro.autoSetDimension(.width, toSize: 29)
        imgPro.autoSetDimension(.height, toSize: 15)
        
        scrollViewPro = UIScrollView(frame: CGRect(x: 0, y: 50, width: screenSize.width-40, height: 180))
        whiteView.addSubview(scrollViewPro)
        scrollViewPro.contentSize = CGSize(width: (screenSize.width-40)*3, height: 180)
        scrollViewPro.isPagingEnabled = true
        scrollViewPro.delegate = self
        scrollViewPro.showsHorizontalScrollIndicator = false
        scrollViewPro.alwaysBounceVertical = false
        
        let title1 = UILabel(frame: CGRect(x: 30, y: 0, width: screenSize.width-100, height: 80))
        title1.font = AppFont.ExtraBold.pt20
        title1.textColor = .black
        title1.textAlignment = .center
        title1.numberOfLines = 0
        title1.text = "PRO 1".localized()
        scrollViewPro.addSubview(title1)
        
        let desc1 = UILabel(frame: CGRect(x: 30, y: 70, width: screenSize.width-100, height: 60))
        desc1.font = AppFont.ExtraLight.pt12
        desc1.textColor = .black
        desc1.textAlignment = .center
        desc1.numberOfLines = 0
        desc1.text = "PRO 1...".localized()
        scrollViewPro.addSubview(desc1)
        
        let title2 = UILabel(frame: CGRect(x: scrollViewPro.width+30, y: 0, width: screenSize.width-100, height: 80))
        title2.font = AppFont.ExtraBold.pt20
        title2.textColor = .black
        title2.textAlignment = .center
        title2.numberOfLines = 0
        title2.text = "PRO 2".localized()
        scrollViewPro.addSubview(title2)
        
        let desc2 = UILabel(frame: CGRect(x: scrollViewPro.width+30, y: 70, width: screenSize.width-100, height: 60))
        desc2.font = AppFont.ExtraLight.pt12
        desc2.textColor = .black
        desc2.textAlignment = .center
        desc2.numberOfLines = 0
        desc2.text = "PRO 2...".localized()
        scrollViewPro.addSubview(desc2)
        
        let title3 = UILabel(frame: CGRect(x: (scrollViewPro.width*2)+30, y: 0, width: screenSize.width-100, height: 80))
        title3.font = AppFont.ExtraBold.pt20
        title3.textColor = .black
        title3.textAlignment = .center
        title3.numberOfLines = 0
        title3.text = "PRO 3".localized()
        scrollViewPro.addSubview(title3)
        
        let desc3 = UILabel(frame: CGRect(x: (scrollViewPro.width*2)+30, y: 70, width: screenSize.width-100, height: 60))
        desc3.font = AppFont.ExtraLight.pt12
        desc3.textColor = .black
        desc3.textAlignment = .center
        desc3.numberOfLines = 0
        desc3.text = "PRO 3...".localized()
        scrollViewPro.addSubview(desc3)
        
        pageControlPro.numberOfPages = 3
        pageControlPro.tintColor = .darkGray
        pageControlPro.currentPageTintColor = .black
        pageControlPro.padding = 1
        pageControlPro.radius = 0
        pageControlPro.elementHeight = 2
        whiteView.addSubview(pageControlPro)
        pageControlPro.autoPinEdge(.top, to: .top, of: whiteView, withOffset: 180)
        pageControlPro.autoSetDimension(.width, toSize: 60)
        pageControlPro.autoSetDimension(.height, toSize: 10)
        pageControlPro.autoAlignAxis(.vertical, toSameAxisOf: whiteView)
        
        priceBG.backgroundColor = UIColor.grayLight
        whiteView.addSubview(priceBG)
        priceBG.autoPinEdge(.bottom, to: .bottom, of: whiteView, withOffset: -135)
        priceBG.autoPinEdge(.left, to: .left, of: whiteView, withOffset: 0)
        priceBG.autoPinEdge(.right, to: .right, of: whiteView, withOffset: 0)
        priceBG.autoSetDimension(.height, toSize: 110)
        
        let popular = UILabel()
        popular.text = "En Popüler".localized()
        popular.font = AppFont.ExtraBold.pt10
        popular.textAlignment = .center
        popular.textColor = UIColor.white
        popular.backgroundColor = UIColor.marigold
        popular.layer.cornerRadius = 2
        popular.layer.masksToBounds = true
        whiteView.addSubview(popular)
        popular.autoPinEdge(.top, to: .top, of: priceBG, withOffset: -10)
        popular.autoSetDimension(.width, toSize: ((screenSize.width-40)/3)-20)
        popular.autoSetDimension(.height, toSize: 20)
        popular.autoAlignAxis(.vertical, toSameAxisOf: priceBG)
        
        selectedBox.backgroundColor = UIColor.clear
        selectedBox.borderWidth = 1.0
        selectedBox.borderColor = UIColor.marigold
        selectedBox.layer.cornerRadius = 4
        priceBG.addSubview(selectedBox)
        selectedBox.autoPinEdge(.top, to: .top, of: priceBG, withOffset: 0)
        selectedBox.autoPinEdge(.left, to: .left, of: priceBG, withOffset: (screenSize.width-40)/3)
        selectedBox.autoSetDimension(.width, toSize: (screenSize.width-40)/3)
        selectedBox.autoSetDimension(.height, toSize: 110)
        
        subs1month.text = "1"
        subs1month.font = AppFont.ExtraBold.pt32
        subs1month.textColor = UIColor.black.withAlphaComponent(0.5)
        subs1month.textAlignment = .center
        priceBG.addSubview(subs1month)
        subs1month.autoPinEdge(.top, to: .top, of: priceBG, withOffset: 10)
        subs1month.autoPinEdge(.left, to: .left, of: priceBG, withOffset: 0)
        subs1month.autoSetDimension(.width, toSize: (screenSize.width-40)/3)
        subs1month.autoSetDimension(.height, toSize: 40)
        
        subs1monthsub.text = "Ay".localized()
        subs1monthsub.font = AppFont.ExtraLight.pt10
        subs1monthsub.textColor = UIColor.steel
        subs1monthsub.textAlignment = .center
        priceBG.addSubview(subs1monthsub)
        subs1monthsub.autoPinEdge(.top, to: .top, of: priceBG, withOffset: 48)
        subs1monthsub.autoPinEdge(.left, to: .left, of: priceBG, withOffset: 0)
        subs1monthsub.autoSetDimension(.width, toSize: (screenSize.width-40)/3)
        subs1monthsub.autoSetDimension(.height, toSize: 14)
        
        subs1price.text = IAPData[0].price
        subs1price.font = AppFont.ExtraBold.pt12
        subs1price.textColor = UIColor.black.withAlphaComponent(0.5)
        subs1price.textAlignment = .center
        priceBG.addSubview(subs1price)
        subs1price.autoPinEdge(.top, to: .top, of: priceBG, withOffset: 68)
        subs1price.autoPinEdge(.left, to: .left, of: priceBG, withOffset: 0)
        subs1price.autoSetDimension(.width, toSize: (screenSize.width-40)/3)
        subs1price.autoSetDimension(.height, toSize: 20)
        
        
        
        subs2month.text = "6"
        subs2month.font = AppFont.ExtraBold.pt32
        subs2month.textColor = UIColor.black
        subs2month.textAlignment = .center
        priceBG.addSubview(subs2month)
        subs2month.autoPinEdge(.top, to: .top, of: priceBG, withOffset: 10)
        subs2month.autoPinEdge(.left, to: .left, of: priceBG, withOffset: (screenSize.width-40)/3)
        subs2month.autoSetDimension(.width, toSize: (screenSize.width-40)/3)
        subs2month.autoSetDimension(.height, toSize: 40)
        
        subs2monthsub.text = "Ay".localized()
        subs2monthsub.font = AppFont.ExtraLight.pt10
        subs2monthsub.textColor = UIColor.black
        subs2monthsub.textAlignment = .center
        priceBG.addSubview(subs2monthsub)
        subs2monthsub.autoPinEdge(.top, to: .top, of: priceBG, withOffset: 48)
        subs2monthsub.autoPinEdge(.left, to: .left, of: priceBG, withOffset: (screenSize.width-40)/3)
        subs2monthsub.autoSetDimension(.width, toSize: (screenSize.width-40)/3)
        subs2monthsub.autoSetDimension(.height, toSize: 14)
        
        subs2price.text = IAPData[1].price
        subs2price.font = AppFont.ExtraBold.pt12
        subs2price.textColor = UIColor.black
        subs2price.textAlignment = .center
        priceBG.addSubview(subs2price)
        subs2price.autoPinEdge(.top, to: .top, of: priceBG, withOffset: 68)
        subs2price.autoPinEdge(.left, to: .left, of: priceBG, withOffset: (screenSize.width-40)/3)
        subs2price.autoSetDimension(.width, toSize: (screenSize.width-40)/3)
        subs2price.autoSetDimension(.height, toSize: 20)
        
        subs2promo.text = "1 Ay Hediye".localized()
        subs2promo.font = AppFont.ExtraBold.pt10
        subs2promo.textColor = UIColor.marigold
        subs2promo.textAlignment = .center
        priceBG.addSubview(subs2promo)
        subs2promo.autoPinEdge(.top, to: .top, of: priceBG, withOffset: 88)
        subs2promo.autoPinEdge(.left, to: .left, of: priceBG, withOffset: (screenSize.width-40)/3)
        subs2promo.autoSetDimension(.width, toSize: (screenSize.width-40)/3)
        subs2promo.autoSetDimension(.height, toSize: 20)
        
        let trial = UILabel()
        trial.text = "1 HAFTA ÜCRETSİZ DENE".localized()
        trial.font = AppFont.Regular.pt12
        trial.textColor = UIColor.darkGray
        trial.textAlignment = .center
        whiteView.addSubview(trial)
        trial.autoPinEdge(.top, to: .bottom, of: priceBG, withOffset: 5)
        trial.autoSetDimension(.width, toSize: screenSize.width-40)
        trial.autoSetDimension(.height, toSize: 30)
        trial.autoAlignAxis(.vertical, toSameAxisOf: priceBG)
        
        subs3month.text = "12"
        subs3month.font = AppFont.ExtraBold.pt32
        subs3month.textColor = UIColor.black.withAlphaComponent(0.5)
        subs3month.textAlignment = .center
        priceBG.addSubview(subs3month)
        subs3month.autoPinEdge(.top, to: .top, of: priceBG, withOffset: 10)
        subs3month.autoPinEdge(.left, to: .left, of: priceBG, withOffset: ((screenSize.width-40)/3)*2)
        subs3month.autoSetDimension(.width, toSize: (screenSize.width-40)/3)
        subs3month.autoSetDimension(.height, toSize: 40)
        
        subs3monthsub.text = "Ay".localized()
        subs3monthsub.font = AppFont.ExtraLight.pt10
        subs3monthsub.textColor = UIColor.steel
        subs3monthsub.textAlignment = .center
        priceBG.addSubview(subs3monthsub)
        subs3monthsub.autoPinEdge(.top, to: .top, of: priceBG, withOffset: 48)
        subs3monthsub.autoPinEdge(.left, to: .left, of: priceBG, withOffset: ((screenSize.width-40)/3)*2)
        subs3monthsub.autoSetDimension(.width, toSize: (screenSize.width-40)/3)
        subs3monthsub.autoSetDimension(.height, toSize: 14)
        
        subs3price.text = IAPData[2].price
        subs3price.font = AppFont.ExtraBold.pt12
        subs3price.textColor = UIColor.black.withAlphaComponent(0.5)
        subs3price.textAlignment = .center
        priceBG.addSubview(subs3price)
        subs3price.autoPinEdge(.top, to: .top, of: priceBG, withOffset: 68)
        subs3price.autoPinEdge(.left, to: .left, of: priceBG, withOffset: ((screenSize.width-40)/3)*2)
        subs3price.autoSetDimension(.width, toSize: (screenSize.width-40)/3)
        subs3price.autoSetDimension(.height, toSize: 20)
        
        subs3promo.text = "2 Ay Hediye".localized()
        subs3promo.font = AppFont.ExtraBold.pt10
        subs3promo.textColor = UIColor.marigold
        subs3promo.textAlignment = .center
        priceBG.addSubview(subs3promo)
        subs3promo.autoPinEdge(.top, to: .top, of: priceBG, withOffset: 88)
        subs3promo.autoPinEdge(.left, to: .left, of: priceBG, withOffset: ((screenSize.width-40)/3)*2)
        subs3promo.autoSetDimension(.width, toSize: (screenSize.width-40)/3)
        subs3promo.autoSetDimension(.height, toSize: 20)
        
        let priceBG1 = UIButton()
        priceBG1.addTarget(self, action: #selector(self.buy1m), for: .touchUpInside)
        priceBG1.backgroundColor = UIColor.clear
        priceBG.addSubview(priceBG1)
        priceBG1.autoPinEdge(.top, to: .top, of: priceBG, withOffset: 0)
        priceBG1.autoPinEdge(.left, to: .left, of: priceBG, withOffset: 0)
        priceBG1.autoSetDimension(.width, toSize: (screenSize.width-40)/3)
        priceBG1.autoSetDimension(.height, toSize: 110)
        
        let priceBG2 = UIButton()
        priceBG2.addTarget(self, action: #selector(self.buy6m), for: .touchUpInside)
        priceBG2.backgroundColor = UIColor.clear
        priceBG.addSubview(priceBG2)
        priceBG2.autoPinEdge(.top, to: .top, of: priceBG, withOffset: 0)
        priceBG2.autoPinEdge(.left, to: .left, of: priceBG, withOffset: (screenSize.width-40)/3)
        priceBG2.autoSetDimension(.width, toSize: (screenSize.width-40)/3)
        priceBG2.autoSetDimension(.height, toSize: 110)
        
        let priceBG3 = UIButton()
        priceBG3.addTarget(self, action: #selector(self.buy12m), for: .touchUpInside)
        priceBG3.backgroundColor = UIColor.clear
        priceBG.addSubview(priceBG3)
        priceBG3.autoPinEdge(.top, to: .top, of: priceBG, withOffset: 0)
        priceBG3.autoPinEdge(.left, to: .left, of: priceBG, withOffset: (screenSize.width-40)/3*2)
        priceBG3.autoSetDimension(.width, toSize: (screenSize.width-40)/3)
        priceBG3.autoSetDimension(.height, toSize: 110)
        
        let btnSend = RedButton()
        btnSend.title = "DEVAM ET".localized()
        btnSend.addTarget(self, action: #selector(self.buy), for: .touchUpInside)
        whiteView.addSubview(btnSend)
        btnSend.autoPinEdge(.bottom, to: .bottom, of: whiteView, withOffset: -50)
        btnSend.autoPinEdge(.left, to: .left, of: whiteView, withOffset: 20)
        btnSend.autoPinEdge(.right, to: .right, of: whiteView, withOffset: -20)
        btnSend.autoSetDimension(.height, toSize: 50)
        
        let btnCancel = UIButton()
        btnCancel.setTitleColor(UIColor.black, for: .normal)
        btnCancel.setTitle("VAZGEÇ".localized(), for: .normal)
        btnCancel.titleLabel?.font = AppFont.ExtraLight.pt14
        btnCancel.addTextSpacing(4)
        btnCancel.addTarget(self, action: #selector(self.closeProView), for: .touchUpInside)
        whiteView.addSubview(btnCancel)
        btnCancel.autoPinEdge(.bottom, to: .bottom, of: whiteView, withOffset: -5)
        btnCancel.autoPinEdge(.left, to: .left, of: whiteView, withOffset: 20)
        btnCancel.autoPinEdge(.right, to: .right, of: whiteView, withOffset: -20)
        btnCancel.autoSetDimension(.height, toSize: 40)
        
        
        textView.text = "Subs".localized()
        textView.font = AppFont.ExtraLight.pt12
        textView.textColor = UIColor.white
        textView.isEditable = false
        textView.isSelectable = false
        textView.textAlignment = .center
        textView.backgroundColor = UIColor.clear
        self.view.addSubview(textView)
        textView.autoPinEdge(toSuperviewSafeArea: .bottom, withInset: 5)
        textView.autoPinEdge(toSuperviewSafeArea: .left, withInset: 15)
        textView.autoPinEdge(toSuperviewSafeArea: .right, withInset: 15)
        textView.autoSetDimension(.height, toSize: 60)
        
        self.automaticallyAdjustsScrollViewInsets = false
        
    }
    
    override func viewDidLayoutSubviews() {
        textView.setContentOffset(CGPoint(x: 0, y: 0), animated: false)
    }
    
    @objc func closeProView() {
        
        self.dismiss(animated: false, completion: nil)
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if (scrollView == scrollViewPro) {
            
            let total = scrollView.contentSize.width - scrollView.bounds.width
            let offset = scrollView.contentOffset.x
            let percent = Double(offset / total)
            
            let progress = percent * 2
            pageControlPro.progress = progress
            
        }
        
    }
    
    @objc func buy1m() {
        
        selectedBox.frame = CGRect(x: 0, y: selectedBox.frame.origin.y, width: selectedBox.frame.width, height: selectedBox.frame.height)
        
        subs1month.textColor = UIColor.black
        subs1monthsub.textColor = UIColor.black
        subs1price.textColor = UIColor.black
        
        subs2month.textColor = UIColor.black.withAlphaComponent(0.5)
        subs2monthsub.textColor = UIColor.steel
        subs2price.textColor = UIColor.black.withAlphaComponent(0.5)
        
        subs3month.textColor = UIColor.black.withAlphaComponent(0.5)
        subs3monthsub.textColor = UIColor.steel
        subs3price.textColor = UIColor.black.withAlphaComponent(0.5)
        
        
        selectedIndex = 0

    }
    
    @objc func buy6m() {
        
        selectedBox.frame = CGRect(x: selectedBox.frame.width, y: selectedBox.frame.origin.y, width: selectedBox.frame.width, height: selectedBox.frame.height)
        
        subs1month.textColor = UIColor.black.withAlphaComponent(0.5)
        subs1monthsub.textColor = UIColor.steel
        subs1price.textColor = UIColor.black.withAlphaComponent(0.5)
        
        subs2month.textColor = UIColor.black
        subs2monthsub.textColor = UIColor.black
        subs2price.textColor = UIColor.black
        
        subs3month.textColor = UIColor.black.withAlphaComponent(0.5)
        subs3monthsub.textColor = UIColor.steel
        subs3price.textColor = UIColor.black.withAlphaComponent(0.5)
        
        selectedIndex = 1

    }
    
    @objc func buy12m() {
        
        selectedBox.frame = CGRect(x: selectedBox.frame.width*2, y: selectedBox.frame.origin.y, width: selectedBox.frame.width, height: selectedBox.frame.height)
        
        subs1month.textColor = UIColor.black.withAlphaComponent(0.5)
        subs1monthsub.textColor = UIColor.steel
        subs1price.textColor = UIColor.black.withAlphaComponent(0.5)
        
        subs2month.textColor = UIColor.black.withAlphaComponent(0.5)
        subs2monthsub.textColor = UIColor.steel
        subs2price.textColor = UIColor.black.withAlphaComponent(0.5)
        
        subs3month.textColor = UIColor.black
        subs3monthsub.textColor = UIColor.black
        subs3price.textColor = UIColor.black
        
        selectedIndex = 2

    }
    
    @objc func buy() {
        
        startLoading()
        
        SwiftyStoreKit.purchaseProduct(IAPData[selectedIndex].code, atomically: false) { result in
            switch result {
            case .success(let purchase):
                
                if purchase.needsFinishTransaction {
                    SwiftyStoreKit.finishTransaction(purchase.transaction)
                    print("transactionIdentifier: \(purchase.transaction.transactionIdentifier ?? "-")")
                }
                //print("Purchase Success: \(product.productId)")
                
                let transID = purchase.transaction.transactionIdentifier ?? "\(Date().timeIntervalSince1970.string)-\(purchase.transaction.transactionState.hashValue.string)"
                print(transID)
                
                FBSDKAppEvents.logEvent(purchase.product.productIdentifier)
                
                NotificationCenter.default.post(name: Notification.Name("subsOK"), object: nil)
                self.dismiss(animated: true, completion: {
                    
                })
                AppCache.sharedInstance.isPremium = true
                API.sharedInstance.checkSubscription { (result) in }
                self.stopLoading()
            case .error( _):
                self.stopLoading()
            }
        }
 
 
        
    }


}
