package org.csu.slicing.constraints;

import java.util.HashMap;
import java.util.Map;

public class SteamBoilerSystemCons {
	
	private static Map<String, String> consMap;
	
	public static Map<String, String> getConsMap() {
		
		if (consMap != null) 
			return consMap;
		
		consMap = new HashMap<String, String>();
		
		// From query operations
		consMap.put("Snapshot::getNext", "context Snapshot::getNext() : Snapshot\n" +
				"body : self.AfterTrans.AfterTrans\n");
		consMap.put("Snapshot::futureClosure", "context Snapshot::futureClosure(s : Set(Snapshot)) : Set(Snapshot)\n" + 
				"body: if s->includesAll(s.getNext()->asSet()) then s else futureClosure(s->union(s.getNext()->asSet()))endif\n");		
		consMap.put("Snapshot::getPost", "context Snapshot::getPost(): Set(Snapshot)\n" + 
				"body: futureClosure(Set{self.getNext()})\n");
		consMap.put("Snapshot::getPrevious", "context Snapshot::getPrevious(): Snapshot\n" + 
				"body: self.BeforeTrans.BeforeTrans\n");
		consMap.put("Snapshot::previousClosure", "context Snapshot::previousClosure(s : Set(Snapshot)) : Set(Snapshot)\n" + 
				"body: if s->includesAll(s.getPrevious()->asSet()) then s else previousClosure(s->union(s.getPrevious()->asSet()))endif\n");
		consMap.put("Snapshot::getPre", "context Snapshot::getPre(): Set(Snapshot)\n" +  
				"body: previousClosure(Set{self.getPrevious()})\n");
				
		// From temporal properties
		consMap.put("TP1", "context ControlProgram inv TP1: \n" + 
				"let CS:Snapshot = self.SnapshotControlProgram in let NS: Snapshot= CS.getNext() \n" + 
				"in self.wlmdFailure implies NS.ControlProgramSnapshot.mode = Mode::Rescue\n");
		consMap.put("TP2", "context ControlProgram inv TP2: \n" + 
				"let CS:Snapshot = self.SnapshotControlProgram in let NS: Snapshot= CS.getNext() \n" + 
				"in (self.smdFailure or self.pumpFailure or self.pumpControlerFailure) implies NS.ControlProgramSnapshot.mode= Mode::Degraded\n");
		consMap.put("TP3", "context SteamBoiler inv TP3: \n" + 
				"let CS:Snapshot = self.SnapshotSteamBoiler in let NS: Snapshot= CS.getNext() \n" + 
				" in (self.SteamBoilerWLMD.waterLevel > self.maximalNormal or self.SteamBoilerWLMD.waterLevel < self.minimalNormal) \n" +
				"implies NS.ControlProgramSnapshot.mode= Mode::EmergencyStop\n");
		consMap.put("TP4", "context SteamBoiler inv TP4: \n" + 
				"let CS:Snapshot = self.SnapshotSteamBoiler in let FS: Set(Snapshot)= CS.getPost() \n" + 
				"in self.valveOpen = ValveState::Open implies FS->exists(s:Snapshot | s.WLMDSnapshot.waterLevel <= maximalNormal)\n");
		consMap.put("TP5", "context ControlProgram inv  TP5: \n" + 
				"let CS:Snapshot = self.SnapshotControlProgram in let NS: Snapshot= CS.getNext() \n" + 
				"in (self.mode=Mode::Initialization and self.wlmdFailure) implies NS.ControlProgramSnapshot.mode=Mode::EmergencyStop\n");
		
		// From invariants
		consMap.put("WMD", "context WaterLevelMeasurementDevice inv WMD: \n" + 
				"self.waterLevel < self.WLMDSteamBoiler.capacity\n");
		consMap.put("SB", "context SteamBoiler inv SB: \n" + 
				"self.valveOpen=ValveState::Open implies self.SteamBoilerControlProgram.mode=Mode::Initialization\n");
		consMap.put("OpenPump", "context PumpController_OpenPump inv OpenPump : \n" + 
				"PCPre.PumpControlerPump.mode = State::Off implies PCPost.PumpControlerPump.mode = State::On\n");
		consMap.put("ClosePump", "context PumpController_ClosePump inv ClosePump : \n" +
				"PCPre.PumpControlerPump.mode = State::On implies PCPost.PumpControlerPump.mode = State::Off\n");
		consMap.put("Start", "context ControlProgram_Start inv Start: \n" + 
				"CPPost.mode = Mode::Normal\n");
		consMap.put("getLevel", "context WaterLevelMeaurementDevice_getLevel inv getLevel: \n" + 
				"wlmdPost.waterLevel = ret\n");
		consMap.put("OpenValve", "context SteamBoiler_OpenValve inv OpenValve: \n" + 
				"SBPre.valveOpen = ValveState::Closed implies SBPost.valveOpen = ValveState::Open \n");

		return consMap;
	}
	
	public static void main(String[] args) {
		for (String consName : SteamBoilerSystemCons.getConsMap().keySet()) {
			System.out.println(consName);
		}
	}

}
