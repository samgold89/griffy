//
//  BluetoothManager.swift
//  Griffy
//
//  Created by Sam Goldstein on 11/17/18.
//  Copyright © 2018 Sam Goldstein. All rights reserved.
//

import Foundation

import Foundation
import UIKit
import CoreBluetooth

struct CharacterWriteResponse {
  var characteristic: CBCharacteristic
  var error: String?
  var dataLength: Int
}

struct GFYWriteRequest {
  var data: Data
  var characteristic: CBCharacteristic
}

final class BluetoothManager: NSObject {
  static let shared = BluetoothManager()
  fileprivate var centralManager: CBCentralManager!
  var griffyPeripheral: CBPeripheral?
  var cbCharacteristicsById = [String: CBCharacteristic]()
  fileprivate var timer: Timer?
  /****************************
   NOTE: this doesn't work when multiple, different, concurrent write requests are ongoing
   ****************************/
  fileprivate var sendingImageData = [Int]()
  
  fileprivate var statusUpdatedClosure: (()->())?
  
  fileprivate let minimumPacketSize = 27
  fileprivate let griffyHeaderSize = 11 //Change from 7-->11 on 4/10 due to reported but of it going over 512
  
  fileprivate var pendingWriteRequests = [GFYWriteRequest]()
  
  var visibleCharacteristics: [GFCharacteristic]?
  
  var hasDiscoveredGriffy: Bool {
    return griffyPeripheral != nil
  }
  
  fileprivate override init() {
    super.init()
    centralManager = CBCentralManager(delegate: self, queue: nil)
    //    centralManager.state = CBManagerState.poweredOn // I think we need this, eh?
    //    if centralManager.state <= CBManagerState.poweredOff {
    //      // refetch all peripherals - everything has been cleared out
    //    }
  }
  
  func startUpdateTimer() {
    if timer == nil {
      timer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { (timer) in
        self.updateAllObservedValues()
      }
      updateAllObservedValues()
    }
  }
  
  func updateAllObservedValues() {
    guard let visibleCharacteristics = visibleCharacteristics else {
      return
    }
    
    for characteristic in visibleCharacteristics {
      if let char = cbCharacteristicsById[characteristic.id] {
        griffyPeripheral?.readValue(for: char)
        print("reading \(characteristic.name)")
      }
    }
  }
  
  /*vvv*********************vvv*******Old Dropbox Methods - Delete******************************/
  fileprivate func setMetaDataValues(griffyImage: GriffyImage, useHighRes: Bool) {
    if let animation = GFCharacteristic.animation, let frameCountChar = GFCharacteristic.frameCount, let frameDuration = GFCharacteristic.frameDuration {
      
      let isAnimation = griffyImage.frameCount > 1
      writeValue(data: UInt8(isAnimation ? 1 : 0).data, toCharacteristic: animation)
      
      writeValue(data: UInt8(griffyImage.frameCount).data, toCharacteristic: frameCountChar)
      
      writeValue(data: UInt16(griffyImage.frameDuration).data, toCharacteristic: frameDuration)
    }
    
    if let highRes = GFCharacteristic.isHighRes {
      writeValue(data: UInt8(useHighRes ? 1 : 0).data, toCharacteristic: highRes)
    }
  }
  
  func setImageActive(griffy: GriffyImage, useHighRes: Bool, completion: @escaping ()->()) {
    guard let g = GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.imageSelectId) else {
      //      assertionFailure("Missing image active charactersitic.")
      completion()
      return
    }
    
    assert(((useHighRes && griffy.hiResRadialFilePaths != nil) || (!useHighRes && griffy.stdRadialFilePaths != nil)), "Must have hi res images if hi res, and std images if standard")
    
    setMetaDataValues(griffyImage: griffy, useHighRes: useHighRes)
    
