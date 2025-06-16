//
//  FindView.swift
//  Lookaluxe
//
//  Created by Adishree Das on 6/6/25.
//

import SwiftUI
import PhotosUI

//swift UI view
struct FindView: View {
//    variables for the upload / show image process
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceAlert = false
    @State private var selectedImage: UIImage?
    @State private var savedImageURL: URL?
    @State private var backendResult: String?
    
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
            
            //backend result display
            if let result = backendResult {
                Text("Results:\n\(result)")
                    .padding()
                    .font(.caption)
                    .foregroundColor(.black)
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
            .sheet(isPresented: $showImagePicker, onDismiss: {
                if let selectedImage = selectedImage {
                    uploadImage(selectedImage) { result in
                        switch result {
                        case .success(let responseString):
                            DispatchQueue.main.async {
                                backendResult = responseString
                            }
                        case .failure(let error):
                            DispatchQueue.main.async {
                                backendResult = "Error: \(error.localizedDescription)"
                            }
                        }
                    }
                }
            }) {
                ImagePicker(sourceType: sourceType, selectedImage: $selectedImage)
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight:.infinity)
        .background(Color.brown.opacity(0.2))
    }
}


func uploadImage(_ image: UIImage, completion: @escaping (Result<String, Error>) -> Void) {
    guard let url = URL(string: "http://127.0.0.1:5000/upload") else { return }
    
    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    
    let boundary = UUID().uuidString
    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
    
    let imageData = image.jpegData(compressionQuality: 0.8)!
    var body = Data()
    
    body.append("--\(boundary)\r\n".data(using: .utf8)!)
    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
    body.append(imageData)
    body.append("\r\n".data(using: .utf8)!)
    body.append("--\(boundary)--\r\n".data(using: .utf8)!)
    
    request.httpBody = body
    
    
    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        
        guard let data = data else {
            completion(.failure(NSError(domain: "No data", code: 0)))
            return
        }
        
        let responseString = String(data: data, encoding: . utf8) ?? "Unreadable server response"
        completion(.success(responseString))
    }.resume()
}

#Preview {
    FindView()
}
