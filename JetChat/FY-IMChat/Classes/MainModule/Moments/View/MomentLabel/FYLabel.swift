//
//  FYLabel.swift
//
//  Created by Jett on 2022/04/28.
//  Copyright 2022 Jett. All rights reserved.
//

import UIKit

typealias ElementTuple = (range: NSRange, element: FYElements, type: FYLabelType)

open class FYLabel: UILabel {
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupLabel()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLabel()
    }
    open override func awakeFromNib() {
        super.awakeFromNib()
        updateTextStorage()
    }
    // MARK: 公用 属性
    open var enabledTypes: [FYLabelType] = [.URL, .phone, .hashtag, .mention]
    
    open var hashtagColor : UIColor = .blue{
        didSet {updateTextStorage(updateString: false)}
    }
    open var hashtagSelectColor : UIColor = UIColor.blue.withAlphaComponent(0.5) {
        didSet {updateTextStorage(updateString: false)}
    }
    
    open var mentionColor : UIColor = .blue{
        didSet {updateTextStorage(updateString: false)}
    }
    open var mentionSelectColor : UIColor = UIColor.blue.withAlphaComponent(0.5){
        didSet {updateTextStorage(updateString: false)}
    }
    
    open var URLColor : UIColor = .blue{
        didSet {updateTextStorage(updateString: false)}
    }
    open var URLSelectColor : UIColor = UIColor.blue.withAlphaComponent(0.5){
        didSet {updateTextStorage(updateString: false)}
    }
    
    open var customColor : [FYLabelType : UIColor] = [:] {
        didSet {updateTextStorage(updateString: false)}
    }
    open var customSelectColor : [FYLabelType : UIColor] = [:] {
        didSet {updateTextStorage(updateString: false)}
    }
    
    // MARK: 重写
    override open var text: String? {
        didSet {updateTextStorage()}
    }
    override open var attributedText: NSAttributedString?{
        didSet {updateTextStorage()}
    }
    override open var font: UIFont! {
        didSet {updateTextStorage(updateString: false)}
    }
    override open var textColor: UIColor! {
        didSet {updateTextStorage(updateString: false)}
    }
    override open var textAlignment: NSTextAlignment {
        didSet {updateTextStorage(updateString: false)}
    }
    open override var numberOfLines: Int {
        didSet { textContainer.maximumNumberOfLines = numberOfLines }
    }
    /// 行间距
    open var lineSpacing : CGFloat = 0 {
        didSet {updateTextStorage(updateString: false)}
    }
    /// 段间距
    open var paragraphSpacing : CGFloat = 0 {
        didSet {updateTextStorage(updateString: false)}
    }
    
    // MARK: 私有属性
    /*
     NSTextStorage保存并管理UITextView要展示的文字内容，该类是NSMutableAttributedString的子类，由于可以灵活地往文字添加或修改属性，所以非常适用于保存并修改文字属性。
     NSLayoutManager用于管理NSTextStorage其中的文字内容的排版布局。
     NSTextContainer则定义了一个矩形区域用于存放已经进行了排版并设置好属性的文字。
     以上三者是相互包含相互作用的层次关系。
     NSTextStorage -> NSLayoutManager -> NSTextContainer
     */
    fileprivate var textStorage : NSTextStorage =  NSTextStorage()
    fileprivate var layoutManager : NSLayoutManager =  NSLayoutManager()
    fileprivate var textContainer : NSTextContainer =  NSTextContainer()
    
    fileprivate lazy var elementDict = [FYLabelType: [ElementTuple]]()
    fileprivate var selectedElementTuple : ElementTuple?
    
    public typealias LabelCallBack = (String) -> ()
    fileprivate var hashNormalHandler: LabelCallBack?
    fileprivate var hashtagTapHandler: LabelCallBack?
    fileprivate var mentionTapHandler: LabelCallBack?
    fileprivate var urlTapHandler: LabelCallBack?
    fileprivate var phoneTapHandler: LabelCallBack?
    fileprivate var customHandler: [FYLabelType : LabelCallBack] = [:]
    
    // MARK: 公用 方法
    /// 文本点击事件 （响应除`enabledTypes`属性设置外的点击事件
    open func handleNormalTap(_ handler: @escaping LabelCallBack) {
        hashNormalHandler = handler
    }
    /// 标签点击事件
    open func handleHashtagTap(_ handler: @escaping LabelCallBack) {
        hashtagTapHandler = handler
    }
    /// 提醒点击事件
    open func handleMentionTap(_ handler: @escaping LabelCallBack) {
        mentionTapHandler = handler
    }
    /// URL 点击事件
    open func handleURLTap(_ handler: @escaping LabelCallBack) {
        urlTapHandler = handler
    }
    /// URL 点击事件
    open func handlePhoneTap(_ handler: @escaping LabelCallBack) {
        phoneTapHandler = handler
    }
    /// 自定义 点击事件
    open func handleCustomTap(_ type: FYLabelType, handler: @escaping LabelCallBack) {
        customHandler[type] = handler
    }
    
    fileprivate var drawBeginY : CGFloat = 0
    override open func drawText(in rect: CGRect) {
        let range = NSRange(location: 0, length: textStorage.length)
        textContainer.size = rect.size
        let newRect = layoutManager.usedRect(for: textContainer)
        drawBeginY = (rect.size.height - newRect.size.height) / 2
        let newOrigin = CGPoint(x: rect.origin.x, y: drawBeginY)
        
        layoutManager.drawGlyphs(forGlyphRange: range, at: newOrigin)
    }
    
    override open func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        onTouch(touch)
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        onTouch(touch)
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        onTouch(touch)
    }
    open override var canBecomeFirstResponder: Bool { return true }
    
    open override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return performAction(action, sender: sender)
    }
    /// 是否允许长按复制
    var enableLongPress: Bool? {
        didSet {
            isUserInteractionEnabled = enableLongPress ?? false
            if oldValue != nil && enableLongPress != true {
                removeGestureRecognizer(longPress)
            } else if oldValue == nil && enableLongPress == true {
                addGestureRecognizer(longPress)
            }
        }
    }
    
    fileprivate lazy var longPress: UILongPressGestureRecognizer = {
        return UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(_:)))
    }()
}
// MARK: - init
fileprivate extension FYLabel {
    func setupLabel()  {
        numberOfLines = 1
        textStorage.addLayoutManager(layoutManager)
        layoutManager.addTextContainer(textContainer)
        textContainer.maximumNumberOfLines = numberOfLines
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = .byWordWrapping
        isUserInteractionEnabled = true
        enableLongPress = true
    }
    func updateTextStorage(updateString: Bool = true) {
        guard let attributedText = attributedText else {return}
        
        let mutAttrString = addOrdinarilyAttributes(attributedText)
        if updateString {
            clearElementTupleDict()
            getElementTupleDict(mutAttrString)
        }
        
        addPatternAttributes(mutAttrString)
        textStorage.setAttributedString(mutAttrString)
        
        setNeedsDisplay()
    }
    func clearElementTupleDict() {
        for (type, _) in elementDict {
            elementDict[type]?.removeAll()
        }
    }
    /// 核心方法,配置elementDict
    func getElementTupleDict(_ mutAttrString : NSMutableAttributedString) {
        
        let textString = mutAttrString.string
        let range = NSRange(location: 0, length: textString.count)
        
        for type in enabledTypes {
            elementDict[type] = creatElementTupleArr(type: type, from: textString, range: range)
        }
    }
    // 给所有字符串添加文字属性
    func addOrdinarilyAttributes(_ attrString : NSAttributedString) -> NSMutableAttributedString {
        
        let mutAttrString = NSMutableAttributedString(attributedString: attrString)
        
        if mutAttrString.string.count == 0 {
            return mutAttrString
        }
        
        var range = NSRange(location: 0, length: 0)
        //给指定索引的字符返回属性
        var attributes = mutAttrString.attributes(at: 0, effectiveRange: &range)
        attributes[NSAttributedString.Key.font] = font
        attributes[NSAttributedString.Key.foregroundColor] = textColor
        
        let paragraphStyle = attributes[NSAttributedString.Key.paragraphStyle] as? NSMutableParagraphStyle ?? NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = NSLineBreakMode.byWordWrapping
        paragraphStyle.alignment = textAlignment
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        
        attributes[NSAttributedString.Key.paragraphStyle] = paragraphStyle
        mutAttrString.setAttributes(attributes, range: range)
        
        return mutAttrString
    }
    /// 给目标字符串添加文字属性
    func addPatternAttributes(_ mutAttrString : NSMutableAttributedString) {
        if mutAttrString.string.count == 0 { return }
        
        var range = NSRange(location: 0, length: 0)
        //给指定索引的字符返回属性
        var attributes = mutAttrString.attributes(at: 0, effectiveRange: &range)
        
        for (type, elements) in elementDict {
            switch type {
            case .hashtag:
                attributes[.foregroundColor] = hashtagColor
            case .mention:
                attributes[.foregroundColor] = mentionColor
            case .URL    :
                attributes[.foregroundColor] = URLColor
            case .phone  :
                attributes[.foregroundColor] = URLColor
            case .custom :
                attributes[.foregroundColor] = customColor[type] ?? textColor
            }
            
            for element in elements {
                if mutAttrString.string.count < element.range.location + element.range.length {
                    return
                }
                mutAttrString.setAttributes(attributes, range: element.range)
            }
        }
    }
    
    func creatElementTupleArr(type: FYLabelType, from textString: String, range: NSRange) -> [ElementTuple] {
        
        var elementTupleArr = [ElementTuple]()
        let nsstring = textString as NSString
        
        let matches = FYLabelRegex.getMatches(type: type, from: textString, range: range)
        for match in matches {
            let range = NSRange(location: match.range.location + type.startIndex, length: match.range.length + type.tenderLength - type.startIndex)
            let word = nsstring.substring(with: range)
            guard word.count > 0 else { continue }
            elementTupleArr.append((range, FYElements.creat(with: type, text: word), type))
        }
        return elementTupleArr
    }
}

