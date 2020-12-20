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
    
    var body: Body {
                
        Body(state: viewModel.state,
             detailViewMaker: { AnyView(makeDetailView(at: $0)) },
             deleteItems: { viewModel.deleteItems(for: $0) })
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
    
    struct Body: View {
        
        let state: State
        
        let detailViewMaker: (Int) -> AnyView
        let deleteItems: (IndexSet) -> Void
        
        var body: some View {
            NavigationView {
                content(for: state)
                    .navigationBarTitle(state.title)
            }
        }
    }
}

private extension LocationListView.Body {
    
    func content(for state: State) -> some View {
        switch state.items {
        case let .nonEmpty(locations):
            return AnyView(list(for: locations))
        }
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
}

struct LocationListViewBody_Previews: PreviewProvider {
    
    typealias ViewState = LocationListView.Body.State
    
    static var previews: some View {
        Preview(items: [
            .init(id: UUID(), name: "Moscow"),
            .init(id: UUID(), name: "Amsterdam")
        ])
    }
    
    struct Preview: View {
        
        @State var items: [ViewState.Item]
        
        var body: some View {
            LocationListView.Body(state: .init(title: "Weather",
                                               items: .nonEmpty(items)),
                                  detailViewMaker: { _ in AnyView(EmptyView()) },
                                  deleteItems: { items.remove(atOffsets: $0) })
        }
    }
}
