import Carbon

let command = ProcessInfo.processInfo.arguments.dropFirst().last ?? ""
let filter = command == "list" ? nil : [kTISPropertyInputSourceID: command]

guard let cfSources = TISCreateInputSourceList(filter as CFDictionary?, false),
    let sources = cfSources.takeRetainedValue() as? [TISInputSource]
else {
    print("Usage: switch-input-source <list|input-source>")
    exit(-1)
}

if filter == nil {
    sources.forEach {
        let cfID = TISGetInputSourceProperty($0, kTISPropertyInputSourceID)!
        print(Unmanaged<CFString>.fromOpaque(cfID).takeUnretainedValue() as String)
    }
} else if let firstSource = sources.first {
    exit(TISSelectInputSource(firstSource))
}
