//
//  FavoritesView.swift
//  Lookaluxe
//
//  Created by Adishree Das on 6/8/25.
//

import SwiftUI
import SwiftData

struct FavoritesView: View {
    @Environment(\.modelContext) private var modelContext //allows access to model context
    @State private var savedItems: [SavedItem] = [] //array of saved items
    
    var body: some View {
        NavigationView {
            VStack { //main view
                Text("Saved Lookaluxes")
                    .font(.system(size: 50, design:.serif))
                    .fontWeight(.heavy)
                    .foregroundColor(.brown)
                    .italic()
                    .padding(.top)
                
                // Debug information
                Text("Total items: \(savedItems.count)")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.bottom, 5)
                
                if savedItems.isEmpty {
                    //shows heart icon and text if no items saved
                    VStack {
                        Image(systemName: "heart")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("No saved items yet")
                            .font(.title2)
                            .foregroundColor(.gray)
                        Text("Save items from Find View to see them here")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    //shows list of saved items otherwise
                    List {
                        ForEach(savedItems.sorted(by: { $0.timestamp > $1.timestamp })) { item in //sorts items by timestamp
                            SavedItemRow(item: item)
                        }
                        .onDelete(perform: deleteItems) // deletes items from list
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight:.infinity)
            .background(Color.brown.opacity(0.2))
        }
        .onAppear {
            loadSavedItems() //loads saved items when view appears
        }
    }
    
    //function loading saved items
    private func loadSavedItems() {
        do {
            let descriptor = FetchDescriptor<SavedItem>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)]) //sorts items by timestamp
            savedItems = try modelContext.fetch(descriptor) //fetches items from model context
            for item in savedItems { //prints each item name and id
                print("   - \(item.name) (\(item.id))")
            }
        } catch { //error handling prints error message 
            print("Failed to fetch saved items: \(error)") 
        }
    }

    //function deleting items
    private func deleteItems(offsets: IndexSet) {
        withAnimation { //animates the deletion
            for index in offsets { //deletes items from list
                modelContext.delete(savedItems[index])
            }
            
            // Save after deletion
            do {
                try modelContext.save() //saves changes
                loadSavedItems() // Reload the list
            } catch {
                print("Failed to save after deletion: \(error)") //otherwise prints error message
            }
        }
    }
}

//swiftUI view for each saved item (frontend)
struct SavedItemRow: View {
    let item: SavedItem
    
    var body: some View {
        HStack {
            if let imageData = item.imageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 60, height: 60)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            } else {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray.opacity(0.3))
                    .frame(width: 60, height: 60)
                    .overlay(
                        Image(systemName: "photo")
                            .foregroundColor(.gray)
                    )
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Text(item.backendResult)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
                
                Text(item.timestamp, style: .date)
                    .font(.caption2)
                    .foregroundColor(.gray)
            }
            
            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    FavoritesView()
        .modelContainer(for: SavedItem.self, inMemory: true) //creates a model container for the saved items
}
