import SwiftUI

struct HandSignPredictionView: View {
    
    @EnvironmentObject var appModel: AppModel
    
    @State var signLanguageText: String = ""
    @State var canTextBeUpdated: Bool = false
    
    @Binding var currentHandSignPredictionView: Int
    
    var body: some View {
        ZStack {
            // Show the camera feed
            if let image = appModel.viewfinderImage { //if there is a camera feed
                GeometryReader { geometry in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                .ignoresSafeArea()
                .overlay {
                    VStack {
                        HStack {
                            ASLBackButtonView()
                            Spacer()
                            Button(action: {
                                appModel.camera.switchCaptureDevice()
                            }, label: {
                                Image(systemName: "arrow.trianglehead.2.clockwise.rotate.90")
                                    .padding(10)
                                    .background(Color.black.opacity(0.7).clipShape(Circle()))
                                    .padding()
                                    .foregroundStyle(Color.white)
                                    
                            })
                        }
                        
                        
                        Spacer()
                        HStack {
                            Spacer()
                            VStack {
                                ScrollViewReader { proxy in
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack {
                                            TitleView(title: appModel.recognizedText)
                                                .padding()
                                                .foregroundStyle(Color.white)
                                                .lineLimit(1)

                                            // Invisible view to scroll to
                                            Color.clear
                                                .frame(width: 1, height: 1)
                                                .id("END")
                                        }
                                    }
                                    .onChange(of: appModel.recognizedText, {
                                        Vibration.success.vibrate()
                                        withAnimation {
                                            proxy.scrollTo("END", anchor: .trailing)
                                        }
                                    })
                                }

                                if (appModel.recognizedText != "") {
                                    HStack {
                                        Button(action: {
                                            appModel.recognizedText = ""
                                        }, label: {
                                            HStack {
                                                Text("Clear text")
                                                Image(systemName: "trash.fill")
                                            }
                                            .foregroundStyle(Color.white)
                                            .padding()
                                            .background(Color.black.clipShape(RoundedRectangle(cornerRadius:20)))
                                            .padding(.bottom)
                                        })
                                        
                                        
                                        Button(action: {
                                            appModel.recognizedText = String(appModel.recognizedText.dropLast())
                                        }, label: {
                                            HStack {
                                                Text("Undo")
                                                Image(systemName: "arrow.uturn.backward")
                                            }
                                            .foregroundStyle(Color.white)
                                            .padding()
                                            .background(Color.black.clipShape(RoundedRectangle(cornerRadius:20)))
                                            .padding(.bottom)
                                        })
                                        .foregroundStyle(Color.white)
                                    }
                                }
                                
                                
                                
                            }
                            Spacer()
                                
                        }
                        .background(Color.black.opacity(0.7))
                        
                    }
                    
                }

            }
            else { //no camera feed
                Rectangle()
                    .fill(Color.black)
                    .ignoresSafeArea()
                    .overlay {
                        VStack(alignment: .leading) {
                            ASLBackButtonView()
                            Spacer()
                            Text("The camera could not be initialized. Please ensure that you have granted permission to the app to access your camera in your device's Settings. For more information, please visit the help menu on the home page.")
                                .font(Font.custom("AvenirNext-Regular", size: 20))
                                .foregroundStyle(.white)
                                .padding()
                            Spacer()
                        }
                        
                    }
            }
                        
        }
    }
    
    @ViewBuilder
    func ASLBackButtonView() -> some View {
        Button(action: {
            currentHandSignPredictionView = 0
        }, label: {
            Image(systemName: "chevron.left")
                .padding(10)
                .background(Color.black.opacity(0.7).clipShape(Circle()))
                .padding()
                .foregroundStyle(Color.white)
                
        })
    }
}
