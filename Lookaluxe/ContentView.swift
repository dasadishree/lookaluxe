//
//  ContentView.swift
//  Lookaluxe
//
//  Created by Adishree Das on 6/6/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "diamond")
                .imageScale(.large)
                .foregroundStyle(Color(red: 191/255, green: 121/255, blue: 71/255))
                .padding(10)
                .background(
                    Circle().fill(Color.brown.opacity(0.2))
                )
            Text("Welcome to")
                .font(.system(size: 20, design:.serif))
                .fontWeight(.heavy)
            Text("Lookaluxe")
                .font(.system(size: 50, design:.serif))
                .fontWeight(.heavy)
                .foregroundColor(.brown)
                .italic()
            
            HStack {
                Button("Explore", action: {print("works")})
                    .background(Color(red: 191/255, green: 121/255, blue: 71/255))
                    .foregroundColor(.white)
                    .buttonStyle(.bordered)
                
                Button("Allow Access to Photos", action: {print("allows works")})
                    .buttonStyle(.bordered)
                    .background(Color(red: 191/255, green: 121/255, blue: 71/255))
                    .foregroundColor(.white)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight:.infinity)
        .background(Color.brown.opacity(0.2))
    }
}

#Preview {
    ContentView()
}