    var index = griffy.startingIndex
    if let stds = griffy.stdRadialFilePaths, useHighRes {
      index += stds.count
    }
    writeValue(data: UInt16(index).data, toCharacteristic: g)
    delay(1) {
      GriffyImageState(griffyImage: griffy, setHighRes: useHighRes).saveInfo()
      completion()
    }
  }
  
  func sendGriffyImageToDevice(griffy: GriffyImage) -> Int {
    return sendGriffyImageToDevice(griffy: griffy, resetDataTotal: true)
  }
  
  func sendGriffyImageToDevice(griffy: GriffyImage, resetDataTotal: Bool) -> Int {
    if resetDataTotal {
      sendingImageData.removeAll()
    }
    
    var idx = 0
    var dataSize = 0
    
    if let stds = griffy.stdRadialFilePaths {
      for radial in stds {
        dataSize += sendImageToDevice(radialFilePath: radial, index: griffy.startingIndex+idx)
        idx += 1
      }
    }
    
    if let hiRes = griffy.hiResRadialFilePaths {
      for radial in hiRes {
        dataSize += sendImageToDevice(radialFilePath: radial, index: griffy.startingIndex+idx)
        idx += 1
      }
    }
    
    return dataSize
  }
  
  /*^^^*********************^^^*******Old Dropbox Methods - Delete******************************/
  
  fileprivate func setMetaDataValues(ad: TestAd, useHighRes: Bool) {
    if let animation = GFCharacteristic.animation, let frameCountChar = GFCharacteristic.frameCount, let frameDuration = GFCharacteristic.frameDuration {
      
      writeValue(data: UInt8(ad.isAnimation ? 1 : 0).data, toCharacteristic: animation)
      
      writeValue(data: UInt8(ad.frameCount).data, toCharacteristic: frameCountChar)
      
      writeValue(data: UInt16(ad.frameDuration).data, toCharacteristic: frameDuration)
    }
    
    if let highRes = GFCharacteristic.isHighRes {
      writeValue(data: UInt8(useHighRes ? 1 : 0).data, toCharacteristic: highRes)
    }
  }
  
  func setAdActive(ad: TestAd, useHighRes: Bool) {
    guard let g = GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.imageSelectId) else {
      return
    }
    
    setMetaDataValues(ad: ad, useHighRes: useHighRes)
    
    let index = useHighRes ? ad.hrStartIndexOnWheel ?? -1 : ad.stdStartIndexOnWheel ?? -1
    assert(index >= 0, "Index should exist if we're setting it active on the wheel.")
    
    writeValue(data: UInt16(index).data, toCharacteristic: g)
    delay(1) {
      // save state
    }
  }
  
  func sendAdToDevice(ad: TestAd, withWheelInfo wheelInfo: AdMemoryMap.PumpMemoryPlacement) {
    var idx = 0
    var dataSize = 0
    
    if let stdStart = wheelInfo.stdResStartIndex, let stds = ad.stdRadFilePaths {
      for radial in stds {
        dataSize += sendImageToDevice(radialFilePath: radial, index: stdStart + idx)
        idx += 1
      }
    }
    
    idx = 0
    
    if let hiRes = ad.hrRadFilePaths, let hrIdx = wheelInfo.hrResStartIndex {
      for radial in hiRes {
        dataSize += sendImageToDevice(radialFilePath: radial, index: hrIdx + idx)
        idx += 1
      }
    }
    //    return dataSize
  }
  
  fileprivate func sendImageToDevice(radialFilePath: String, index: Int) -> Int {
    let dataSize = FileManager.default.contents(atPath: radialFilePath)?.count ?? 0
    
    guard let data = FileManager.default.contents(atPath: radialFilePath) else {
      assertionFailure("Not radial data at path: \(radialFilePath)")
      return 0
    }
    
    let maxLength = min((griffyPeripheral?.maximumWriteValueLength(for: CBCharacteristicWriteType.withResponse) ?? minimumPacketSize), 512) - griffyHeaderSize
    let imageDataArray = getDataChunks(data: data, length: maxLength)
    
    guard let char = GFCharacteristic.find(GFCharacteristic.self, byId: BLEConstants.CharacteristicIds.imageLoadId) else {
      return data.count
    }
    
    var idx = 0
    var offsetCounter = 0
    
    NotificationCenter.default.post(name: .setBluetoothBanner, object: GFBluetoothState(message: "Sending Image Parts", color: UIColor.gfGreen), userInfo: nil)
    self.statusUpdatedClosure = nil
    
    for el in imageDataArray {
      if let data = el.first {
        var prependedData = self.getOffsetData(imageId: index, offset: offsetCounter)
        prependedData.append(data)
        self.sendingImageData.append(data.count)
        self.writeValue(data: prependedData, toCharacteristic: char)
        
        idx += 1
        offsetCounter += data.count
      } else {
        assertionFailure("Didn't find data in the first element...")
      }
    }
    
    return dataSize
  }
  
  fileprivate func getOffsetData(imageId: Int, offset: Int) -> Data {
    let imageIdByteZero = imageId % 256
    let imageIdByteOne = (imageId - imageIdByteZero) / 256
    
    let remainder = offset % 65536
    let byteZero = remainder % 256
    let byteOne = (remainder - byteZero)/256
    let byteTwo = (offset - remainder)/65536
    
    let data = Data(bytes: [UInt8(imageIdByteZero), UInt8(imageIdByteOne), UInt8(byteZero), UInt8(byteOne), UInt8(byteTwo), UInt8(0)])
    
    
    return data
  }
  
  fileprivate func getDataChunks(data: Data, length: Int) -> [[Data]] {
    var idx = 0
    var chunks = [[Data]]()
    while idx < data.count {
      let sub = [data.subdata(in: idx..<(min(idx+length, data.count)))]
      chunks.append(sub)
      idx += length
    }
    return chunks
  }
  
  func writeValue(data: Data, toCharacteristic characteristic: GFCharacteristic) {
    guard let char = cbCharacteristicsById[characteristic.uuid] else {
      // If we try to set up values before connection is established, we crash (namely setting brightness on didappear in main vc
      assertionFailure("Couldn't find characteristic with that GFUUID: \(characteristic)")
      return
    }
    
    pendingWriteRequests.append(GFYWriteRequest(data: data, characteristic: char))
    checkSendPendingWriteRequests()
  }
  
  func checkSendPendingWriteRequests() {
    //    if pendingWriteRequestCount < UserDefaults.standard.integer(forKey: UserDefaultConstants.maxOutgoingBLERequests) {
    //      print("skipping the write request due to volume reasons")
    //      return
    //    } else if let pend = pendingWriteRequests.first {
    //      print("SENDING a request from the queue")
    //      pendingWriteRequestCount += 1
    //      griffyPeripheral?.writeValue(pend.data, for: pend.characteristic, type: CBCharacteristicWriteType.withResponse)
    //      pendingWriteRequests.remove(at: 0)
    //    }
    while pendingWriteRequests.count > 0 {
      let pend = pendingWriteRequests.first!
      //      griffyPeripheral?.writeValue(pend.data, for: pend.characteristic, type: (pend.characteristic.griffyCharacteristic?.isReadable ?? false) ? CBCharacteristicWriteType.withResponse : CBCharacteristicWriteType.withoutResponse)
      griffyPeripheral?.writeValue(pend.data, for: pend.characteristic, type: CBCharacteristicWriteType.withResponse)
      pendingWriteRequests.remove(at: 0)
    }
  }
  
  func cancelGriffyConnection() {
    if let griff = griffyPeripheral {
      centralManager.cancelPeripheralConnection(griff)
    }
  }
  
  func scanForPeripherals() {
    centralManager.scanForPeripherals(withServices: nil, options: nil)
  }
  
  fileprivate func setupModels(forPeripheral peripheral: CBPeripheral) {
    GFCharacteristic.deleteAll(GFCharacteristic.self)
    if AdMemoryMap.activeMemoryMap != nil { return }
    guard let name = griffyPeripheral?.name else {
      assertionFailure("Missing peripheral name when setting up admemorymap")
      return
    }
    
    //TODO MVP: use/read the memory size for a memory map
    AdMemoryMap.create(withPeripheralName: name, memorySize: AdMemoryMap.defaultMemorySize)
  }
}

