State = IntroState.Intro;
MsgBox(Dialogue[DialogueIndex]);
DialogueActive = true;
DialogueIndex++;
global.DB_Inst.CenterText = true;
global.DB_Inst.ShowBox = false;
