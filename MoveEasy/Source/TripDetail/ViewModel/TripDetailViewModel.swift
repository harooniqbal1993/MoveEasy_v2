//
//  TripDetailViewModel.swift
//  MoveEasy
//
//  Created by Apple on 06/01/1444 AH.
//

import Foundation

struct BookingPropertyModel {
    var image: UIImage? = nil
    var name: String? = nil
    var value: String? = nil
}

class TripDetailViewModel {
    
    var properties: [BookingPropertyModel]? = nil
    
    var order: OrderModel?
    
    var orderNumber: Int? {
        return order?.id ?? 0
    }
    
    var customerName: String? {
        return (OrderSession.shared.bookingModel?.user?.firstName ?? "--") + " " + (OrderSession.shared.bookingModel?.user?.lastName ?? "") // order?.riderName ?? ""
    }
    
    var phoneNumber: String? {
        return OrderSession.shared.bookingModel?.user?.phone // order?.riderPhone
    }
    
    var date: String? {
        return OrderSession.shared.bookingModel?.deliveryDate
    }
    
    var time: String? {
        let split = OrderSession.shared.bookingModel?.deliveryDate?.components(separatedBy: " ")
        if let t = split?[1], let m = split?[2] {
            return t + " " + m
        }
        return OrderSession.shared.bookingModel?.exactTime
    }
    
    var pickupLocation: String? {
        return OrderSession.shared.bookingModel?.pickupLocation
    }
    
    var dropoffLocation: String? {
        return OrderSession.shared.bookingModel?.dropoffLocation
    }
    
    var pickupInstructions: String? {
        return OrderSession.shared.bookingModel?.pickUpInstructions
    }
    
    var dropoffInstructions: String? {
        return OrderSession.shared.bookingModel?.dropOffInstructions
    }
    
    var moveType: String? {
        return moveType(id: OrderSession.shared.bookingModel?.moveTypeId ?? 0)
    }
    
    var moveSize: String? {
        return moveSize(id: OrderSession.shared.bookingModel?.moveSizeId ?? 0)
    }
    
    var jobType: String? {
        return OrderSession.shared.bookingModel?.type
    }
    
    var vehicleType: String? {
        return vehicleType(id: OrderSession.shared.bookingModel?.vehicleTypeId ?? 0) // "\(OrderSession.shared.bookingModel?.vehicleTypeId ?? 0)"
    }
    
    var numberOfMoovers: String? {
        return "\(OrderSession.shared.bookingModel?.labourNeeded ?? 0)"
    }
    
    var mapButtonHidden: Bool {
        return (OrderSession.shared.bookingModel?.pickupLatitude == nil && OrderSession.shared.bookingModel?.pickupLongitude == nil && OrderSession.shared.bookingModel?.dropoffLatitude == nil && OrderSession.shared.bookingModel?.dropoffLongitude == nil)
    }
    
    var stops: [Stop]? {
        let pickupLocation = Stop(id: nil, stop: OrderSession.shared.bookingModel?.pickupLocation, personName: OrderSession.shared.bookingModel?.user?.firstName, personPhone: OrderSession.shared.bookingModel?.user?.phone, instructions: OrderSession.shared.bookingModel?.pickUpInstructions, bookingId: OrderSession.shared.bookingModel?.id, lat: OrderSession.shared.bookingModel?.pickupLatitude, long: OrderSession.shared.bookingModel?.pickupLongitude)
        
        let destinationLocation = Stop(id: nil, stop: OrderSession.shared.bookingModel?.dropoffLocation, personName: OrderSession.shared.bookingModel?.user?.firstName, personPhone: OrderSession.shared.bookingModel?.user?.phone, instructions: OrderSession.shared.bookingModel?.dropOffInstructions, bookingId: OrderSession.shared.bookingModel?.id, lat: OrderSession.shared.bookingModel?.dropoffLatitude, long: OrderSession.shared.bookingModel?.dropoffLongitude)
        
        return [pickupLocation] + (OrderSession.shared.bookingModel?.stops ?? []) + [destinationLocation]
    }
    
