//
//  Font+OpenSans.swift
//  HabitTracker
//
//  Created by Shameem on 11/10/25.
//

import SwiftUI

extension Font {
    // OpenSans Regular
    static func openSansRegular(size: CGFloat) -> Font {
        return Font.custom("OpenSans-Regular", size: size)
    }
    
    // OpenSans Bold
    static func openSansBold(size: CGFloat) -> Font {
        return Font.custom("OpenSans-Bold", size: size)
    }
    
    // Convenience methods for common font sizes
    static var openSansTitle: Font {
        return .openSansBold(size: 28)
    }
    
    static var openSansLargeTitle: Font {
        return .openSansBold(size: 34)
    }
    
    static var openSansHeadline: Font {
        return .openSansBold(size: 17)
    }
    
    static var openSansSubheadline: Font {
        return .openSansRegular(size: 15)
    }
    
    static var openSansBody: Font {
        return .openSansRegular(size: 17)
    }
    
    static var openSansCallout: Font {
        return .openSansRegular(size: 16)
    }
    
    static var openSansFootnote: Font {
        return .openSansRegular(size: 13)
    }
    
    static var openSansCaption: Font {
        return .openSansRegular(size: 12)
    }
    
    static var openSansCaption2: Font {
        return .openSansRegular(size: 11)
    }
    
    static var openSansTitle2: Font {
        return Font.custom("OpenSans-SemiBold", size: 20)
    }
    static var openSansTitle3: Font{
        return .openSansRegular(size: 16)
    }
    static func openSansCustomRegular(size: CGFloat) -> Font{
        return .openSansRegular(size: size)
    }
    static func openSansCustomBold(size: CGFloat) -> Font{
        return .openSansBold(size: size)
    }
}
