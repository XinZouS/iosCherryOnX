//
//  DisclaimerController.swift
//  carryonex
//
//  Created by Xin Zou on 8/11/17.
//  Copyright © 2017 Xin Zou. All rights reserved.
//

import UIKit



class DisclaimerController: UIViewController {
    
//    let titleLabel : UILabel = {
//        let b = UILabel()
//        b.text = "用户协议"
//        b.font = UIFont.boldSystemFont(ofSize: 23)
//        b.textAlignment = .center
//        return b
//    }()
    
    private let contentTextView: UITextView = {
        let v = UITextView()
        v.backgroundColor = .white
        v.font = UIFont.systemFont(ofSize: 14)
        v.isScrollEnabled = true
        v.isEditable = false
        return v
    }()
    
//    private let scrollView: UIScrollView = {
//        let v = UIScrollView()
//        v.backgroundColor = .yellow
//        v.isScrollEnabled = true
//        return v
//    }()
    
    private let userAgreementString = "Harry Potter is a series of fantasy novels written by British author J. K. Rowling. The novels chronicle the life of a young wizard, Harry Potter, and his friends Hermione Granger and Ron Weasley, all of whom are students at Hogwarts School of Witchcraft and Wizardry. The main story arc concerns Harry's struggle against Lord Voldemort, a dark wizard who intends to become immortal, overthrow the wizard governing body known as the Ministry of Magic, and subjugate all wizards and muggles, a reference term that means non-magical people. Since the release of the first novel, Harry Potter and the Philosopher's Stone, on 26 June 1997, the books have found immense popularity, critical acclaim and commercial success worldwide. They have attracted a wide adult audience as well as younger readers, and are often considered cornerstones of modern young adult literature.[2] The series has also had its share of criticism, including concern about the increasingly dark tone as the series progressed, as well as the often gruesome and graphic violence it depicts. As of May 2013, the books have sold more than 500 million copies worldwide, making them the best-selling book series in history, and have been translated into seventy-three languages.[3][4] The last four books consecutively set records as the fastest-selling books in history, with the final instalment selling roughly eleven million copies in the United States within twenty-four hours of its release. The series was originally published in English by two major publishers, Bloomsbury in the United Kingdom and Scholastic Press in the United States. A play, Harry Potter and the Cursed Child, based on a story co-written by Rowling, premiered in London on 30 July 2016 at the Palace Theatre, and its script was published by Little, Brown. The original seven books were adapted into an eight-part film series by Warner Bros. Pictures, which has become the second highest-grossing film series of all time as of August 2015. In 2016, the total value of the Harry Potter franchise was estimated at $25 billion,[5] making Harry Potter one of the highest-grossing media franchises of all time. A series of many genres, including fantasy, drama, coming of age, and the British school story (which includes elements of mystery, thriller, adventure, horror and romance), the world of Harry Potter explores numerous themes and includes many cultural meanings and references.[6] According to Rowling, the main theme is death.[7] Other major themes in the series include prejudice, corruption, and madness.[8] The success of the books and films has ensured that the Harry Potter franchise continues to expand, with numerous derivative works, a travelling exhibition that premiered in Chicago in 2009, a studio tour in London that opened in 2012, a digital platform on which J.K. Rowling updates the series with new information and insight, and a pentalogy of spin-off films premiering in November 2016, among many other developments. Most recently, themed attractions, collectively known as The Wizarding World of Harry Potter, have been built at several Universal Parks & Resorts amusement parks around the world."
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupNavigationBar()
//        setupTitle()
//        setupScrollView()
        setupTextView()
        setupTextContent()
    }

    private func setupNavigationBar(){
        UINavigationBar.appearance().tintColor = buttonColorWhite
        navigationController?.navigationBar.tintColor = buttonColorWhite
        navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: buttonColorWhite]
        
        navigationItem.title = "用户协议"
    }

    private func setupTitle(){
//        view.addSubview(titleLabel)
//        titleLabel.addConstraints(left: view.leftAnchor, top: view.topAnchor, right: view.rightAnchor, bottom: nil, leftConstent: 0, topConstent: 20, rightConstent: 0, bottomConstent: 0, width: 0, height: 30)
    }
    
