//
//  FYDarkTheme.swift
//  FY-IMChat
//
//  Created by Jett on 2022/4/30.
//  Copyright © 2022 MacOsx. All rights reserved.
//

import UIKit
import RxSwift
import RxTheme

struct FYDarkTheme: Theme {

    // MARK: - **************************** Dark Color ****************************
    
    // MARK: - 导航栏
    /// 导航栏背景色   黑-> 10171B
    var FYColor_Nav_BackgroundColor = UIColor.Color_Black_10171B
    
    // MARK: - TabBar
    /// TabBar背景色 黑-> 181D21
    var FYColor_Tab_BackgroundColor = UIColor.Color_Black_181D21
    
    // MARK: - 背景色
    /// 一级模块背景色     黑 -> 181D21 白 -> FFFFFF
    var FYColor_BackgroundColor_V1 = UIColor.Color_Black_181D21
    
    /// 二级模块背景色     黑 -> 252D33 白 -> F6F6F6
    var FYColor_BackgroundColor_V2 = UIColor.Color_Black_252D33
    
    /// 三级模块背景色   黑 -> FFFFFF 白 -> 000000
    var FYColor_BackgroundColor_V3 = UIColor.Color_White_FFFFFF
    
    /// 黑 -> FFFFFF 白 -> F6F6F6
    var FYColor_BackgroundColor_V4 = UIColor.Color_White_FFFFFF
    
    /// 黑 -> 252D33 白 -> FFFFFF
    var FYColor_BackgroundColor_V5 = UIColor.Color_Black_252D33
    
    /// 黑 -> 2B343B 白 -> 384955
    var FYColor_BackgroundColor_V6 = UIColor.Color_Black_2B343B
    
    /// 黑 -> 10171B 白 -> C0C0C0
    var FYColor_BackgroundColor_V7 = UIColor.Color_Black_10171B
    
    /// 黑 -> 000000 白 -> F6F6F6
    var FYColor_BackgroundColor_V8 = UIColor.Color_Black_000000
    
    /// 黑 -> 10171B 白 -> 2C363E
    var FYColor_BackgroundColor_V9 = UIColor.Color_Black_10171B
    
    /// 黑 -> 2C363E 白 -> F6F6F6
    var FYColor_BackgroundColor_V10 = UIColor.Color_Black_2C363E
    
    /// 黑 -> 0F1317 白 -> F6F6F6
    var FYColor_BackgroundColor_V11 = UIColor.Color_Black_0F1317
    
    /// 黑 -> 2C363E 白 -> FFFFFF
    var FYColor_BackgroundColor_V12 = UIColor.Color_Black_2C363E
    
    /// 黑 -> 272D34 白 -> F7F7F7
    var FYColor_BackgroundColor_V13 = UIColor.Color_Black_272D34
    
    /// 黑 -> 272D34 白 -> F8F8F8
    var FYColor_BackgroundColor_V14 = UIColor.Color_Black_272D34
    
    /// 黑 -> 10171B 白 -> CCCCCC
    var FYColor_BackgroundColor_V15 = UIColor.Color_Black_10171B
    
    //MARK: - 边框颜色
    /// 黑 -> 1E2328 白 -> E5E5E5
    var FYColor_BorderColor_V1 = UIColor.Color_Gray_1E2328
    
    /// 黑 -> 5A636D 白 -> E5E5E5
    var FYColor_BorderColor_V2 = UIColor.Color_Gray_5A636D
    
    /// 黑 -> 12171B 白 -> F6F6F6
    var FYColor_BorderColor_V3 = UIColor.Color_Black_12171B
    
    /// 黑 -> 181D21 白 -> E5E5E5
    var FYColor_BorderColor_V4 = UIColor.Color_Black_181D21
    
    /// 黑 -> FFFFFF 白 -> E5E5E5
    var FYColor_BorderColor_V5 = UIColor.Color_White_FFFFFF
    
    /// 黑 -> 1E2328 白 -> F6F6F6
    var FYColor_BorderColor_V6 = UIColor.Color_Gray_1E2328
    
    /// 黑 -> 272E37 白 -> E5E5E5
    var FYColor_BorderColor_V7 = UIColor.Color_Gray_272E37
    
    /// 黑 -> 12171B 白 -> E5E5E5
    var FYColor_BorderColor_V8 = UIColor.Color_Black_12171B
    
    /// 黑 -> 2C363E 白 -> E5E5E5
    var FYColor_BorderColor_V9 = UIColor.Color_Black_2C363E
    
    // MARK: - 文本颜色 (Placeholder)
    /// 黑 -> 919191 白 -> B4B4B4
    var FYColor_Placeholder_Color_V1 = UIColor.Color_Gray_919191
    
    /// 黑 -> 6D777C 白 -> 999999
    var FYColor_Placeholder_Color_V2 = UIColor.Color_Gray_6D777C
    
    /// 黑 -> FFFFFF 白 -> 999999
    var FYColor_Placeholder_Color_V3 = UIColor.Color_Gray_999999
    
    // MARK: - 文本颜色 (TextColor)
    /// 黑 -> FFFFFF 白 -> 000000
    var FYColor_Main_TextColor_V1 = UIColor.Color_White_FFFFFF
    
    /// 黑 -> 5A636D 白 -> 77808A
    var FYColor_Main_TextColor_V2 = UIColor.Color_Gray_5A636D
    
    /// 黑 -> FFFFFF 白 -> 77808A
    var FYColor_Main_TextColor_V3 = UIColor.Color_White_FFFFFF
    
    /// 黑 -> 919191 白 -> 1D1E34
    var FYColor_Main_TextColor_V4 = UIColor.Color_Gray_919191
    
    /// 黑 -> 000000 白 -> FFFFFF
    var FYColor_Main_TextColor_V5 = UIColor.Color_Gray_919191
    
    /// 黑 -> 000000 白 -> 000000
    var FYColor_Main_TextColor_V6 = UIColor.Color_Black_000000
    
    /// 黑 -> 5A636D 白 -> B4B4B4
    var FYColor_Main_TextColor_V7 = UIColor.Color_Gray_5A636D
    
    /// 黑 -> FFBF27 白 -> 000000
    var FYColor_Main_TextColor_V8 = UIColor.Color_Yellow_FFBF27
    
    /// 黑 -> FFFFFF 白 -> 666666
    var FYColor_Main_TextColor_V9 = UIColor.Color_White_FFFFFF
    
    /// 黑 -> 9BA1A4 白 -> 666666
    var FYColor_Main_TextColor_V10 = UIColor.Color_Gray_9BA1A4
    
    /// 黑 -> FFFFFF 白 -> 1A1F24
    var FYColor_Main_TextColor_V11 = UIColor.Color_White_FFFFFF
    
    /// 黑 -> FFFFFF 白 -> 1890FF
    var FYColor_Main_TextColor_V12 = UIColor.Color_White_FFFFFF
}
