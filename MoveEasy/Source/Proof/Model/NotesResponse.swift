//
//  NotesResponse.swift
//  MoveEasy
//
//  Created by Apple on 27/12/1443 AH.
//

import Foundation

struct NotesResponse: Decodable {
    var statusCode: Int? = nil
    var message: String? = nil
}


//{
//  "": 200,
//  "": "Success",
//  "data": {
//    "id": 1310,
//    "userId": null,
//    "pickupLocation": "Calgary, AB, Canada",
//    "dropoffLocation": "Calgary International Airport (YYC), Airport Road Northeast, Calgary, AB, Canada",
//    "vehicleTypeId": 1000,
//    "deliveryDate": "7/22/2022 7:00:00 PM",
//    "type": "Mooving",
//    "deliverySlotId": null,
//    "labourNeeded": 2,
//    "pickupTotalFloors": null,
//    "dropoffTotalFloors": null,
//    "perFloorRate": null,
//    "pickupMedium": null,
//    "dropoffMedium": null,
//    "distanceInKm": 17,
//    "durationInMins": 20,
//    "dropOffPersonName": null,
//    "dropOffPersonPhone": null,
//    "pickUpPersonName": null,
//    "pickUpPersonPhone": null,
//    "dropOffInstructions": null,
//    "pickUpInstructions": null,
//    "status": "Confirmation",
//    "exactTime": "7:00 AM",
//    "moveTypeId": 1,
//    "startTime": null,
//    "endTime": null,
//    "moveSizeId": 1,
//    "bookingTotalModel": {
//      "coupon": null,
//      "discount": null,
//      "baseFare": "5",
//      "totalDistance": "17.00",
//      "gstandPst": null,
//      "subtotal": "20.30",
//      "totalChargeBTax": "44.88",
//      "transferFee": "1.83",
//      "totalServiceFee": "4.58",
//      "totalCharge": null,
//      "serviceFee": "2.50",
//      "labourSurcharge": "20",
//      "totalTaxGstpstrate": "5",
//      "totalDuration": null
//    },
//    "bookingFiles": [],
//    "vehicle": {
//      "id": 1000,
//      "title": "Car",
//      "pictureUrl": "Car_car.png",
//      "description": "Car",
//      "baseFare": 5,
//      "serviceFee": 2.5,
//      "perKmrate": 0.9,
//      "labourCost": 10,
//      "minimumFare": 7.5,
//      "cancellationFee": 5,
//      "width": "2.9",
//      "height": "2.9",
//      "length": "3.9",
//      "detailPictureUrl": "Car_Front side view.png",
//      "availableForMove": true,
//      "availableForDelivery": true,
//      "availableForEnterprise": false,
//      "halfLoadPrice": null,
//      "isHalfLoadAvailable": true,
//      "cargoSpace": null,
//      "recommendedUse": null
//    },
//    "user": null,
//    "deliverySlot": null,
//    "stops": []
//  }
//}
//
//
//// in case of error
//
//{
//  "statusCode": 400,
//  "message": "Bad Request",
//  "data": null
//}
