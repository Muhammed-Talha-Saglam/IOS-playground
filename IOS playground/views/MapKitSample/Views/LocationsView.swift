//
//  LocationsView.swift
//  IOS playground
//
//  Created by Muhammed Talha Sağlam on 8.06.2022.
//

import SwiftUI
import MapKit

struct LocationsView: View {
     
    @StateObject private var vm = LocationsViewModel()
    let maxWithForIpad: CGFloat = 700
    
    var body: some View {
        ZStack{
            mapLayer
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header
                    .padding()
                    .frame(maxWidth: maxWithForIpad)
                Spacer()
                locationsPreviewStack
            }
        }
        .sheet(item: $vm.sheetLocation, onDismiss: nil, content: { location in
            LocationDetailView(location: location)
        })
        .environmentObject(vm)
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView()
    }
}


extension LocationsView {
        
    private var header: some View {
        VStack {
            
            Button {
                vm.toggleLocationsList()
            } label: {
                Text( "\(vm.mapLocation.name), \(vm.mapLocation.cityName)")
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: vm.mapLocation)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: vm.showLocationsList ? 180 : 0))
                    }
            }

            
            if vm.showLocationsList {
                LocationsListView()
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.3), radius: 20, x: 0, y: 15)
    }
    
    private var mapLayer: some View {
        Map(coordinateRegion: $vm.mapRegion,
            annotationItems: vm.locations,
            annotationContent: { location in
//                MapMarker(coordinate: location.coordinates, tint: .blue)
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnnotationView()
                    .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
                    .shadow(radius: 10)
                    .onTapGesture {
                        vm.showNextLocation(location: location)
                    }
            }
        })
    }
    
    private var locationsPreviewStack: some View {
        ZStack {
            ForEach(vm.locations) { location in
                if vm.mapLocation == location {
                    LocationPreviewView(location: location)
                    .shadow(color: .black.opacity(0.3), radius: 20)
                    .padding()
                    .frame(maxWidth: maxWithForIpad)
                    .frame(maxWidth: .infinity)
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing),
                        removal: .move(edge: .leading)))
                }
            }
        }
    }
}
