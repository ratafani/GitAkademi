//
//  DetailView.swift
//  GitIntroSesiPagi
//
//  Created by Tafani Rabbani on 26/11/21.
//

import SwiftUI

struct DetailView : View{
    
    @EnvironmentObject private var appData: AppData

    var body: some View{
        NavigationView{
            List{
                Button("Navigation Back"){
        //            navigation.popToRootViewController(animated: true)
                    appData.navigation?.popViewController(animated: true)
                }
                Button("Change Root View Controller"){

                    let storyboard = UIStoryboard(name: "Main", bundle: nil)

                    let viewController = storyboard.instantiateViewController(withIdentifier: "main")
                    
                    let navigationController  = UINavigationController(rootViewController: viewController)

                    appData.window?.rootViewController = navigationController

                    appData.window?.makeKeyAndVisible()
                    // A mask of options indicating how you want to perform the animations.
                    let options: UIView.AnimationOptions = .transitionCrossDissolve

                    // The duration of the transition animation, measured in seconds.
                    let duration: TimeInterval = 1

                    // Creates a transition animation.
                    // Though `animations` is optional, the documentation tells us that it must not be nil. ¯\_(ツ)_/¯
                    UIView.transition(with: appData.window!, duration: duration, options: options, animations: {}, completion:
                    { completed in
                        // maybe do something on completion here
                    })
                    
                }
            }
            .listStyle(.plain)
            .onAppear{
                appData.navigation?.isToolbarHidden = true
            }
            
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("Pilih Tanaman dan Metode")
            

        }
        
    }
}



final class AppData: ObservableObject {
    let window: UIWindow? // Will be nil in SwiftUI previewers
    let navigation : UINavigationController?
    
    init(window: UIWindow? = nil, navigation : UINavigationController? = nil) {
        self.window = window
        self.navigation = navigation
    }
    
}

struct DashboardView : View{
    var body: some View{
        ScrollView{
            VStack{
                //TODO DashboarTitleView
                CardDashboardEmpty()
                PlantReference()
                MethodeReference()
            }
        }
        
    }
}
 
struct DashboardTitleView:View{
    var body: some View{
        Text("")
    }
}


struct CardDashboardEmpty : View{
    var body: some View{
        ZStack{
            Rectangle()
                .cornerRadius(16)
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 5, x: 0.5, y: 5)
            Image("dashboardEmpty")
                .resizable()
                .frame(width: UIScreen.screenWidth * 0.6, height: UIScreen.screenHeight / 6)
            VStack{
                Text("Ayo Rencanakan Kebun Baru")
                    .foregroundColor(.gray)
                    .bold()
                    .font(.system(size: 20))
                Spacer()
                CustomButton(title: "Rencanakan")
            }.padding()

        }
        .frame(width: UIScreen.screenWidth * 0.8, height: UIScreen.screenHeight / 3.5)
        
    }
}


struct PlantReference : View{
    var body: some View{
        VStack{
            HStack{
                Text("Referensi Tanaman")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(Color("GreenPrimary"))
                Spacer()
                Button("lihat semua"){}
                .foregroundColor(Color("myLightGreen"))
            }.padding()
            
            HStack(alignment: .center) {
                Spacer()
                ImageReference(imageName: "patung_jempol", imageTitle: "patung jempol")
                Spacer()
                ImageReference(imageName: "patung_jempol", imageTitle: "patung jempol")
                Spacer()
                ImageReference(imageName: "patung_jempol", imageTitle: "patung jempol")
                Spacer()
            }
        }
    }
}
struct MethodeReference : View{
    var body: some View{
        VStack{
            HStack{
                Text("Referensi Metode")
                    .bold()
                    .font(.system(size: 20))
                    .foregroundColor(Color("GreenPrimary"))
                Spacer()
                Button("lihat semua"){}
                .foregroundColor(Color("myLightGreen"))
            }.padding()
            
            HStack(alignment: .center) {
                Spacer()
                ImageReference(imageName: "patung_jempol", imageTitle: "patung jempol")
                Spacer()
                ImageReference(imageName: "patung_jempol", imageTitle: "patung jempol")
                Spacer()
                ImageReference(imageName: "patung_jempol", imageTitle: "patung jempol")
                Spacer()
            }
        }
    }
}

struct ImageReference : View{
    @State var imageName : String
    @State var imageTitle : String
    var body: some View{
        VStack{
            Image(imageName)
                .resizable()
                .frame(width: 72, height: 72)
                .cornerRadius(36)
            Text(imageTitle)
                .multilineTextAlignment(.center)
                .font(.system(size: 12))
        }
    }
    
}

struct CustomButton : View{
    @State var title : String
    var body: some View{
        Button {
            
        } label: {
            ZStack{
                Rectangle()
                    .frame(width: 314, height: 60)
                    .cornerRadius(16)
                    .foregroundColor(Color("GreenPrimary"))
                Text(title)
                    .foregroundColor(.white)
            }
            
        }
    }
}
extension UIScreen{
   static let screenWidth = UIScreen.main.bounds.size.width
   static let screenHeight = UIScreen.main.bounds.size.height
   static let screenSize = UIScreen.main.bounds.size
}
