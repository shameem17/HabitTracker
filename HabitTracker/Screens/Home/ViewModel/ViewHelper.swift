//
//  ViewHelper.swift
//  HabitTracker
//
//  Created by Shameem on 31/8/25.
//
import SwiftUI

final class ViewHelper{
    func getTabBarIconName(currentSelected: Int, for index: Int) -> String {
        var starIcon = ""
        switch index {
        case 0:
            starIcon =  "house"
        case 1:
            starIcon = "chart.bar"
        case 2:
            starIcon = "gearshape"
        default:
            starIcon = "questionmark"
        }
        return currentSelected == index ? "\(starIcon).fill" : starIcon
    }
    
    func getTabBarColor(currentSelected: Int, for index: Int) -> Color {
        return currentSelected == index ? .blue : .white
    }
}
