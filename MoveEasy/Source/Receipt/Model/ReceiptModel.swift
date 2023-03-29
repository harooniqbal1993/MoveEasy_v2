//
//  ReceiptModel.swift
//  MoveEasy
//
//  Created by Apple on 26/01/1444 AH.
//

import Foundation

struct FinalJobResponse: Decodable {
    var statusCode: Int? = nil
    var message: String? = nil
    var data: OrderSummaryModel? = nil
    var bookingTotalModel: ReceiptModel? = nil
}

struct ReceiptModel: Decodable {
    var coupon: String? = nil
    var discount: Float? = nil
    var baseFare: Float? = nil
    var totalDistance: Float? = nil
    var gstandPst: Float? = nil
    var subtotal: Float? = nil
    var totalChargeBTax: Float? = nil
    var transferFee: Float? = nil
    var totalServiceFee: Float? = nil
    var totalCharge: Float? = nil
    var serviceFee: Float? = nil
    var labourSurcharge: Float? = nil
    var totalTaxGstpstrate: Float? = nil
    var totalDuration: Float? = nil
    var workTime: Float? = nil
}

//{"id":1013,"userId":0,"pickupLocation":"Karachi, Pakistan","dropoffLocation":"Sukkur, Pakistan","vehicleTypeId":1004,"deliveryDate":"12/6/2021 7:00:00 PM","type":"Mooving","deliverySlotId":1003,"labourNeeded":3,"pickupTotalFloors":1,"dropoffTotalFloors":3,"perFloorRate":null,"pickupMedium":"stairs","dropoffMedium":"elevator","distanceInKm":474.0,"durationInMins":410,"dropOffPersonName":"bb","dropOffPersonPhone":"234","pickUpPersonName":"aa","pickUpPersonPhone":"123","dropOffInstructions":"","pickUpInstructions":"","status":"InProgress","exactTime":null,"moveTypeId":null,"moveSizeId":null,"startTime":null,"endTime":null,"numberOfHours":null,"resumingTime":null,"pauseTime":null,"bookingTotalModel":{"coupon":null,"discount":null,"baseFare":"8","totalDistance":"474.00","gstandPst":"26.83","subtotal":"434.60","totalChargeBTax":"536.68","transferFee":"2.83","totalServiceFee":"7.08","totalCharge":"563.51","serviceFee":"2.50","labourSurcharge":"90","totalTaxGstpstrate":"5","totalDuration":null},"bookingFiles":[],"vehicle":{"id":1004,"title":"Trailer (4''x8'')","pictureUrl":"Trailer (4''x8'')_semi_truck.png","description":"Trailer (4''x8'')","baseFare":8.0,"serviceFee":2.5,"perKmrate":0.9,"labourCost":30.0,"minimumFare":10.5,"cancellationFee":5.0,"width":"-","height":"8","length":"4","detailPictureUrl":null,"availableForMove":true,"availableForDelivery":true,"availableForEnterprise":true,"halfLoadPrice":null,"isHalfLoadAvailable":false,"cargoSpace":null,"recommendedUse":null},"user":null,"deliverySlot":{"id":1003,"rate":"0","startTime":"13:00:00","endTime":"15:00:00","exactTimeRange":null,"isASAP":null},"stops":[]}

struct OrderSummaryModel: Decodable {
    var id: Int? = nil
    var userId: Int? = nil
    var pickupLocation: String? = nil
    var dropoffLocation: String? = nil
    var vehicleTypeId: Int? = nil
    var deliveryDate: String? = nil
    var type: String? = nil
    var deliverySlotId: Int? = nil
    var labourNeeded: Int? = nil
    var pickupTotalFloors: Int? = nil
    var dropoffTotalFloors: Int? = nil
    var perFloorRate: Float? = nil
    var pickupMedium: String? = nil
    var dropoffMedium: String? = nil
    var distanceInKm: Float? = nil
    var durationInMins: Float? = nil
    var dropOffPersonName: String? = nil
    var dropOffPersonPhone: String? = nil
    var pickUpPersonName: String? = nil
    var pickUpPersonPhone: String? = nil
    var dropOffInstructions: String? = nil
    var pickUpInstructions: String? = nil
    var pickupLatitude: String? = nil
    var pickupLongitude: String? = nil
    var dropoffLatitude: String? = nil
    var dropoffLongitude: String? = nil
    var status: String? = nil
    var exactTime: String? = nil
    var moveTypeId: Int? = nil
    var moveSizeId: Int? = nil
    var startTime: String? = nil
    var endTime: String? = nil
    var numberOfHours: Float? = nil
    var resumingTime: String? = nil
    var pauseTime: String? = nil
    var bookingTotalModel: BookingTotalModel? = nil
//    var bookingFiles: []
    var vehicle: VehicleModel? = nil
    var user: User? = nil
    var deliverySlot: DeliverySlot? = nil
    var stops: [Stop]? = nil
    var completionTime: TimeInterval? = 0
    var driverId: String? = nil
}

struct VehicleModel: Decodable {
    var id: Int? = nil
    var title: String? = nil
    var pictureUrl: String? = nil
    var description: String? = nil
    var baseFare: Float? = nil
    var serviceFee: Float? = nil
    var perKmrate: Float? = nil
    var labourCost: Float? = nil
    var minimumFare: Float? = nil
    var cancellationFee: Float? = nil
    var width: String? = nil
    var height: String? = nil
    var length: String? = nil
    var detailPictureUrl: String? = nil
    var availableForMove: Bool? = false
    var availableForDelivery: Bool? = false
    var availableForEnterprise: Bool? = false
    var halfLoadPrice: Float? = nil
    var isHalfLoadAvailable: Bool? = false
    var cargoSpace: String? = nil
    var recommendedUse: String? = nil
}

struct User: Decodable {
    var id: Int? = nil
    var email: String? = nil
    var firstName: String? = nil
    var lastName: String? = nil
    var secondaryEmail: String? = nil
    var profileDisplayImageUrl: String? = nil
    var streetAddress: String? = nil
    var city: String? = nil
    var province: String? = nil
    var gender: String? = nil
    var country: String? = nil
    var birthDate: String? = nil
    var phone: String? = nil
    var credit: Float? = nil
    var isFromReferral: Bool? = false
    var hasCard: Bool? = false
    var userRatings: Float? = nil
    var userCards: [UserCard]? = []
}

struct UserCard: Decodable {
    var id: Int? = nil
    var userId: Int? = nil
    var stripeCardId: String? = nil
    var stripeCardCustomer: String? = nil
    var stripeTokenId: String? = nil
    var stripeCardLastFourDigits: String? = nil
    var isDefault: Bool? = nil
}

struct DeliverySlot: Decodable {
    var id: Int? = nil
    var rate: String? = nil
    var startTime: String? = nil
    var endTime: String? = nil
    var exactTimeRange: String? = nil
    var isASAP: Bool? = nil
}

struct Stop: Decodable {
    var id: Int? = nil
    var stop: String? = nil
    var personName: String? = nil
    var personPhone: String? = nil
    var instructions: String? = nil
    var bookingId: Int? = nil
    var lat: String? = nil
    var long: String? = nil
}
