//
//  EditProfileView.swift
//  iOS-FakeNFT-Extended
//
//  Created by ivan on 2026-10-28.
//

import SwiftUI

struct EditProfileView: View {
    @Binding var viewModel: ProfileViewModel
    
    @State private var imageURL = ""
    @State private var name = ""
    @State private var description = ""
    @State private var website = ""
    @State private var showMenu = false
    @State private var showAlert = false
    
    var body: some View {
        VStack {
            Button(action: {
                showMenu = true
            }, label: {
                ZStack(alignment: .bottomTrailing) {
                    viewModel.getImage()
                        .resizable()
                        .frame(width: 70, height: 70)
                    Image(.addProfilePhoto22)
                }
            })
            .confirmationDialog("Фото профиля", isPresented: $showMenu, titleVisibility: .visible, actions: {
                Button {
                    showAlert = true
                } label: {
                    Text("Изменить фото")
                }
                Button("Удалить фото", role: .destructive) {
                    
                }
                Button("Отмена", role: .cancel) {
                    
                }
            })
            .padding(EdgeInsets(top: 1, leading: 0, bottom: 0, trailing: 0))
            .alert("Ссылка на фото", isPresented: $showAlert) {
                TextField("", text: $imageURL)
                Button("Сохранить") {
                    
                }
                Button("Отмена", role: .cancel) {
                    
                }
            }
            
            HStack {
                Text("Имя")
                    .font(.system(size: 22, weight: .bold))
                    .tint(.ypBlack)
                Spacer()
            }
            .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
            
            TextField("", text: $name)
                .frame(height: 44)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ypLightGrey)
                }
            
            HStack {
                Text("Описание")
                    .font(.system(size: 22, weight: .bold))
                    .tint(.ypBlack)
                Spacer()
            }
            .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
            
            TextEditor(text: $description)
                .frame(height: 132)
                .scrollContentBackground(.hidden)
                .background(.clear)
                .padding(EdgeInsets(top: 11, leading: 16, bottom: 11, trailing: 16))
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ypLightGrey)
                }
            
            HStack {
                Text("Сайт")
                    .font(.system(size: 22, weight: .bold))
                    .tint(.ypBlack)
                Spacer()
            }
            .padding(EdgeInsets(top: 24, leading: 0, bottom: 0, trailing: 0))
            
            TextField("", text: $website)
                .frame(height: 44)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                .background {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(.ypLightGrey)
                }
            
            Spacer()
            
            Button {
                
            } label: {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(.ypBlack)
                        .frame(height: 60)
                    Text("Сохранить")
                        .font(.system(size: 17, weight: .bold))
                        .tint(.ypWhite)
                }
                
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
        }
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .onAppear {
            setup()
        }
    }
    
    private func setup() {
        name = viewModel.getName()
        description = viewModel.getDescription()
        website = viewModel.getWebsite()
    }
}

#Preview {
    @Previewable @State var vm = ProfileViewModel()
    EditProfileView(viewModel: $vm)
}
