//
//  Font+Poppins.swift
//  HabitTracker
//
//  Created by Shameem on 13/11/25.
//

import SwiftUI

extension Font {
    // MARK: - Poppins Font Family
    
    // Regular weights
    static let poppinsThin = Font.custom("Poppins-Thin", size: 17)
    static let poppinsExtraLight = Font.custom("Poppins-ExtraLight", size: 17)
    static let poppinsLight = Font.custom("Poppins-Light", size: 17)
    static let poppinsRegular = Font.custom("Poppins-Regular", size: 17)
    static let poppinsMedium = Font.custom("Poppins-Medium", size: 17)
    static let poppinsSemiBold = Font.custom("Poppins-SemiBold", size: 17)
    static let poppinsBold = Font.custom("Poppins-Bold", size: 17)
    static let poppinsExtraBold = Font.custom("Poppins-ExtraBold", size: 17)
    static let poppinsBlack = Font.custom("Poppins-Black", size: 17)
    
    // Italic weights
    static let poppinsThinItalic = Font.custom("Poppins-ThinItalic", size: 17)
    static let poppinsExtraLightItalic = Font.custom("Poppins-ExtraLightItalic", size: 17)
    static let poppinsLightItalic = Font.custom("Poppins-LightItalic", size: 17)
    static let poppinsItalic = Font.custom("Poppins-Italic", size: 17)
    static let poppinsMediumItalic = Font.custom("Poppins-MediumItalic", size: 17)
    static let poppinsSemiBoldItalic = Font.custom("Poppins-SemiBoldItalic", size: 17)
    static let poppinsBoldItalic = Font.custom("Poppins-BoldItalic", size: 17)
    static let poppinsExtraBoldItalic = Font.custom("Poppins-ExtraBoldItalic", size: 17)
    static let poppinsBlackItalic = Font.custom("Poppins-BlackItalic", size: 17)
    
    // MARK: - Poppins Styled Fonts (Different Sizes)
    
    // Large Title (34pt)
    static let poppinsLargeTitle = Font.custom("Poppins-Bold", size: 34)
    static let poppinsLargeTitleRegular = Font.custom("Poppins-Regular", size: 34)
    
    // Title 1 (28pt)
    static let poppinsTitle = Font.custom("Poppins-Bold", size: 28)
    static let poppinsTitleRegular = Font.custom("Poppins-Regular", size: 28)
    
    // Title 2 (22pt)
    static let poppinsTitle2 = Font.custom("Poppins-Bold", size: 22)
    static let poppinsTitle2Regular = Font.custom("Poppins-Regular", size: 22)
    
    // Title 3 (20pt)
    static let poppinsTitle3 = Font.custom("Poppins-SemiBold", size: 20)
    static let poppinsTitle3Regular = Font.custom("Poppins-Regular", size: 20)
    
    // Headline (17pt)
    static let poppinsHeadline = Font.custom("Poppins-SemiBold", size: 17)
    static let poppinsHeadlineRegular = Font.custom("Poppins-Regular", size: 17)
    
    // Body (17pt)
    static let poppinsBody = Font.custom("Poppins-Regular", size: 17)
    static let poppinsBodyMedium = Font.custom("Poppins-Medium", size: 17)
    
    // Callout (16pt)
    static let poppinsCallout = Font.custom("Poppins-Regular", size: 16)
    static let poppinsCalloutMedium = Font.custom("Poppins-Medium", size: 16)
    
    // Subheadline (15pt)
    static let poppinsSubheadline = Font.custom("Poppins-Regular", size: 15)
    static let poppinsSubheadlineMedium = Font.custom("Poppins-Medium", size: 15)
    
    // Footnote (13pt)
    static let poppinsFootnote = Font.custom("Poppins-Regular", size: 13)
    static let poppinsFootnoteMedium = Font.custom("Poppins-Medium", size: 13)
    
    // Caption 1 (12pt)
    static let poppinsCaption = Font.custom("Poppins-Regular", size: 12)
    static let poppinsCaptionMedium = Font.custom("Poppins-Medium", size: 12)
    
    // Caption 2 (11pt)
    static let poppinsCaption2 = Font.custom("Poppins-Regular", size: 11)
    static let poppinsCaption2Medium = Font.custom("Poppins-Medium", size: 11)
    static func poppinsCustomRegular(size: CGFloat) -> Font{
        return .poppinsRegular(size: size)
    }
    static func poppinsCustomBold(size: CGFloat) -> Font{
        return .poppinsBold(size: size)
    }
    
    static func poppinsRegular(size: CGFloat) -> Font {
        return Font.custom("Poppins-Regular", size: size)
    }
    
    // Poppins SemiBold
    static func poppinsSemiBold(size: CGFloat) -> Font {
        return Font.custom("Poppins-SemiBold", size: size)
    }
    
    // Poppins Bold
    static func poppinsBold(size: CGFloat) -> Font {
        return Font.custom("Poppins-Bold", size: size)
    }
}
