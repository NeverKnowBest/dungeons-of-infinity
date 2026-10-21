enum Prisoner {
	Letter,	
	Justin,
	Witch,
	Games,
	Lawyer,	
	Hungry,
	Warranty,
	Thief,
	Woman,
	FortuneTeller,
	Asleep,
	WetBandits,
	Dead1,
	Dead2,
	Dead3
}
#macro PrisonerIDs 15

enum PrisonerState {
	Sitting,
	Walking,
	Talking	
}


global.Dialogue_Prisoner[Prisoner.Dead1][0] = "...\\\\\\Looks like she's dead...";
global.Dialogue_Prisoner[Prisoner.Dead2][0] = "...\\\\\\Looks like she's dead...";
global.Dialogue_Prisoner[Prisoner.Dead3][0] = "...\\\\\\Looks like he's dead...";

global.Dialogue_Prisoner[Prisoner.Woman][0] = "I have 13 sons at home, I hope they are ok."
global.Dialogue_Prisoner[Prisoner.Woman][1] = "Their names are Marky, Ricky, Danny, Terry, Mikey, Davey, Timmy, Tommy, Joey, Robby, Johnny, Brian, and Will.";

var i = 0
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "The older you get, the better you were.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "Some days you are the pigeon, some days you are the statue. Today, bring an umbrella.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "A wise person never tries to get even. A wise person gets odder.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "Catch on fire with enthusiasm and people will come from miles to watch you burn.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "To truly find yourself you should play hide and seek alone.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "Two days from now, tomorrow will be yesterday.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "You will soon have an out-of-money experience.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "When working towards the solution of a problem, it always helps if you know the answer.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "Your inferiority complex is not good enough. Try harder.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "You are cleverly disguised as a responsible adult.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "You don’t have to be faster than the bear, you just have to be faster than the slowest guy running from it.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "I see money in your future...it is not yours though.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "Hard work pays off in the future. Laziness pays off now.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "If at first you don’t succeed, skydiving is not for you.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "If you think nobody cares you are alive, try missing a couple of car payments.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "The early bird gets the worm but the second mouse gets the cheese.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "He who laughs at himself never runs out of things to laugh at.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "The easiest way to find a lost object is to buy a replacement.";
global.Dialogue_Prisoner[Prisoner.FortuneTeller][i++] = "The wise man is the one that makes you think he is dumb.";

global.Dialogue_Prisoner[Prisoner.Asleep][0] = "I used to live under a bridge.";
global.Dialogue_Prisoner[Prisoner.Asleep][1] = "Hey, I remember you, didn't I give you a bottle once?";
global.Dialogue_Prisoner[Prisoner.Asleep][2] = "Ya, that was my old pee bottle, I hope you were able to make use of it.";
	
global.Dialogue_Prisoner[Prisoner.Lawyer][0] = "Are you my lawyer? They said they would send for him. I don't think they will."
global.Dialogue_Prisoner[Prisoner.Lawyer][1] = "I've been wrongfully accused. The justice system is corrupt in Hyrule."
	
global.Dialogue_Prisoner[Prisoner.Hungry][0] = "They don't feed us enough here."
global.Dialogue_Prisoner[Prisoner.Hungry][1] = "I'm craving burgers and fries."
global.Dialogue_Prisoner[Prisoner.Hungry][2] = "I could use a glass of Lon-Lon milk."

global.Dialogue_Prisoner[Prisoner.Witch][0] = "They locked me up because they think I'm a witch. How absurd!"
global.Dialogue_Prisoner[Prisoner.Witch][1] = "Just because I have a black cat and I eat toad stew doesn't mean I'm a witch."
global.Dialogue_Prisoner[Prisoner.Witch][2] = "Ok, I also own a magical broom, so I can see why they might think that."
global.Dialogue_Prisoner[Prisoner.Witch][3] = "Ok fine, I'm a witch."

global.Dialogue_Prisoner[Prisoner.Warranty][0] = "Hi, I've been trying to reach you about your car's extended warranty."

global.Dialogue_Prisoner[Prisoner.Thief][0] = "What are you looking at?!"
global.Dialogue_Prisoner[Prisoner.Thief][1] = "Beat it kid!"
global.Dialogue_Prisoner[Prisoner.Thief][2] = "If these bars weren't here, I would sooo bump into you, causing your possessions to fly all over. Then I would take them."

i = 0;
global.Dialogue_Prisoner[Prisoner.Games][i++] = "I am Error."
global.Dialogue_Prisoner[Prisoner.Games][i++] = "Don't look into the death star, or you will die!"
global.Dialogue_Prisoner[Prisoner.Games][i++] = "All your base are belong to us!"
global.Dialogue_Prisoner[Prisoner.Games][i++] = "You have dysentery."
global.Dialogue_Prisoner[Prisoner.Games][i++] = "Our princess is in another castle."
global.Dialogue_Prisoner[Prisoner.Games][i++] = "What is a man? A miserable little pile of secrets."


global.Dialogue_Prisoner[Prisoner.Justin][0] = "Hi, I'm Justin, the game's creator. Nintendo put me in jail because they don't like people making games using their assets."
global.Dialogue_Prisoner[Prisoner.Justin][1] = "I hid many secrets in the rebel village. I hope you will find them all."
global.Dialogue_Prisoner[Prisoner.Justin][2] = "It’s dangerous to go alone, take this!"

global.Dialogue_Prisoner[Prisoner.WetBandits][0] = "Marv, you did it again didn't you?\\You left the water running.\\What's wrong with you, I told you\\not to do it!\\\\\\(Marv) Harry, it's our calling card!\\All the great ones leave their\\mark. We're the wet bandits!\\(Harry) You're sick, Marv."
global.Dialogue_Prisoner[Prisoner.WetBandits][1] = "What are you starring at, kid? I'll snap off your cajones and boil them in motor oil!"
global.Dialogue_Prisoner[Prisoner.WetBandits][2] = "Yeah kid, I'm gonna smash your face with an iron, and shove a nail through your foot!"

global.Dialogue_Prisoner_LetterIntro = "Hello young lad, my name is Pezo, could I ask you for a favor?"
global.Dialogue_Prisoner_LetterNo = "Ok, thanks anyways, goodbye my friend."
global.Dialogue_Prisoner_LetterYes1 = "Great! I have a friend who lives in the rebel village, she is ill and I can only assume she is on her last breath. Could you deliver a letter to her?"
global.Dialogue_Prisoner_LetterYes2 = "Thank you! Here is the letter. You will find the rebel village through the catacombs and below the sewers. Stay safe and farewell!"
global.Dialogue_Prisoner_GaveLetter = "Please deliver my letter to my friend. You will find her in the rebel village. Thank you."
global.Dialogue_Prisoner_GotFortune = "Only 1 fortune allowed, good luck to you."

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