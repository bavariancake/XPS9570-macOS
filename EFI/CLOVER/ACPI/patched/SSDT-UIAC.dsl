// SSDT-UIAC.dsl
//
// This SSDT contains customizations for USBInjectAll.kext for Dell XPS 15 9570.
//
// Note:
// UsbConnector is the 'Type' value in table 9-291, ACPI spec 6.2 A:
// | Type | Description                                                        |
// |------+--------------------------------------------------------------------|
// | 0x00 | Type 'A' connector                                                 |
// | 0x01 | Mini-AB connector                                                  |
// | 0x02 | ExpressCard                                                        |
// | 0x03 | USB 3 Standard-A connector                                         |
// | 0x04 | USB 3 Standard-B connector                                         |
// | 0x05 | USB 3 Micro-B connector                                            |
// | 0x06 | USB 3 Micro-AB connector                                           |
// | 0x07 | USB 3 Power-B connector                                            |
// | 0x08 | Type C connector - USB2-only                                       |
// | 0x09 | Type C connector - USB2 and SS with Switch                         |
// | 0x0A | Type C connector - USB2 and SS without Switch                      |
// | 0xFF | Proprietary connector                                              |
//
// port-count is not a count; it is the maximum port address specific by port.
//
// Credit bavariancake: https://github.com/bavariancake/XPS9570-macOS

DefinitionBlock ("", "SSDT", 2, "hack", "_UIAC", 0)
{
    Device(UIAC)
    {
        Name(_HID, "UIA00000")

        Name(RMCF, Package()
        {
            "8086_a36d", Package()
            {
                "port-count", Buffer() { 18, 0, 0, 0 },
                "ports", Package()
                {
                    "HS01", Package() // right side type A
                    {
                        "UsbConnector", 0x03,
                        "port", Buffer() { 1, 0, 0, 0 },
                    },
                    "HS02", Package() // left side type A
                    {
                        "UsbConnector", 0x03,
                        "port", Buffer() { 2, 0, 0, 0 },
                    },
                    "HS03", Package() // internal Bluetooth
                    {
                        "UsbConnector", 0xFF,
                        "port", Buffer() { 4, 0, 0, 0 },
                    },
                    "HS04", Package() // type C
                    {
                        "UsbConnector", 0x09,
                        "port", Buffer() { 5, 0, 0, 0 },
                    },
                    "HS05", Package() // Goodix fingerprint reader
                    {
                        "UsbConnector", 0xFF,
                        "port", Buffer() { 7, 0, 0, 0 },
                    },
                    "HS06", Package() // webcam
                    {
                        "UsbConnector", 0xFF,
                        "port", Buffer() { 12, 0, 0, 0 },
                    },
                    "SS01", Package() // right side type A
                    {
                        "UsbConnector", 0x03,
                        "port", Buffer() { 17, 0, 0, 0 },
                    },
                    "SS02", Package() // left side type A
                    {
                        "UsbConnector", 0x03,
                        "port", Buffer() { 18, 0, 0, 0 },
                    },
                },
            },
        })
    }
}
//EOF
