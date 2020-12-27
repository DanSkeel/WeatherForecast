//
//  LocationListView.swift
//  WeatherForecast
//
//  Created by Danila Shikulin on 20.12.2020.
//

import Foundation
import SwiftUI

struct LocationListView: View {
    
    @ObservedObject var viewModel: LocationListViewModel
    
    let helpView: AnyView
    
    var body: some View {
        ZStack {
            BodyView(
                state: viewModel.state,
                detailViewMaker: { AnyView(makeDetailView(at: $0)) },
                deleteItems: { viewModel.deleteItems(for: $0) },
                addItemAction: viewModel.addItem,
                helpAction: viewModel.helpAction
            )
            .sheet(isPresented: $viewModel.isShowingHelp, content: {
                helpView
            })
            
            // Seems like bug, but you can't use `sheet` twice on same view.
            EmptyView()
                .sheet(item: $viewModel.locationPickerViewModel) {
                    viewModel.locationPickerBuiler.build(for: $0)
                }
        }
    }
}

private extension LocationListView {
    
    func makeDetailView(at index: Int) -> some View {
        viewModel.detailViewModel(at: index).map {
            AnyView(viewModel.detailViewBuilder.build(for: $0))
        } ?? AnyView(Text("Location not found"))
    }
}

extension LocationListView {
    
    struct BodyView: View {
        
        let state: State
        
        let detailViewMaker: (Int) -> AnyView
        let deleteItems: (IndexSet) -> Void
        let addItemAction: () -> Void
        let helpAction: () -> Void
        
        var body: some View {
            NavigationView {
                content(for: state)
                    .navigationBarTitle(state.title)
                    .navigationBarItems(leading: helpButton(), trailing: addButton())
            }
        }
    }
}

private extension LocationListView.BodyView {
    
    func content(for state: State) -> some View {
        switch state.items {
        
        case let .empty(text):
            return AnyView(emtpyList(text: text))
            
        case let .nonEmpty(locations):
            return AnyView(list(for: locations))
        }
    }
    
    func emtpyList(text: String) -> some View {
        Text(text)
            .font(.largeTitle)
            .multilineTextAlignment(.center)
    }
    
    func list(for items: [State.Item]) -> some View {
        List {
            ForEach(Array(items.enumerated()), id: \.1.id) { index, item in
                NavigationLink(destination: NavigationLazyView(detailViewMaker(index))) {
                    Text(item.name)
                }
            }
            .onDelete(perform: deleteItems)
        }
        .listStyle(PlainListStyle())
    }
    
    func addButton() -> some View {
        navigationBarButton(imageSystemName: "plus", action: addItemAction)
    }
    
    func helpButton() -> some View {
        navigationBarButton(imageSystemName: "questionmark.circle", action: helpAction)
    }
    
    func navigationBarButton(imageSystemName: String, action: @escaping () -> Void) -> some View {
        Button(action: action, label: {
            Image(systemName: imageSystemName)
                .imageScale(.large)
                .frame(width: 44, height: 44)
        })
    }
}

struct LocationListViewBody_Previews: PreviewProvider {
    
    typealias ViewState = LocationListView.BodyView.State
    
    static var previews: some View {
        Preview(items: [
            .init(id: UUID(), name: "Moscow"),
            .init(id: UUID(), name: "Amsterdam")
        ])
    }
    
    struct Preview: View {
        
        @State var items: [ViewState.Item]
        
        var body: some View {
            LocationListView.BodyView(state: .init(title: "Weather",
                                                   items: .nonEmpty(items)),
                                      detailViewMaker: { _ in AnyView(EmptyView()) },
                                      deleteItems: { items.remove(atOffsets: $0) },
                                      addItemAction: { items.insert(.init(id: UUID(), name: "London"), at: 0) },
                                      helpAction: {})
        }
    }
}
