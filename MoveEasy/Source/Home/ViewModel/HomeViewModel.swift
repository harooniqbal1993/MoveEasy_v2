//
//  HomeViewModel.swift
//  MoveEasy
//
//  Created by Apple on 17/12/1443 AH.
//

import Foundation

class HomeViewModel {
    
    var driverName: String? = DriverSession.shared.driver?.firstName
    var displayedOrders: [OrderModel]? = []
    var upcomingOrders: Int = 0
    var completedOrder: Int = 0
    var activeTrip: OrderModel? = nil
    var orders: [OrderModel] = []
    var activeOrders: [OrderModel] = []
    var pendingOrders: [OrderModel] = []
    var completedOrders: [OrderModel] = []
    var cancelledOrders: [OrderModel] = []
    var allOrders: [OrderModel] = []
    var todayOrders: [OrderModel] = []
    var myOrders: [OrderModel] = []
    var newOrders: [OrderModel] = []
    var isLoading: Bool = false
    
    var filterArray: [FilterModel] = [FilterModel(name: "New Bookings", isSelected: false), FilterModel(name: "All Bookings", isSelected: true), FilterModel(name: "Cancelled", isSelected: false), FilterModel(name: "Completed", isSelected: false)]
    
    var appliedFilter: FilterModel!
    
    init() {
        appliedFilter = filterArray[1]
    }
    
    func refreshFilters(selectedFilter: FilterModel) {
        filterArray = filterArray.map { filter in
            var mutableFilter = filter
            mutableFilter.isSelected = filter == selectedFilter
            if mutableFilter.isSelected {
                appliedFilter = mutableFilter
            }
            return mutableFilter
        }
    }
    
    func filterOrders() {
        switch appliedFilter.name {
        case "All":
            displayedOrders = allOrders
            break
            
        case "New Bookings":
            displayedOrders = newOrders
            break
            
        case "All Bookings":
            displayedOrders = myOrders
            break
            
        case "Today's":
            displayedOrders = todayOrders
            break
            
        case "Completed":
            displayedOrders = completedOrders
            
        case "Cancelled":
            displayedOrders = cancelledOrders
            break
            
        default:
            print()
        }
    }
    
    func getDashboardData(completion: @escaping (String?) -> Void) {
        isLoading = true
        NetworkService.shared.dashboard { result, error in
            if let error = error {
                completion(error)
                return
            }
            DispatchQueue.main.async {
                self.displayedOrders = result?.data?.active ?? []
                self.upcomingOrders = result?.data?.totalOrders ?? 0
                self.completedOrder = result?.data?.completed?.count ?? 0
                self.activeTrip = result?.data?.activeTrip
                self.activeOrders = result?.data?.active ?? []
                self.pendingOrders = result?.data?.pending ?? []
                self.completedOrders = result?.data?.completed ?? []
                self.cancelledOrders = result?.data?.cancelled ?? []
                self.todayOrders = result?.data?.today ?? []
                self.myOrders = result?.data?.myOrders ?? []
                self.newOrders = result?.data?.newOrders ?? []
                self.allOrders = self.activeOrders + self.pendingOrders + self.completedOrders + self.cancelledOrders
                if let activeTrip = self.activeTrip {
                    self.allOrders.append(activeTrip)
                }
                self.isLoading = false
                self.filterOrders()
                completion(nil)
            }
        }
    }
    
    func getTodaysBookings(completion: @escaping (String?) -> Void) {
        isLoading = true
        NetworkService.shared.getTodaysBookings { result, error in
            if let error = error {
                self.displayedOrders = []
                completion(error)
                return
            }
            DispatchQueue.main.async {
                self.displayedOrders = result ?? []
//                self.upcomingOrders = result?.data?.totalOrders ?? 0
//                self.completedOrder = result?.data?.completeOrders ?? 0
//                self.activeTrip = result?.data?.activeTrip
//                self.activeOrders = result?.data?.active ?? []
//                self.pendingOrders = result?.data?.pending ?? []
//                self.completedOrders = result?.data?.completed ?? []
//                self.cancelledOrders = result?.data?.cancelled ?? []
//                self.allOrders = self.activeOrders + self.pendingOrders + self.completedOrders + self.cancelledOrders
                self.isLoading = false
                completion(nil)
            }
        }
    }
    
    func getDriverDetail(completion: @escaping () -> Void) {
        isLoading = true
        NetworkService.shared.getDriverDetail { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    debugPrint("getDriverDetail Error", error)
                    return
                }
            }
            DriverSession.shared.driver = result?.data
            self.driverName = result?.data?.firstName
            completion()
        }
    }
}
