import CoreMIDI

public struct Source: Object, Enumerable {
	public let ref: MIDIEndpointRef
	
	public static var count: Int {
		return MIDIGetNumberOfSources()
	}
	
	public init(index: Int) {
		ref = MIDIGetSource(index)
	}
	
	public init(ref: MIDIEndpointRef) {
		self.ref = ref
	}
	
	public var entity: Entity? {
		var result: MIDIEntityRef = 0
		if Error(MIDIEndpointGetEntity(ref, &result)) == nil {
			return Entity(ref: result)
		}
		return nil
	}
	
	

}
