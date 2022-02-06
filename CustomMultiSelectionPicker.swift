//
//  ContentView.swift
//  Shared
//
//  Created by Kyra on 2/2/22.
//

import SwiftUI

struct ContentView: View {
    
    @State var selectedItems = [String]()
    @State var allItems:[String] = ["more items",
                         "another item",
                         "and more",
                         "still more",
                         "yet still more",
                         "and the final item"]
    
    var body: some View {
#if os(macOS)
                macOSview(selectedItems: selectedItems, allItems: allItems)
#else //iOS
                iOSview(selectedItems: selectedItems, allItems: allItems)
#endif
    }
}

// This View is functional on macOS and iOS; however, I prefer using a NavigationalLink for iOS rather than the popover so setting this one to macOS for this example
struct macOSview: View {
    @State var selectedItems:[String]
    @State var allItems:[String]
    // Needed to show the popover
    @State var showingPopover:Bool = false
    
    var body: some View {
        Form {
            HStack() {
                // Rather than a picker we're using Text for the label and a button for the picker itself
                Text("Select Items:")
                    .foregroundColor(.white)
                Button(action: {
                    // The only job of the button is to toggle the showing popover boolean so it pops up and we can select our items
                    showingPopover.toggle()
                }) {
                    HStack {
                        Spacer()
                        Image(systemName: "\($selectedItems.count).circle")
                            .font(.title2)
                        Image(systemName: "chevron.right")
                            .font(.caption)
                    }
                    .foregroundColor(Color(red: 0.4192, green: 0.2358, blue: 0.3450))
                }
                .popover(isPresented: $showingPopover) {
                    MultiSelectPickerView(allItems: allItems, selectedItems: $selectedItems)
                    // If you have issues with it being too skinny you can hardcode the width
                     .frame(width: 300)
                }
            }
            // Made a quick text section so we can see what we selected
            Text("My selected items are:")
                .foregroundColor(.white)
            if selectedItems.count > 0 {
                Text("\t* \(selectedItems.joined(separator: "\n\t* "))")
                    .foregroundColor(.white)
            }
        }
        .padding()
        .background(Color(red: 0.4192, green: 0.2358, blue: 0.3450))
        .navigationTitle("My Items")
    }
}

// The iOS version uses a NavigationLink that requires being in a NavigationView to work so I chose to move the entire thing into a new View.
struct iOSview:View {
    @State var selectedItems:[String]
    @State var allItems:[String]
    
    var body: some View {
        NavigationView {
            Form {
                // Since this is for iOS I included sections
                Section("Choose your items:", content: {
                    // Rather than a button we're using a NavigationLink but passing in the same destination
                    NavigationLink(destination: {
                        MultiSelectPickerView(allItems: allItems, selectedItems: $selectedItems)
                            .navigationTitle("Choose Your Items")
                    }, label: {
                        // And then the label and dynamic number are displayed in the label. We don't need to include the chevron as it's done for us in the link
                        HStack {
                            Text("Select Items:")
                                .foregroundColor(Color(red: 0.4192, green: 0.2358, blue: 0.3450))
                            Spacer()
                            Image(systemName: "\($selectedItems.count).circle")
                                .foregroundColor(Color(red: 0.4192, green: 0.2358, blue: 0.3450))
                                .font(.title2)
                        }
                    })
                })
                // Made a quick text section so we can see what we selected
                Section("My selected items are:", content: {
                    Text(selectedItems.joined(separator: "\n"))
                        .foregroundColor(Color(red: 0.4192, green: 0.2358, blue: 0.3450))
                })
            }
            .navigationTitle("My Items")
        }
    }
}


// The struct that the custom picker (button) opens which is minorly adapted from: https://gist.github.com/dippnerd/5841898c2cf945994ba85871446329fa
struct MultiSelectPickerView: View {
    // The list of items we want to show
    @State var allItems: [String]

    // Binding to the selected items we want to track
    @Binding var selectedItems: [String]

    var body: some View {
        Form {
            List {
                ForEach(allItems, id: \.self) { item in
                    Button(action: {
                        withAnimation {
                            if self.selectedItems.contains(item) {
                                // Previous comment: you may need to adapt this piece
                                self.selectedItems.removeAll(where: { $0 == item })
                            } else {
                                self.selectedItems.append(item)
                            }
                        }
                    }) {
                        HStack {
                            Image(systemName: "checkmark")
                                .opacity(self.selectedItems.contains(item) ? 1.0 : 0.0)
                            Text(item)
                        }
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