//    private func setupScrollView(){
//        view.addSubview(scrollView)
//    }
    
    private func setupTextView(){
        view.addSubview(contentTextView)
        contentTextView.addConstraints(left: view.leftAnchor, top: topLayoutGuide.bottomAnchor, right: view.rightAnchor, bottom: view.bottomAnchor, leftConstent: 10, topConstent: 10, rightConstent: 10, bottomConstent: 10, width: 0, height: 0)
        contentTextView.text = userAgreementString
    }

    
    var lastStringLen: Int = 0
    var currStringLen: Int = 0
    let textString = NSMutableAttributedString()

    private func setupTextContent(){
        
        textString.append(attributeString(text: "Disclaimer of CarryonEx \r\n", size: 14, weight: 1, textColor: .black))
        currStringLen = textString.string.characters.count
        
        let title1Style = NSMutableParagraphStyle()
        title1Style.lineSpacing = 3
        title1Style.alignment = .center
        let title1Range = NSMakeRange(lastStringLen, currStringLen)
        textString.addAttribute(NSParagraphStyleAttributeName, value: title1Style, range: title1Range)
        lastStringLen = textString.string.characters.count
        
        let t2 = "游箱服务协议 \r\n"
        currStringLen = t2.characters.count
        textString.append(attributeString(text: t2, size: 16, weight: 1, textColor: .black))
        let title2Style = NSMutableParagraphStyle()
        title2Style.lineSpacing = 10
        title2Style.alignment = .center
        let title2Range = NSMakeRange(lastStringLen, currStringLen)
        textString.addAttribute(NSParagraphStyleAttributeName, value: title2Style, range: title2Range)
        lastStringLen = textString.string.characters.count

        let p1 = "1. When you register your account in our system, you have to submit your information correctly; our system will receive your personal information put it into our server. The data from you will include IP address, Cookie and so on. \r\n 1. 您注册游箱时，必须根据要求提供准确的个人信息； 在您使用带货或者寄货服务、或访问网页时，软件自动接收并记录服务器数据，包括但不限于IP地址、网站Cookie中的资料及您要求取用的网页记录 \r\n"
        
        let p2 = "2. CarryonEx will not open your information to any other people without your permission. \r\n 2. 游箱不会向任何人出售或出借您的个人信息，除非事先得到您的许可 \r\n"

        let p3 = "3. In the purpose of serving, CarryonEx may need your personal information to disclose your trip details and some data. \r\n 3. 为服务用户的目的，游箱可能通过使用您的个人信息，向您提供服务，包括但不限于向您发出活动和服务信息等 \r\n"
        
        let p4 = "4. When we don’t get law permission or your permission, we can’t let your information out including pictures, nickname and address. \r\n 4. 承诺：非经法律程序或经您的许可不会泄露您的个人信息（如昵称、肖像、区域等） \r\n"
        
        let p5 = "5. When you use the app to ask for service, we treat you know the agreement of our company. The data on the platform by you and your partners seem as our common properties. \r\n 5. 您在游箱平台上寻求服务，将视为您同意游箱将您个人信息展示给其他用户。您在游箱上与其他用户一起产生的全部内容，将视为你、其他用户和游箱平台三方所共有，游箱不会单独将相关内容在适当的范围内予以使用 \r\n \r\n"
        
        let partA = [p1, p2, p3, p4, p5]
        for p in partA {
            addParagraph(p: p, withLineSpacing: 2)
        }
        
        let t3 = "Your personal information will be disclosed in part or in all of the following circumstances \r\n 您的个人信息将在下述情况下部分或全部被披露：\r\n"
        currStringLen = t3.characters.count
        textString.append(attributeString(text: t3, size: 16, weight: 1, textColor: .black))
        let title3Style = NSMutableParagraphStyle()
        title3Style.lineSpacing = 3
        title3Style.paragraphSpacing = 10
        let title3Range = NSMakeRange(lastStringLen, currStringLen)
        textString.addAttribute(NSParagraphStyleAttributeName, value: title3Style, range: title3Range)
        lastStringLen = textString.string.characters.count
        
        let p6 = "1. To a third party with your consent. \r\n 1. 经您同意，向第三方披露；"
        
        let p7 = "2.If you are a qualified complainant and have filed a complaint, the complainant should be asked to disclose to the Respondent so that both parties may handle possible rights disputes \r\n 2. 如您是符合资格的投诉人并已提起投诉，应被投诉人要求，向被投诉人披露，以便双方处理可能的权利纠纷；"
        
        let p8 = "3. In accordance with the relevant provisions of the local law, or the requirements of the administrative or judicial authorities, to the third party or the administrative and judicial agencies \r\n 3. 根据当地法律的有关规定，或者行政或司法机构的要求，向第三方或者行政、司法机构披露"
        
        let p9 = "4.In order to provide the products and services you require, you must share your personal information with a third party  \r\n 4. 为提供你所要求的产品和服务，而必须和第三方分享您的个人信息"
        
        let p10 = "5.Platforms are deemed appropriate under the law or platform policy for other information.  \r\n 5. 其他本平台根据法律或者平台政策认为合适的披露。"
        
        let p11 = "(CarryonEx has the final interpretation of principal content) \r\n   \r\n （游箱对原则内容拥有最终解释权）"
        
        let partB = [p6, p7, p8, p9, p10, p11]
        for p in partB {
            addParagraph(p: p, withLineSpacing: 2)
        }
        
        contentTextView.attributedText = textString
        contentTextView.scrollsToTop = true
    }
    
    private func attributeString(text:String, size sz:CGFloat, weight wt:CGFloat, textColor clr:UIColor) -> NSMutableAttributedString {
        let attributes = [
            NSFontAttributeName: UIFont.systemFont(ofSize: sz, weight: wt),
            NSForegroundColorAttributeName: clr
        ]
        return NSMutableAttributedString(string: text, attributes: attributes)
    }
    
    private func addParagraph(p: String, withLineSpacing ls: CGFloat){
        currStringLen = p.characters.count
        textString.append(attributeString(text: p, size: 12, weight: 0, textColor: .black))
        let pStyle = NSMutableParagraphStyle()
        pStyle.lineSpacing = ls
        pStyle.paragraphSpacing = 5
        let pRange = NSMakeRange(lastStringLen, currStringLen)
        textString.addAttribute(NSParagraphStyleAttributeName, value: pStyle, range: pRange)
        lastStringLen = textString.string.characters.count
    }

    
    
}
