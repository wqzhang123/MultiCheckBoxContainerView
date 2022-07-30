//
//  Created by Wei Zhang on 7/29/22.
//

import SwiftUI

protocol OptionSelectable: CaseIterable, Identifiable, CustomStringConvertible, Equatable {
}

class CheckBoxContainerViewModel<Option: OptionSelectable>: ObservableObject {
    
    let options: [Option]
    
    @Published var selectedOption: Option?
    
    init(selectedOption: Option? = nil) {
        self.selectedOption = selectedOption
        self.options = Option.allCases as! [Option]
    }
}

struct CheckBoxView<Option: OptionSelectable>: View {
    
    @EnvironmentObject var viewModel: CheckBoxContainerViewModel<Option>
    
    let option: Option
    
    var checkedImage = "checkmark.square.fill"
    
    var uncheckedImage = "square"
    
    var body: some View {
        Button {
            viewModel.selectedOption = option
        } label: {
            HStack {
                Image(systemName: option == viewModel.selectedOption ?  checkedImage : uncheckedImage)
                    .onTapGesture {
                        viewModel.selectedOption = option
                    }
                
                Text(option.description)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .buttonStyle(.plain)
    }
}

struct YesNoCheckBoxContainerView: View {
    
    enum YesNoOption: OptionSelectable {
        
        case yes
        
        case no
        
        var id: Self {
            self
        }
        
        var description: String {
            switch self {
            case .yes:
                return "YES"
            case .no:
                return "NO"
            }
        }
    }
    
    @StateObject var viewModel = CheckBoxContainerViewModel<YesNoOption>(selectedOption: .yes)
    
    var body: some View {
        VStack {
            ForEach(viewModel.options) { option in
                CheckBoxView(option: option)
            }
        }
        .padding()
        .environmentObject(viewModel)
    }
}

struct MultiCheckBoxContainerView: View {
    
    enum MultiOption: String, OptionSelectable {
        
        case option1
        
        case option2
        
        case option3
        
        case option4
        
        var id: Self {
            self
        }
        
        var description: String {
            self.rawValue
        }
    }
    
    @StateObject var viewModel = CheckBoxContainerViewModel<MultiOption>()
    
    var body: some View {
        List {
            ForEach(viewModel.options) { option in
                CheckBoxView(option: option)
            }
        }
        .padding()
        .environmentObject(viewModel)
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            VStack {
                Text("Yes or No CheckBox")
                HStack {
                    Spacer()
                    YesNoCheckBoxContainerView()
                        .frame(width: 100, height: 50)
                    Spacer()
                }
            }
            .padding(50)
            
            VStack {
                Text("Multiple Options CheckBox")
                MultiCheckBoxContainerView()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

