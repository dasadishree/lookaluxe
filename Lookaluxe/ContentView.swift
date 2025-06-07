//
//  ContentView.swift
//  Lookaluxe
//
//  Created by Adishree Das on 6/6/25.
//

import SwiftUI
import PhotosUI
import AVFoundation

struct ContentView: View {
    @State private var showFindView = false
    
    func requestPhotoAndCameraAccess() {
        PHPhotoLibrary.requestAuthorization{ status in switch status {
            case .authorized, .limited:
                print("Photo library access granted")
            case .denied, .restricted, .notDetermined:
                print("Photo library access denied or restricted")
            @unknown default:
                print("Photo library access Unknown status")
            }
        }
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            if granted {
                print("Camera access granted")
            } else {
                print("Camera access denied")
            }
        }
    }
    
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
            
            Button("Allow Access to Photos & Camera"){
                requestPhotoAndCameraAccess()
            }
            .buttonStyle(.bordered)
            .background(Color(red: 191/255, green: 121/255, blue: 71/255))
            .foregroundColor(.white)
            HStack {
                NavigationLink(destination: ExploreView()) {
                    Text("Explore")
                        .padding()
                        .background(Color(red:191/255, green:121/255, blue:71/255))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
                
                NavigationLink(destination: FindView()) {
                    Text("Find")
                        .padding()
                        .background(Color(red:191/255, green:121/255, blue:71/255))
                        .foregroundColor(.white)
                        .cornerRadius(8)
                }
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
