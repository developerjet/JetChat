//
//  FYThemeColor.swift
//  FY-JetChat
//
//  Created by Jett on 2022/4/30.
//  Copyright © 2022 Jett. All rights reserved.
//

import UIKit

extension UIColor {
    
    convenience init(hex: Int, alpha: CGFloat = 1.0) {
        let red = CGFloat((hex & 0xFF0000) >> 16) / 255
        let green = CGFloat((hex & 0xFF00) >> 8) / 255
        let blue = CGFloat(hex & 0xFF) / 255
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    // 白
    static var Color_White_FFFFFF: UIColor { UIColor(hex: 0xFFFFFF) }
    static var Color_White_F7F7F7: UIColor { UIColor(hex: 0xF7F7F7) }
    static var Color_White_F9F9F9: UIColor { UIColor(hex: 0xF9F9F9) }
    static var Color_White_F7F7FA: UIColor { UIColor(hex: 0xF7F7FA) }
    static var Color_White_F3F3F3: UIColor { UIColor(hex: 0xF3F3F3) }
    static var Color_White_F5F5F5: UIColor { UIColor(hex: 0xF5F5F5) }
    
    // 黑
    static var Color_Black_000000: UIColor { UIColor(hex: 0x000000) }
    static var Color_Black_202C33: UIColor { UIColor(hex: 0x202C33) }
    static var Color_Black_2F404A: UIColor { UIColor(hex: 0x2F404A) }
    static var Color_Black_223037: UIColor { UIColor(hex: 0x223037) }
    static var Color_Black_252D33: UIColor { UIColor(hex: 0x252D33) }
    static var Color_Black_25333A: UIColor { UIColor(hex: 0x25333A) }
    static var Color_Black_344A56: UIColor { UIColor(hex: 0x344A56) }
    static var Color_Black_272D34: UIColor { UIColor(hex: 0x272D34) }
    static var Color_Black_030303: UIColor { UIColor(hex: 0x030303) }
    static var Color_Black_10171B: UIColor { UIColor(hex: 0x10171B) }
    static var Color_Black_181D21: UIColor { UIColor(hex: 0x181D21) }
    static var Color_Black_1B2025: UIColor { UIColor(hex: 0x1B2025) }
    static var Color_Black_12171B: UIColor { UIColor(hex: 0x12171B) }
    static var Color_Black_565F68: UIColor { UIColor(hex: 0x565F68) }
    static var Color_Black_2C363E: UIColor { UIColor(hex: 0x2C363E) }
    static var Color_Black_161B1E: UIColor { UIColor(hex: 0x161B1E) }
    static var Color_Black_2B343B: UIColor { UIColor(hex: 0x2B343B) }
    static var Color_Black_181818: UIColor { UIColor(hex: 0x181818) }
    static var Color_Black_433C37: UIColor { UIColor(hex: 0x433C37) }
    static var Color_Black_0E1418: UIColor { UIColor(hex: 0x0E1418) }
    static var Color_Black_1D1E34: UIColor { UIColor(hex: 0x0E1418) }
    static var Color_Black_384955: UIColor { UIColor(hex: 0x384955) }
    static var Color_Black_0F1317: UIColor { UIColor(hex: 0x0F1317) }
    static var Color_Black_21272F: UIColor { UIColor(hex: 0x21272F) }
    static var Color_Black_28323B: UIColor { UIColor(hex: 0x28323B) }
    static var Color_Black_15191E: UIColor { UIColor(hex: 0x15191E) }
    static var Color_Black_313944: UIColor { UIColor(hex: 0x313944) }
    static var Color_Black_1D232A: UIColor { UIColor(hex: 0x1D232A) }
    static var Color_Black_0E2B2D: UIColor { UIColor(hex: 0x0E2B2D) }
    static var Color_Black_193434: UIColor { UIColor(hex: 0x193434) }
    static var Color_Black_29313A: UIColor { UIColor(hex: 0x29313A) }
    static var Color_Black_1A2029: UIColor { UIColor(hex: 0x1A2029) }
    static var Color_Black_1E262C: UIColor { UIColor(hex: 0x1E262C) }
    static var Color_Black_2A2F33: UIColor { UIColor(hex: 0x2A2F33) }
    static var Color_Black_171D28: UIColor { UIColor(hex: 0x171D28) }
    static var Color_Black_252C33: UIColor { UIColor(hex: 0x252C33) }
    static var Color_Black_333333: UIColor { UIColor(hex: 0x333333) }
    
    // 绿
    static var Color_Green_02EAD0: UIColor { UIColor(hex: 0x02EAD0) }
    static var Color_Green_00D4BC: UIColor { UIColor(hex: 0x00D4BC) }
    static var Color_Green_27B87D: UIColor { UIColor(hex: 0x27B87D) }
    static var Color_Green_01E8CE: UIColor { UIColor(hex: 0x01E8CE) }
    static var Color_Green_00C1AB: UIColor { UIColor(hex: 0x00C1AB) }
    static var Color_Green_008878: UIColor { UIColor(hex: 0x008878) }
    static var Color_Green_136440: UIColor { UIColor(hex: 0x136440) }
    static var Color_Green_16BD74: UIColor { UIColor(hex: 0x16BD74) }
    static var Color_Green_1ED760: UIColor { UIColor(hex: 0x1ED760) }
    static var Color_Green_09BB07: UIColor { UIColor(hex: 0x09BB07) }
    static var Color_Green_124F4C: UIColor { UIColor(hex: 0x124F4C) }
    static var Color_Green_0A978A: UIColor { UIColor(hex: 0x0A978A) }
    static var Color_Green_E5FAF8: UIColor { UIColor(hex: 0xE5FAF8) }
    static var Color_Green_E8F8F6: UIColor { UIColor(hex: 0xE8F8F6) }
    static var Color_Green_0E413F: UIColor { UIColor(hex: 0x0E413F) }
    static var Color_Green_CCF2EE: UIColor { UIColor(hex: 0xCCF2EE) }
    static var Color_Green_102B2D: UIColor { UIColor(hex: 0x102B2D) }
    static var Color_Green_00C2AD: UIColor { UIColor(hex: 0x00C2AD) }
    static var Color_Green_163E3E: UIColor { UIColor(hex: 0x163E3E) }
    static var Color_Green_DBF7F4: UIColor { UIColor(hex: 0xDBF7F4) }
    static var Color_Green_144848: UIColor { UIColor(hex: 0x144848) }
    static var Color_Green_00C7B1: UIColor { UIColor(hex: 0x00C7B1) }
    static var Color_Green_00C0AB: UIColor { UIColor(hex: 0x00C0AB, alpha: 0.2) }

    // 红
    static var Color_Red_FF5055: UIColor { UIColor(hex: 0xFF5055) }
    static var Color_Red_FF4646: UIColor { UIColor(hex: 0xFF4646) }
    static var Color_Red_FF2B00: UIColor { UIColor(hex: 0xFF2B00) }
    static var Color_Red_EB6164: UIColor { UIColor(hex: 0xEB6164) }
    static var Color_Red_BB5254: UIColor { UIColor(hex: 0xBB5254) }
    static var Color_Red_9A4245: UIColor { UIColor(hex: 0x9A4245) }
    static var Color_Red_FEF6F5: UIColor { UIColor(hex: 0xFEF6F5) }
    static var Color_Red_FFE8E5: UIColor { UIColor(hex: 0xFFE8E5) }
    static var Color_Red_F25534: UIColor { UIColor(hex: 0xF25534) }
    static var Color_Red_8C3624: UIColor { UIColor(hex: 0x8C3624) }
    static var Color_Red_ED2931: UIColor { UIColor(hex: 0xED2931) }
    static var Color_Red_F95A3E: UIColor { UIColor(hex: 0xF95A3E) }
    static var Color_Red_51282D: UIColor { UIColor(hex: 0x51282D) }
    static var Color_Red_A22E3B: UIColor { UIColor(hex: 0xA22E3B) }
    static var Color_Red_FDEFEF: UIColor { UIColor(hex: 0xFDEFEF) }
    static var Color_Red_392024: UIColor { UIColor(hex: 0x392024) }
    static var Color_Red_FFDCDD: UIColor { UIColor(hex: 0xFFDCDD) }
    static var Color_Red_351F23: UIColor { UIColor(hex: 0x351F23) }
    static var Color_Red_FE3A1C: UIColor { UIColor(hex: 0xFE3A1C) }
    static var Color_Red_FF0000: UIColor { UIColor(hex: 0xFF0000) }
    static var Color_Red_3C272C: UIColor { UIColor(hex: 0x3C272C) }
    static var Color_Red_E5474C: UIColor { UIColor(hex: 0xE5474C) }
    static var Color_Red_F75B48: UIColor { UIColor(hex: 0xF75B48) }
    
    // 灰
    static var Color_Gray_919191: UIColor { UIColor(hex: 0x919191) }
    static var Color_Gray_323A42: UIColor { UIColor(hex: 0x323A42) }
    static var Color_Gray_3E4951: UIColor { UIColor(hex: 0x3E4951) }
    static var Color_Gray_384955: UIColor { UIColor(hex: 0x384955) }
    static var Color_Gray_272D34: UIColor { UIColor(hex: 0x272D34) }
    static var Color_Gray_5A636D: UIColor { UIColor(hex: 0x5A636D) }
    static var Color_Gray_1E2328: UIColor { UIColor(hex: 0x1E2328) }
    static var Color_Gray_7E8B99: UIColor { UIColor(hex: 0x7E8B99) }
    static var Color_Gray_7B7C7D: UIColor { UIColor(hex: 0x7B7C7D) }
    static var Color_Gray_E5E5E5: UIColor { UIColor(hex: 0xE5E5E5) }
    static var Color_Gray_C0C0C0: UIColor { UIColor(hex: 0xC0C0C0) }
    static var Color_Gray_CCCCCC: UIColor { UIColor(hex: 0xCCCCCC) }
    static var Color_Gray_B4B4B4: UIColor { UIColor(hex: 0xB4B4B4) }
    static var Color_Gray_B2B2B2: UIColor { UIColor(hex: 0xB2B2B2) }
    static var Color_Gray_BEBEBE: UIColor { UIColor(hex: 0xBEBEBE) }
    static var Color_Gray_1A1F24: UIColor { UIColor(hex: 0x1A1F24) }
    static var Color_Gray_F5F5F5: UIColor { UIColor(hex: 0xF5F5F5) }
    static var Color_Gray_F7F7F7: UIColor { UIColor(hex: 0xF7F7F7) }
    static var Color_Gray_F8F8F8: UIColor { UIColor(hex: 0xF8F8F8) }
    static var Color_Gray_DBDBDB: UIColor { UIColor(hex: 0xDBDBDB) }
    static var Color_Gray_EAEAEA: UIColor { UIColor(hex: 0xEAEAEA) }
    static var Color_Gray_F0BD5C: UIColor { UIColor(hex: 0xF0BD5C) }
    static var Color_Gray_F0F0F0: UIColor { UIColor(hex: 0xF0F0F0) }
    static var Color_Gray_DEDEDE: UIColor { UIColor(hex: 0xDEDEDE) }
    static var Color_Gray_F6F7FA: UIColor { UIColor(hex: 0xF6F7FA) }
    static var Color_Gray_EEEEEE: UIColor { UIColor(hex: 0xEEEEEE) }
    static var Color_Gray_EDEDED: UIColor { UIColor(hex: 0xEDEDED) }
    static var Color_Gray_77808A: UIColor { UIColor(hex: 0x77808A) }
    static var Color_Gray_F6F6F6: UIColor { UIColor(hex: 0xF6F6F6) }
    static var Color_Gray_272E37: UIColor { UIColor(hex: 0x272E37) }
    static var Color_Gray_F4F4F4: UIColor { UIColor(hex: 0xF4F4F4) }
    static var Color_Gray_E9E9E9: UIColor { UIColor(hex: 0xE9E9E9) }
    static var Color_Gray_364450: UIColor { UIColor(hex: 0x364450) }
    static var Color_Gray_E2E2E2: UIColor { UIColor(hex: 0xE2E2E2) }
    static var Color_Gray_F5FCFC: UIColor { UIColor(hex: 0xF5FCFC) }
    static var Color_Gray_EBF5F5: UIColor { UIColor(hex: 0xEBF5F5) }
    static var Color_Gray_9BA1A4: UIColor { UIColor(hex: 0x9BA1A4) }
    static var Color_Gray_666666: UIColor { UIColor(hex: 0x666666) }
    static var Color_Gray_6D777C: UIColor { UIColor(hex: 0x6D777C) }
    static var Color_Gray_999999: UIColor { UIColor(hex: 0x999999) }
    static var Color_Gray_959B9E: UIColor { UIColor(hex: 0x959B9E) }
    static var Color_Gray_C6C6C6: UIColor { UIColor(hex: 0xC6C6C6) }
    static var Color_Gray_484D50: UIColor { UIColor(hex: 0x484D50) }
    static var Color_Gray_97A2B0: UIColor { UIColor(hex: 0x97A2B0) }
    static var Color_Gray_3D4950: UIColor { UIColor(hex: 0x3D4950) }
    static var Color_Gray_CAD1D8: UIColor { UIColor(hex: 0xCAD1D8) }
    static var Color_Gray_9AA5B5: UIColor { UIColor(hex: 0x9AA5B5) }
    static var Color_Gray_D2D2D2: UIColor { UIColor(hex: 0xD2D2D2) }
    static var Color_Gray_D8D8D8: UIColor { UIColor(hex: 0xD8D8D8) }
    static var Color_Gray_696969: UIColor { UIColor(hex: 0x696969)  }
    
    // 橙
    static var Color_Orange_FF793A: UIColor { UIColor(hex: 0xFF793A) }
    static var Color_Orange_FFA946: UIColor { UIColor(hex: 0xFFA946) }
    static var Color_Orange_FD5900: UIColor { UIColor(hex: 0xFD5900) }
    static var Color_Orange_CFA972: UIColor { UIColor(hex: 0xCFA972) }
    static var Color_Orange_F59B23: UIColor { UIColor(hex: 0xF59B23) }
    static var Color_Orange_FF8F61: UIColor { UIColor(hex: 0xFF8F61) }
    static var Color_Orange_FE8E1C: UIColor { UIColor(hex: 0xFE8E1C) }

    // 金
    static var Color_Gold_CFA972: UIColor { UIColor(hex: 0xCFA972) }
    static var Color_Gold_F7F0E7: UIColor { UIColor(hex: 0xF7F0E7) }
    static var Color_Gold_7D5923: UIColor { UIColor(hex: 0x7D5923) }
    static var Color_Gold_DBBA86: UIColor { UIColor(hex: 0xDBBA86) }
    static var Color_Gold_D4AB91: UIColor { UIColor(hex: 0xD4AB91) }
    static var Color_Gold_ECD5C4: UIColor { UIColor(hex: 0xECD5C4) }
    static var Color_Gold_CA9F84: UIColor { UIColor(hex: 0xCA9F84) }


    // 黄
    static var Color_Yellow_FFCC00: UIColor { UIColor(hex: 0xFFCC00) }
    static var Color_Yellow_FFE5A7: UIColor { UIColor(hex: 0xFFE5A7) }
    static var Color_Yellow_FFBF27: UIColor { UIColor(hex: 0xFFBF27) }

    // 蓝
    static var Color_Blue_6CD0D8: UIColor { UIColor(hex: 0x6CD0D8) }
    static var Color_Blue_186DD5: UIColor { UIColor(hex: 0x186DD5) }
    static var Color_Blue_1890FF: UIColor { UIColor(hex: 0x1890FF) }
    static var Color_Blue_0000FF: UIColor { UIColor(hex: 0x0000FF) }
    static var Color_Blue_375793: UIColor { UIColor(hex: 375793) }


    // 粉
    static var Color_Pink_F86882: UIColor { UIColor(hex: 0xF86882) }
}
