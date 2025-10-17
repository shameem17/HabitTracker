//
//  HomeScreen.swift
//  HabitTracker
//
//  Created by Shameem on 5/10/25.
//

import SwiftUI

extension HomeView{
    var HomeScreen: some View{
        VStack(alignment: .leading){
              if viewModel.showContent{
                  HomeContentView(viewModel: viewModel)
                  
              }
              
          }
    }
}
