package com.bestPlayerEver 
{
	import com.novabox.poker.PokerTools;
	import flash.system.System;
	import com.novabox.playingCards.Deck;
	import com.novabox.playingCards.Height;
	import com.novabox.playingCards.PlayingCard;
	import com.novabox.playingCards.Suit;
	import com.novabox.poker.evaluator.HandEvaluator;
	import com.novabox.poker.HumanPlayer;
	import com.novabox.poker.PokerPlayer;
	import com.novabox.poker.PokerTable;
	import com.novabox.poker.HandValue;
	import com.novabox.poker.states.Preflop;
		import com.novabox.poker.PokerAction;
        /**
         * ...
		 * I'm sorry, Dave. I'm afraid I can't let you win this hand.
         * @author
         */
        public class Hal extends PokerPlayer
        {
			protected var handEvaluator:HandEvaluator;
			protected var expertSystem:ExpertSystem;
			protected var valeurDePortefeuilleDeDepart:int;
			// conclusions
			protected static const LITTLERAISE:String = "Petite relance";
			protected static const BIGRAISE:String = "Grosse relance";
			protected static const FOLD:String = "Se coucher";
			protected static const CHECK:String = "Check";
			protected static const CALL:String = "Suivre";
			protected static const ALLIN:String = "Tapis";
			// faits
			protected var CARTEJOUEURFAIBLE:String = "CarteJoueurFaible";
			protected var CARTEJOUEURMOYENBAS:String = "CarteJoueurMoyenBas";
			protected var CARTEJOUEURMOYENHAUT:String = "CarteJoueurMoyenHaut";
			protected var CARTEJOUEURELEVEE:String = "CarteJoueurElevee";
			
			protected var POSITIONPETITEBLINDE:String = "PositionPetiteBlinde";
			protected var POSITIONGROSSEBLINDE:String = "PositionGrosseBlinde";
			protected var POSITIONDEALER:String = "PositionDealer";
			protected var POSITIONUNDERTHEGUN:String = "PositionUnderTheGun";
			protected var POSITIONAUTRE:String = "PositionAutre";
			
			protected var PORTEFEUILLEFAIBLE:String = "PortefeuilleFaible";
			protected var PORTEFEUILLECONFORTABLE:String = "PortefeuilleConfortable";
			protected var PORTEFEUILLEFORT:String = "PortefeuilleFort";
			
			protected var RELANCENULLE:String = "RelanceNulle";
			protected var RELANCEFAIBLE:String = "RelanceFaible";
			protected var RELANCEFORTE:String = "RelanceForte";
			
			protected var SUIVREGROSSEBLINDE:String = "SuivreGrosseBlinde";
			
				public function Hal(_name:String, _stackValue:Number)
                {
                        super(_name, _stackValue);
						expertSystem = new ExpertSystem();
						handEvaluator = new HandEvaluator();
						valeurDePortefeuilleDeDepart = GetStackValue();
						
                }
				
				private function initRules() : void
				{
						expertSystem.AddRule([SUIVREGROSSEBLINDE], CALL);
						
						
						expertSystem.AddRule([CARTEJOUEURFAIBLE, RELANCENULLE], CHECK);
						expertSystem.AddRule([CARTEJOUEURFAIBLE, RELANCEFAIBLE], FOLD);
						expertSystem.AddRule([CARTEJOUEURFAIBLE, RELANCEFORTE], FOLD);
						
						expertSystem.AddRule([CARTEJOUEURMOYENBAS, RELANCENULLE], CHECK);
						expertSystem.AddRule([CARTEJOUEURMOYENBAS, RELANCEFAIBLE], FOLD);
						expertSystem.AddRule([CARTEJOUEURMOYENBAS, RELANCEFORTE], FOLD);
						
						expertSystem.AddRule([CARTEJOUEURMOYENHAUT, RELANCENULLE], CHECK);
						expertSystem.AddRule([CARTEJOUEURMOYENHAUT, RELANCENULLE, POSITIONUNDERTHEGUN, PORTEFEUILLECONFORTABLE], LITTLERAISE);
						expertSystem.AddRule([CARTEJOUEURMOYENHAUT, RELANCENULLE, POSITIONUNDERTHEGUN, PORTEFEUILLEFORT], BIGRAISE);
						expertSystem.AddRule([CARTEJOUEURMOYENHAUT, RELANCEFAIBLE, PORTEFEUILLECONFORTABLE], CALL);
						expertSystem.AddRule([CARTEJOUEURMOYENHAUT, RELANCEFAIBLE, PORTEFEUILLEFORT], LITTLERAISE);
						expertSystem.AddRule([CARTEJOUEURMOYENHAUT, RELANCEFORTE, PORTEFEUILLEFAIBLE], FOLD);
						expertSystem.AddRule([CARTEJOUEURMOYENHAUT, RELANCEFORTE, PORTEFEUILLECONFORTABLE], CALL);
						expertSystem.AddRule([CARTEJOUEURMOYENHAUT, RELANCEFORTE, PORTEFEUILLEFORT], LITTLERAISE);
						expertSystem.AddRule([CARTEJOUEURMOYENHAUT, RELANCEFORTE, PORTEFEUILLEFORT, POSITIONUNDERTHEGUN ], BIGRAISE);
						
						expertSystem.AddRule([CARTEJOUEURELEVEE, RELANCENULLE], LITTLERAISE);
						expertSystem.AddRule([CARTEJOUEURELEVEE, RELANCENULLE, POSITIONUNDERTHEGUN, PORTEFEUILLECONFORTABLE], BIGRAISE);
						expertSystem.AddRule([CARTEJOUEURELEVEE, RELANCENULLE, POSITIONUNDERTHEGUN, PORTEFEUILLEFORT], BIGRAISE);
						expertSystem.AddRule([CARTEJOUEURELEVEE, RELANCEFAIBLE,PORTEFEUILLEFAIBLE], CALL);
						expertSystem.AddRule([CARTEJOUEURELEVEE, RELANCEFAIBLE, PORTEFEUILLECONFORTABLE], LITTLERAISE);
						expertSystem.AddRule([CARTEJOUEURELEVEE, RELANCEFAIBLE, PORTEFEUILLEFORT], BIGRAISE);
						expertSystem.AddRule([CARTEJOUEURELEVEE, RELANCEFORTE], CALL);
						expertSystem.AddRule([CARTEJOUEURELEVEE, RELANCEFORTE, PORTEFEUILLECONFORTABLE], LITTLERAISE);
						expertSystem.AddRule([CARTEJOUEURELEVEE, RELANCEFORTE, PORTEFEUILLEFORT], BIGRAISE);
					
				}
               
                override public function Play(_pokertable:PokerTable) : Boolean {
 
                        Perceive(_pokertable);
                        var actionLabel:String = Analyze();
                        Act(actionLabel, _pokertable);
                       
                        return (lastAction != PokerAction.NONE);
                }
               
               
                public function Act(actionLabel:String, pokerTable:PokerTable) : void {
                        if (actionLabel == CALL) {
                                Call(pokerTable.GetValueToCall());
                        } else if (actionLabel == ALLIN) {
								Raise(GetStackValue(), pokerTable.GetValueToCall());
						} else if (actionLabel == CHECK) {
								Check();
						} else if (actionLabel == FOLD) {
								Fold();
						} else if (actionLabel == BIGRAISE) {
								Raise(pokerTable.GetValueToCall(), Math.floor((Math.random() * (pokerTable.GetValueToCall()/6)) + pokerTable.GetValueToCall()/5));
						} else if (actionLabel == LITTLERAISE) {
								Raise(pokerTable.GetValueToCall(), Math.floor((Math.random() * (pokerTable.GetValueToCall()/15)) + pokerTable.GetValueToCall()/12));
						}
                }
               
                public function Analyze() : String {
                       
                        var conclusionLabels:Array = expertSystem.InferForward();
                       
                        var actions:Array = new Array();
						for each (var uneConclusion:String in conclusionLabels){
							actions.push(uneConclusion);
						}
                       
                       
                        if (actions.length > 1) {
                                //Problème de logique parallèle
								var indexAleatoire:int = new int;
								indexAleatoire = Math.floor((Math.random() * (length - 1)) + 0);
								return actions[indexAleatoire];
                               
                        } else if (actions.length > 0) {
                                //Une seule action
                                return actions[0];
                        } else {
                                //Pas d'action trouvée
								return CALL;
                        }
						return CALL;
                       
                }
               
                public function Perceive(_pokertable:PokerTable) : void {
                                               
                        expertSystem.ResetFactValues();
						var valeurCarte:int;
						valeurCarte= new int;
                       
						//Perçoit la valeur de la relance
                        if (_pokertable.GetValueToCall() > 0) {
                                //Relancé
								if (_pokertable.GetValueToCall() < 20)
									expertSystem.SetFactValue(RELANCEFAIBLE, true);
								else
									expertSystem.SetFactValue(RELANCEFORTE, true);
                        } else {
                                expertSystem.SetFactValue(RELANCENULLE, true);
                        }
						
						
						//Perçoit la valeur de notre portefeuille
						if (GetStackValue() >= (valeurDePortefeuilleDeDepart * 3)) {
							expertSystem.SetFactValue(PORTEFEUILLEFORT, true);
							
						} else if (GetStackValue() < valeurDePortefeuilleDeDepart) {
							expertSystem.SetFactValue(PORTEFEUILLEFAIBLE, true);
							
						} else {
							expertSystem.SetFactValue(PORTEFEUILLECONFORTABLE, true)
						}
						
						//Perçoit notre position sur la table
						if (_pokertable.GetDealer() == this) {
							expertSystem.SetFactValue(POSITIONDEALER, true);	
						} else if(estPetiteBlinde(_pokertable)){
							expertSystem.SetFactValue(POSITIONPETITEBLINDE, true);
						} else if (estUnderTheGun(_pokertable)) {
							expertSystem.SetFactValue(POSITIONUNDERTHEGUN, true);
						} else {
							expertSystem.SetFactValue(POSITIONAUTRE, true);
						}


						//Perçoit la valeur de nos cartes
						if (_pokertable.GetPreviousStateId() == Preflop.ID) { // si on est en préFlop
							valeurCarte = GetCard(0).GetHeight() + GetCard(1).GetHeight();
							trace(valeurCarte);
							
							if (GetCard(0).GetHeight() == GetCard(1).GetHeight()) {
								valeurCarte += 9; // s'il y a une paire, on rajoute de la valeur aux cartes
							}
							
							if ((valeurCarte >= 0) && (valeurCarte < 4 ))
							{
								expertSystem.SetFactValue(CARTEJOUEURFAIBLE, true);
							} else if ((valeurCarte >= 5) && (valeurCarte < 9 )) {
								expertSystem.SetFactValue(CARTEJOUEURMOYENBAS, true);
							} else if ((valeurCarte >= 10) && (valeurCarte < 14 )) {
								expertSystem.SetFactValue(CARTEJOUEURMOYENHAUT, true);
							} else if (valeurCarte >= 15) {
								expertSystem.SetFactValue(CARTEJOUEURELEVEE, true);
							}
							
						} else {

							var cardSet:Array = new Array();
							AddCard(cardSet, GetCard(0));
							AddCard(cardSet, GetCard(1));
							for each (var uneCarteDeLaTable:PlayingCard in _pokertable.GetBoard()){
								AddCard(cardSet, uneCarteDeLaTable);
							}
							var playerScore:int = PokerTools.GetCardSetValue(cardSet);
							switch(handEvaluator.hand_rank(playerScore)){
								case HandValue.HIGH_CARD:
									expertSystem.SetFactValue(CARTEJOUEURFAIBLE, true);
									break;
								case HandValue.PAIR:
									expertSystem.SetFactValue(CARTEJOUEURMOYENBAS, true);
									break;
								case HandValue.TWO_PAIRS:
									expertSystem.SetFactValue(CARTEJOUEURMOYENHAUT, true);
									break;
								case HandValue.THREE_OF_A_KIND:
									expertSystem.SetFactValue(CARTEJOUEURMOYENHAUT, true);
								break;
									case HandValue.STRAIGHT:
									expertSystem.SetFactValue(CARTEJOUEURMOYENHAUT, true);
									break;
								case HandValue.FLUSH:
									expertSystem.SetFactValue(CARTEJOUEURMOYENHAUT, true);
								break;
									case HandValue.FULL_HOUSE:
									expertSystem.SetFactValue(CARTEJOUEURELEVEE, true);
									break;
								case HandValue.FOUR_OF_A_KIND:
									expertSystem.SetFactValue(CARTEJOUEURELEVEE, true);
									break;
								case HandValue.STRAIGHT_FLUSH:
									expertSystem.SetFactValue(CARTEJOUEURELEVEE, true);
									break;
								case HandValue.ROYAL_FLUSH:
									expertSystem.SetFactValue(CARTEJOUEURELEVEE, true);
									break;
								default:
									expertSystem.SetFactValue(CARTEJOUEURFAIBLE, true);;
							}
							
						}
							
                       
                }
				
				private function AddCard(_cardSet:Array, _card:PlayingCard) : void
				{
					if (_card != null)
					{
						_cardSet.push(_card);
					}
				}
				
				private function estPetiteBlinde(_pokertable:PokerTable) : Boolean
				{
					var notreIndex:int;
					notreIndex = _pokertable.GetPlayerIndex(this)
					if (_pokertable.GetNextPlayerIndex(_pokertable.GetPlayerIndex(_pokertable.GetDealer())) == notreIndex)
						return true;
					
					return false;
				}
				
				private function estGrosseBlinde(_pokertable:PokerTable) : Boolean
				{
					var notreIndex:int;
					var indexDealer:int
					var indexPetiteBlinde:int
					notreIndex = _pokertable.GetPlayerIndex(this);
					indexDealer = _pokertable.GetNextPlayerIndex(_pokertable.GetPlayerIndex(_pokertable.GetDealer()));
					indexPetiteBlinde = _pokertable.GetNextPlayerIndex(indexDealer);
					
					if (_pokertable.GetNextPlayerIndex(indexPetiteBlinde) == notreIndex)
						return true;
					
					return false;
				}
				
				private function estUnderTheGun(_pokertable:PokerTable) : Boolean
				{
					var notreIndex:int;
					var indexDealer:int
					var indexPetiteBlinde:int
					var indexGrosseBlinde:int
					notreIndex = _pokertable.GetPlayerIndex(this);
					indexDealer = _pokertable.GetNextPlayerIndex(_pokertable.GetPlayerIndex(_pokertable.GetDealer()));
					indexPetiteBlinde = _pokertable.GetNextPlayerIndex(indexDealer);
					indexGrosseBlinde = _pokertable.GetNextPlayerIndex(indexPetiteBlinde);
					
					if (_pokertable.GetNextPlayerIndex(indexGrosseBlinde) == notreIndex)
						return true;
					
					return false;
				}
				

				
				
               
                override public function ProcessPlayerAction(_player:PokerPlayer) : void
                {
                        trace("IL a joué");
                }
 
               
        }
}
