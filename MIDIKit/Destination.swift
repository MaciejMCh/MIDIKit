import CoreMIDI

public struct Destination: Object, Enumerable {
	public let ref: MIDIEndpointRef

	public init(index: Int) {
		ref = MIDIGetDestination(index)
	}
	
	public var entity: Entity? {
		var result: MIDIEntityRef = 0
		if Error(MIDIEndpointGetEntity(ref, &result)) == nil {
			return Entity(ref: result)
		}
		return nil
	}
	
	public static var count: Int {
		return MIDIGetNumberOfDestinations()
	}
	
	public init(ref: MIDIEndpointRef) {
		self.ref = ref
	}
	
	public func unschedulePreviouslySentPackets() {
		MIDIFlushOutput(ref)
	}
}