// MARK: - touch
fileprivate extension FYLabel {
    
    func updateWhenSelected(_ isSelected :Bool){
        guard let elementTuple = selectedElementTuple else {return}
        
        //给指定索引的字符返回属性
        var attributes = textStorage.attributes(at: 0, effectiveRange: nil)
        if isSelected {
            switch elementTuple.type {
            case .hashtag:
                attributes[NSAttributedString.Key.foregroundColor] = hashtagSelectColor
            case .mention:
                attributes[NSAttributedString.Key.foregroundColor] = mentionSelectColor
            case .URL    :
                attributes[NSAttributedString.Key.foregroundColor] = URLSelectColor
            case .phone  :
                attributes[NSAttributedString.Key.foregroundColor] = URLSelectColor
            case .custom :
                var color = self.customSelectColor[elementTuple.type] ?? self.customColor[elementTuple.type]
                color = color ?? textColor
                attributes[NSAttributedString.Key.foregroundColor] = color
            }
        } else{
            switch elementTuple.type {
            case .hashtag: attributes[NSAttributedString.Key.foregroundColor] = hashtagColor
            case .mention: attributes[NSAttributedString.Key.foregroundColor] = mentionColor
            case .URL    : attributes[NSAttributedString.Key.foregroundColor] = URLColor
            case .phone  : attributes[NSAttributedString.Key.foregroundColor] = URLColor
            case .custom : attributes[NSAttributedString.Key.foregroundColor] = customColor[elementTuple.type] ?? textColor
            }
        }
        
        textStorage.addAttributes(attributes, range: elementTuple.range)
        setNeedsDisplay()
    }
    
    func getSelectElementTuple(_ index: Int) -> ElementTuple? {
        for elementTuples in elementDict.map({ $0.1 }) {
            for elementTuple in elementTuples {
                guard index >= elementTuple.range.location else { continue }
                guard index < elementTuple.range.location + elementTuple.range.length else { continue }
                return elementTuple
            }
        }
        return nil
    }
    
    func onTouch(_ touch : UITouch) {
        var location = touch.location(in: self)
        location.y -= drawBeginY
        
        let textRect = layoutManager.boundingRect(forGlyphRange: NSRange(location: 0, length: textStorage.length), in: textContainer)
        guard textRect.contains(location) else {return}
        
        let index = layoutManager.glyphIndex(for: location, in: textContainer)
        let elementTuple = getSelectElementTuple(index)
        
        switch touch.phase {
        case .began,.moved:
            if elementTuple?.range.location != selectedElementTuple?.range.location {
                updateWhenSelected(false)
                selectedElementTuple = elementTuple
                updateWhenSelected(true)
            }
        case .ended:
            guard let elementTuple = elementTuple else {
                if let text = text {
                    hashNormalHandler?(text)
                }
                return
            }
            updateWhenSelected(false)
            switch elementTuple.element {
            case .hashtag(let hashtag)  : didTapHashtag(hashtag)
            case .mention(let mention)  : didTapMention(mention)
            case .URL(let URL)          : didTapURL(URL)
            case .phone(let phone)      : didTapPhone(phone)
            case .custom(let custom)    : didTapCustom(elementTuple.type, custom: custom)
            }
        default: break
        }
    }
    /// 点击的是标签
    func didTapHashtag(_ hashtagString : String) -> Void {
        hashtagTapHandler?(hashtagString)
    }
    /// 点击的是提醒
    func didTapMention(_ mentionString : String) -> Void {
        mentionTapHandler?(mentionString)
    }
    /// 点击的是URL
    func didTapURL(_ URLString : String) -> Void {
        urlTapHandler?(URLString)
    }
    /// 点击的是phone
    func didTapPhone(_ phoneString : String) -> Void {
        phoneTapHandler?(phoneString)
    }
    /// 点击的是自定义
    func didTapCustom(_ type : FYLabelType,custom : String) -> Void {
        guard let customHandler = customHandler[type] else {return}
        customHandler(custom)
    }
}
private var showFavorKey: Void?
public extension FYLabel {
    var showFavor: (()->Void)? {
        set {
            objc_setAssociatedObject(self, &showFavorKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
        get {
            return objc_getAssociatedObject(self, &showFavorKey) as? (()->Void)? ?? nil
        }
    }
}
// MARK: 手势
fileprivate extension FYLabel {
    @objc func longPressAction(_ sender: UIGestureRecognizer) {
        guard sender.state == .began else {
            return
        }
        becomeFirstResponder()

        let menuController = UIMenuController.shared
        let copyItem = UIMenuItem(title: "复制", action: #selector(copyText))
        var items = [copyItem]
        if showFavor != nil {
            items.append(UIMenuItem(title: "收藏", action: #selector(favor)))
        }
        menuController.menuItems = items
        // 设置菜单控制器点击区域为当前控件 bounds
        menuController.setTargetRect(bounds, in: self)
        menuController.setMenuVisible(true, animated: true)

    }
    @objc func copyText() {
        UIPasteboard.general.string = self.text
    }
    @objc func favor() {
        showFavor?()
    }
    @objc func performAction(_ action: Selector, sender: Any?) -> Bool {
        switch action {
        case #selector(copyText), #selector(favor):
            return true
        default:
            return false
        }
    }
}
