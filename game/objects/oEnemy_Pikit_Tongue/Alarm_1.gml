with(ItemInst){
	other.ParentInst.SwallowedItem_Class = Class;
	other.ParentInst.SwallowedItem_Index = Index;
	other.ParentInst.SwallowedItem_Amount = Amount;
}
instance_destroy(ItemInst);
instance_destroy(id);