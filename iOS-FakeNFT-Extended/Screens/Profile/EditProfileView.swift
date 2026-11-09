//
//  EditProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-10-28.
//

import SwiftUI

struct EditProfileView: View {
    @Binding var viewModel: ProfileViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    @State private var imageURL = ""
    @State private var name = ""
    @State private var description = ""
    @State private var website = ""
    @State private var showMenu = false
    @State private var showAlert = false
    @State private var showExitAlert = false
    
    var body: some View {
        ZStack {
            VStack {
                Button(action: {
                    showMenu = true
                }, label: {
                    ZStack(alignment: .bottomTrailing) {
                        Image(uiImage: viewModel.image)
                            .resizable()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                        Image(.addProfilePhoto22)
                    }
                })
                .confirmationDialog(String(localized: .profilePhotoTitle), isPresented: $showMenu, titleVisibility: .visible, actions: {
                    Button {
                        showAlert = true
                    } label: {
                        Text(.profileChangePhoto)
                    }
                    Button(String(localized: .profileDeletePhoto), role: .destructive) {
                        viewModel.image = .profilePhotoDefault70
                    }
                    Button(String(localized: .commonCancel), role: .cancel) {
                        
                    }
                })
                .padding(EdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 0))
                .alert(String(localized: .profilePhotoURL), isPresented: $showAlert) {
                    TextField("", text: $imageURL)
                    Button(String(localized: .commonSave)) {
                        viewModel.loadImage(urlString: imageURL)
                    }
                    Button(String(localized: .commonCancel), role: .cancel) {
                        
                    }
                }
                
                HStack {
                    Text(.profileName)
                        .font(AppFont.bold22)
                        .foregroundStyle(.ypBlack)
                    Spacer()
                }
                .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
                
                TextField("", text: $name)
                    .foregroundStyle(.ypBlack)
                    .frame(height: 44)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ypLightGrey)
                    }
                
                HStack {
                    Text(.profileDescription)
                        .font(AppFont.bold22)
                        .foregroundStyle(.ypBlack)
                    Spacer()
                }
                .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
                
                TextEditor(text: $description)
                    .foregroundStyle(.ypBlack)
                    .frame(height: 132)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .padding(EdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16))
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ypLightGrey)
                    }
                
                HStack {
                    Text(.profileWebsite)
                        .font(AppFont.bold22)
                        .foregroundStyle(.ypBlack)
                    Spacer()
                }
                .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
                
                TextField("", text: $website)
                    .foregroundStyle(.ypBlack)
                    .frame(height: 44)
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(.ypLightGrey)
                    }
                
                Spacer()
                
                Button {
                    Task {
                        await viewModel.save(
                            name: name,
                            avatar: imageURL,
                            description: description,
                            website: website
                        )
                    }
                    dismiss()
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(.ypBlack)
                            .frame(height: 60)
                        Text(.commonSave)
                            .font(AppFont.bold17)
                            .foregroundStyle(.ypWhite)
                    }
                    
                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
            }
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .background(Color.ypWhite.ignoresSafeArea())
        .navigationBarBackButtonHidden()
        .toolbar(.hidden, for: .tabBar)
        .toolbar(content: {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    showExitAlert = true
                } label: {
                    Image(.backward24)
                        .renderingMode(.template)
                        .resizable()
                        .foregroundStyle(.ypBlack)
                        .frame(width: 24, height: 24)
                }

            }
        })
        .alert(String(localized: .profileExitConfirmation), isPresented: $showExitAlert) {
            Button(String(localized: .profileStay), role: .cancel) {
                
            }
            
            Button(String(localized: .profileExit), role: .destructive) {
                dismiss()
            }
        }
        .onAppear {
            setup()
        }
    }
    
    private func setup() {
        name = viewModel.getName
        description = viewModel.getDescription
        website = viewModel.getWebsite
    }
}

#Preview {
    @Previewable @State var model = ProfileViewModel(
        assembly: ServicesAssembly(
            networkClient: DefaultNetworkClient(),
            nftStorage: NftStorageImpl()
        )
    )

    EditProfileView(viewModel: $model)
}
