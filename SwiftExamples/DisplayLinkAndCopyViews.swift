import SwiftUI

struct ContentView: View {
    let websiteString = "https://www.simplykyra.com/blog/how-i-handle-external-links-in-my-ios-app-with-a-built-in-copy-option"
    let emailString = "mail@simplykyra.com?subject=Display Link Blog Post"
    
    var body: some View {
        VStack(alignment: .center, spacing: 10, content: {
            Text("Here are the examples using both a website and an email.")
            
            Divider()
            
            Text("You can set just the url and by default both caption and the copy value will be the same.")
            
            DisplayLinkAndCopy(
                url: URL(string: websiteString)!
            )
            
            Text("Or overwrite the caption with your own text:")
            
            DisplayLinkAndCopy(
                url: URL(string: websiteString)!,
                captionString: "Click link for blog post!"
            )
            
            Text("Email might be more complicated as the action url includes \"mailto:\" and optional add-ons like the subject so you may want to overwrite the copy text like this:")
            
            DisplayLinkAndCopy(
                url: URL(string: "mailto:hello@example.com")!,
                copyString: emailString,
                captionString: "Mail Me Here!"
            )
            
        }) 
        .multilineTextAlignment(.center)
    }
}

public struct DisplayLinkAndCopy: View {
    public var url: URL
    
    // Below values optional as they both default to url.absoluteString
    public var copyString: String?
    public var captionString: String?
    
    public var body: some View {
        HStack {
            CopyStringButton(myString: copyString ?? url.absoluteString)
                .padding(.horizontal, 10)
            Spacer()
            DisplayLink(URLsource: url, captionText: captionString ?? url.absoluteString)
        }.padding(.horizontal, 20)
    }
}

public struct CopyStringButton: View {
    public var myString: String
    
    public init(myString: String) {
        self.myString = myString
    }
    
    public var body: some View {
        Button(action: {
#if os(macOS)
            let pasteboard = NSPasteboard.general
            pasteboard.declareTypes([NSPasteboard.PasteboardType.string], owner: nil)
            pasteboard.setString(myString, forType: NSPasteboard.PasteboardType.string)
#else
            UIPasteboard.general.string = myString
#endif
        }, label: {
            Image(systemName: "doc.on.doc")
            // Above is just the icon. If you prefer you can use a label with/without the label hidden:
            // Label("Copy", systemImage: "doc.on.doc").labelsHidden()
        })
    }
}

public struct DisplayLink: View {
    public var URLsource:URL?
    public var captionText:String
    
    public init(URLsource: URL? = nil, 
                captionText: String? = nil) {
        self.URLsource = URLsource
        self.captionText = captionText ?? "External Link"
    }
    
    public var body: some View {
        if URLsource != nil {
            Link(destination: URLsource!) {
                HStack {
                    Spacer()
                    Text(captionText)
                        .multilineTextAlignment(.center)
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundColor(.secondary)
                    Spacer()
                }
            }
        } else {
            HStack {
                Spacer()
                Text("No URL set for \"\(captionText)\"")
                    .multilineTextAlignment(.center)
                Spacer()
            }
        }
    }
}
