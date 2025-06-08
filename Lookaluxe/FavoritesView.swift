//
//  FavoritesView.swift
//  Lookaluxe
//
//  Created by Adishree Das on 6/8/25.
//

import SwiftUI

struct FavoritesView: View {
    var body: some View {
        HStack{
            Text("Saved")
                .font(.system(size: 50, design:.serif))
                .fontWeight(.heavy)
                .foregroundColor(.brown)
                .italic()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight:.infinity)
        .background(Color.brown.opacity(0.2))
    }
}
    
#Preview {
    FavoritesView()
}
