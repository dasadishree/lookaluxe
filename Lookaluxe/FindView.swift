//
//  FindView.swift
//  Lookaluxe
//
//  Created by Adishree Das on 6/6/25.
//

import SwiftUI
import PhotosUI

struct FindView: View {
//    variables for the upload / show image process
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceAlert = false
    @State private var selectedImage: UIImage?
    @State private var savedImageURL: URL?
    
    var body: some View {
        VStack{
            
//            title
            Text("Find Lookaluxes")
                .font(.system(size: 50, design:.serif))
                .fontWeight(.heavy)
                .foregroundColor(.brown)
                .italic()
            
//          shows image if the user selected/took one
            if let image = selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding()
            }
//            saves the url file location
            if let savedURL = savedImageURL {
                Text("Saved at: \(savedURL.lastPathComponent)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            
//            button & functionality
            Button("UPLOAD / TAKE A PHOTO") {
                showSourceAlert = true
            }
            .padding()
            .background(Color(red:191/255, green:121/255, blue:71/255))
            .foregroundColor(.white)
            .cornerRadius(8)
//            shows options for from camera vs from photo roll
            .confirmationDialog("Choose Image Source", isPresented: $showSourceAlert, titleVisibility: .visible) {
                Button("Photo Library") {
                    sourceType = .photoLibrary
                    showImagePicker = true
                }
                
                Button("Camera") {
                    sourceType = .camera
                    showImagePicker = true
                }
                Button("Cancel", role:.cancel) {}
            }
//            shows the imagepicker to pick a photo to display
            .sheet(isPresented: $showImagePicker) {
                ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight:.infinity)
        .background(Color.brown.opacity(0.2))
    }
}

#Preview {
    FindView()
}