struct GFBluetoothState {
  let message: String
  let color: UIColor
}

extension BluetoothManager: CBCentralManagerDelegate {
  func centralManagerDidUpdateState(_ central: CBCentralManager) {
    switch central.state {
    case .unknown:
      NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Bluetooth state is unknown.", color: UIColor.gfYellow))
    case .resetting:
      NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Bluetooth state is resetting...", color: UIColor.gfYellow))
    case .unsupported:
      NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Central state is unsupported.", color: UIColor.gfRed))
    case .unauthorized:
      NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Bluetooth is not authorized", color: UIColor.gfRed))
    case .poweredOff:
      NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Bluetooth state is powered off.", color: UIColor.gfRed))
    case .poweredOn:
      NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Looking for Griffy...", color: UIColor.gfYellow))
      
      centralManager.scanForPeripherals(withServices: nil, options: nil)
      //      let periphs = centralManager.retrievePeripherals(withIdentifiers: [UUID(uuidString: PeripheralIds.griffy) ?? UUID()])
      //      if periphs.count != 1 {
      ////        assertionFailure("Should find at least one peripheral")
      //        print("Should find at least one peripheral")
      //      } else {
      //        griffyPeripheral = periphs.first
      //        centralManager.connect(griffyPeripheral!, options: nil)
      //        griffyPeripheral?.delegate = self
      //      }
    }
  }
  