    init(order: OrderModel) {
        self.order = order
        self.properties = [BookingPropertyModel(image: UIImage(systemName: "person.fill"), name: "Customer name", value: "John doe"), BookingPropertyModel(image: UIImage(systemName: "phone.fill"), name: "Phone name", value: "+1 120101123"), BookingPropertyModel(image: UIImage(systemName: "calendar"), name: "Date", value: "22 June 2022"), BookingPropertyModel(image: UIImage(systemName: "clock"), name: "Time", value: "10:30 PM"), BookingPropertyModel(image: UIImage(systemName: "train.side.rear.car"), name: "Vehicle type", value: "Pickup"), BookingPropertyModel(image: UIImage(systemName: "person.wave.2"), name: "# of movers", value: "1"), BookingPropertyModel(image: UIImage(systemName: "network"), name: "Job type", value: "moovers"), BookingPropertyModel(image: UIImage(systemName: "dollarsign.square"), name: "Est. income", value: "$62.80")]
    }
    
    func getBooking(bookingID: String?, completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.getBookingSummary(bookingID: bookingID ?? "") { result, error in
            if let error = error {
                completion(error)
                return
            }
            OrderSession.shared.bookingModel = result
            
            self.properties = [BookingPropertyModel(image: UIImage(systemName: "person.fill"), name: "Customer name", value: self.customerName), BookingPropertyModel(image: UIImage(systemName: "phone.fill"), name: "Phone name", value: self.phoneNumber), BookingPropertyModel(image: UIImage(systemName: "calendar"), name: "Date", value: self.date), BookingPropertyModel(image: UIImage(systemName: "clock"), name: "Time", value: self.time), BookingPropertyModel(image: UIImage(systemName: "train.side.rear.car"), name: "Vehicle type", value: self.vehicleType), BookingPropertyModel(image: UIImage(systemName: "person.wave.2"), name: "# of movers", value: self.numberOfMoovers), BookingPropertyModel(image: UIImage(systemName: "network"), name: "Job type", value: self.jobType), BookingPropertyModel(image: UIImage(systemName: "dollarsign.square"), name: "Est. income", value: "$62.80")]
            
            if (OrderSession.shared.bookingModel?.type?.lowercased() == "Moovers".lowercased()) {
                self.properties = [BookingPropertyModel(image: UIImage(systemName: "person.fill"), name: "Customer name", value: self.customerName), BookingPropertyModel(image: UIImage(systemName: "phone.fill"), name: "Phone name", value: self.phoneNumber), BookingPropertyModel(image: UIImage(systemName: "calendar"), name: "Date", value: self.date), BookingPropertyModel(image: UIImage(systemName: "clock"), name: "Time", value: self.time), BookingPropertyModel(image: UIImage(systemName: "person.wave.2"), name: "# of movers", value: self.numberOfMoovers), BookingPropertyModel(image: UIImage(systemName: "network"), name: "Job type", value: self.jobType), BookingPropertyModel(image: UIImage(systemName: "dollarsign.square"), name: "Est. income", value: "$62.80")]
            }
            
            completion(nil)
        }
    }
    
    func acceptOrder(completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.acceptBooking(bookingID: "\(OrderSession.shared.order?.id ?? 0)") { bookingModel, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }
                
                completion(nil)
            }
        }
    }
    
    func cancelBooking(completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.cancelBooking(bookingID: "\(OrderSession.shared.order?.id ?? 0)") { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }
                
                completion(nil)
            }
        }
    }
    
    func rejectBooking(completion: @escaping (_ error: String?) -> Void) {
        NetworkService.shared.rejectBooking(bookingID: "\(OrderSession.shared.order?.id ?? 0)", driverID: "\(DriverSession.shared.driver?.id ?? 0)") { result, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(error)
                    return
                }
                
                completion(nil)
            }
        }
        
//        {
//          "statusCode": 200,
//          "message": "Success",
//          "data": "Trip rejected and Notification sent to all active drivers"
//        }
    }
    
    func vehicleType(id: Int) -> String {
        switch id {
        case 1001:
            return "Mini Van"
        case 1002:
            return "Pickup Truck"
        case 1003:
            return "Cargo Van"
        case 1004:
            return "Trailer (4''x8'')"
        default:
            return "Trailer (5''x10'')"
        }
    }
    
    func moveType(id: Int) -> String {
        switch id {
        case 1000:
            return "2-3"
        case 1001:
            return "3-4"
        case 1003:
            return "4-5"
        case 1004:
            return "5-6"
        default:
            return "1"
        }
    }
    
    func moveSize(id: Int) -> String {
        switch id {
        case 1:
            return "1 Bedroom"
        case 2:
            return "2 Bedroom"
        case 3:
            return "3 Bedroom"
        case 4:
            return "4 Bedroom"
        case 5:
            return "5 Bedroom"
        case 6:
            return "6 Bedroom"
        default:
            return "Other"
        }
    }
}
