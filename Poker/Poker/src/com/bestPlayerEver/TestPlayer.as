package com.bestPlayerEver 
{
	import com.bestPlayerEver.TestPlayer;
	import com.novabox.playingCards.Deck;
	import com.novabox.playingCards.Height;
	import com.novabox.playingCards.PlayingCard;
	import com.novabox.playingCards.Suit;
	import com.novabox.poker.evaluator.HandEvaluator;
	import com.novabox.poker.HumanPlayer;
	import com.novabox.poker.PokerPlayer;
	import com.novabox.poker.PokerTable;
	import com.novabox.poker.states.Preflop;
		import com.novabox.poker.PokerAction;
        /**
         * ...
         * @author
         */
        public class TestPlayer extends PokerPlayer
        {
			protected var expertSystem;
			// conclusions
			protected var littleRaise:String = "Petite relance";
			protected var bigRaise:String = "Grosse relance";
			protected var fold:String = "Se coucher";
			protected var check:String = "Check";
			protected var call:String = "Suivre";
			protected var AllIn:String = "Tapis";
			// faits
			protected var CarteJoueurFaible:String = "CarteJoueurFaible";
			protected var CarteJoueurMoyenBas:String = "CarteJoueurMoyenBas";
			protected var CarteJoueurMoyenHaut:String = "CarteJoueurMoyenHaut";
			protected var CarteJoueurElevee:String = "CarteJoueurElevee";
			
			protected var PositionPetiteBlinde:String = "PositionPetiteBlinde";
			protected var PositionGrosseBlinde:String = "PositionGrosseBlinde";
			protected var PositionDealer:String = "PositionDealer";
			protected var PositionUnderTheGun:String = "PositionUnderTheGun";
			protected var PositionAutre:String = "PositionAutre";
			
			protected var PortefeuilleFaible:String = "PortefeuilleFaible";
			protected var PortefeuilleConfortable:String = "PortefeuilleConfortable";
			protected var PortefeuilleFort:String = "PortefeuilleFort";
			
			protected var RelanceNulle:String = "RelanceNulle";
			protected var RelanceFaible:String = "RelanceFaible";
			protected var RelanceForte:String = "RelanceForte";
			
			protected var SuivreGrosseBlinde:String = "SuivreGrosseBlinde";
			
				public function TestPlayer(_name:String, _stackValue:Number)
                {
                        super(_name, _stackValue);
						expertSystem = new ExpertSystem();
						// règles
						
						expertSystem.AddRule([SuivreGrosseBlinde], call);
						
						expertSystem.AddRule([CarteJoueurFaible, RelanceNulle], check);
						expertSystem.AddRule([CarteJoueurFaible, RelanceFaible], fold);
						expertSystem.AddRule([CarteJoueurFaible, RelanceForte], fold);
						
						expertSystem.AddRule([CarteJoueurMoyenBas, RelanceNulle], check);
						expertSystem.AddRule([CarteJoueurMoyenBas, RelanceFaible], fold);
						expertSystem.AddRule([CarteJoueurMoyenBas, RelanceForte], fold);
						
						expertSystem.AddRule([CarteJoueurMoyenHaut, RelanceNulle], check);
						expertSystem.AddRule([CarteJoueurMoyenHaut, RelanceNulle, PositionUnderTheGun, PortefeuilleConfortable], littleRaise);
						expertSystem.AddRule([CarteJoueurMoyenHaut, RelanceNulle, PositionUnderTheGun, PortefeuilleFort], bigRaise);
						expertSystem.AddRule([CarteJoueurMoyenHaut, RelanceFaible, PortefeuilleConfortable], call);
						expertSystem.AddRule([CarteJoueurMoyenHaut, RelanceFaible, PortefeuilleFort], littleRaise);
						expertSystem.AddRule([CarteJoueurMoyenHaut, RelanceForte, PortefeuilleConfortable], call);
						expertSystem.AddRule([CarteJoueurMoyenHaut, RelanceForte, PortefeuilleFort], littleRaise);
						expertSystem.AddRule([CarteJoueurMoyenHaut, RelanceForte, PortefeuilleFort, PositionUnderTheGun ], bigRaise);
						
						expertSystem.AddRule([CarteJoueurElevee, RelanceNulle], littleRaise);
						expertSystem.AddRule([CarteJoueurElevee, RelanceNulle, PositionUnderTheGun, PortefeuilleConfortable], bigRaise);
						expertSystem.AddRule([CarteJoueurElevee, RelanceNulle, PositionUnderTheGun, PortefeuilleFort], bigRaise);
						expertSystem.AddRule([CarteJoueurElevee, RelanceFaible,PortefeuilleFaible], call);
						expertSystem.AddRule([CarteJoueurElevee, RelanceFaible, PortefeuilleConfortable], call);
						expertSystem.AddRule([CarteJoueurElevee, RelanceFaible, PortefeuilleFort], littleRaise);
						expertSystem.AddRule([CarteJoueurElevee, RelanceForte], call);
						expertSystem.AddRule([CarteJoueurElevee, RelanceForte, PortefeuilleConfortable], littleRaise);
						expertSystem.AddRule([CarteJoueurElevee, RelanceForte, PortefeuilleFort], bigRaise);
                }
               
                override public function Play(_pokertable:PokerTable) : Boolean {
 
                        Perceive(_pokertable);
                        var actionLabel:String = Analyze();
                        Act(actionLabel, _pokertable);
                       
                        return (lastAction != PokerAction.NONE);
                }
               
               
                public function Act(actionLabel:String, pokerTable:PokerTable) : void {
                        if (actionLabel == "Suivre") {
                                Call(pokerTable.GetValueToCall());
                        } else if (actionLabel == "ALL IN") {
								Raise(GetStackValue(), pokerTable.GetValueToCall());
						}
                        /* else if (...) {
                        } */
                }
               
                public function Analyze() : String {
                       
                        var conclusionLabels:Array = expertSystem.InferForward();
                       
                        //conclusionLabels = expertSystem.InferForward()
                       
                        var actions:Array = new Array();
                        //actions = /*conclusionLabels sans les faits intermédiaires*/
						actions[0] = "ALL IN";
                       
                       
                        if (actions.length > 1) {
                                //Problème de logique parallèle
                               
                                /* Choisir une action */
                               
                        } else if (actions.length > 0) {
                                //Une seule action
                                return actions[0]
                        } else {
                                //Pas d'action trouvée
                                //return null;
								return "Suivre";
                        }
						return "Suivre";
                       
                }
               
                public function Perceive(_pokertable:PokerTable) : void {
                                               
                        expertSystem.ResetFactValues();
                       
                        if (_pokertable.GetValueToCall() > 0) {
                                //Relancé
                                expertSystem.SetFactValue("Relancé", true);
                        } else {
                                expertSystem.SetFactValue("Pas relancé", true);
                        }
                                               
                        if (GetCard(0).GetHeight() == GetCard(1).GetHeight()) {
                                //Pocket Pair
                               
                                if (GetCard(0).GetHeight() >= Height.TEN) {
                                        //Au moins une paire de 10
                                       
                                }
                        }
                       
                       
                }
               
                override public function ProcessPlayerAction(_player:PokerPlayer) : void
                {
                        trace("IL a joué");
                }
 
               
        }
}
