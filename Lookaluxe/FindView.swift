//
//  FindView.swift
//  Lookaluxe
//
//  Created by Adishree Das on 6/6/25.
//

import SwiftUI
import PhotosUI
import SwiftData

//swift UI view
struct FindView: View {
//    variables for the upload / show image process
    @State private var showImagePicker = false
    @State private var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @State private var showSourceAlert = false
    @State private var selectedImage: UIImage?
    @State private var savedImageURL: URL?
    @State private var backendResult: String?
    @State private var showingSaveAlert = false
    @State private var itemName: String = ""
    
    @Environment(\.modelContext) private var modelContext
    
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
            
            //backend result display (displays results and save to favorites button)
            if let result = backendResult {
                VStack(spacing: 10) {
                    Text("Results:")
                        .font(.headline)
                        .foregroundColor(.brown)
                    
                    Text(result)
                        .padding()
                        .font(.caption)
                        .foregroundColor(.black)
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                    
                    // Save button
                    Button("SAVE TO FAVORITES") {
                        showingSaveAlert = true //shows an alert to save item and name it 
                    }
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                }
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
            //alert to save item and name it 
            .alert("Save Item", isPresented: $showingSaveAlert) {
                TextField("Enter item name", text: $itemName)
                Button("Save") {
                    saveToFavorites() //function saving item to favorites
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("Name your saved item")
            }
            
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight:.infinity)
        .background(Color.brown.opacity(0.2))
    }
    
// function saving item to favorites
    private func saveToFavorites() {
        guard let image = selectedImage,
              let result = backendResult else { 
            print("❌ Cannot save: missing image or backend result")
            return 
        } //doesn't save if image/result missing
        
        let imageData = image.jpegData(compressionQuality: 0.8) //compresses image
        let name = itemName.isEmpty ? "Item Name" : itemName //default name
        
        let savedItem = SavedItem(
            imageData: imageData,
            backendResult: result, 
            name: name
        )//saves image and result and name
        
        modelContext.insert(savedItem) //saves item to favorites?
    }
}

//function uploading image to backend
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
