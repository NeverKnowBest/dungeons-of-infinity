enum Prisoner {
	Letter,	
	Justin,
	Witch,
	Games,
	Lawyer,	
	Hungry,
	Warranty,
	Thief,
	Dead,
	Asleep
}
#macro PrisonerIDs 10

enum PrisonerState {
	Sitting,
	Walking,
	Talking
	
}

global.Dialogue_Prisoner[Prisoner.Dead][0] = "...\\\\\\Looks like she's dead...";

global.Dialogue_Prisoner[Prisoner.Asleep][0] = "I used to live under a bridge.";
global.Dialogue_Prisoner[Prisoner.Asleep][1] = "Hey, I remember you, didn't I give\\you a bottle once?";
global.Dialogue_Prisoner[Prisoner.Asleep][2] = "Ya, that was my old pee bottle,\\I hope you were able to make use\\of it.";
	
global.Dialogue_Prisoner[Prisoner.Lawyer][0] = "Are you my lawyer? They said\\they would send for him. I don't\\think they will."
global.Dialogue_Prisoner[Prisoner.Lawyer][1] = "I've been wrongfully accused.\\The justice system is corrupt\\in Hyrule."
	
global.Dialogue_Prisoner[Prisoner.Hungry][0] = "They don't feed us enough here."
global.Dialogue_Prisoner[Prisoner.Hungry][1] = "I'm craving burgers and fries."
global.Dialogue_Prisoner[Prisoner.Hungry][2] = "I could use a glass of Lon-Lon\\milk."

global.Dialogue_Prisoner[Prisoner.Witch][0] = "They locked me up because they\\think I'm a witch. How absurd!"
global.Dialogue_Prisoner[Prisoner.Witch][1] = "Just because I have a black cat\\and I eat toad stew doesn't mean\\I'm a witch."
global.Dialogue_Prisoner[Prisoner.Witch][2] = "Ok, I also own a magical bRoom, so\\I can see why they might think\\that."
global.Dialogue_Prisoner[Prisoner.Witch][3] = "...\\\\\\Ok I'm a witch."

global.Dialogue_Prisoner[Prisoner.Warranty][0] = "Hi, I've been trying to reach you\\about you car's extended\\warranty."

global.Dialogue_Prisoner[Prisoner.Thief][0] = "What are you looking at?!"
global.Dialogue_Prisoner[Prisoner.Thief][1] = "Beat it kid!"
global.Dialogue_Prisoner[Prisoner.Thief][2] = "If these bars weren't here, I would\\sooo bump into you, causing your\\possessions to fly all over.\\Then I would take them."

	
global.Dialogue_Prisoner[Prisoner.Games][0] = "I am Error."
global.Dialogue_Prisoner[Prisoner.Games][1] = "Don't look into the death star,\\or you will die!"
global.Dialogue_Prisoner[Prisoner.Games][2] = "All your base are belong to us!"
global.Dialogue_Prisoner[Prisoner.Games][3] = "You have dysentery."

global.Dialogue_Prisoner[Prisoner.Justin][0] = "Hi, I'm Justin, the game's creator.\\Nintendo put me in jail because\\they don't like people making\\games using their assets."
global.Dialogue_Prisoner[Prisoner.Justin][1] = "I hid many secrets in the rebel\\village. I hope you will find them\\all."
global.Dialogue_Prisoner[Prisoner.Justin][2] = "Here's some of the profits I\\secretly earned from this game.\\Don't tell Nintendo."

global.Dialogue_Prisoner_LetterIntro = "Hello young lad, my name is Pezo,\\could I ask you for a favor?"
global.Dialogue_Prisoner_LetterNo = "Ok, thanks anyways, goodbye\\my friend."
global.Dialogue_Prisoner_LetterYes1 = "Great! I have a friend who lives in\\the rebel village, she is ill and\\I can only assume she is on her\\last breath. Could you deliver a\\letter to her?"
global.Dialogue_Prisoner_LetterYes2 = "Thank you! Here is the letter. You\\will find the rebel village through\\the catacombs and below the\\sewers. Stay safe and farewell!"
global.Dialogue_Prisoner_GaveLetter = "Please deliver my letter to my\\friend. You will find her in the\\rebel village. Thank you."

function ResetUnusedPrisonerList(){
	
	//add 0 to PrisonerIDs - 1, then shuffle. When picking a prisoner, use the first index from this list then delete it so it doesn't get used twice.
	//Add the letter prisoner in slot 0 only after the rest have been added and shuffled. This way, the letter prisoner should always appear
	ds_list_clear(global.UnusedPrisoners);
	for(var i = 1; i < PrisonerIDs; i++){
		ds_list_add(global.UnusedPrisoners, i);
	}
	ds_list_shuffle(global.UnusedPrisoners);
	ds_list_insert(global.UnusedPrisoners, 0, Prisoner.Letter);
	
}

function Prisoner_GetMainStateForIndex(){
	return (Index > 2 ? PrisonerState.Sitting : PrisonerState.Walking)	;
}