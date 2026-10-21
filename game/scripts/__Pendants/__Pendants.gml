enum Pendant{Health, Magic, Protection, Revival, Direction, Secrets, Immunity, Wealth}
global.PendantNames = [ "Health",    //red
						"Magic",     //green
						"Protection",//blue
						"Revival",   //white
						"Direction", //Purple
						"Secrets",   //cyan
						"Immunity",  //pink
						"Wealth"]	 //gold
#macro PendantCount 8

#macro WEALTHMULTIPLIER 1.2

function Pendant_Check(_Index){
	
	if(Curse_Check(CurseEffects.PendantsNoWork)) return false;
	
	return global.Inventory.ItemData[ItemClass.Pendant].Owns[_Index];
	
}