  func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
    if peripheral.name == "Griffy" {
      NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Did discover peripheral!", color: UIColor.gfYellow))
      griffyPeripheral = peripheral
      centralManager.connect(griffyPeripheral!, options: nil)
      griffyPeripheral?.delegate = self
    }
  }
  
  func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
    setupModels(forPeripheral: peripheral)
    NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Connected to Griffy!", color: UIColor.gfGreen))
    peripheral.discoverServices(BLEConstants.gfBleObjects.filter({ $0.type == BLEConstants.GFBLEObjectType.service}).map({ $0.uuid.cbuuid }))
    peripheral.delegate = self
  }
  
  func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
    NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Disconnected from Griffy 🤦‍♀️. Tap to scan again. Error: \(error?.localizedDescription ?? "~ no error description ~")", color: UIColor.gfRed))
    if peripheral == griffyPeripheral {
      griffyPeripheral = nil
    }
  }
  
  func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
    NotificationCenter.default.post(name: .bluetoothStateChanged, object: GFBluetoothState(message: "Failed to connect to Griffy. Tap to retry. \(error?.localizedDescription ?? "~ no error description ~")", color: UIColor.gfRed))
  }
}

extension BluetoothManager: CBPeripheralDelegate {
  func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
    guard let services = peripheral.services else { return }
    for service in services {
      peripheral.discoverCharacteristics(nil, for: service)
      peripheral.discoverCharacteristics([BLEConstants.CharacteristicIds.imageLoadId.cbuuid], for: service)
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
    guard let characteristics = service.characteristics else {
      return
    }
    
    for characteristic in characteristics {
      print("Discovered: \(characteristic.gfBleObject?.displayName ?? "nil-zip-nada")")
      //      printCharacteristicValue(characteristic)
      let _ = GFCharacteristic.parse(GFCharacteristic.self, characteristic: characteristic)
      cbCharacteristicsById[characteristic.uuid.uuidString] = characteristic
      
      if characteristic.uuid.uuidString == BLEConstants.CharacteristicIds.imageLoadId {
        print("we out here")
      }
    }
  }
  
  func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {    
    if let e = error {
      let error = "\(e.localizedDescription) - \(characteristic.griffyName())"
      print("\n\n⛔️ ERROR writing value:\n\(error)\n\n")
      NotificationCenter.default.post(name: .setBluetoothBanner, object: GFBluetoothState(message: error, color: UIColor.gfRed))
    } else {
      print("Wrote a value for \(characteristic.griffyCharacteristic?.name ?? "NO NAME")")
      if characteristic.griffyCharacteristic?.isReadable ?? false {
        griffyPeripheral?.readValue(for: characteristic)
      }
    }
    
    var length = 0
    if characteristic.uuid.uuidString == BLEConstants.CharacteristicIds.imageLoadId {
      length = sendingImageData.first ?? 0
      if sendingImageData.count > 0 {
        sendingImageData.removeFirst()
      }
    }
    
    NotificationCenter.default.post(name: .didWriteToCharacteristic, object: CharacterWriteResponse(characteristic: characteristic, error: error?.localizedDescription, dataLength: length))
    
    checkSendPendingWriteRequests()
  }
  
  func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    let _ = GFCharacteristic.parse(GFCharacteristic.self, characteristic: characteristic)
    cbCharacteristicsById[characteristic.uuid.uuidString] = characteristic
    NotificationCenter.default.post(name: .didUpdateCharacteristic, object: characteristic)
    
    //    NotificationCenter.default.post(name: .setBluetoothBanner, object: GFBluetoothState(message: "Updated Values", color: UIColor.gfGreen))
    delay(0.5) {
      NotificationCenter.default.post(name: .setBluetoothBanner, object: GFBluetoothState(message: "Connected to Griffy!", color: UIColor.gfGreen))
    }
    print("we here \(characteristic.griffyName())")
    
    if let statusClosure = statusUpdatedClosure {
      statusClosure()
    }
    //    if characteristic.uuid.uuidString == BLEConstants.CharacteristicIds.instantCurrentId || characteristic.uuid.uuidString == BLEConstants.CharacteristicIds.averageCurrentId {
    //      print("we here \(characteristic.uuid.uuidString)")
    //    }
  }
  
  private func printCharacteristicValue(_ characteristic: CBCharacteristic) {
    //    guard let characteristicData = characteristic.value else {return}
    //    SerialNumber(
    //    print(characteristicNameById[characteristic.uuid.uuidString]!, characteristicData.count)
    //    let vals = characteristic.griffyDisplayValue()
    //    print(vals!)
    //    print("\(characteristicNameById[characteristic.uuid.uuidString]!) = \(vals ?? nil)")
  }
}
