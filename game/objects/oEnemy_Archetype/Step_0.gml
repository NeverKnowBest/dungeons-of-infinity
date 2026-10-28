EnemyArch_StepBegin();

event_inherited();

if(Arch.Recover != undefined && (KnockBackDone || StunDone)){
	Enemy_UpdateState(Arch.Recover);
}

PauseCheck

EnemyArch_Step();
