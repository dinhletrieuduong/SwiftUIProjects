//
//  ProfessionalSideMenuView.swift
//  SwiftUIPortal
//
//  Created by Dinh Le Trieu Duong on 12/02/2024.
//

import SwiftUI

struct ProfessionalSideMenuDemoView: View {
    
    @State private var showMenu: Bool = false
    @State private var selectedTab: SideMenuOptionEnum = .dashboard
    var body: some View {
        NavigationStack {
            ZStack {
                TabView(selection: $selectedTab) {
                    Text("Dashboard")
                        .tag(SideMenuOptionEnum.dashboard)
                    Text("Performance")
                        .tag(SideMenuOptionEnum.performance)
                    Text("Profile")
                        .tag(SideMenuOptionEnum.profile)
                    Text("Search")
                        .tag(SideMenuOptionEnum.search)
                    Text("Notification")
                        .tag(SideMenuOptionEnum.notification)
                }
                
                ProfessionalSideMenuView(isShowing: $showMenu, selectedTab: $selectedTab)
                
                
            }
            .toolbar(showMenu ? .hidden : .visible, for: .navigationBar)
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        showMenu.toggle()
                    }, label: {
                        Image(systemName: "line.3.horizontal")
                    })
                }
            })
        }
    }
}

struct ProfessionalSideMenuView: View {
    @Binding var isShowing: Bool
    @Binding var selectedTab: SideMenuOptionEnum
    
    var body: some View {
        ZStack {
            if isShowing {
                Rectangle()
                    .opacity(0.3)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isShowing.toggle()
                    }
                
                HStack {
                    VStack(alignment: .leading, spacing: 32) {
                        ProfessionalSideMenuHeaderView()
                        
                        VStack {
                            ForEach(SideMenuOptionEnum.allCases, id: \.rawValue) { option in
                                Button {
                                    selectedTab = option
                                    isShowing = false
                                } label: {
                                    ProfessionalSideMenuRowView(option: option, selectedOption: selectedTab)
                                }
                            }
                        }
                        
                        Spacer()
                        
                    }
                    .padding()
                    .frame(width: 270, alignment: .leading)
                    .background(.white)
                    
                    Spacer()
                }
            }
        }
        .transition(.move(edge: .leading))
        .animation(.easeInOut, value: isShowing)
    }
}

struct ProfessionalSideMenuRowView: View {
    
    var option: SideMenuOptionEnum
    var selectedOption: SideMenuOptionEnum
    
    private var isSelected: Bool {
        return selectedOption == option
    }
    
    var body: some View {
        HStack {
            Image(systemName: option.systemImage)
                .imageScale(.small)
            
            Text(option.title)
                .font(.subheadline)
            
            Spacer()
            
            
        }
        .padding(.leading)
        .foregroundStyle(isSelected ? .blue : .primary)
        .frame(width: 216, height: 44)
        .background(isSelected ? .blue.opacity(0.25) : .clear)
        .clipShape(.rect(cornerRadius: 10))
    }
}

struct ProfessionalSideMenuHeaderView: View {
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .imageScale(.large)
                .foregroundStyle(.white)
                .frame(width: 48, height: 48)
                .background(.blue)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .padding(.vertical)
            
            VStack(alignment: .leading, spacing: 6) {
                Text("Dylan Dinh")
                    .font(.subheadline)
                
                Text("dinhletrieuduong@gmail.com")
                    .font(.footnote)
                    .tint(.gray)
                
            }
        }
    }
}

enum SideMenuOptionEnum: Int, CaseIterable {
    case dashboard
    case performance
    case profile
    case search
    case notification
    
    var title: String {
        switch self {
            case .dashboard:
                "Dashboard"
            case .performance:
                "Performance"
            case .profile:
                "Profile"
            case .search:
                "Search"
            case .notification:
                "Notification"
        }
    }
    
    var systemImage: String {
        switch self {
            case .dashboard:
                "filemenu.and.cursorarrow"
            case .performance:
                "chart.bar"
            case .profile:
                "person"
            case .search:
                "magnifyingglass"
            case .notification:
                "bell"
        }
    }
}

#Preview {
    ProfessionalSideMenuDemoView()
}
