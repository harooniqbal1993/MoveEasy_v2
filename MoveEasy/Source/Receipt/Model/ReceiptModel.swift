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
}

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
//    var stops: [Stop]? = nil
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
    var rate: Float? = nil
    var startTime: String? = nil
    var endTime: String? = nil
    var exactTimeRange: String? = nil
    var isASAP: Bool? = nil
}
