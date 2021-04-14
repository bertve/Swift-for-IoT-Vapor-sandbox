import SwiftyGPIO
import Foundation

final class GPIOService {
    class var sharedInstance: GPIOService {
        struct Singleton {
            static let instance = GPIOService()
        }
        return Singleton.instance
    }
    private let gpios: [GPIOName: GPIO] = SwiftyGPIO.GPIOs(for: .RaspberryPi4)
    private var LED: GPIO?
    private var digitDisplay : DigitDisplay?

    func setup(){

        // setup LED
        LED = gpios[.P21]
        if let led = LED {
            led .direction = .OUT
        }

        // setup btn
        guard let btn = gpios[.P20] else {
            fatalError("Could not init target gpio")
        }
        btn.direction = .IN
        let debounceTime = 0.5
        btn.bounceTime = debounceTime

        // setup display
        var digitDisplayGPIO = [GPIO]()
        guard let gpioOne = gpios[.P14] else {
            fatalError("Could not init target 14 gpio")
        }
        digitDisplayGPIO.append(gpioOne)
        guard let gpioTwo = gpios[.P2] else {
            fatalError("Could not init target 2 gpio")
        }
        digitDisplayGPIO.append(gpioTwo)
        guard let gpioThree = gpios[.P3] else {
            fatalError("Could not init target 3 gpio")
        }
        digitDisplayGPIO.append(gpioThree)
        guard let gpioFour = gpios[.P4] else {
            fatalError("Could not init target 4 gpio")
        }
        digitDisplayGPIO.append(gpioFour)
        guard let gpioFive = gpios[.P5] else {
            fatalError("Could not init target 5 gpio")
        }
        digitDisplayGPIO.append(gpioFive)
        guard let gpioSix = gpios[.P6] else {
            fatalError("Could not init target 6 gpio")
        }
        digitDisplayGPIO.append(gpioSix)
        guard let gpioSeven = gpios[.P7] else {
            fatalError("Could not init target 7 gpio")
        }
        digitDisplayGPIO.append(gpioSeven)
        guard let gpioEight = gpios[.P8] else {
            fatalError("Could not init target 8 gpio")
        }
        digitDisplayGPIO.append(gpioEight)
        guard let gpioNine = gpios[.P9] else {
            fatalError("Could not init target 9 gpio")
        }
        digitDisplayGPIO.append(gpioNine)
        guard let gpioTen = gpios[.P15] else {
            fatalError("Could not init target 15 gpio")
        }
        digitDisplayGPIO.append(gpioTen)
        guard let gpioEleven = gpios[.P18] else {
            fatalError("Could not init target 18 gpio")
        }
        digitDisplayGPIO.append(gpioEleven)
        guard let gpioTwelve = gpios[.P12] else {
            fatalError("Could not init target 12 gpio")
        }
        digitDisplayGPIO.append(gpioTwelve)

        digitDisplay = DigitDisplay(gpios: digitDisplayGPIO )

        if let display = digitDisplay {
            btn.onRaising{
                gpio in
                display.increment()
            }

            Thread.detachNewThread {
                while true {
                    display.display()
                }
            }
        }

    }

    func toggleLight(_ state: LightState){
        if let led = LED {
            switch state {
                case .onn:
                led.value = 1
                case .off:
                led.value = 0
            }
        }
    }

    func incrementDisplay(){
        if let display = digitDisplay {
            display.increment()
        } 
    }

    func decrementDisplay(){
        if let display = digitDisplay {
            display.decrement()
        } 
    }

    func display(_ number: Int){
        if let display = digitDisplay {
            display.displayNumber(number)
        } 
    }

}