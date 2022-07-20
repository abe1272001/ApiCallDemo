//
//  ContentView.swift
//  apiCallDemo
//
//  Created by abe chen on 2022/7/20.
//

import SwiftUI

struct Users: Codable {
    var data: [User]
}

struct User: Hashable, Codable {
    var id: Int
    var email: String
    var first_name: String
    var last_name: String
    var avatar: String
}

class ViewModel: ObservableObject {
    @Published var users: [User] = []
    
    func fetchData() {
        guard let url = URL(string: "https://reqres.in/api/users") else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            // Convert to JSON
            do {
                let usersData = try JSONDecoder().decode(Users.self, from: data)
                DispatchQueue.main.async {
                    self.users = usersData.data
                    
                    print(self.users)
                }
            }
            catch {
                print(error)
            }
        }
        
        task.resume()
    }
}


struct ListView: View {
    @StateObject var viewModel = ViewModel()
    
    
    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.users, id: \.self) { user in
                    HStack {
//                        AsyncImage(url: URL(string: user.avatar))
                        AsyncImage(url: URL(string: user.avatar)) { image in
                            image.resizable()
                                 .aspectRatio(contentMode: .fit)
                                 .frame(maxWidth: 60, maxHeight: 60)
                                 .cornerRadius(150)
                        } placeholder: {
                            ProgressView()
                        }
                        .padding(.trailing, 20)
                        
                        VStack(alignment: .leading) {
                            Text("\(user.first_name) \(user.last_name)")
                            
                            Text(user.email)
                        }
                    }
//                    .listRowSeparator(.hidden)
                }
            }
            .navigationTitle("Users")
            .onAppear{
                viewModel.fetchData()
            }
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView()
    }
}
